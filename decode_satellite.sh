#!/bin/bash

SAT=$1
FILEKEY=$2
TLE_FILE=$3
START_TIME=$4
SAMPLERATE=$5

IMAGE_DIR=${WX_GROUND_DIR}/images
LOG_DIR=${WX_GROUND_DIR}/logs
AUDIO_DIR=${WX_GROUND_DIR}/audio
DRAFT_DIR=${WX_GROUND_DIR}/draft
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
AUDIO_FILE_NORM=${AUDIO_DIR}/${FILEKEY}_NORM.wav # For METEOR-M 2
AUDIO_FILE_DEMOD=${AUDIO_DIR}/${FILEKEY}.qpsk # For METEOR-M 2
AUDIO_FILE_BASE=${AUDIO_DIR}/${FILEKEY} # For METEOR-M 2
MAP_FILE=${IMAGE_DIR}/${FILEKEY}-map.png
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

echo $SAMPLERATE

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

      upload.sh "${SAT}" ${FILEKEY}
  else
    echo "NO AUDIO FILE" >>$LOGFILE
  fi
fi

if [[ "$SAT" == "METEOR-M 2" ]]; then

  if [ `wc -c <${AUDIO_FILE}` -le 1000000 ]; then
      echo "Audio file ${AUDIO_FILE}.wav too small, probably wrong recording" 2>> $LOGFILE
      exit
  fi

  # Normalise:
  #sox ${AUDIO_FILE} ${AUDIO_FILE_NORM} channels 1 gain -n
  sox ${AUDIO_FILE} ${AUDIO_FILE_NORM} gain -n

  # Demodulate:
  yes | meteor_demod -B -m qpsk -o ${AUDIO_FILE_DEMOD} ${AUDIO_FILE_NORM}

  touch -r ${AUDIO_FILE_NORM} ${AUDIO_FILE_DEMOD}

  medet ${AUDIO_FILE_DEMOD} ${AUDIO_FILE_BASE} -cd -q

  touch -r ${AUDIO_FILE} ${AUDIO_FILE_BASE}.dec

  # Create image:
  # composite only
  medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE} -r 65 -g 65 -b 64 -d -q
  # three channels
  #medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE} -S -r 65 -g 65 -b 64 -d -q
  # IR
  medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE}_IR -r 68 -g 68 -b 68 -d -q

  if [[ -f "${AUDIO_FILE_BASE}.bmp" ]]; then
    convert ${AUDIO_FILE_BASE}.bmp ${IMAGE_DIR}/${FILEKEY}.png &> /dev/null
    rm -f ${AUDIO_FILE_BASE}.bmp
    touch -r ${AUDIO_FILE} ${IMAGE_DIR}/${FILEKEY}.png
    # check brightness
    brightness=`convert ${IMAGE_DIR}/${FILEKEY}.png -colorspace Gray -format "%[fx:image.mean]" info:`
    if (( $(echo "$brightness > 0.09" |bc -l) )); then
      echo -e "\nComposite image created!" 2>> $LOGFILE
    else
      mv ${IMAGE_DIR}/${FILEKEY}.png ${DRAFT_DIR}
      echo -e "\nComposite image too dark, probably bad quality." 2>> $LOGFILE
    fi
  fi

  if [[ -f "${AUDIO_FILE_BASE}_IR.bmp" ]]; then
    convert ${AUDIO_FILE_BASE}_IR.bmp -negate -normalize ${IMAGE_DIR}/${FILEKEY}_IR.png &> /dev/null
    rm -f ${AUDIO_FILE_BASE}_IR.bmp
    touch -r ${AUDIO_FILE} ${IMAGE_DIR}/${FILEKEY}_IR.png
    # check brightness
    brightness=`convert ${IMAGE_DIR}/${FILEKEY}_IR.png -negate -colorspace Gray -format "%[fx:image.mean]" info:`
    if (( $(echo "$brightness > 0.09" |bc -l) )); then
      echo -e "\nIR image created!" 2>> $LOGFILE
    else
      mv ${IMAGE_DIR}/${FILEKEY}_IR.png ${DRAFT_DIR}
      echo -e "\nIR image too dark, probably bad quality." 2>> $LOGFILE
    fi
  fi

  rm -f ${AUDIO_FILE_NORM}

  echo "upload.sh \"${SAT}\" ${FILEKEY}" >> $LOGFILE 2>&1s
  upload.sh "${SAT}" ${FILEKEY} >> $LOGFILE 2>&1
fi
