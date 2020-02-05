#!/bin/bash

# Update Satellite Information

BASEDIR="/home/acien101/gitRepos/wx-ground-station"

logger "[WX weather station] Updating TLE from Celestrak"

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O $BASEDIR/weather.txt
grep "NOAA 15" $BASEDIR/weather.txt -A 2 > $BASEDIR/weather.tle
grep "NOAA 18" $BASEDIR/weather.txt -A 2 >> $BASEDIR/weather.tle
grep "NOAA 19" $BASEDIR/weather.txt -A 2 >> $BASEDIR/weather.tle

#Remove all AT jobs

for i in `atq | awk '{print $1}'`;do atrm $i;done

rm -f $BASEDIR/upcoming_passes.txt

#Schedule Satellite Passes:

$BASEDIR/schedule_satellite.sh "NOAA 19" 137.1000
$BASEDIR/schedule_satellite.sh "NOAA 18" 137.9125
$BASEDIR/schedule_satellite.sh "NOAA 15" 137.6200
