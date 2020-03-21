#!/bin/bash

cd $WX_GROUND_DIR

SAT=$1
FREQ=$2
TLE_FILE=weather.tle # CANT PUT ABSOLUT PATH, PREDICT BUG, SO MOVE TO $WX_GROUND_DIR FIRST

echo $TLE_FILE
PREDICTION_START=`/usr/bin/predict -t $TLE_FILE -p "$SAT" | head -1`
PREDICTION_END=`/usr/bin/predict -t $TLE_FILE -p "$SAT" | tail -1`

echo $PREDICTION_START
echo $PREDICTION_END

END_EPOCH=`echo $PREDICTION_END | cut -d " " -f 1`
END_EPOCH_DATE=`date --date="TZ=\"UTC\" @${END_EPOCH}" +%D`

echo $END_EPOCH
echo $END_EPOCH_DATE

MAXELEV=`/usr/bin/predict -t $TLE_FILE -p "${SAT}" | awk -v max=0 '{if($5>max){max=$5}}END{print max}'`
START_LAT=`echo $PREDICTION_START | awk '{print $8}'`
END_LAT=`echo $PREDICTION_END | awk '{print $8}'`

if $DEBUG; then
  PREDICTION_END_DATE=`echo $PREDICTION_END | awk '{print $3 " " $4}'`
  echo FIRST PREDICTION END AT: $PREDICTION_END_DATE
  echo MAX ELEV: $MAXELEV
fi

if [ $START_LAT -gt $END_LAT ]
  then
    DIR="southbound"
  else
    DIR="northbound"
fi

echo ---
while [ \"$END_EPOCH_DATE\" = \"`date +%D`\" ] || [ \"$END_EPOCH_DATE\" = \"`date --date="tomorrow" +%D`\" ]; do

  START_TIME=`echo $PREDICTION_START | cut -d " " -f 3-4`
  echo Start time $START_TIME
  START_EPOCH=`echo $PREDICTION_START | cut -d " " -f 1`
  echo START_EPOCH $START_EPOCH

  SECONDS_REMAINDER=`echo $START_TIME | cut -d " " -f 2 | cut -d ":" -f 3`
  echo SECONDS_REMAINDER $SECONDS_REMAINDER

  JOB_START=`date --date="TZ=\"UTC\" $START_TIME" +"%H:%M %D"`
  echo JOB_START $JOB_START

  # at jobs can only be started on minute boundaries, so add the
  # seconds remainder to the duration of the pass because the
  # recording job will start early
  PASS_DURATION=`expr $END_EPOCH - $START_EPOCH`
  echo PASS_DURATION $PASS_DURATION
  JOB_TIMER=`expr $PASS_DURATION + $SECONDS_REMAINDER`
  echo JOB_TIMER $JOB_TIMER
  OUTDATE=`date --date="TZ=\"UTC\" $START_TIME" +%Y%m%d-%H%M%S`
  echo OUTDATE $OUTDATE

  if [ $MAXELEV -ge 20 ]
    then
      FILEKEY="${SAT// /_}-${OUTDATE}"
      echo FILEKEY $FILEKEY

      COMMAND="./receive_satellite.sh \"${SAT}\" $FREQ \"${FILEKEY}\" $WX_GROUND_DIR/$TLE_FILE $START_EPOCH $JOB_TIMER $MAXELEV $DIR 32000 32000"
      echo $COMMAND
      echo $COMMAND | at $JOB_START

      TLE1=`grep "$SAT" $TLE_FILE -A 2 | tail -2 | head -1 | tr -d '\r'`
      TLE2=`grep "$SAT" $TLE_FILE -A 2 | tail -2 | tail -1 | tr -d '\r'`

      echo ${START_EPOCH},${END_EPOCH},${MAXELEV},${DIR},${SAT},"${TLE1}","${TLE2}" >>  upcoming_passes.txt
  fi

  nextpredict=`expr $END_EPOCH + 60`

  PREDICTION_START=`/usr/bin/predict -t $TLE_FILE -p "${SAT}" $nextpredict | head -1`
  PREDICTION_END=`/usr/bin/predict -t $TLE_FILE -p "${SAT}"  $nextpredict | tail -1`

  MAXELEV=`/usr/bin/predict -t $TLE_FILE -p "${SAT}" $nextpredict | awk -v max=0 '{if($5>max){max=$5}}END{print max}'`
  START_LAT=`echo $PREDICTION_START | awk '{print $8}'`
  END_LAT=`echo $PREDICTION_END | awk '{print $8}'`
  if [ $START_LAT -gt $END_LAT ]
    then
      DIR="southbound"
    else
      DIR="northbound"
  fi

  END_EPOCH=`echo $PREDICTION_END | cut -d " " -f 1`
  END_EPOCH_DATE=`date --date="TZ=\"UTC\" @${END_EPOCH}" +%D`

done
