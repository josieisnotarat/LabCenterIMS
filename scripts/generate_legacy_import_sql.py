import csv
import datetime as dt
import os
import re

RAW_DATA = """Date,ID,First Name,Last Name,Phone,Instructor,Qty.,Material ,Returned? ,Return Note
5/24/2023,726743,Jonathan,Ehlman,(513) 569-1762,Me,,Everything,Disposable,
5/24/2023,588443,""""""",Wagner,(513) 569-4684,""""""",,Dignity,Yes,
5/24/2023,588443,""""""",Wagner,(513) 569-4684,""""""",,Dignity,Yes,
6/8/2023,475875,Clarence,Stepp,(513) 404-3749,Ron,,Dig Kit,Disposable,
6/8/2023,704399,Jessica,Cortez,(831) 539-3969,Ron,,Dig Kit,Yes,
6/8/2023,706770,Ryan,Kellam,(859) 957-4988,Ron,,Dig Kit,Yes,
6/8/2023,632672,Quintan,Mincy,(513) 521-2381,Ron,,Dig Kit,Yes,
6/8/2023,709786,Andrew,Morlan,(513) 439-0915,Ron,,Dig Kit,Yes,
6/8/2023,678189,Will,Smith,(513) 609-0114,Ron,,Dig Kit,Yes,
6/8/2023,683043,Spencer,Spek,(937) 716-9020,Ron,,Dig Kit,Yes,
6/8/2023,587445,Bryce,Washick,(513) 657-8913,Ron,,Dig Kit,Yes,
6/8/2023,587114,Ben,Wylie,(513) 570-3925,Ron,,Dig Kit,Yes,
6/9/2023,,Karen,Mckinney,,Doug,,3 AA batteries,Disposable,
6/12/2023,,Thelson,Curry,(513) 212-3243,,,"IR Unit, Reflector and Buzzer",Yes,
6/15/2023,678189,William,Smith,(513) 609-0114,Ron,, Trainer,Yes,
6/15/2023,475875,Clarance,Stepp,(513) 404-3749,Singleton,, Trainer,Yes,Counted as Loss
6/15/2023,475875,Clarance,Stepp,(513) 404-3749,Singleton,, Trainer,Yes,
6/15/2023,696703,Da'Quan,Allen,(513) 604-4591,Ron,, Trainer 27,Yes,
6/22/2023,696703,Da'Quan,Allen,(513) 604-4591,Ron,, Trainer,Yes,will renew tm
6/22/2023,696703,Da'Quan,Allen,(513) 604-4591,Ron,, Trainer,Yes,
6/22/2023,475875,Clarance,Stepp,(513) 404-3749,Singleton,, Trainer 26,Yes,
6/29/2023,696703,Da'Quan,Allen,(513) 604-4591,Singleton,,Trainer 30,Yes,
7/27/2023,587114,Ben,Wiley,(513) 570-3925,Ron,7, 7400 (NAND),Yes,
7/27/2023,483907,Donald,Brill,(513) 939-4863,Ron,,Resistors and Orange Board,Yes,
7/27/2023,632672,Quintan,Mincy,(513) 521-2381,Ron,,Trainor 26,Yes,
8/3/2023,483907,Donald,Brill,(513) 939-4863,Ron,1,"Red LED, 7408, 220 Resistor",Yes,
8/3/2023,695527,Kantima,Egngtion,,Ron,1,Reistors,Yes,
8/3/2023,483907,Donald,Brill,(513) 939-4863,Ron,1,Reistors and bread board,Yes, 
8/3/2023,483907,Donald,Brill,(513) 939-4863,Ron,1,Reistors and bread board,Yes,
8/3/2023,695527,Kantima,Egngtion,,Ron,1,"Reistors, LED and bread board",Yes,
8/3/2023,695527,Kantima,Egngtion,(513) 364-5302,Ron,1,"Reistors, LED and bread board",Yes,
8/29/2023,,Mark,CVG,,Mark,10,Calculators,Disposable,
8/30/2023,696703,Da'Quan,Allen,513-604-4591,Geraldine,1,Dig Kit,Yes,
8/30/2023,620929,Mikayla,Harris,513-692-3731,Geraldine,1,Dig Kit,Yes,
8/30/2023,716176,Quintanilla,Karen,"Oh, you know",Geraldine,1,Dig Kit,Yes,
8/30/2023,702088,Mussa,Kebe,513-306-1094,Geraldine,1,Dig Kit,Yes,
8/30/2023,702088,Moussa,Kebe,513-306-1094,Geraldine,1,Dig Kit,Yes,
8/30/2023,700224,Erin,Moeller,513-869-1177,Geraldine,1,Dig Kit,Yes,
8/30/2023,696723,Evan,Selles,513-302-9660,Geraldine,1,Dig Kit,Yes,
8/30/2023,679236,Tanner,Sharpe,612-597-7447,Geraldine,1,Dig Kit,Yes,
8/30/2023,701563,Joey,Tomamichel,513-288-8539,Geraldine,1,Dig Kit,Yes,
8/30/2023,679236,Tanner,Sharpe,612-597-7447,Geraldine,1,Trainer 30,Yes,
8/30/2023,696703,Da'Quan,Allen,513-604-4591,Geraldine,1,Trainer 4,Yes,
9/5/2023,703415,Wesley,Ortiz,513-787-0377,Ralph,1,MSP430+USB cable,Yes,
9/5/2023,716176,Quintanilla,Karen,"Oh, you know :P",Ralph,1,MSP430+USB cable: #1,Yes,
9/5/2023,702088,Moussa,Kebe,513-306-1094,Ralph,1,MSP430+USB cable: #2,Yes,Failed Class
9/5/2023,702088,Moussa,Kebe,513-306-1094,Ralph,1,MSP430+USB cable: #2,Yes,
9/7/2023,,Bruce,Scherer,,Bruce,2,3/32 Collet,Disposable,
9/7/2023,696703,Da'Quan,Allen,513-604-4591,Ralph,1,MSP430+USB cable: #3,Yes,
9/11/2023,702964,Alexander,Bozhenov,513-800-8247,Geraldine,1,Dig Kit,Yes,
9/11/2023,704399,Jess,Cortez,831-539-3969,Geraldine,1,Dig Kit,Yes,
9/11/2023,507792,Andrew,Day,859-444-3756,Geraldine,1,Dig Kit,Yes,
9/11/2023,716207,Mason,Earls,812-655-4677,Geraldine,1,Dig Kit,Yes,
9/11/2023,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Kit,Yes,
9/11/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Dig Kit,Yes,
9/11/2023,680317,Cole,Quitter,859-638-4570,Geraldine,1,Dig Kit,Yes,
9/11/2023,,Jacob,Simpson,937-618-5847,Geraldine,1,Dig Kit,Yes,
9/11/2023,709999,Tanner,Thornberry,859-640-1274,Geraldine,1,Dig Kit,Yes,
9/11/2023,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Dig Kit,Yes,
9/11/2023,683161,Katie,Wernicke,513-462-2229,Geraldine,1,Dig Kit,Yes,
9/11/2023,704343,John,Wilson,859-620-0250,Geraldine,1,Dig Kit,Yes,
9/11/2023,683161,Katie,Wernicke,""""""",Geraldine,1,Trainer #27,Yes,
9/11/2023,716944,Max,Hall,""""""",Geraldine,1,Trainer #30,Yes,
9/11/2023,719233,Damon,Madaris,""""""",Geraldine,1,Trainer #4,Yes,
9/13/2023,620929,Mickaela,Harris,513-692-3731,Geraldine,1,Dig Kit,Yes,
9/13/2023,696723,Evan,Sellers,513-302-9660,Geraldine,1,Trainer #30,Yes,
9/13/2023,696703,Da'Quan,Allen,513-604-4591,Geraldine,1,Trainer #4,Yes,
9/18/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Trainer #27,Yes,
9/18/2023,683161,Katie,Wernicke,513-462-2229,Geraldine,1,Trainer #30,Yes,
9/18/2023,716944,Max,Paul,513-805-2605,Geraldine,1,Trainer #4,Yes,
9/25/2023,696703,Da'Quan,Allen,513-604-4591,Geraldine,1,Trainer #30,Yes,
9/25/2023,716944,Max,Paul,513-805-2605,Geraldine,1,Trainer #30,Yes,
9/27/2023,696703,Da'Quan,Allen,513-604-4591,Geraldine,1,Trainer #30,Yes,
10/2/2023,716944,Max,Paul,513-805-2605,Geraldine,1,Trainer #04,Yes,
10/2/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Trainer #30,Yes,
10/9/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Trainer #30,Yes,
10/16/2023,716944,Max,Paul,513-805-2605,Geraldine,1,Trainer #04,Yes,
10/16/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Trainer #27,Yes,
10/30/2023,716944,Max,Paul,513-374-5236,Geraldine,1,Trainer #15,Yes,
11/6/2023,704343,John,Wilson,(859) 620-0250,Geraldine,2,22V10 chips,Yes,
11/6/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Dig Trainer 27,Yes,
11/6/2023,716944,Max,Paul,513-374-5236,Geraldine,1,Trainer #15,Yes,
11/20/2023,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Trainer 27,Yes,
11/27/2023,719233,Damon,Madaris,513-374-5236,Geraldine,1,Dig Trainer 32,Yes,
11/29/2023,702088,Moussa,Kebe,513-306-1094,Geraldine,1,Dig Trainer 15,Yes,
12/4/2023,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Trainer 27,Yes,
12/11/2023,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Trainer 27,Yes,
1/14/2024,717574,Andrew,Slipper,(937) 705-9811,curtis,1,Instrumentation Kit #06,Yes,
1/16/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Kit,Yes,
1/16/2024,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Kit,Yes,returned
1/16/2024,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Kit,Yes,
1/16/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Dig Kit,Yes,
1/16/2024,683161,Katie,Wernicke,513-462-2229,Geraldine,1,Dig Kit,Yes,
1/16/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Trainer 25,Yes,
1/16/2024,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Trainer 3,Yes,
1/22/2024,664114,Kyle,Hedlund,859-635-5325,Geraldine,1,Dig Kit,Yes,
1/22/2024,664114,Kyle,Hedlund,859-635-5325,Geraldine,1,Dig Kit,Yes,Voicemail
1/22/2024,709439,jorden ,Hess,513-444-7808,Geraldine,1,Dig Kit,Yes,
1/22/2024,725150,Galyam,korbogo,513-978-8988,Geraldine,1,Dig Kit,Yes,
1/22/2024,725150,Galyam,korbogo,513-978-8988,Geraldine,1,Dig Kit,Yes,Will return
1/22/2024,719233,Damaind,Madaris,513-374-5236,Geraldine,1,Dig Kit,Yes,
1/22/2024,303364,Sean,Miller,513-668-7423,Geraldine,1,Dig Kit,Yes,
1/22/2024,506049,Tyler,Miller,513-289-2108,Geraldine,1,Dig Kit,Yes,
1/22/2024,678189,william,Smith,513-609-0114,Geraldine,1,Dig Kit,Yes,
1/22/2024,678189,William,Smith,513-609-0114,Geraldine,1,Dig Kit,Yes,
1/22/2024,717461,simon,valdez,859-240-9186,Geraldine,1,Dig Kit,Yes,
1/22/2024,717461,simon,valdez,859-240-9186,Geraldine,1,Dig Kit,Yes,In search
1/22/2024,709439,jorden ,Hess,513-444-7808,Geraldine,1,Dig Trainer 15,Yes,
1/22/2024,725150,Galyam,korbogo,513-978-8988,Geraldine,1,Dig Trainer 25,Yes,
1/22/2024,717461,simon,valdez,859-240-9186,Geraldine,1,Dig Trainer 27,Yes,
1/22/2024,303364,Sean,Miller,513-668-7423,Geraldine,1,Dig Trainer 3,Yes,
1/22/2024,719233,Damaind,Madaris,513-374-5236,Geraldine,1,Dig Trainer 30,Yes,
1/22/2024,664114,Kyle,Hedlund,859-635-5325,Geraldine,1,Dig Trainer 32,Yes,
1/22/2024,678189,william,Smith,513-609-0114,Geraldine,1,Dig Trainer 34,Yes,
1/22/2024,506049,Tyler,Miller,513-289-2108,Geraldine,1,Dig Trainer 9,Yes,
1/23/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Trainer 27,Yes,
1/23/2024,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Trainer 30,Yes,
1/29/2024,658471,Noah,Patsfall,513-846-5118,Geraldine,1,Dig kit,Yes,
1/30/2024,716944,Max,Hall,513-805-2605,Geraldine,1,Dig Kit (temporary),Yes,
1/30/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Trainer 30,Yes,
2/5/2024,719233,Damaind,Madaris,513-374-5236,Geraldine,1,Dig Trainer 30,Yes,
2/6/2024,702964,Alexander,Bozhenov,513-800-8247,Geraldine,1,Dig Kit (temporary),Yes,
2/6/2024,702964,Alexander,Bozhenov,513-800-8247,Geraldine,1,Dig Trainer 3,Yes,
2/6/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Trainer 30,Yes,
2/8/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Dig Trainer #3,Yes,
2/8/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Dig Trainer #30,Yes,
2/9/2024,730163,Sam,Beccaccio,859-462-5058,Geraldine,1,Dig Trainer #3,Yes,
2/13/2024,,Bio teacher,,,,2,250ma fuse,Disposable,
2/13/2024,702964,Alexander,Bozhenov,513-800-8247,Geraldine,1,Dig Kit,Yes,
2/13/2024,702964,Alexander,Bozhenov,513-800-8247,Geraldine,1,Dig Kit,Yes,Will return
2/13/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Trainer 3,Yes,
2/20/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Trainer 30,Yes,
2/27/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Trainer 3,Yes,
2/28/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor kit 6,Yes,
2/28/2024,696723,Evan ,Sellers,(513) 302-9660,Curtis,1,Motor Kit 7,Yes,
3/4/2024,725150,Galyam,Korbeogo,(513) 978-8988,Geraldine,1,Trainer 30,Yes,
3/4/2024,719233,Damaind,Madaris,513-374-5236,Geraldine,1,Trainor 3 ,Yes,
3/5/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Trainer 15,Yes,
3/11/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 15,Yes,
3/18/2024,303364,Sean,Miller,513-668-7423,Geraldine,1,Trainer 15,Yes,
3/18/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 30,Yes,
3/19/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Trainer 3,Yes,
3/20/2024,696703,DaQuan,Allen,(513) 604-4591,Geraldine,1,Trainer 15,Yes,
3/26/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,"Display 10, 74LS190",Yes,
3/26/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Trainer 30,Yes,
4/8/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 30,Yes,
4/9/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,7 seg display,Yes,
4/9/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,"Trainer 3, 7seg display",Yes,
4/15/2024,303364,Sean,Miller,513-668-7423,Geraldine,1,Dig kit,Yes,
4/15/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 3,Yes,
4/16/2024,706645,Minaj,Waeba,513-306-1948,Geraldine,1,Trainer 3,Yes,
4/16/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,Trainer 30,Yes,
4/17/2024,495148,Jasmine,Hurst,(704) 907-3211,-,1,HP charger,Yes,
4/22/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 30,Yes,
4/24/2024,730163,Sam,Beccaccio,(859) 462-5058,Geraldine,1,"Trainer 3, 7seg display",Yes,
4/25/2024,706645,Manoj,Waiba,513-306-1948,Geraldine,1,"Trainer 1, 7seg display",Yes,
4/29/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer 15,Yes,
5/2/2024,,Larry,Feist,,Feist,1,Toolkit 5,Disposable,
5/2/2024,706645,Manoj,Waiba,513-306-1948,Geraldine,1,Dig Kit ,Yes,
6/6/2024,,,,,Curtis,1,MSP430 #2,Yes,
8/14/2024,719233,Damen,Madaris,513-374-5236,Ray,1,Calculator,Yes,
8/26/2024,699106,Alex,Masraum,513-470-7774,Geraldine,1,Dig Kit,Disposable,left voicemail
8/26/2024,706242,Isabella,Carmen,513-497-7066,Geraldine,1,Dig Kit,Yes,
8/26/2024,739273,Joshua,Hoffman,513-687-4090,Geraldine,1,Dig Kit,Yes,
8/26/2024,598689,Quincy,Milton,513-616-2311,Geraldine,1,Dig Kit,Yes,
8/26/2024,682898,Dakota,Risch,513-417-6479,Geraldine,1,Dig Kit,Yes,
8/26/2024,732516,Jacob,Steinmetz,216-644-3967,Geraldine,1,Dig Kit,Yes,left voicemail
8/26/2024,598689,Quincy,Milton,513-616-2311,Geraldine,1,Trainer 15,Yes,
8/26/2024,682898,Dakota,Risch,513-417-6479,Geraldine,1,Trainer 27,Yes,
8/26/2024,739273,Joshua,Hoffman,513-687-4090,Geraldine,1,Trainer 32,Yes,
8/26/2024,732516,Jacob,Steinmetz,216-644-3967,Geraldine,1,Trainer 34,Yes,
8/27/2024,671792,Aaron,Arocho,(513) 254-1498,curtis,1,bread board,Disposable,
8/27/2024,671792,Aaron,Arocho,(513) 254-1498,curtis,1,instrumentation kit 7,No,will drop off by friday
8/27/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1, instrumentation kit 12,Yes,
8/27/2024,738133,Colin,McCloy,(513) 479-6857,curtis,1,bread board,Yes,
8/27/2024,664251,Andrew,Osburg,(859) 640-5563,curtis,1,instrumentation kit 3,Yes,left voicemail
8/27/2024,738133,Colin,McCloy,(513) 479-6857,curtis,1,instrumentation kit 4,Yes,
8/27/2024,151430,Rathana,Kreal,(513) 407-0607,curtis,1,instrumentation kit 6,Yes,
8/27/2024,706242,isabella,Carmen,(513) 497-7066,curtis,1,instrumentation kit 8,Yes,
8/27/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,trainer 32,Yes,
8/27/2024,738133,Colin,McCloy,(513) 479-6857,curtis,1,trainer 34,Yes,
8/28/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1, Trainer 32,Yes,
8/28/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,1,Breadboard,Yes,
8/28/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,1,Dig Kit,Yes,will bring on 12/18
8/28/2024,709439,jorden ,Hess,513-444-7808,Geraldine,1,Dig Kit,Yes,left voicemail
8/28/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Dig Kit,Yes,will bring on 12/18
8/28/2024,709786,Andrew,Moreland,513-439-0915,Geraldine,1,Dig Kit,Yes,left voicemail
8/28/2024,678189,william,Smith,513-609-0114,Geraldine,1,Dig Kit,Yes,left voicemail
8/28/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,1,MSP430 #1,Yes,
8/28/2024,709786,Andrew,Moreland,513-439-0915,Geraldine,1,Trainer 27,Yes,
8/28/2024,717574,Andrew,Sliper,(937) 705-9811,curtis,1,Trainer 27,Yes,
8/29/2024,717574,Andrew,Slipper,(937) 705-9811,Curtis,1,Motor Kit #6,Yes,
8/29/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit #7,Yes,
8/29/2024,711504,Nelson,Malakada,513-479-0684,Curtis,1,Motor Kit #8,Yes,
8/29/2024,717574,Andrew,Slipper,(937) 705-9811,Curtis,1,Trainer #32,Yes,
8/30/2024,680996,Zemirah ,Torrey,(513) 655-0954,Curtis,1,Trainer #27,Yes,
9/3/2024,717574,Andrew,Slipper,(937) 705-9811,Curtis,1,Instrumentation Kit #1,Yes,will bring on 12/18
9/3/2024,717574,Andrew,Slipper,(937) 705-9811,Curtis,1,Motor Kit #8,Yes,
9/3/2024,671792,Aaron,Arocho,(513) 254-1498,Curtis,1,Trainer #27,Yes,
9/3/2024,680996,Zemirah ,Torrey,(513) 655-0954,Curtis,1,Trainer #32,Yes,
9/4/2024,716991,Garrett,Hornsby,513-300-4346,Ralph,1,Dig Kit,Yes,
9/4/2024,725150,Galyam,Korbogo,513-978-8988,Ralph,1,Dig Kit,Yes,left voicemail
9/4/2024,707595,Jarod,Moore,513-575-6735,Ralph,1,Dig Kit,Yes,Says he returned it
9/4/2024,731814,Jonathan,Nemi,716-940-0074,Ralph,1,Dig Kit,Yes,
9/4/2024,695941,Nicholas,Odgers,513-678-4837,Ralph,1,Dig Kit,Yes,wrong number
9/4/2024,708026,Justin,Owens,513-316-5228,Ralph,1,Dig Kit,Yes,
9/4/2024,658471,Noah,Patsfall,513-846-5118,Geraldine,1,Dig Kit,Yes,drop box return
9/4/2024,743939,Tyler,Vrh,513-319-5211,Ralph,1,Dig Kit,Yes,
9/4/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Dig Kit,Yes,
9/4/2024,708026,Justin,Owens,513-316-5228,Ralph,1,Trainer #15,Yes,
9/4/2024,716991,Garrett,Hornsby,513-300-4346,Ralph,1,Trainer #27,Yes,
9/4/2024,709786,Andrew,Moreland,513-439-0915,Geraldine,1,Trainer #27,Yes,
9/4/2024,708026,Justin,Owens,513-316-5228,Ralph,1,Trainer #27,Yes,
9/4/2024,707595,Jarod,Moore,513-575-6735,Ralph,1,Trainer #31,Yes,
9/4/2024,725150,Galyam,Korbogo,513-978-8988,Ralph,1,Trainer #32,Yes,
9/4/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #34,Yes,
9/4/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #9,Yes,
9/4/2024,695941,Nicholas,Odgers,513-678-4837,Ralph,1,Trainer #9,Yes,
9/5/2024,722073,Abagial,Atwood,513-544-8101,Curtis,1,Instrumentation Kit #9,No,left voicemail
9/9/2024,,Jody,Black,,,1,HP charger,Yes,
9/10/2024,711504,Nelson,Makada,(513) 479-0684,Curtis,1,"Instrumentation Kit #5, Breadboard",Temporarily Yes,
9/10/2024,711504,Nelson,Makada,(513) 479-0684,Curtis,1,Digital Trainer #32,Yes,
9/11/2024,708026,Justin,Owens,513-316-5228,Ralph,1,Trainer #31,Yes,
9/11/2024,707595,Jarod,Moore,513-575-6735,Ralph,1,Trainer #32,Yes,
9/11/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #43,Yes,
9/16/2024,708890,Bryce,Drake,(513) 609-6551,Savrda,1,trainer 31,Yes,
9/16/2024,682898,Dakota,Risch,(513) 417-6479,Savrda,1,Trainer 42,Yes,
9/17/2024,711504,Nelson,Malakada,513-479-0684,Curtis,1,Motor Kit #8,Yes,
9/17/2024,722073,Abagial,Atwood,513-544-8101,Curtis,1,Trainer #41,Yes,
9/18/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #03,Yes,
9/18/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #41,Yes,
9/19/2024,706242,isabella,Carmen,(513) 497-7066,curtis,1,motor and control kit 8,Yes,
9/23/2024,708890,Bryce,Drake,(513) 609-6551,Geraldine,1,Dig Kit,Yes,
9/23/2024,726553,Eric,Medly,(513) 446-9639,Geraldine,1,Dig Kit,Yes,
9/23/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Dig Kit,Yes,
9/23/2024,,Ann,Gunkel,(513) 569-1783,,,Green extension cable,Yes,
9/23/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer 31,Yes,
9/23/2024,708890,Bryce,Drake,(513) 609-6551,Geraldine,1,trainer 42,Yes,
9/25/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #42,Yes,
9/25/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #42,Yes,
9/30/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #42,Yes,
10/2/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #3,Yes,
10/4/2024,656484,Avana,Hilton,(513) 208-0538,Ralph,1,Microcontroller #2,Yes,left voicemail i think lol
10/7/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #3,Yes,
10/8/2024,151430,Rathana,Kreal,(513) 407-0607,,1,Soldering Kit #17,Yes,
10/9/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #42,Yes,
10/15/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #42,Yes,
10/16/2024,711504,Nelson,Makada,(513) 479-0684,Curtis,1,Instrumentation kit #05,Yes,bro has no voicemail box
10/16/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,Trainer #42,Yes,
10/16/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #42,Yes,
10/17/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,trainer 31,Yes,
10/18/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #42,Yes,
10/21/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #42,Yes,
10/21/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,trainer #43,Yes,
10/21/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,trainer 31,Yes,
10/21/2024,711504,Nelson,Malakada,513-479-0684,Curtis,1,trainer 31,Yes,
10/23/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,trainer 31,Yes,
10/24/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 8,Yes,
10/29/2024,706242,isabella,Carmen,(513) 497-7066,curtis,1,motor and control kit 6,Yes,
10/29/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 7,Yes,
10/29/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #31,Yes,
10/31/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 8,Yes,
11/4/2024,726553,Eric,Medly,(513) 446-9639,Geraldine,1,Dig Kit,Yes,
11/4/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #41,Yes,
11/4/2024,726553,Eric,Medly,(513) 446-9639,Geraldine,1,trainer 31,Yes,
11/4/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,trainer 31 breadboard,Yes,
11/5/2024,706242,isabella,Carmen,(513) 497-7066,curtis,1,motor and control kit 8,Yes,
11/5/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #41,Yes,
11/6/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #41,Yes,
11/6/2024,725150,Galyan,Korbeogo,(513) 978-8988,Ralph,1,trainer 32,Yes,
11/7/2024,711504,Nelson,Malakada,513-479-0684,Curtis,1,trainer 32,Yes,
11/12/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 3,Yes,
11/13/2024,709439,jorden ,Hess,513-444-7808,Geraldine,1,breadboard,Yes,
11/13/2024,709786,Andrew,Moreland,513-439-0915,Geraldine,1,breadboard,Yes,
11/13/2024,678189,william,Smith,513-609-0114,Geraldine,1,breadboard,Yes,
11/13/2024,656484,Avana,Hilton,(513) 208-0538,Ralph,1,Trainer 32,Yes,
11/13/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,trainer 42,Yes,
11/14/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 3,Yes,
11/15/2024,,Jody,Black,(513) 330-0078,,1,HP charger,Yes,
11/18/2024,719233,Damen,Madaris,513-374-5236,Geraldine,1,breadboard,Yes,
11/18/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #42,Yes,
11/19/2024,712169,Alexander ,Taylor,(513) 516-6673,Savrda,1,2 probes +breadboard,Yes,
11/19/2024,706242,isabella,Carmen,(513) 497-7066,curtis,1,motor and control kit 3,Yes,
11/19/2024,730163,Sam,Beccaccio,(859) 462-5058,Curtis,1,Motor Kit 8,Yes,
11/20/2024,231805,Amy,Gutman Fuentes,(513) 706-9524,Geraldine,1,breadboard,Yes,
11/20/2024,709925,andrew,lakes,(513) 903-0701,Geraldine,1,probes x3,Yes,
11/25/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #42,Yes,
12/2/2024,717561,Omar,Sheta,(513) 288-4216,Savrda,1,Trainer #41,Yes,
12/3/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #03,Yes,
12/4/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #31,Yes,
12/4/2024,725150,Galyan,Korbeogo,(513) 978-8988,Ralph,1,Trainer #34,Yes,
12/4/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,trainer 42,Yes,
12/5/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,1,7 segment display ,Yes,
12/5/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,2,74190 chip,Yes,
12/5/2024,695527,Kantima,Egngtion,(513) 364-5302,Geraldine,1,Trainer #31,Yes,
12/9/2024,680996,Zemirah ,Torrey,(513) 655-0954,curtis,1,Trainer #09,Yes,
12/11/2024,709786,Andrew,Moreland,513-439-0915,Geraldine,1,breadboard,Disposable,
12/11/2024,708026,Jackson,Owens,513-316-5228,Ralph,1,Trainer #31,Yes,
12/11/2024,725150,Galyam,Korbeogo,,Geraldine,1,Trainer #41,Yes,
12/11/2024,732670,Caroline,Wilbur,904-333-2204,Ralph,1,Trainer #41,Yes,
1/13/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,Dig Kit,No,
1/13/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Dig Kit,Yes,
1/13/2025,682677,Evan,Frank,513-616-4462,Geraldine,1,Dig Kit,Yes,
1/13/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Dig Kit,Yes,
1/13/2025,682677,Evan,Frank,513-616-4462,Geraldine,1,Trainer #30,Yes,
1/13/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Trainer #32,Yes,
1/13/2025,,Geraldine,Danger,,Geraldine,1,Trainer #34,Yes,
1/13/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,Trainer #41,Yes,
1/13/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #42,Yes,
1/14/2025,738234,ben,weber,(812) 716-6481,curtis,1,instrumentation kit 13,Yes,
1/14/2025,738862,ethan ,alexander,(929) 888-3555,waley,1,dig kit,Yes,
1/14/2025,727389,allison,carr,(859) 446-8632,waley,1,dig kit ,Yes,
1/14/2025,735376,anthony,franks,(740) 504-6680,waley,1,dig kit ,Yes,
1/14/2025,739273,Joshua,Hoffman,(513) 687-4090,Geraldine,1,dig kit,Yes,
1/14/2025,687366,miles,landon,(513) 908-5744,waley,1,dig kit ,Yes,
1/14/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,dig kit,Yes,
1/14/2025,738133,collin ,mccloy,(513) 479-6857,waley,1,dig kit,Yes,
1/14/2025,726553,Eric,Medley,(513) 446-9639,Geraldine,1,dig kit,Yes,
1/14/2025,695941,Nicholas,Odgers,(513) 678-4837,Geraldine,1,dig kit,Yes,
1/14/2025,727050,lucy,wang,(513) 886-9513,waley,1,dig kit,Yes,
1/14/2025,721046,Cecil,payne,(513) 439-0888,Curtis,1,Instrumentation Kit #04,Yes,
1/14/2025,731464,Logan ,Grever,(859) 391-2090,Curtis,1,Instrumentation Kit #12,Yes,
1/14/2025,732209,jonah,baldwin,(513) 503-9819,curtis,1,instrumentation kit #14,Yes,
1/14/2025,735841,Jesse ,Cooper,(801) 889-0623,curtis,1,instrumentation kit 1,Yes,
1/21/2025,633360,adrian,bacon,(513) 264-9579,,1,dig kit,No,
1/21/2025,617633,caleb,brennan,(513) 497-8301,waley,1,dig kit,No,
1/21/2025,717461,Simon,Valdez,(859) 240-9186,ralph,1,dig kit,No,
1/21/2025,725150,Galyam,Korbogo,513-978-8988,Ralph,1,Dig Kit,Yes,
1/21/2025,708026,Justin,Owens,513-316-5228,Ralph,1,Dig Kit,Yes,
1/21/2025,711504,Nelson,Makada,513-479-0684,curtis,1,instrumentation kit 3,Yes,
1/21/2025,711504,Nelson,Makada,513-479-0684,curtis,1,phillips screwdriver,Yes,
1/21/2025,717461,Simon,Valdez,(859) 240-9186,ralph,1,trainer 31,Yes,
1/21/2025,687366,miles,landon,(513) 908-5744,waley,1,trainer 32,Yes,
1/21/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 34,Yes,
1/21/2025,727050,lucy,wang,(513) 886-9513,waley,1,trainer 42,Yes,
1/21/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 8,Yes,
1/23/2025,721046,Cecil,payne,(513) 439-0888,Curtis,1,trainer 32,Yes,
1/27/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #32,Yes,
1/27/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,Trainer #34,Yes,
1/27/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Trainer #42,Yes,
1/28/2025,687366,miles,landon,(513) 908-5744,waley,1,trainer 09,Yes,
1/28/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 31,Yes,
1/28/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 31,Yes,
1/28/2025,727050,lucy,wang,(513) 886-9513,waley,1,trainer 41,Yes,
2/3/2025,,,,,curtis,,microcontroller 3,No,
2/3/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Trainer #31,Yes,
2/3/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #32,Yes,
2/3/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,trainer 41,Yes,
2/4/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 34,Yes,
2/10/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,trainer 31,Yes,
2/10/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer 41,Yes,
2/10/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Trainer 42,Yes,
2/11/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 31,Yes,
2/11/2025,633360,adrian,bacon,(513) 264-9579,,1,trainer 31 + temp deg kit,Yes,
2/11/2025,732209,Jonah,Baldwin,513-503-9819,Geraldine,1,trainer 34,Yes,
2/11/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 42,Yes,
2/13/2025,738234,Benjamin,Weber,812-716-6481,Curtis,1,trainer 31,Yes,
2/18/2025,633360,adrian,bacon,(513) 264-9579,Geraldine,1,7seg,Yes,
2/18/2025,739273,Joshua,Hoffman,(513) 687-4090,Geraldine,1,7seg,Yes,
2/18/2025,725150,Galyam,Korbogo,513-978-8988,geraldine,1,7seg,Yes,
2/18/2025,708026,Justin,Owens,513-316-5228,geraldine,1,7seg,Yes,
2/18/2025,726553,Eric,Medley,(513) 446-9639,Geraldine,1,7seg  display,Yes,
2/18/2025,695941,Nicholas,Odgers,(513) 678-4837,Geraldine,1,7segment display,Yes,
2/25/2025,,Kid,,,,a few,Chips for personal project,Disposable,
2/25/2025,739273,Joshua,Hoffman,(513) 687-4090,Geraldine,1,7seg,No,
2/25/2025,725150,Galyam,Korbogo,513-978-8988,geraldine,1,7seg,No,
2/25/2025,708026,Justin,Owens,513-316-5228,geraldine,1,7seg,No,
2/25/2025,726553,Eric,Medley,(513) 446-9639,Geraldine,1,7seg  display,Yes,
2/25/2025,695941,Nicholas,Odgers,(513) 678-4837,Geraldine,1,7segment display,Yes,
2/25/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 31,Yes,
2/25/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 34,Yes,
2/25/2025,738133,collin ,mccloy,(513) 479-6857,waley,1,Trainer 41,Yes,
3/3/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,"Motor Kit #3, Multimeter",Yes,
3/3/2025,716944,Max,Hall,(513) 805-2605,curtis,1,"motor kit #4, multimeter",Yes,
3/3/2025,#3698,Aaron,Arocho,513-254-1498,Curtis,1,Motor Kit #5,Yes,
3/3/2025,#0685,Meka,Nwachukwu,347-279-1996,Curtis,1,"Motor Kit #6, Multimeter",Yes,
3/3/2025,721046,Cecil,Payne,513-439-0888,Curtis,1,"Motor Kit #7, Multimeter",Yes,
3/3/2025,Curtis,Curtis,Curtis,Curtis,Curtis,1,Motor Kit #8,Yes,
3/3/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #31,Yes,
3/3/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,Trainer #34,Yes,
3/3/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,Trainer #41,Yes,
3/3/2025,678189,william,Smith,513-609-0114,Geraldine,~~,Various hookup wires for MSP430,Yes,
3/4/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 32,Yes,
3/4/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 42,Yes,
3/10/2025,#0685,Meka,Nwachukwu,347-279-1996,Curtis,1,Motor Kit #3,Yes,
3/11/2025,617633,caleb,brennan,(513) 497-8301,waley,1,trainer 34,Yes,
3/17/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #31,Yes,
3/17/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #41,Yes,
3/18/2025,617633,caleb,brennan,(513) 497-8301,waley,1,Trainer #09,Yes,
3/18/2025,738133,collin ,mccloy,(513) 479-6857,waley,1,Trainer #34,Yes,
3/18/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,Tranier #42,Yes,
3/24/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #09,Yes,
3/24/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,Trainer #31,Yes,
3/24/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #42,Yes,
3/25/2025,617633,caleb,brennan,(513) 497-8301,waley,1,Trainer #31,Yes,
3/25/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,Tranier #42,Yes,
3/31/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #09,Yes,
3/31/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #42,Yes,
4/1/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #34,Yes,
4/7/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #08,Yes,
4/7/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,trainer #42,Yes,
4/8/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,Trainer #41,Yes,
4/9/2025,700224,Erin,Molar,(513) 869-1177,ron,1,soldering kit #16,Yes,
4/14/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #08,Yes,
4/14/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,trainer #31,Yes,
4/14/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #32,Yes,
4/15/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,Trainer #34,Yes,
4/17/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,soldering kit 35,Yes,
4/21/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,trainer #32,Yes,
4/21/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #42,Yes,
4/22/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 31,Yes,
4/23/2025,721045,Tyler,Sansone,(513) 903-0996,Ron,1,Soldering Kit #31,Yes,
4/23/2025,738234,Benjamin,Weber,812-716-6481,Curtis,1,trainer 34,Yes,
4/24/2025,676359,jason,stanley,(513) 592-7216,geraldine,1,"solder kit 12, breadboard",Yes,
4/24/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #31,Yes,
4/28/2025,,Larry,,,Larry,1 drawer,Screwdrivers,Yes,
4/28/2025,#1461,Jonah,Baldwin,513-503-9819,Curtis,1,trainer #08,Yes,
4/28/2025,671816,Nathan,McClellan,513-801-0896,Geraldine,1,trainer #08,Yes,
4/28/2025,741979,Gerald,Cummings,937-620-1894,Geraldine,1,Trainer #34,Yes,
4/29/2025,699442,benie,lumbuambu,(859) 415-7196,waley,1,trainer 41,Yes,
4/30/2025,749072,arthur,viirchanko,(513) 302-8713,waley,1,solder kit 02,No,
4/30/2025,,ava,Chatman,513-817-7259,Ralf,1,Solder kit 31,Yes,
5/20/2025,598689,quincy,milton,(513) 616-2311,geraldine,1,dig kit,Yes,
5/20/2025,732042,steven,mose,(513) 808-8690,geraldine,1,dig kit,Yes,
5/20/2025,732042,steven,mose,(513) 808-8690,geraldine,1,trainer 34,Yes,
5/20/2025,754286,daniel,hoffer,(513) 706-5730,geraldine,1,dig kit,Yes,
7/3/2025,745890,russ,wright,(513) 257-7539,Thelson,1,solder kit 37,Yes,
7/3/2025,676443,daniel,kaiser,(513) 704-6652,Thelson,1,solder kit 25,Yes,
7/3/2025,691755,imaed,boudouma,(513) 823-8869,Thelson,1,solder kit 33,Yes,
7/3/2025,755314,geuillermo ,venegas,(360) 674-6762,Thelson,1,solder kit 7,Yes,
7/28/2025,721661,dontonio,brown,(513) 955-2673,Geraldine,1,wire strippers,Yes,
8/12/2025,656060,cameron,wallace,(513) 696-2861,ron,1,solder kit #01 + 3sponges + bottle,Yes,
8/12/2025,746378,nathaniel,offei,(513) 633-5047,ron,1,solder kit #21,Yes,
8/12/2025,728227,erin,grow,(360) 922-2959,ron,1,solder kit #31,Yes,
8/14/2025,656060,cameron,wallace,(513) 696-2861,ron,1,Solder kit 02,Yes,
8/25/2025,745890,Russ,Wright,(513) 257-7539,Geraldine,1,Dig Kit ,No,
8/25/2025,8366,Simon,Raver,(859) 640-5167,Geraldine,1,Dig Kit,Yes,
8/25/2025,7792,Divin,Ilunga,(513) 816-9326,Geraldine,1,Dig Kit,No,
8/25/2025,738234,Ben,Weber,(812) 716-6481,Geraldine,1,Dig Kit,No,
8/25/2025,707595,Jared,Moore,(513) 575-6735,Geraldine,1,Dig Kit,No,
8/29/2025,labcenter,lab,center,yuh,207 cabinet,1,Microcontroller #5,No,
9/3/2025,738234,Ben,Webber,(812) 716-6481,Geraldine,1,trainer 41,Yes,
9/3/2025,707595,jared,moore,(513) 575-6735,Geraldine,1,temporary dig kit,yes,
9/3/2025,731773,devin,ilunga,(513) 816-9326,geraldine,1,trainer 34,yes,
,,,,,geraldine,1,trainer #8,yes,
9/8/2025,729129,Abygale,browning,(513) 673-5792,feghali,1,ruler,No,
9/10/2025,731773,devin,ilunga,(513) 816-9326,geraldine,1,trainer #08,yes,
9/10/2025,738234,Ben,Webber,(812) 716-6481,Geraldine,1,trainer #34,yes,
9/15/2025,753628,Vince,Vogel,(513) 518-7691,,1,painter's tape,Yes,
9/10/2025,731773,devin,ilunga,(513) 816-9326,geraldine,1,trainer #08,Yes,
9/24/2025,731773,devin,ilunga,(513) 816-9326,geraldine,1,trainer #34,Yes,
9/3/2025,707595,jared,moore,(513) 575-6735,Geraldine,1,temporary dig kit,Yes,
10/1/2025,731773,devin,ilunga,(513) 816-9326,geraldine,1,trainer #34,yes,
,,,,,,,,No,
,,Geraldine,,,,1,Trainer #8,Yes,
,738234,Benjamin,Weber,812-716-6481,Curtis,1,trainer 31,Yes,
"""

