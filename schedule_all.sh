#!/bin/bash

# This script is suppose to be execute once a day

SCRIPTS_DIR=${WX_GROUND_DIR}/scripts
CELESTRAK_TLE_FILE=${WX_GROUND_DIR}/weather.txt
TLE_FILE=${WX_GROUND_DIR}/weather.tle
NEXT_PASSES=${WX_GROUND_DIR}/upcoming_passes.txt


# Update Satellite Information

/usr/bin/logger "[WX weather station] Updating TLE from Celestrak"

/usr/bin/wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O ${CELESTRAK_TLE_FILE}
/usr/bin/grep "NOAA 15" ${CELESTRAK_TLE_FILE} -A 2 > ${TLE_FILE}
/usr/bin/grep "NOAA 18" ${CELESTRAK_TLE_FILE} -A 2 >> ${TLE_FILE}
/usr/bin/grep "NOAA 19" ${CELESTRAK_TLE_FILE} -A 2 >> ${TLE_FILE}
/usr/bin/grep "METEOR-M 2" ${CELESTRAK_TLE_FILE} -A 2 >> ${TLE_FILE}

#Remove all AT jobs

for i in `/usr/bin/atq | /usr/bin/awk '{print $1}'`;do /usr/bin/atrm $i;done

# Remove previous calculated passes

/usr/bin/rm -f ${WX_GROUND_DIR}/upcoming_passes.txt

#Schedule Satellite Passes
PROPAGATOR_CMD="python3 ${SCRIPTS_DIR}/predict.py --location ${WX_GROUND_LAT} ${WX_GROUND_LON} ${WX_GROUND_LON} ${TLE_FILE}"
echo $PROPAGATOR_CMD

while IFS= read -r line; do
    SAT=`echo $line | awk '{print $10 " " $11}'`
    START_EPOCH=`echo $line | awk '{print $3}'`
    JOB_START=`date --date="TZ=\"UTC\" @${START_EPOCH}" "+%H:%M %D"`
    FILEKEY=`echo $line | awk '{print $8}'`
    JOB_TIMER=`echo $line | awk '{print $5}'`
    MAXELEV=`echo $line | awk '{print $4}'`

    if [[ "$SAT" == "NOAA 19" ]]; then
      FREQ=137100000
      SAMPLERATE=96000 # Must match with the sample rate on spyserver and decimation. Mine is 384K with 2 decimation (384000 / 4 = 96000)
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    elif [[ "$SAT" == "NOAA 18" ]]; then
      FREQ=137912000
      SAMPLERATE=96000
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    elif [[ "$SAT" == "NOAA 15" ]]; then
      FREQ=137620000
      SAMPLERATE=96000
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    else    # METEOR-M 2
      FREQ=137100000
      SAMPLERATE=192000 # Must match with the sample rate on spyserver and decimation. Mine is 384K with 2 decimation (384000 / 2 = 192000)
    fi

    if [ $MAXELEV -ge $WX_GROUND_MAX_ELEV ]; then
      echo ${line} >> ${NEXT_PASSES}
      COMMAND="$WX_GROUND_DIR/receive_satellite.sh \"${SAT}\" $FREQ $SAMPLERATE ${FILEKEY} $TLE_FILE $START_EPOCH $JOB_TIMER $BANDWIDTH $DEVIATION $OUTPUTSAMPLERATE"
      echo CREATING JOB: $COMMAND at $JOB_START
      echo $COMMAND | at $JOB_START
    fi
done < <( eval $PROPAGATOR_CMD )
