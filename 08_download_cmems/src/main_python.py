import argparse
import json
from download import download_cmems


parser = argparse.ArgumentParser()
parser.add_argument("--json", help="insert your json file", required = True)

args = parser.parse_args(["--json", "data/inputs/global_analysis.json"])
with open(args.json) as f:
    jdata = json.load(f)
download_cmems(jdata)

args = parser.parse_args(["--json", "data/inputs/mediterranean.json"])
with open(args.json) as f:
    jdata = json.load(f)
download_cmems(jdata)

args = parser.parse_args(["--json", "data/inputs/black_sea.json"])
with open(args.json) as f:
    jdata = json.load(f)
download_cmems(jdata)
