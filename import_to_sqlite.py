import sqlite3
import pandas as pd
from pathlib import Path

DB_PATH = "labcenterims.sqlite"
SCHEMA_PATH = "schema.sql"

CSV_DEPTS   = "clean_departments.csv"
CSV_ITEMS   = "clean_items.csv"
CSV_BORR    = "clean_borrowers.csv"
CSV_ALIAS   = "clean_borrower_aliases.csv"
CSV_LOANS   = "clean_item_loans.csv"
CSV_TICKETS = "clean_service_tickets.csv"


def must_exist(p: str):
    if not Path(p).exists():
        raise FileNotFoundError(f"Missing file: {p}")


def get_or_create_import_labtech(cur) -> int:
    """
    TItemLoans requires intCheckoutLabTechID NOT NULL.
    We create a placeholder lab tech account used for historical imports.
    """
    cur.execute("SELECT intLabTechID FROM TLabTechs WHERE strUsername = ?", ("import",))
    row = cur.fetchone()
    if row:
        return int(row[0])

    cur.execute("""
        INSERT INTO TLabTechs (
            strUsername, strDisplayName, strFirstName, strLastName,
            strEmail, strPhoneNumber, strPassword, strRole, blnIsActive
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)
    """, (
        "import", "Data Import", "Data", "Import",
        None, None, "CHANGE_ME", "admin"
    ))
    return int(cur.lastrowid)


