from orbit_predictor.locations import Location
from orbit_predictor.coordinate_systems import to_horizon
from orbit_predictor.coordinate_systems import horizon_to_az_elev
from my_source import MultipleEtcTLESource
import datetime as dt
import math
import tree
import argparse
from datetime import timezone
import re

pi=math.pi

def degree(x):
    degree=(x*180)/pi
    return degree

# Argunment parser
parser = argparse.ArgumentParser(description='Get satellites predictions of the TLE\'s on tle_file while avoiding overlaping.')
parser.add_argument('--location', dest='gndlocation', nargs=3, required=True,
                    help='Ground Station Location like lat long alt')
parser.add_argument('file', nargs=1,
                    help='Path of the file containing TLE\'s like CELESTRAK')
args = parser.parse_args()

gndlocation=Location(
    "GND", latitude_deg=float(vars(args)['gndlocation'][0]), longitude_deg=float(vars(args)['gndlocation'][1]), elevation_m=float(vars(args)['gndlocation'][2]))

source = MultipleEtcTLESource(filename=vars(args)['file'][0])
passes = tree.Node()

for sat in source.get_sats():
    predictor = source.get_predictor(sat)
    delta = dt.datetime.utcnow()
    max_delta = dt.datetime.utcnow() + dt.timedelta(days=1)
    while delta.timestamp() < max_delta.timestamp():
        ppass = predictor.get_next_pass(gndlocation, when_utc=delta)
        delta = ppass.aos + dt.timedelta(seconds=1000)
        passes.insert(ppass, predictor)

for i in passes.getNodes():
    # We need to put azi and ele on aos and los
    # First get horizon of the satelite in aos and los
    sat_horizon_aos = to_horizon(gndlocation.latitude_rad, \
                gndlocation.longitude_rad, gndlocation.position_ecef, \
                i.predictor.get_position(i.data.aos).position_ecef)

    sat_horizon_los = to_horizon(gndlocation.latitude_rad, \
                gndlocation.longitude_rad, gndlocation.position_ecef, \
                i.predictor.get_position(i.data.los).position_ecef)

    # Get azi on aos and los
    az_aos = horizon_to_az_elev(sat_horizon_aos[0], sat_horizon_aos[1], sat_horizon_aos[2])[0]
    az_los = horizon_to_az_elev(sat_horizon_los[0], sat_horizon_los[1], sat_horizon_los[2])[0]

    # Create unique filekey
    satname_splitted = i.data.sate_id.split() # There are innesesary spaces
    # There are some white spaces that are innesesary
    satname = ""
    for word in satname_splitted:
        satname += word + " "
    satname = satname[:-1]
    #format text for directory names
    satnorm = re.sub('[\\~#%&*{}/:<>?|\"-()\[\] ]', '_', satname)
    outdate = i.data.aos.strftime("%Y%m%d-%H%M%S")
    filekey =  satnorm + "-" + outdate

    # Get NORAD ID
    norad_id = source.getNoradId(satname=i.data.sate_id)

    print('{0} {1} {2} {3} {5:.2f} {6:.2f} {7} {8} {4}'.format(i.data.aos.strftime("%H:%M %D"), \
    math.ceil(i.data.aos.replace(tzinfo=timezone.utc).timestamp()), math.ceil(i.data.max_elevation_deg), \
    math.ceil(i.data.duration_s), satname, degree(az_aos), degree(az_los), filekey, norad_id))
