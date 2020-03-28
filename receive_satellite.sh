#!/bin/bash

SAT=$1
FREQ=$2
FILEKEY=$3
TLE_FILE=$4
START_TIME=$5
DURATION=$6
ELEVATION=$7
DIRECTION=$8
BANDWIDTH=$9
DEVIATION=${10}
OUTPUTSAMPLERATE=${11}

SERVER=$WX_GROUND_SPY_SERVER
PORT=$WX_GROUND_SPY_PORT
ROTCTLD_SERVER=$WX_GROUND_ROTCTLD_SERVER
ROTCTLD_PORT=$WX_GROUND_ROTCTLD_PORT
SAMPLERATE=$WX_GROUND_SPY_SAMPLERATE
GAIN=$WX_GROUND_SPY_GAIN
RX_LAT=$WX_GROUND_LAT
RX_LON=$WX_GROUND_LON
RX_ALT=$WX_GROUND_ALT
OFFSET=$WX_GROUND_RX_OFFSET

AUDIO_DIR=$WX_GROUND_DIR/audio
LOG_DIR=$WX_GROUND_DIR/logs
IQ_FILE=${AUDIO_DIR}/${FILEKEY}.iq
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

echo "/usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE  | /usr/local/bin/doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} --offset ${OFFSET} 2>> $LOGFILE | /usr/bin/tee ${IQ_FILE} | /usr/local/bin/demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | /usr/bin/sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}" 2>> $LOGFILE

/usr/bin/timeout $DURATION /usr/bin/ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | /usr/local/bin/rotor --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --server ${ROTCTLD_SERVER} --port ${ROTCTLD_PORT} 2>> $LOGFILE | /usr/local/bin/doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} --offset ${OFFSET} 2>> $LOGFILE | /usr/bin/tee ${IQ_FILE} | /usr/local/bin/demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | /usr/bin/sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}

echo "$WX_GROUND_DIR/decode_satellite.sh \"${SAT}\" ${AUDIO_FILE} ${TLE_FILE} ${START_TIME}" 2>> $LOGFILE
$WX_GROUND_DIR/decode_satellite.sh "${SAT}" "${FILEKEY}" ${TLE_FILE} ${START_TIME} ${OUTPUTSAMPLERATE}
