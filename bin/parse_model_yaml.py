import json
import sys
import re


def main():
    input_json_str = sys.stdin.read()
    input_json = json.loads(input_json_str)

    for sbj in input_json:
        sbj_name = list(sbj.keys())[0]
        cls = ""
        for val in sbj[sbj_name]:
            pred = list(val.keys())[0]
            if (pred == "a"):
                if (isinstance(val[pred], list)):
                    cls = " ".join(val[pred])
                elif (isinstance(val[pred], str)):
                    cls = cls + " " + val[pred]
        cls = cls.strip()
        for val in sbj[sbj_name]:
            pred = list(val.keys())[0]
            if (pred != "a"):
                print(cls, re.sub('[?*+]$', '', pred),
                      re.sub('[^?*+]+', '', pred), sep="\t")


if __name__ == "__main__":
    main()
