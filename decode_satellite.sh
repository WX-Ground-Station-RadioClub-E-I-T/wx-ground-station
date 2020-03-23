#!/bin/bash

SAT=$1
FILEKEY=$2
TLE_FILE=$3
START_TIME=$4
SAMPLERATE=$5

IMAGE_DIR=${WX_GROUND_DIR}/images
LOG_DIR=${WX_GROUND_DIR}/logs
AUDIO_DIR=${WX_GROUND_DIR}/audio
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
MAP_FILE=${IMAGE_DIR}/${FILEKEY}-map.png
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

PassStart=`expr $START_TIME + 90`

if [[ "$SAT" == "NOAA 19" || "$SAT" == "NOAA 15" || "$SAT" == "NOAA 18" ]]; then
  if [ -e $AUDIO_FILE ]
    then
      echo "bin/wxmap -T \"${SAT}\" -H $TLE_FILE -p 0 -l 0 -o $PassStart ${MAP_FILE}" >>$LOGFILE
      /usr/local/bin/wxmap -T "${SAT}" -H $TLE_FILE -p 0 -l 0 -o $PassStart ${MAP_FILE} >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e ZA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-ZA.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e ZA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-ZA.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e NO $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-NO.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e NO $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-NO.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MSA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MSA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MCIR $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MCIR.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MCIR $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MCIR.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e therm $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-THERM.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e therm $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-THERM.png >> $LOGFILE 2>&1

      echo "$WX_GROUND_DIR/upload.sh \"${SAT}\" ${FILEKEY}" >> $LOGFILE 2>&1
      $WX_GROUND_DIR/upload.sh "${SAT}" ${FILEKEY}
  else
    echo "NO AUDIO FILE" >>$LOGFILE
  fi
fi

