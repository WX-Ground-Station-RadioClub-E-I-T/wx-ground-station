#!/bin/bash

SAT=$1
SAT_NORM=${1// /_} # Substitude space on upload
FILEKEY=$2

AUDIO_DIR=${WX_GROUND_DIR}/audio
IMAGE_DIR=$WX_GROUND_DIR/images
FTP_DIRECTORY=$WX_GROUND_FTP_DIR

if [[ "$SAT" == "NOAA 19" || "$SAT" == "NOAA 15" || "$SAT" == "NOAA 18" ]]; then
  AUDIO_FILE=${FILEKEY}.wav
  AUDIO_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.wav
  IQ_FILE=${FILEKEY}.iq
  IQ_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.iq
  MAP_FILE=${FILEKEY}-map.png
  MAP_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-map.png
  ZA_FILE=${FILEKEY}-ZA.png
  ZA_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-ZA.png
  NO_FILE=${FILEKEY}-NO.png
  NO_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-NO.png
  MSA_FILE=${FILEKEY}-MSA.png
  MSA_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-MSA.png
  MCIR_FILE=${FILEKEY}-MCIR.png
  MCIR_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-MCIR.png
  THERM_FILE=${FILEKEY}-THERM.png
  THERM_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-THERM.png
  MB_FILE=${FILEKEY}-MB.png
  MB_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-MB.png
  MD_FILE=${FILEKEY}-MD.png
  MD_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-MD.png
  BD_FILE=${FILEKEY}-BD.png
  BD_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-BD.png
  CC_FILE=${FILEKEY}-CC.png
  CC_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-CC.png
  EC_FILE=${FILEKEY}-EC.png
  EC_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-EC.png
  HE_FILE=${FILEKEY}-HE.png
  HE_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-HE.png
  HF_FILE=${FILEKEY}-HF.png
  HF_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-HF.png
  JF_FILE=${FILEKEY}-JF.png
  JF_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-JF.png
  JJ_FILE=${FILEKEY}-JJ.png
  JJ_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-JJ.png
  LC_FILE=${FILEKEY}-LC.png
  LC_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-LC.png
  WV_FILE=${FILEKEY}-WV.png
  WV_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-WV.png
  MSA_PRECIP_FILE=${FILEKEY}-MSA-precip.png
  MSA_PRECIP_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-MSA-precip.png
  HVC_FILE=${FILEKEY}-HVC.png
  HVC_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-HVC.png
  HVCT_FILE=${FILEKEY}-HVCT.png
  HVCT_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-HVCT.png
  SEA_FILE=${FILEKEY}-sea.png
  SEA_FILE_DIR=${IMAGE_DIR}/${FILEKEY}-sea.png


  echo "UPLOADING FILES"
  echo $IQ_FILE_DIR
  echo $MAP_FILE_DIR
  echo $ZA_FILE_DIR
  echo $NO_FILE_DIR
  echo $MSA_FILE_DIR
  echo $MCIR_FILE_DIR
  echo $THERM_FILE_DIR
  echo $MB_FILE_DIR
  echo $MD_FILE_DIR
  echo $BD_FILE_DIR
  echo $CC_FILE_DIR
  echo $EC_FILE_DIR
  echo $HE_FILE_DIR
  echo $HF_FILE_DIR
  echo $JF_FILE_DIR
  echo $JJ_FILE_DIR
  echo $LC_FILE_DIR
  echo $WV_FILE_DIR
  echo $MSA_PRECIP_FILE_DIR
  echo $HVC_FILE_DIR
  echo $HVCT_FILE_DIR
  echo $SEA_FILE_DIR

  DATE=`date +%Y-%m-%d`
  HOST=$WX_GROUND_FTP_SERVER
  USER=$WX_GROUND_FTP_USER
  PASSWD=$WX_GROUND_FTP_PASS

  # Upload to FTP

  ftp -n $HOST <<END_SCRIPT
  quote USER $USER
  quote PASS $PASSWD
  mkdir $FTP_DIRECTORY
  cd $FTP_DIRECTORY
  mkdir $SAT_NORM
  cd $SAT_NORM
  mkdir $DATE
  cd $DATE
  binary
  put $AUDIO_FILE_DIR $AUDIO_FILE
  put $IQ_FILE_DIR $IQ_FILE
  put $MAP_FILE_DIR $MAP_FILE
  put $ZA_FILE_DIR $ZA_FILE
  put $NO_FILE_DIR $NO_FILE
  put $MSA_FILE_DIR $MSA_FILE
  put $MCIR_FILE_DIR $MCIR_FILE
  put $THERM_FILE_DIR $THERM_FILE
  put $MB_FILE_DIR $MB_FILE
  put $MD_FILE_DIR $MD_FILE
  put $BD_FILE_DIR $BD_FILE
  put $CC_FILE_DIR $CC_FILE
  put $EC_FILE_DIR $EC_FILE
  put $HE_FILE_DIR $HE_FILE
  put $HF_FILE_DIR $HF_FILE
  put $JF_FILE_DIR $JF_FILE
  put $JJ_FILE_DIR $JJ_FILE
  put $LC_FILE_DIR $LC_FILE
  put $WV_FILE_DIR $WV_FILE
  put $MSA_PRECIP_FILE_DIR $MSA_PRECIP_FILE
  put $HVC_FILE_DIR $HVC_FILE
  put $HVCT_FILE_DIR $HVCT_FILE
  put $SEA_FILE_DIR $SEA_FILE
  quit
END_SCRIPT

  # Send web hook to IFTTT
  if [[ "$WX_GROUND_IFTTT_WEBHOOK" != "" ]]; then
    IMAGE_URL="${WX_GROUND_FTP_URL}/${FTP_DIRECTORY}/${SAT_NORM}/${DATE}/${FILEKEY}-MCIR.png"
    HUMAN_TIME=`date +%H:%M`
    echo "curl -X POST -H \"Content-Type: application/json\" -d '{\"value1\":\"'\"${SAT}\"'\",\"value2\":\"'\"${HUMAN_TIME}\"'\",\"value3\":\"'\"${IMAGE_URL}\"'\"}' ${WX_GROUND_IFTTT_WEBHOOK}"
    curl -X POST -H "Content-Type: application/json" -d '{"value1":"'"${SAT}"'","value2":"'"${HUMAN_TIME}"'","value3":"'"${IMAGE_URL}"'"}' ${WX_GROUND_IFTTT_WEBHOOK}
  fi
fi

if [[ "$SAT" == "METEOR-M 2" ]]; then
  AUDIO_FILE=${FILEKEY}.wav
  AUDIO_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.wav
  IQ_FILE=${FILEKEY}.iq
  IQ_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.iq
  QPSK_FILE=${FILEKEY}.qpsk
  QPSK_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.qpsk
  DEC_FILE=${FILEKEY}.dec
  DEC_FILE_DIR=${AUDIO_DIR}/${FILEKEY}.dec
  BMP_FILE=${FILEKEY}.bmp
  BMP_FILE_DIR=${IMAGE_DIR}/${FILEKEY}.bmp
  IR_BMP_FILE=${FILEKEY}_IR.bmp
  IR_BMP_FILE_DIR=${IMAGE_DIR}/${FILEKEY}_IR.bmp
  PNG_FILE=${FILEKEY}.png
  PNG_FILE_DIR=${IMAGE_DIR}/${FILEKEY}.png
  IR_PNG_FILE=${FILEKEY}_IR.png
  IR_PNG_FILE_DIR=${IMAGE_DIR}/${FILEKEY}_IR.png

  echo "UPLOADING FILES"
  echo ${AUDIO_FILE_DIR}
  echo ${IQ_FILE_DIR}
  echo ${QPSK_FILE_DIR}
  echo ${DEC_FILE_DIR}
  echo ${BMP_FILE_DIR}
  echo ${IR_BMP_FILE_DIR}
  echo ${PNG_FILE_DIR}
  echo ${IR_PNG_FILE_DIR}

  DATE=`date +%Y-%m-%d`
  HOST=$WX_GROUND_FTP_SERVER
  USER=$WX_GROUND_FTP_USER
  PASSWD=$WX_GROUND_FTP_PASS

  # Upload to FTP

  ftp -n $HOST <<END_SCRIPT
  quote USER $USER
  quote PASS $PASSWD
  mkdir $FTP_DIRECTORY
  cd $FTP_DIRECTORY
  mkdir $SAT_NORM
  cd $SAT_NORM
  mkdir $DATE
  cd $DATE
  binary
  put $AUDIO_FILE_DIR $AUDIO_FILE
  put $IQ_FILE_DIR $IQ_FILE
  put $QPSK_FILE_DIR $QPSK_FILE
  put $DEC_FILE_DIR $DEC_FILE
  put $BMP_FILE_DIR $BMP_FILE
  put $IR_BMP_FILE_DIR $IR_BMP_FILE
  put $PNG_FILE_DIR $PNG_FILE
  put $IR_PNG_FILE_DIR $IR_PNG_FILE
END_SCRIPT

  # Send web hook to IFTTT
  if [[ "$WX_GROUND_IFTTT_WEBHOOK" != "" && -e $PNG_FILE_DIR ]]; then
    IMAGE_URL="${WX_GROUND_FTP_URL}/${FTP_DIRECTORY}/${SAT_NORM}/${DATE}/${FILEKEY}.png"
    HUMAN_TIME=`date +%H:%M`
    echo "curl -X POST -H \"Content-Type: application/json\" -d '{\"value1\":\"'\"${SAT}\"'\",\"value2\":\"'\"${HUMAN_TIME}\"'\",\"value3\":\"'\"${IMAGE_URL}\"'\"}' ${WX_GROUND_IFTTT_WEBHOOK}"
    curl -X POST -H "Content-Type: application/json" -d '{"value1":"'"${SAT}"'","value2":"'"${HUMAN_TIME}"'","value3":"'"${IMAGE_URL}"'"}' ${WX_GROUND_IFTTT_WEBHOOK}
  fi
fi
