from orbit_predictor.locations import Location
from my_source import MultipleEtcTLESource
import datetime as dt
import math
import tree
import argparse

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
        passes.insert(ppass)

passes.PrintTree()