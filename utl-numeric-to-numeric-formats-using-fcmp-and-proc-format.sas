Numeric to numeric formats using fcmp and proc format

github
https://tinyurl.com/ya3mpnhp
https://github.com/rogerjdeangelis/utl-numeric-to-numeric-formats-using-fcmp-and-proc-format

   Two Solutions
        a. fcmp (more robust)
        b. proc format (questionalble with non integer labels (ie 0.3333))

Numeric to Numeric mappings are not supported directly by 'proc format'.

Problem:
   Map Days without rain to Fire Threat level - to 4

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;
data have;
input Days_without_rain;
cards4;
12
44
33
21
18
77
;;;;
run;quit;

Mapping

Days withou Rain    fire Threat Level

0-14                     1
15-28                    2
29-56                    3
56-high                  4

 *            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
  __
 / _| ___ _ __ ___  _ __
| |_ / __| '_ ` _ \| '_ \
|  _| (__| | | | | | |_) |
|_|  \___|_| |_| |_| .__/
                   |_|
;

WORK.WANT

     Variables in Creation Order

#    Variable             Type    Len

1    DAYS_WITHOUT_RAIN    Num       8
2    FIRE_THREAT          Num       8  *

    DAYS_
  WITHOUT_     FIRE_
    RAIN      THREAT

     12          1        12 is between 0 and 14 +> Threat Level 1

     44          3
     33          3
     21          2
     18          2
     77          4
* __                            _
 / _| ___  _ __ _ __ ___   __ _| |_
| |_ / _ \| '__| '_ ` _ \ / _` | __|
|  _| (_) | |  | | | | | | (_| | |_
|_|  \___/|_|  |_| |_| |_|\__,_|\__|

;

     Variables in Creation Order

#    Variable             Type    Len

1    DAYS_WITHOUT_RAIN    Num       8

2    FIRE_THREAT_CHAR     Char      1  ==> Need intermediate char var - problematic with non integers
3    FIRE_THREAT_NUM      Num       8


Up to 40 obs from WANT_FMT total obs=6

         DAYS_      FIRE_      FIRE_
       WITHOUT_    THREAT_    THREAT_
Obs      RAIN       CHAR        NUM

 1        12          1          1
 2        44          3          3
 3        33          3          3
 4        21          2          2
 5        18          2          2
 6        77          4          4

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
  __
 / _| ___ _ __ ___  _ __
| |_ / __| '_ ` _ \| '_ \
|  _| (__| | | | | | |_) |
|_|  \___|_| |_| |_| .__/
                   |_|
;;

%let cmplib = %sysfunc(getoption(cmplib));
options cmplib = (work.functions &cmplib);

proc fcmp outlib=work.functions.fireThreat;
function fireThreat(fire);
   select ;
      when (0<=fire<=14    )              threat= 1;
      when (15<=fire<=28   )              threat= 2;
      when (29<=fire<=56   )              threat= 3;
      when (57<=fire<=constant('bigint')) threat= 4;
      otherwise;
    end;
  return(threat);
endsub;
run;quit;


data want;
  set have;;
  fire_Threat =firethreat(Days_without_rain);
run;quit;

* __                            _
 / _| ___  _ __ _ __ ___   __ _| |_
| |_ / _ \| '__| '_ ` _ \ / _` | __|
|  _| (_) | |  | | | | | | (_| | |_
|_|  \___/|_|  |_| |_| |_|\__,_|\__|

;
proc format;
  value noRain2FireThreat
0-14      =     1
15-28     =     2
29-56     =     3
56-high   =     4
;
run;quit;

data want_fmt;
  set have;;
  fire_Threat_Char=put(Days_without_rain,noRain2FireThreat.);
  fire_Threat_Num=input(put(Days_without_rain,noRain2FireThreat.),3.);
run;quit;


