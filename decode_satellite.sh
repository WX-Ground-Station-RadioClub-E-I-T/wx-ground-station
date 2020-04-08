#!/bin/bash

SAT=$1
FILEKEY=$2
TLE_FILE=$3
START_TIME=$4
SAMPLERATE=$5

MAX_ELEV=$WX_GROUND_MAX_ELEV
IMAGE_DIR=${WX_GROUND_DIR}/images
LOG_DIR=${WX_GROUND_DIR}/logs
AUDIO_DIR=${WX_GROUND_DIR}/audio
DRAFT_DIR=${WX_GROUND_DIR}/draft
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

if [[ "$SAT" == "NOAA 19" || "$SAT" == "NOAA 15" || "$SAT" == "NOAA 18" ]]; then
  if [ -e $AUDIO_FILE ]
    then
      PassStart=`expr $START_TIME + 90`
      MAP_FILE=${IMAGE_DIR}/${FILEKEY}-map.png

      echo "bin/wxmap -T \"${SAT}\" -M ${MAX_ELEV} -H $TLE_FILE -b 0 -p 0 -l 0 -o $PassStart ${MAP_FILE}" >>$LOGFILE
      /usr/local/bin/wxmap -T "${SAT}" -M ${MAX_ELEV} -H $TLE_FILE -b 0 -p 0 -l 0 -o $PassStart ${MAP_FILE} >> $LOGFILE 2>&1

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

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MB $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MB.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MB $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MB.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MD $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MD.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MD $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MD.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e BD $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-BD.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e BD $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-BD.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e CC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-CC.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e CC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-CC.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e EC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-EC.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e EC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-EC.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HE $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HE.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HE $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HE.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HF $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HF.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HF $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HF.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e JF $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-JF.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e JF $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-JF.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e JJ $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-JJ.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e JJ $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-JJ.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e LC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-LC.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e LC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-LC.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e WV $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-WV.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e WV $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-WV.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MSA-precip $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA-precip.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e MSA-precip $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA-precip.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HVC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HVC.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HVC $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HVC.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HVCT $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HVCT.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e HVCT $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-HVCT.png >> $LOGFILE 2>&1

      echo "/usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e sea $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-sea.png" >> $LOGFILE
      /usr/local/bin/wxtoimg -m ${MAP_FILE} -f ${SAMPLERATE} -e sea $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-sea.png >> $LOGFILE 2>&1

      echo "$WX_GROUND_DIR/upload.sh \"${SAT}\" ${FILEKEY}" >> $LOGFILE
      $WX_GROUND_DIR/upload.sh "${SAT}" ${FILEKEY} >> $LOGFILE 2>&1
  else
    echo "NO AUDIO FILE" >>$LOGFILE
  fi
fi

if [[ "$SAT" == "METEOR-M 2" ]]; then
  AUDIO_FILE_BASE=${AUDIO_DIR}/${FILEKEY} # For METEOR-M 2
  QPSK_FILE=${AUDIO_DIR}/${FILEKEY}.qpsk

  # Decode
  medet ${QPSK_FILE} ${AUDIO_FILE_BASE} -cd -q >> $LOGFILE 2>&1

  touch -r ${QPSK_FILE} ${AUDIO_FILE_BASE}.dec >> $LOGFILE 2>&1

  # Create image:
  # composite only
  medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE} -r 65 -g 65 -b 64 -d -q >> $LOGFILE 2>&1
  # three channels
  #medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE} -S -r 65 -g 65 -b 64 -d -q
  # IR
  medet ${AUDIO_FILE_BASE}.dec ${AUDIO_FILE_BASE}_IR -r 68 -g 68 -b 68 -d -q >> $LOGFILE 2>&1

  if [[ -f "${AUDIO_FILE_BASE}.bmp" ]]; then
    convert ${AUDIO_FILE_BASE}.bmp ${IMAGE_DIR}/${FILEKEY}.png &> /dev/null
    rm -f ${AUDIO_FILE_BASE}.bmp
    touch -r ${AUDIO_FILE} ${IMAGE_DIR}/${FILEKEY}.png
    # check brightness
    brightness=`convert ${IMAGE_DIR}/${FILEKEY}.png -colorspace Gray -format "%[fx:image.mean]" info:`
    if (( $(echo "$brightness > 0.09" |bc -l) )); then
      echo -e "\nComposite image created!" >> $LOGFILE
    else
      mv ${IMAGE_DIR}/${FILEKEY}.png ${DRAFT_DIR}
      echo -e "\nComposite image too dark, probably bad quality." >> $LOGFILE
    fi
  fi

  if [[ -f "${AUDIO_FILE_BASE}_IR.bmp" ]]; then
    convert ${AUDIO_FILE_BASE}_IR.bmp -negate -normalize ${IMAGE_DIR}/${FILEKEY}_IR.png &> /dev/null
    rm -f ${AUDIO_FILE_BASE}_IR.bmp
    touch -r ${AUDIO_FILE} ${IMAGE_DIR}/${FILEKEY}_IR.png
    # check brightness
    brightness=`convert ${IMAGE_DIR}/${FILEKEY}_IR.png -negate -colorspace Gray -format "%[fx:image.mean]" info:`
    if (( $(echo "$brightness > 0.09" |bc -l) )); then
      echo -e "\nIR image created!" >> $LOGFILE
    else
      mv ${IMAGE_DIR}/${FILEKEY}_IR.png ${DRAFT_DIR}
      echo -e "\nIR image too dark, probably bad quality." >> $LOGFILE
    fi
  fi

  echo "$WX_GROUND_DIR/upload.sh \"${SAT}\" ${FILEKEY}" >> $LOGFILE
  $WX_GROUND_DIR/upload.sh "${SAT}" ${FILEKEY} >> $LOGFILE 2>&1
fi