def main():
    for p in [SCHEMA_PATH, CSV_DEPTS, CSV_ITEMS, CSV_BORR, CSV_ALIAS, CSV_LOANS, CSV_TICKETS]:
        must_exist(p)

    # Load CSVs
    df_depts   = pd.read_csv(CSV_DEPTS)
    df_items   = pd.read_csv(CSV_ITEMS)
    df_borr    = pd.read_csv(CSV_BORR)
    df_alias   = pd.read_csv(CSV_ALIAS) if Path(CSV_ALIAS).stat().st_size > 0 else pd.DataFrame(columns=["strSchoolIDNumber","strAlias"])
    df_loans   = pd.read_csv(CSV_LOANS)
    df_tickets = pd.read_csv(CSV_TICKETS)

    con = sqlite3.connect(DB_PATH)
    con.execute("PRAGMA foreign_keys = ON;")
    cur = con.cursor()

    # Run schema
    schema_sql = Path(SCHEMA_PATH).read_text(encoding="utf-8")
    cur.executescript(schema_sql)

    import_labtech_id = get_or_create_import_labtech(cur)

    # -----------------------------
    # Insert Departments
    # -----------------------------
    dept_name_to_id = {}
    for name in df_depts["strDepartmentName"].dropna().astype(str).unique():
        cur.execute("INSERT OR IGNORE INTO TDepartments (strDepartmentName) VALUES (?)", (name,))
    con.commit()

    cur.execute("SELECT intDepartmentID, strDepartmentName FROM TDepartments")
    for did, dname in cur.fetchall():
        dept_name_to_id[str(dname)] = int(did)

    # -----------------------------
    # Insert Borrowers
    # -----------------------------
    schoolid_to_borrowerid = {}
    for _, r in df_borr.iterrows():
        school_id = str(r["strSchoolIDNumber"]).strip()
        first = str(r["strFirstName"]).strip()
        last  = str(r["strLastName"]).strip()
        phone = str(r["strPhoneNumber"]).strip() if pd.notna(r.get("strPhoneNumber")) else None
        instr = str(r["strInstructor"]).strip() if pd.notna(r.get("strInstructor")) else None
        btype = str(r["strBorrowerType"]).strip() if pd.notna(r.get("strBorrowerType")) else None

        # Insert borrower
        cur.execute("""
            INSERT INTO TBorrowers (
                strFirstName, strLastName, strSchoolIDNumber, strPhoneNumber,
                strInstructor, intDepartmentID, strBorrowerType
            )
            VALUES (?, ?, ?, ?, ?, NULL, ?)
        """, (first, last, school_id, phone, instr, btype))

        borrower_id = int(cur.lastrowid)
        schoolid_to_borrowerid[school_id] = borrower_id

    con.commit()

    # Borrower Aliases
    for _, r in df_alias.iterrows():
        school_id = str(r["strSchoolIDNumber"]).strip()
        alias = str(r["strAlias"]).strip()
        borrower_id = schoolid_to_borrowerid.get(school_id)
        if borrower_id and alias:
            cur.execute("""
                INSERT OR IGNORE INTO TBorrowerAliases (intBorrowerID, strAlias)
                VALUES (?, ?)
            """, (borrower_id, alias))
    con.commit()

    # -----------------------------
    # Insert Items
    # -----------------------------
    itemname_to_itemid = {}

    for _, r in df_items.iterrows():
        item_name = str(r["strItemName"]).strip()
        if not item_name:
            continue

        school_owned = int(r["blnIsSchoolOwned"]) if pd.notna(r.get("blnIsSchoolOwned")) else 1
        dept_name = r.get("strDepartmentName")
        dept_id = None
        if pd.notna(dept_name):
            dept_id = dept_name_to_id.get(str(dept_name).strip())

        desc = r.get("strDescription")
        desc = str(desc).strip() if pd.notna(desc) else None

        cur.execute("""
            INSERT INTO TItems (
                strItemName, blnIsSchoolOwned, intDepartmentID, strDescription
            )
            VALUES (?, ?, ?, ?)
        """, (item_name, school_owned, dept_id, desc))

        item_id = int(cur.lastrowid)
        itemname_to_itemid[item_name] = item_id

    con.commit()

    # Refresh map from DB to avoid duplicates if you rerun
    cur.execute("SELECT intItemID, strItemName, blnIsSchoolOwned, intDepartmentID FROM TItems")
    item_cache = {}
    for iid, nm, owned, deptid in cur.fetchall():
        item_cache[str(nm)] = {"id": int(iid), "owned": int(owned), "deptid": int(deptid) if deptid is not None else None}

    # -----------------------------
    # Insert Service Tickets
    # -----------------------------
    for _, r in df_tickets.iterrows():
        public_id = str(r["strPublicTicketID"]).strip()
        label = str(r["strItemLabel"]).strip() if pd.notna(r.get("strItemLabel")) else None
        issue = str(r["strIssue"]).strip()
        logged = r.get("dtmLoggedUTC")
        status = str(r.get("strStatus")).strip() if pd.notna(r.get("strStatus")) else "Diagnosing"

        item_id = None
        borrower_id = None  # you chose to ignore contacts in service CSV

        if label and label in item_cache:
            item_id = item_cache[label]["id"]

        cur.execute("""
            INSERT INTO TServiceTickets (
                strPublicTicketID, intItemID, intBorrowerID, strItemLabel,
                strIssue, dtmLoggedUTC, intAssignedLabTechID, strStatus
            )
            VALUES (?, ?, ?, ?, ?, ?, NULL, ?)
        """, (public_id, item_id, borrower_id, label, issue, logged, status))

        # optional: put Service column into notes
        note = r.get("strServiceNote")
        if pd.notna(note) and str(note).strip():
            ticket_id = int(cur.lastrowid)
            cur.execute("""
                INSERT INTO TServiceTicketNotes (intServiceTicketID, intLabTechID, strNote)
                VALUES (?, ?, ?)
            """, (ticket_id, import_labtech_id, str(note).strip()))

    con.commit()

    # -----------------------------
    # Insert Item Loans (with snapshots)
    # -----------------------------
    for _, r in df_loans.iterrows():
        school_id = str(r["strSchoolIDNumber"]).strip()
        item_name = str(r["strItemName"]).strip()
        qty = int(r["intQty"]) if pd.notna(r.get("intQty")) else 1

        checkout = r.get("dtmCheckoutUTC")
        checkin  = r.get("dtmCheckinUTC")
        checkin_notes = r.get("strCheckinNotes")
        checkin_notes = str(checkin_notes).strip() if pd.notna(checkin_notes) else None

        borrower_id = schoolid_to_borrowerid.get(school_id)
        if not borrower_id:
            # strict: skip loan if borrower missing
            continue

        item_info = item_cache.get(item_name)
        if not item_info:
            # strict: skip loan if item missing
            continue

        # get borrower snapshot
        cur.execute("""
            SELECT strFirstName, strLastName, strSchoolIDNumber, strPhoneNumber, strRoomNumber, strInstructor
            FROM TBorrowers WHERE intBorrowerID = ?
        """, (borrower_id,))
        b = cur.fetchone()
        if not b:
            continue

        snap_first, snap_last, snap_sid, snap_phone, snap_room, snap_instr = b

        # item snapshot
        cur.execute("""
            SELECT strItemName, blnIsSchoolOwned, intDepartmentID
            FROM TItems WHERE intItemID = ?
        """, (item_info["id"],))
        it = cur.fetchone()
        if not it:
            continue
        snap_item_name, snap_owned, snap_dept_id = it

        snap_dept_name = None
        if snap_dept_id is not None:
            cur.execute("SELECT strDepartmentName FROM TDepartments WHERE intDepartmentID = ?", (snap_dept_id,))
            drow = cur.fetchone()
            snap_dept_name = drow[0] if drow else None

        # Insert loan row
        cur.execute("""
            INSERT INTO TItemLoans (
                intItemID, intBorrowerID, intCheckoutLabTechID,
                dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,
                dtmCheckinUTC, intCheckinLabTechID, strCheckinNotes,
                snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber,
                snapPhoneNumber, snapRoomNumber, snapInstructor,
                snapItemName, snapIsSchoolOwned, snapDepartmentName
            )
            VALUES (
                ?, ?, ?,
                ?, NULL, NULL,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?
            )
        """, (
            item_info["id"], borrower_id, import_labtech_id,
            checkout, checkin, (import_labtech_id if pd.notna(checkin) else None), checkin_notes,
            snap_first, snap_last, snap_sid,
            snap_phone, snap_room, snap_instr,
            snap_item_name, int(snap_owned), snap_dept_name
        ))

    con.commit()
    con.close()

    print(f"Done ✅ Created/updated: {DB_PATH}")
    print("Tip: open it in 'DB Browser for SQLite' to inspect tables quickly.")


if __name__ == "__main__":
    main()
