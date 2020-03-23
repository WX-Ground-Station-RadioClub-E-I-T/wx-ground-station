
# create directories
if [ ! -d "audio" ]
then
    mkdir audio
fi

if [ ! -d "images" ]
then
    mkdir images
fi

if [ ! -d "logs" ]
then
    mkdir logs
fi

chmod +x schedule_all.sh
chmod +x schedule_satellite.sh
chmod +x schedule_rotor.sh
chmod +x upload.sh
chmod +x decode_satellite.sh
chmod +x receive_satellite.sh

cronjobcmd="source $HOME/.profile; $WX_GROUND_DIR/schedule_all.sh"
cronjob="0 0 * * * $cronjobcmd"
( crontab -l | grep -v -F "$cronjobcmd" ; echo "$cronjob" ) | crontab -
