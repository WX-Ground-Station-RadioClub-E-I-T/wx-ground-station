#!/bin/bash

BASEDIR="/home/acien101/gitRepos/wx-ground-station"
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

SERVER=$WX_GROUND_SPY_SERVER
PORT=$WX_GROUND_SPY_PORT
SAMPLERATE=$WX_GROUND_SPY_SAMPLERATE
GAIN=$WX_GROUND_SPY_GAIN
RX_LAT=$WX_GROUND_LAT
RX_LON=$WX_GROUND_LON
RX_ALT=$WX_GROUND_ALT
OFFSET=$WX_GROUND_RX_OFFSET

OUTPUTSAMPLERATE=11025

AUDIO_DIR=$WX_GROUND_DIR/audio
LOG_DIR=$WX_GROUND_DIR/logs
IQ_FILE=${AUDIO_DIR}/${FILEKEY}.iq
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log

echo $@ >> $LOGFILE

#/usr/local/bin/rtl_biast -b 1 2>> $LOGFILE
#sudo timeout $DURATION rtl_fm -f ${FREQ}M -s 60k -g 45 -p 0 -E wav -E deemp -F 9 - 2>> $LOGFILE | sox -t wav - $AUDIO_FILE rate 11025
#timeout $DURATION ./ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} | doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} > ${AUDIO_FILE}

echo $DEVIATION

echo "timeout $DURATION ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename \"${SAT}\" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} --offset ${OFFSET} 2>> $LOGFILE | tee ${IQ_FILE} | demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}" 2>> $LOGFILE

timeout $DURATION ss_client iq -r ${SERVER} -q ${PORT} -f ${FREQ} -s ${SAMPLERATE} 2>> $LOGFILE | doppler track -s ${SAMPLERATE} -i i16 --tlefile ${TLE_FILE} --tlename "${SAT}" --location lat=${RX_LAT},lon=${RX_LON},alt=${RX_ALT} --frequency ${FREQ} --offset ${OFFSET} 2>> $LOGFILE | tee ${IQ_FILE} | demod --samplerate ${SAMPLERATE} --intype i16 --outtype i16 --bandwidth ${BANDWIDTH} fm --deviation ${DEVIATION} 2>> $LOGFILE | sox -t raw -e signed-integer -r ${SAMPLERATE} -b 16 -c 1 -V1 - ${AUDIO_FILE} rate ${OUTPUTSAMPLERATE}


echo "./decode_satellite.sh \"${SAT}\" ${AUDIO_FILE} ${TLE_FILE} ${START_TIME}"
./decode_satellite.sh "${SAT}" "${FILEKEY}" ${TLE_FILE} ${START_TIME} ${OUTPUTSAMPLERATE}
