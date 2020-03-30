#!/bin/bash

TLE_FILE=${WX_GROUND_DIR}/weather.tle

PROPAGATOR_CMD="python3 ${WX_GROUND_DIR}/predict.py --location ${WX_GROUND_LAT} ${WX_GROUND_LON} ${WX_GROUND_LON} ${TLE_FILE}"
echo $PROPAGATOR_CMD

while IFS= read -r line; do
    SAT=`echo $line | awk '{print $6 " " $7}'`
    JOB_START=`echo $line | awk '{print $1 " " $2}'`
    OUTDATE=`date --date="TZ=\"UTC\" $JOB_START" +%Y%m%d-%H%M%S`
    FILEKEY="${SAT// /_}-${OUTDATE}"
    START_EPOCH=`echo $line | awk '{print $3}'`
    JOB_TIMER=`echo $line | awk '{print $5}'`
    MAXELEV=`echo $line | awk '{print $4}'`

    if [[ "$SAT" == "NOAA 19"]]; then
      FREQ=137100000
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    elif [[ "$SAT" == "NOAA 18" ]]; then
      FREQ=137912000
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    elif [[ "$SAT" == "NOAA 15" ]]; then
      FREQ=137620000
      BANDWIDTH=32000
      DEVIATION=32000
      OUTPUTSAMPLERATE=11025
    else    # METEOR-M 2
      FREQ=137100000
      BANDWIDTH=96000
      DEVIATION=96000
      OUTPUTSAMPLERATE=96000
    fi

    if [ $MAXELEV -ge $WX_GROUND_MAX_ELEV ]; then
      COMMAND="$WX_GROUND_DIR/receive_satellite.sh \"${SAT}\" $FREQ ${FILEKEY} $TLE_FILE $START_EPOCH $JOB_TIMER $MAXELEV $BANDWIDTH $DEVIATION $OUTPUTSAMPLERATE"
      echo CREATING JOB: $COMMAND at $JOB_START
      echo $COMMAND | at $JOB_START
    fi
done < <( eval $PROPAGATOR_CMD )
