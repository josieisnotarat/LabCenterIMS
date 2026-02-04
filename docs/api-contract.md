# API/UI Contract (current)

This document captures the current API surface exposed by `server.js`, how the UI consumes it in `LabCenterIMS.html`, and the SQL Server dependency behind each route. It is meant to be the source of truth before replacing SQL Server/HTTP with Electron + SQLite.

> **Notation:**
> - UI calls are referenced by the JS helper functions in `LabCenterIMS.html`.
> - DB dependency calls out stored procedures (SPs) or direct table usage.

## Contract table

| Endpoint | UI call(s) | Request (method, params/body) | Response (shape) | DB dependency |
| --- | --- | --- | --- | --- |
| `/api/login` | Login form submit (inline fetch) | **POST** `{ username, password }` | `{ token, user }` or `{ error }` | `TLabTechs` lookup (direct query) |
| `/api/session` | `fnRestoreSession` | **GET** (Bearer token) | `{ user }` or `{ error }` | Session in memory (no DB) |
| `/api/logout` | `fnLogout` | **POST** (Bearer token) | `{ success: true }` | Session in memory (no DB) |
| `/api/dashboard-stats` | `fnFetchDashboardStats` | **GET** | `{ outNow, dueToday, repairs, overdue }` | **SP** `dbo.usp_GetDashboardStats` |
| `/api/loans` | `fnFetchLoans` | **GET** `?status&search` | `{ entries: Loan[] }` | `TItemLoans` (CTE query) |
| `/api/loans/:id/notes` | `fnFetchDetailNotes` (loan) | **GET** | `{ entries: Note[] }` | `TItemLoanNotes`, `TLabTechs` |
| `/api/loans/checkout` | New/Returning Borrow flows | **POST** `{ borrowerId/schoolId/name/customerName, item, notes }` | `{ loanId, traceNumber, dueUtc, dueDescription, duePolicy }` | **SP** `dbo.usp_CheckoutItem` + `TItems`, `TBorrowers`, loan/tech lookup queries |
| `/api/service-tickets` | `fnFetchServiceTickets` | **GET** `?status&search` | `{ entries: Ticket[] }` | `TServiceTickets`, `TBorrowers`, `TItems`, `TLabTechs` |
| `/api/service-tickets/:id/notes` | `fnFetchDetailNotes` (ticket) | **GET** | `{ entries: Note[] }` | `TServiceTicketNotes`, `TLabTechs` |
| `/api/tickets` | New/Returning Service flows | **POST** `{ borrowerId/schoolId/name/customerName, item, issue }` | `{ ticketId, publicId }` | **SP** `dbo.usp_ServiceTicketCreate` + `TServiceTickets` (public ID generation) |
| `/api/status` | Detail modal “Save” | **POST** `{ id, type, status, note }` | `{ success: true }` or `{ error }` | **SPs** `dbo.usp_CheckinItem`, `dbo.usp_UpdateLoanDue`, `dbo.usp_AddLoanNote`, `dbo.usp_ServiceTicketSetStatus`, `dbo.usp_AddServiceTicketNote` + `TItemLoans`, `TServiceTickets` |
| `/api/borrowers/search` | Borrower lookup autocomplete | **GET** `?query` | `{ entries: BorrowerSummary[] }` | **SP** `dbo.usp_SearchBorrowers` + `TBorrowerAliases` (direct query) |
| `/api/customers` | `fnFetchCustomerProfiles` | **GET** `?search` | `{ entries: Customer[] }` | `TBorrowers`, `TDepartments`, `TBorrowerAliases` |
| `/api/customers` | New customer flow | **POST** `{ first, last, schoolId, phone, room, instructor }` | `{ id }` | **SP** `dbo.usp_CreateBorrower` |
| `/api/customers/:id` | `fnFetchCustomerProfileDetail` | **GET** | Customer detail (incl. aliases) | `TBorrowers`, `TDepartments`, `TBorrowerAliases` |
| `/api/customers/:id` | `fnDeleteCustomerProfile` | **DELETE** | `{ success: true }` | `TBorrowers`, `TBorrowerAliases`, dependency check on `TItemLoans`, `TServiceTickets` |
| `/api/customers/:id/aliases` | `fnCreateCustomerAlias` | **POST** `{ alias }` | Alias object | `TBorrowerAliases` |
| `/api/customers/:id/aliases/:aliasId` | `fnDeleteCustomerAlias` | **DELETE** | `{ success: true }` | `TBorrowerAliases` |
| `/api/items` | `fnFetchItems` | **GET** `?search` | `{ entries: Item[] }` | `TItems`, `TDepartments` |
| `/api/items` | Create item | **POST** `{ name, department, schoolOwned, description, duePolicy, offsetDays/offsetHours/dueTime/fixedDue }` | `{ itemId }` | **SP** `dbo.usp_CreateItem` + `TDepartments` |
| `/api/items/:id` | `fnOpenInventoryItemDialog` | **GET** | Item detail | `TItems`, `TDepartments` |
| `/api/items/:id` | Manage item “Save” | **PUT** payload like create | Item detail | `TItems` update + `TDepartments` |
| `/api/items/:id` | Manage item “Delete” | **DELETE** | `{ success: true }` | `TItems` (FK checks) |
| `/api/items/due-preview` | Due preview helper | **GET** `?item` | `{ itemId, itemName, dueUtc, policy, policyDescription }` or `{ message }` | `TItems` |
| `/api/users` | `fnFetchUsers` | **GET** `?search` | `{ entries: User[] }` | `TLabTechs` |
| `/api/users` | Create user | **POST** `{ username, display, role, password }` | `{ username }` | `TLabTechs`, `TLabTechCredentials` |
| `/api/users/:username` | Edit user | **PUT** `{ display, role, password? }` | Updated user object | `TLabTechs`, `TLabTechCredentials` |
| `/api/users/:username` | Delete user | **DELETE** | `{ success: true }` | `TLabTechs` + dependency checks on `TItemLoans`, `TItemLoanNotes`, `TServiceTickets`, `TServiceTicketNotes`, `TAuditLog` |
| `/api/audit-log` | `fnFetchAuditLog` | **GET** | `{ entries: AuditEntry[] }` | `TAuditLog`, `TLabTechs` |
| `/api/admin/audit-log` | `fnClearAuditLog` | **DELETE** | `{ success: true }` | `TAuditLog` |
| `/api/admin/clear-database` | `fnClearDatabase` | **POST** | `{ success: true }` | `TItemLoanNotes`, `TItemLoans`, `TServiceTicketNotes`, `TServiceTickets`, `TBorrowerAliases`, `TBorrowers`, `TItems`, `TLabTechs`, `TAuditLog`, `TDepartments` |

## Notes

- Some endpoints are called directly via `fetch` (login/session/logout); most others go through `fnApi`, which adds JSON headers and bearer auth when present.
- The API uses a mix of stored procedures and direct SQL queries; the stored procedure dependency list is essential to re-implement when migrating away from SQL Server.
