#!/bin/bash

# Update Satellite Information

logger "[WX weather station] Updating TLE from Celestrak"

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O $WX_GROUND_DIR/weather.txt
grep "NOAA 15" $WX_GROUND_DIR/weather.txt -A 2 > $WX_GROUND_DIR/weather.tle
grep "NOAA 18" $WX_GROUND_DIR/weather.txt -A 2 >> $WX_GROUND_DIR/weather.tle
grep "NOAA 19" $WX_GROUND_DIR/weather.txt -A 2 >> $WX_GROUND_DIR/weather.tle

#Remove all AT jobs

for i in `atq | awk '{print $1}'`;do atrm $i;done

rm -f $WX_GROUND_DIR/upcoming_passes.txt

#Schedule Satellite Passes:

$WX_GROUND_DIR/schedule_satellite.sh "NOAA 19" 137100000
$WX_GROUND_DIR/schedule_satellite.sh "NOAA 18" 137912000
$WX_GROUND_DIR/schedule_satellite.sh "NOAA 15" 137620000
