#!/bin/bash

SAT=$1
FREQ=$2
SAMPLERATE=$3
FILEKEY=$4
TLE_FILE=$5
START_TIME=$6
DURATION=$7
BANDWIDTH=$8
DEVIATION=$9
OUTPUTSAMPLERATE=${10}

SERVER=$WX_GROUND_SPY_SERVER
PORT=$WX_GROUND_SPY_PORT
ROTCTLD_SERVER=$WX_GROUND_ROTCTLD_SERVER
ROTCTLD_PORT=$WX_GROUND_ROTCTLD_PORT
GAIN=$WX_GROUND_SPY_GAIN
RX_LAT=$WX_GROUND_LAT
RX_LON=$WX_GROUND_LON
RX_ALT=$WX_GROUND_ALT
OFFSET=$WX_GROUND_RX_OFFSET

AUDIO_DIR=$WX_GROUND_DIR/audio
LOG_DIR=$WX_GROUND_DIR/logs
IQ_FILE=${AUDIO_DIR}/${FILEKEY}.iq
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
QPSK_FILE=${AUDIO_DIR}/${FILEKEY}.qpsk
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

if [[ "$SAT" == "NOAA 19" || "$SAT" == "NOAA 15" || "$SAT" == "NOAA 18" ]]; then
  echo "/usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE  | /usr/local/bin/doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} 2>> $LOGFILE | /usr/bin/tee ${IQ_FILE} | /usr/local/bin/demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | /usr/bin/sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}" >> $LOGFILE

  /usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE | /usr/local/bin/doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} 2>> $LOGFILE | /usr/bin/tee ${IQ_FILE} | /usr/local/bin/demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | /usr/bin/sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}

  echo "$WX_GROUND_DIR/decode_satellite.sh \"${SAT}\" \"${FILEKEY}\" ${TLE_FILE} ${START_TIME} ${OUTPUTSAMPLERATE}" >> $LOGFILE
  $WX_GROUND_DIR/decode_satellite.sh "${SAT}" "${FILEKEY}" ${TLE_FILE} ${START_TIME} ${OUTPUTSAMPLERATE}
elif [[ "$SAT" == "METEOR-M 2" ]]; then
  echo "/usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE >> ${IQ_FILE}" >> $LOGFILE

  /usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE >> ${IQ_FILE}

  if [ `wc -c <${IQ_FILE}` -le 1000000 ]; then
      echo "Audio file ${IQ_FILE} too small, probably wrong recording" >> $LOGFILE
      exit
  fi

  echo "NORMALIZE IQ" >> $LOGFILE
  sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 2 -V1 ${IQ_FILE} ${AUDIO_FILE} gain -n rate ${SAMPLERATE} >> $LOGFILE 2>&1

  echo "DEMODULATION QPSK"  >> $LOGFILE
  yes | meteor_demod -B -m qpsk -s ${SAMPLERATE} -o ${QPSK_FILE} ${AUDIO_FILE} >> $LOGFILE 2>&1

  touch -r ${AUDIO_FILE} ${QPSK_FILE} >> $LOGFILE 2>&1

  echo "$WX_GROUND_DIR/decode_satellite.sh \"${SAT}\" ${FILEKEY}" >> $LOGFILE
  $WX_GROUND_DIR/decode_satellite.sh "${SAT}" "${FILEKEY}"
fi