# ... script to follow

def clean_whitespace(value: str) -> str:
    return re.sub(r"\s+", " ", value.strip()) if value else ""


def smart_case(value: str) -> str:
    value = clean_whitespace(value)
    if not value:
        return ""
    normalized = value
    if value.isupper() or value.islower():
        normalized = value.title()
    # Fix common prefixes like Mc, Mac, O'
    normalized = re.sub(r"\bMc([a-z])", lambda m: "Mc" + m.group(1).upper(), normalized)
    normalized = re.sub(r"\bMac([a-z])", lambda m: "Mac" + m.group(1).upper(), normalized)
    normalized = re.sub(r"\bO'([a-z])", lambda m: "O'" + m.group(1).upper(), normalized)
    return normalized


def normalize_status(value: str) -> str | None:
    value = clean_whitespace(value.lower()) if value else ""
    if not value:
        return None
    if "disposable" in value:
        return "Disposable"
    if value.startswith("temp"):
        return "Temporarily Yes"
    if value in {"yes", "y", "returned", "return", "true"}:
        return "Yes"
    if value in {"no", "n"}:
        return "No"
    return value.title()


def normalize_material(value: str) -> str:
    if not value:
        return ""
    text = clean_whitespace(value.replace("\u2019", "'").strip('"'))
    if not text:
        return ""
    # Fix obvious typos and variants before casing
    replacements = {
        "trainor": "trainer",
        "tranier": "trainer",
        "dig kit": "digital kit",
        "dig trainer": "digital trainer",
        "temporary dig kit": "digital kit (temporary)",
        "temp dig kit": "digital kit (temporary)",
        "trainer#": "trainer #",
        "trainer  #": "trainer #",
        "bread board": "breadboard",
        "breadboard": "breadboard",
        "breadboard": "breadboard",
        "reistors": "resistors",
        "3sponges": "3 sponges",
        "7seg": "7-seg",
        "7 segment": "7-seg",
        "msp 430": "msp430",
        "msp-430": "msp430",
        "hp charger": "hp charger",
        "motor kit": "motor kit",
        "motor and control": "motor & control",
        "instrumentation kit": "instrumentation kit",
        "digital trainer trainer": "digital trainer",
    }
    lowered = text.lower()
    for needle, repl in replacements.items():
        lowered = lowered.replace(needle, repl)
    text = lowered
    # Normalize numeric suffixes
    def normalize_numbered(prefix: str, label: str, raw: str) -> str:
        pattern = rf"{prefix}\s*#?\s*(\d+)"
        return re.sub(pattern, lambda m: f"{label} #{int(m.group(1))}", raw)

    text = normalize_numbered("digital trainer", "Digital Trainer", text)
    text = normalize_numbered("trainer", "Trainer", text)
    text = normalize_numbered("instrumentation kit", "Instrumentation Kit", text)
    text = normalize_numbered("motor kit", "Motor Kit", text)
    text = normalize_numbered("solder kit", "Soldering Kit", text)
    text = normalize_numbered("soldering kit", "Soldering Kit", text)
    text = normalize_numbered("microcontroller", "Microcontroller", text)

    text = re.sub(r"digital kit", "Digital Kit", text)
    text = re.sub(r"temporary", "Temporary", text)
    text = re.sub(r"7-seg", "7-Segment", text)
    text = re.sub(r"\bphillips screwdriver\b", "Phillips Screwdriver", text, flags=re.I)
    text = re.sub(r"\bmotor & control kit\b", "Motor & Control Kit", text, flags=re.I)
    text = re.sub(r"\bwire strippers\b", "Wire Strippers", text, flags=re.I)
    text = re.sub(r"\bbreadboard\b", "Breadboard", text, flags=re.I)

    text = clean_whitespace(text)
    # Apply title casing where appropriate
    cased = text.title()
    fixes = {
        "Usb": "USB",
        "Msp430": "MSP430",
        "Aa": "AA",
        "Hp": "HP",
        "Led": "LED",
        "Ls": "LS",
        "V10": "V10",
        "Vrh": "VRH",
        "Id": "ID",
        "Ms": "MS",
    }
    for bad, good in fixes.items():
        cased = re.sub(bad, good, cased)
    # Preserve number formatting like #03 -> #3
    cased = re.sub(r"#0(\d)", r"#\1", cased)
    cased = cased.replace("  ", " ")
    return cased.strip()


