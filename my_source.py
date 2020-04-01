from orbit_predictor.sources import TLESource

class MultipleEtcTLESource(TLESource):
    def __init__(self, filename):
        self.filename = filename

    def _get_tle(self, sate_id, date):
        with open(self.filename) as fd:
            data = fd.read().split("\n")
            tle_lines = [data[i:i+3] for i in range(0, len(data), 3)]
            for tle in tle_lines:
                if tle[0] == sate_id:
                    return tuple(tle[1:])
            raise LookupError("Stored satellite id not found")
    def get_sats(self):
        sats = []
        with open(self.filename) as fd:
            data = fd.read().split("\n")
            tle_lines = [data[i:i+3] for i in range(0, len(data), 3)]
            for tle in tle_lines:
                if tle[0] != '':
                    sats.append(tle[0])
            return sats

    def getNoradId(self, satname):
        norad_id = ""
        with open(self.filename) as fd:
            data = fd.read().split("\n")
            tle_lines = [data[i:i+3] for i in range(0, len(data), 3)]
            for tle in tle_lines:
                if tle[0] == satname:
                    col = tle[2].split()
                    return col[1]
            return sats