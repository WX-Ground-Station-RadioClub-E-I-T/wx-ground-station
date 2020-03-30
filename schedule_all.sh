#!/bin/bash

# Update Satellite Information

/usr/bin/logger "[WX weather station] Updating TLE from Celestrak"

/usr/bin/wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O ${WX_GROUND_DIR}/weather.txt
/usr/bin/grep "NOAA 15" ${WX_GROUND_DIR}/weather.txt -A 2 > ${WX_GROUND_DIR}/weather.tle
/usr/bin/grep "NOAA 18" ${WX_GROUND_DIR}/weather.txt -A 2 >> ${WX_GROUND_DIR}/weather.tle
/usr/bin/grep "NOAA 19" ${WX_GROUND_DIR}/weather.txt -A 2 >> ${WX_GROUND_DIR}/weather.tle
/usr/bin/grep "METEOR-M 2" ${WX_GROUND_DIR}/weather.txt -A 2 >> ${WX_GROUND_DIR}/weather.tle

#Remove all AT jobs

for i in `/usr/bin/atq | /usr/bin/awk '{print $1}'`;do /usr/bin/atrm $i;done

/usr/bin/rm -f ${WX_GROUND_DIR}/upcoming_passes.txt

#Schedule Satellite Passes:
${WX_GROUND_DIR}/schedule_satellite.sh