def sql_literal(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("'", "''") + "'"


def build_rows() -> list[dict]:
    reader = csv.reader(RAW_DATA.strip().splitlines())
    header = next(reader)
    keys = []
    for column in header:
        key = column.strip().lower()
        key = re.sub(r"[^a-z0-9]+", "_", key)
        key = re.sub(r"_+", "_", key).strip('_')
        keys.append(key)

    rows: list[dict] = []
    skipped: list[tuple[int, list[str]]] = []
    for idx, raw_row in enumerate(reader, start=2):
        if not any(cell.strip() for cell in raw_row):
            continue
        # Pad row if shorter
        if len(raw_row) < len(keys):
            raw_row += [""] * (len(keys) - len(raw_row))
        row = {keys[i]: raw_row[i].strip() for i in range(len(keys))}

        date_text = row.get("date", "")
        checkout_date = None
        if date_text:
            try:
                checkout_date = dt.datetime.strptime(date_text, "%m/%d/%Y").date()
            except ValueError:
                checkout_date = None

        school_id = clean_whitespace(row.get("id", "")) or None
        first_name = smart_case(row.get("first_name", "").replace('"', ''))
        last_name = smart_case(row.get("last_name", "").replace('"', ''))
        phone = clean_whitespace(row.get("phone", "")) or None
        instructor = smart_case(row.get("instructor", "")) or None
        qty_label = clean_whitespace(row.get("qty", "")) or None
        material = normalize_material(row.get("material", ""))
        status = normalize_status(row.get("returned", ""))
        return_note = clean_whitespace(row.get("return_note", "")) or None

        if not material:
            skipped.append((idx, raw_row))
            continue
        if not checkout_date:
            skipped.append((idx, raw_row))
            continue
        if not first_name and not last_name:
            skipped.append((idx, raw_row))
            continue

        if not first_name:
            first_name = "Unknown"
        if not last_name:
            last_name = "Unknown"

        rows.append({
            "row": idx,
            "checkout_date": checkout_date.isoformat(),
            "school_id": school_id,
            "first_name": first_name,
            "last_name": last_name,
            "phone": phone,
            "instructor": instructor,
            "qty": qty_label,
            "material": material,
            "status": status,
            "return_note": return_note,
        })

    if skipped:
        print(f"Skipped {len(skipped)} rows due to missing required data: {[r[0] for r in skipped]}")
    return rows


def generate_sql(rows: list[dict]) -> str:
    lines: list[str] = []
    lines.append("/* Auto-generated legacy import script */")
    lines.append("USE dbLabCenter;")
    lines.append("GO")
    lines.append("SET NOCOUNT ON;")
    lines.append("")
    lines.append("DECLARE @DefaultDeptID INT = (SELECT intDepartmentID FROM dbo.TDepartments WHERE strDepartmentName = 'Electrical Engineering Tech');")
    lines.append("DECLARE @CheckoutLabTechID INT = (SELECT intLabTechID FROM dbo.TLabTechs WHERE strFirstName = 'Josie');")
    lines.append("IF @DefaultDeptID IS NULL OR @CheckoutLabTechID IS NULL")
    lines.append("BEGIN")
    lines.append("    RAISERROR('Required seed data not found. Ensure departments and lab techs are populated.', 16, 1);")
    lines.append("    RETURN;")
    lines.append("END")
    lines.append("")
    lines.append("IF OBJECT_ID('tempdb..#LegacyLoans') IS NOT NULL DROP TABLE #LegacyLoans;")
    lines.append("CREATE TABLE #LegacyLoans (")
    lines.append("    LegacyRowID   INT IDENTITY(1,1) PRIMARY KEY,")
    lines.append("    CheckoutDate  DATE        NOT NULL,")
    lines.append("    SchoolID      VARCHAR(50) NULL,")
    lines.append("    FirstName     VARCHAR(50) NULL,")
    lines.append("    LastName      VARCHAR(50) NULL,")
    lines.append("    Phone         VARCHAR(30) NULL,")
    lines.append("    Instructor    VARCHAR(100) NULL,")
    lines.append("    QtyLabel      VARCHAR(40) NULL,")
    lines.append("    Material      VARCHAR(120) NOT NULL,")
    lines.append("    ReturnStatus  VARCHAR(40) NULL,")
    lines.append("    ReturnNote    VARCHAR(200) NULL");
    lines.append(");")
    lines.append("")
    lines.append("INSERT INTO #LegacyLoans (CheckoutDate, SchoolID, FirstName, LastName, Phone, Instructor, QtyLabel, Material, ReturnStatus, ReturnNote)")
    lines.append("VALUES")

    value_lines = []
    for idx, row in enumerate(rows):
        tuple_sql = "(" + ", ".join([
            sql_literal(row["checkout_date"]),
            sql_literal(row["school_id"]),
            sql_literal(row["first_name"]),
            sql_literal(row["last_name"]),
            sql_literal(row["phone"]),
            sql_literal(row["instructor"]),
            sql_literal(row["qty"]),
            sql_literal(row["material"]),
            sql_literal(row["status"]),
            sql_literal(row["return_note"]),
        ]) + ")"
        value_lines.append("    " + tuple_sql)
    lines.append(",\n".join(value_lines) + ";")
    lines.append("")
    lines.append(";WITH BorrowerSource AS (")
    lines.append("    SELECT")
    lines.append("        l.SchoolID,")
    lines.append("        l.FirstName,")
    lines.append("        l.LastName,")
    lines.append("        l.Phone,")
    lines.append("        l.Instructor,")
    lines.append("        ROW_NUMBER() OVER (")
    lines.append("            PARTITION BY COALESCE(NULLIF(l.SchoolID, ''), CONCAT(UPPER(ISNULL(l.FirstName,'')), '|', UPPER(ISNULL(l.LastName,'')), '|', UPPER(ISNULL(l.Phone,''))))")
    lines.append("            ORDER BY l.CheckoutDate")
    lines.append("        ) AS rn")
    lines.append("    FROM #LegacyLoans l")
    lines.append("    WHERE ISNULL(l.FirstName, '') <> '' OR ISNULL(l.LastName, '') <> ''")
    lines.append(")")
    lines.append("INSERT INTO dbo.TBorrowers (strFirstName, strLastName, strSchoolIDNumber, strPhoneNumber, strInstructor, intDepartmentID)")
    lines.append("SELECT DISTINCT")
    lines.append("    bs.FirstName,")
    lines.append("    bs.LastName,")
    lines.append("    NULLIF(bs.SchoolID, ''),")
    lines.append("    NULLIF(bs.Phone, ''),")
    lines.append("    NULLIF(bs.Instructor, ''),")
    lines.append("    @DefaultDeptID")
    lines.append("FROM BorrowerSource bs")
    lines.append("WHERE bs.rn = 1")
    lines.append("  AND NOT EXISTS (")
    lines.append("        SELECT 1")
    lines.append("        FROM dbo.TBorrowers b")
    lines.append("        WHERE (")
    lines.append("            NULLIF(bs.SchoolID, '') IS NOT NULL AND b.strSchoolIDNumber = NULLIF(bs.SchoolID, '')")
    lines.append("        ) OR (")
    lines.append("            NULLIF(bs.SchoolID, '') IS NULL AND")
    lines.append("            b.strFirstName = bs.FirstName AND")
    lines.append("            b.strLastName = ISNULL(bs.LastName, '') AND")
    lines.append("            ISNULL(b.strPhoneNumber, '') = ISNULL(bs.Phone, '')")
    lines.append("        )");
    lines.append("")
    lines.append(";WITH ItemSource AS (")
    lines.append("    SELECT DISTINCT l.Material")
    lines.append("    FROM #LegacyLoans l")
    lines.append(")")
    lines.append("INSERT INTO dbo.TItems (strItemName, blnIsSchoolOwned, intDepartmentID, strDescription)")
    lines.append("SELECT")
    lines.append("    isrc.Material,")
    lines.append("    1,")
    lines.append("    @DefaultDeptID,")
    lines.append("    'Imported from legacy checkout spreadsheet' ")
    lines.append("FROM ItemSource isrc")
    lines.append("WHERE NOT EXISTS (")
    lines.append("    SELECT 1 FROM dbo.TItems ti WHERE ti.strItemName = isrc.Material")
    lines.append(");")
    lines.append("")
    lines.append(";WITH LoanData AS (")
    lines.append("    SELECT")
    lines.append("        l.LegacyRowID,")
    lines.append("        l.CheckoutDate,")
    lines.append("        l.QtyLabel,")
    lines.append("        l.Material,")
    lines.append("        l.ReturnStatus,")
    lines.append("        l.ReturnNote,")
    lines.append("        CASE WHEN l.ReturnStatus IN ('Yes', 'Temporarily Yes', 'Disposable') THEN 1 ELSE 0 END AS IsReturned,")
    lines.append("        (SELECT TOP 1 b.intBorrowerID FROM dbo.TBorrowers b WHERE (")
    lines.append("            NULLIF(l.SchoolID, '') IS NOT NULL AND b.strSchoolIDNumber = NULLIF(l.SchoolID, '')")
    lines.append("        ) OR (")
    lines.append("            NULLIF(l.SchoolID, '') IS NULL AND b.strFirstName = l.FirstName AND b.strLastName = ISNULL(l.LastName, '') AND ISNULL(b.strPhoneNumber,'') = ISNULL(l.Phone,'')")
    lines.append("        ) ORDER BY b.intBorrowerID) AS BorrowerID,")
    lines.append("        (SELECT TOP 1 i.intItemID FROM dbo.TItems i WHERE i.strItemName = l.Material ORDER BY i.intItemID) AS ItemID,")
    lines.append("        l.Instructor,")
    lines.append("        l.Phone")
    lines.append("    FROM #LegacyLoans l")
    lines.append(")")
    lines.append("INSERT INTO dbo.TItemLoans (")
    lines.append("    intItemID, intBorrowerID, intCheckoutLabTechID, dtmCheckoutUTC, dtmDueUTC, strCheckoutNotes,")
    lines.append("    dtmCheckinUTC, intCheckinLabTechID, strCheckinNotes,")
    lines.append("    snapBorrowerFirstName, snapBorrowerLastName, snapSchoolIDNumber, snapPhoneNumber, snapRoomNumber, snapInstructor,")
    lines.append("    snapItemName, snapItemNumber, snapIsSchoolOwned, snapDepartmentName")
    lines.append("SELECT")
    lines.append("    ld.ItemID,")
    lines.append("    ld.BorrowerID,")
    lines.append("    @CheckoutLabTechID,")
    lines.append("    DATEADD(HOUR, 14, CAST(ld.CheckoutDate AS DATETIME2(0))),")
    lines.append("    NULL,")
    lines.append("    CONCAT('Legacy import - Qty: ', ISNULL(ld.QtyLabel, '1'), '; Instructor: ', ISNULL(ld.Instructor, 'Unknown')), ")
    lines.append("    CASE WHEN ld.IsReturned = 1 THEN DATEADD(HOUR, 18, CAST(ld.CheckoutDate AS DATETIME2(0))) ELSE NULL END,")
    lines.append("    CASE WHEN ld.IsReturned = 1 THEN @CheckoutLabTechID ELSE NULL END,")
    lines.append("    CASE WHEN ld.ReturnStatus IS NOT NULL THEN CONCAT('Legacy status: ', ld.ReturnStatus, ISNULL(CONCAT(' - ', ld.ReturnNote), '')) ELSE ld.ReturnNote END,")
    lines.append("    b.strFirstName,")
    lines.append("    b.strLastName,")
    lines.append("    b.strSchoolIDNumber,")
    lines.append("    b.strPhoneNumber,")
    lines.append("    b.strRoomNumber,")
    lines.append("    b.strInstructor,")
    lines.append("    i.strItemName,")
    lines.append("    i.strItemNumber,")
    lines.append("    i.blnIsSchoolOwned,")
    lines.append("    d.strDepartmentName")
    lines.append("FROM LoanData ld")
    lines.append("JOIN dbo.TBorrowers b ON b.intBorrowerID = ld.BorrowerID")
    lines.append("JOIN dbo.TItems i ON i.intItemID = ld.ItemID")
    lines.append("LEFT JOIN dbo.TDepartments d ON d.intDepartmentID = i.intDepartmentID")
    lines.append("WHERE ld.ItemID IS NOT NULL AND ld.BorrowerID IS NOT NULL")
    lines.append("  AND NOT EXISTS (")
    lines.append("        SELECT 1")
    lines.append("        FROM dbo.TItemLoans existing")
    lines.append("        WHERE existing.intItemID = ld.ItemID")
    lines.append("          AND existing.intBorrowerID = ld.BorrowerID")
    lines.append("          AND existing.dtmCheckoutUTC = DATEADD(HOUR, 14, CAST(ld.CheckoutDate AS DATETIME2(0)))")
    lines.append("    );")
    lines.append("")
    lines.append("DROP TABLE #LegacyLoans;")
    return "\n".join(lines) + "\n"


def main() -> None:
    rows = build_rows()
    output = generate_sql(rows)
    os.makedirs('sql', exist_ok=True)
    output_path = os.path.join('sql', 'legacy_loans_import.sql')
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(output)
    print(f"Wrote {len(rows)} rows to {output_path}")


if __name__ == '__main__':
    main()
