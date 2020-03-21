#!/bin/bash

cd $WX_GROUND_DIR

DEBUG=true

SAT="NOAA 19"
TLE_FILE=weather.tle
SERVER="ea4rct.org"
PORT=4533

#SAT=$1

PREDICT_CMD="/usr/bin/predict -t weather.tle -p \"${SAT}\""
PREDICTION_END=`/usr/bin/predict -t $TLE_FILE -p "$SAT" | tail -1`

END_EPOCH=`echo $PREDICTION_END | cut -d " " -f 1`
END_EPOCH_DATE=`date --date="TZ=\"UTC\" @${END_EPOCH}" +%D`

MAXELEV=`/usr/bin/predict -t $TLE_FILE -p "${SAT}" | awk -v max=0 '{if($5>max){max=$5}}END{print max}'`

if $DEBUG; then
  echo CMD: $PREDICT_CMD
  PREDICTION_END_DATE=`echo $PREDICTION_END | awk '{print $3 " " $4}'`
  echo FIRST PREDICTION END AT: $PREDICTION_END_DATE
  echo MAX ELEV: $MAXELEV
fi

echo ---
while [ \"$END_EPOCH_DATE\" = \"`date +%D`\" ] || [ \"$END_EPOCH_DATE\" = \"`date --date="tomorrow" +%D`\" ]; do
  if [ $MAXELEV -ge 5 ]
    then
      while IFS= read -r line; do
          ELE=`echo $line | awk '{print $5}'`
          AZI=`echo $line | awk '{print $6}'`
          TIME=`echo $line | cut -d " " -f 3-4`
          JOB_START=`date --date="TZ=\"UTC\" $TIME" +"%H:%M %D"`
          SECONDS_OFFSET=`date --date="TZ=\"UTC\" $TIME" +"%S"`
          ROT_CMD="P ${AZI} ${ELE}"
          TELNET_CMD="echo \"${ROT_CMD}\" | telnet ${SERVER} ${PORT}"
          COMMAND="sleep \"${SECONDS_OFFSET}\"; ${TELNET_CMD} | at \"${JOB_START}\""

          if $DEBUG; then
            echo CREATING JOB: $COMMAND at $JOB_START
          else
            echo $COMMAND | at ${JOB_START}
          fi
      done < <( eval $PREDICT_CMD )
  fi

  nextpredict=`expr $END_EPOCH + 60`

  PREDICTION_END=`/usr/bin/predict -t $TLE_FILE -p "${SAT}"  $nextpredict | tail -1`
  PREDICT_CMD="/usr/bin/predict -t weather.tle -p \"${SAT}\" ${nextpredict}"

  MAXELEV=`/usr/bin/predict -t $TLE_FILE -p "${SAT}" $nextpredict | awk -v max=0 '{if($5>max){max=$5}}END{print max}'`

  END_EPOCH=`echo $PREDICTION_END | cut -d " " -f 1`
  END_EPOCH_DATE=`date --date="TZ=\"UTC\" @${END_EPOCH}" +%D`

done
