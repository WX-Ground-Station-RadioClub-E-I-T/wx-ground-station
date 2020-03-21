# RadioClub EIT - Automated Weather Satellite Ground Station

Based on this [project](https://github.com/nootropicdesign/wx-ground-station) made by [nootropicdesign](https://github.com/nootropicdesign).

*Automated Weather Satelite Ground Station*. Automates the reception of weather satellites on Linux using [spyserver](https://airspy.com/quickstart/) and [rotctld](http://manpages.ubuntu.com/manpages/trusty/man8/rotctld.8.html). Even if you don't have groundstation you can connect to a sdr on [spyserver directory](https://airspy.com/directory/#).

Features:
* Powered by [predict](https://github.com/kd2bd/predict/), [wxtoimg](https://wxtoimgrestored.xyz), [spyserver_client](https://github.com/miweber67/spyserver_client), [doppler](https://github.com/cubehub/doppler), [demod](https://github.com/cubehub/demod), and Linux (Ubuntu and Debian tested).
* Works with **NOAA 18**, **NOAA 19** and **NOAA 15**
* Doppler correction
* Radio reception through [spyserver](https://airspy.com/quickstart/). Allows to multiple users to use the sdr at the same time.
* Antenna positioning through [rotctld](http://manpages.ubuntu.com/manpages/trusty/man8/rotctld.8.html). Allows to other users use the antenna control when is not receiving.
* Upload wav, iq and images to a **FTP** Server.

## Dependencies (Mainly for Linux)

### Some linux dependencies

```
$ sudo apt-get install autoconf
$ sudo apt-get install cmake
$ sudo apt-get install sox
$ sudo apt-get install at
$ sudo apt-get install libncurses5-dev libncursesw5-dev
```

### Doppler

Follow install instructions from here: <https://github.com/cubehub/doppler>


### Demod

Follow install instructions from here: <https://github.com/cubehub/demod>

### Predict

[Link](https://github.com/kd2bd/predict/)

```
$ wget https://www.qsl.net/kd2bd/predict-2.2.5.tar.bz2
$ tar -xvf predict-2.2.5.tar.bz2
$ cd predict
$ sudo ./configure /usr/bin
```

### Wxtoimg

[Link](https://wxtoimgrestored.xyz)

```
$ wget https://wxtoimgrestored.xyz/beta/wxtoimg-armhf-2.11.2-beta.deb
$ sudo dpkg -i wxtoimg-armhf-2.11.2-beta.deb
```

### Spyserver_client

[Link](https://github.com/miweber67/spyserver_client)

```
$ git clone https://github.com/erikd/libsamplerate.git
$ cd libsamplerate
$ mkdir build
$ cd build
$ cmake ..
$ make
$ sudo make install
$ cd ../..
$ git clone https://github.com/miweber67/spyserver_client
$ cd spyserver_client
$ git checkout ee20bcaf908fc859
$ make
$ sudo cp ./ss_client /usr/bin/ss_client
```

## Install

### Setup environment variables
Complete environment variables on `.venv` with your station data. Export them or put it on `~/.bashrc` for example. Make environment variables efective with `source ~/.bashrc`

### Configure Predict

Create a file under `~/.predict/predict.qth` with your station latitude, longitude, and altitude. Here is an example `predict.qth`.

```
EA4RCT
 40.452591
 -3.7286226
 666
```

### Configure wxtoimg

Write the next variables under ` ~/.wxtoimgrc`. Here is an example `.wxtoimgrc`.

```
Latitude: 40.438
Longitude: -3.708
Altitude: 666.0
```

### Configure project

Execute `configure.sh`. The `configure.sh` script sets the installation directory in the scripts and schedules a cron job to run the satellite pass scheduler job at midnight every night.


## How it works

Powered by **bash** this program calculate the satellites orbit with [predict](https://github.com/kd2bd/predict/). It schedules the redio record and the antenna positioning when its passing with `schedule_all.sh`. On `receive_satellite.sh` a Linux pipe is used for receive, correct doppler, demodulate fm and export to wav, something like `ss_client | doppler track | demod  | sox`. Then the wav is decoded with [wxtoimg](https://wxtoimgrestored.xyz) and upload the results to a *FTP Server*.


Everyday the next pipeline is executed:
* `schedule_all.sh` Starts the pipeline with the supported satellites. It starts `schedule_rotor.sh` and `schedule_satellite.sh`.
* `schedule_rotor.sh` Calculates the azimuth and elevation of the antennas when a satellite is passing. Probably is not acquire enough, try changing predict source code.
* `schedule_satellite.sh` Calculate when the pass is starting and finishing and then it schedule `receive_satellite.sh` passing the timeout in args.
* `receive_satellite.sh` Connect to spyserver the amount time specified on arg (timeout). It receive, correct doppler, demodulate fm and export to wav. Then `decode_satellite.sh` is executed.
* `decode_satellite.sh` Use [wxtoimg](https://wxtoimgrestored.xyz) to decode NOAA images. Then `upload.sh` is executed
* `upload.sh` Upload the results to a FTP Server.
