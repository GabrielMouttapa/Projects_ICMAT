import subprocess
import datetime
import os
from dotenv import load_dotenv



load_dotenv()



def download_cmems(dic):
    """
    This function download CMEMS global data from the parameters in dic.

    Inputs :
        - dic a dictionnary with the folowing values :
            - depth_min (real) [by default 0]
            - depth_max (real) [by default 0]
            - long_min (real) [by default -180]
            - long_max (real) [by default 180]
            - lat_min (real) [by default -90]
            - lat_max (real) [by default 90]
            - date_min (%Y-%m-%d) [by default today]
            - date_max (%Y-%m-%d) [by default today]
            - time_min (%H:%M:%S) [by default None]
            - time_max (%H:%M:%S) [by default None]
            - time_step_type (string in "year", "week", "day", "hour", "minute", "second") [by default "day"]
            - time_step_value (integer) [by default 1]
            - time_step_number (integer) [by default 2]
            - many_files (string : "True" to work with time_step and create different files, "False" to work with time_max and work with 1 file) [by default False]
            - folder (string) [by default "../data/outputs"]
            - name (string) [by default "data"]
            - service (string) [by default "GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS"]
            - product (string) [by default "global-analysis-forecast-phy-001-024"]
            - variables (string list) [by default [uo", "vo"])

    Outputs :
        - <name>_<date>.nc files in /<folder>
    """



    # Reading dic data

    depth_min = str(dic.get("depth_min", 0.49402499198913574))
    depth_max = str(dic.get("depth_max", 0))
    long_min = str(dic.get("long_min", -180))
    long_max = str(dic.get("long_max", 180))
    lat_min = str(dic.get("lat_min", -90))
    lat_max = str(dic.get("lat_max", 90))
    date_min = dic.get("date_min", "today")
    date_max = dic.get("date_max", "today")
    time_min = dic.get("time_min", None)
    time_max = dic.get("time_max", None)
    time_step_type = dic.get("time_step_type", "day")
    time_step_value = dic.get("time_step_value", 1)
    time_step_number = dic.get("time_step_number", 2)
    many_files = dic.get("many_files", False)
    folder = dic.get("folder", "data/outputs")
    name = dic.get("name", "data")
    service = dic.get("service", "GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS")
    product = dic.get("product", "global-analysis-forecast-phy-001-024")
    variables = dic.get("variables", ["uo", "vo"])


    # Conversion in datetime

    if date_min == "today" :
        if time_min == None :
            t0 = datetime.date.today()
            date0 = t0.strftime("%Y-%m-%d")
        else :
            t0 = datetime.datetime.strptime(datetime.date.today().strftime("%Y-%m-%d")+" "+time_min, "%Y-%m-%d %H:%M:%S")
            date0 = t0.strftime("%Y-%m-%d %H:%M:%S")
    else :
        if time_min == None :
            t0 = datetime.datetime.strptime(date_min, "%Y-%m-%d")
            date0 = t0.strftime("%Y-%m-%d")
        else :
            t0 = datetime.datetime.strptime(date_min+" "+time_min, "%Y-%m-%d %H:%M:%S")
            date0 = t0.strftime("%Y-%m-%d %H:%M:%S")

    if date_max == "today" :
        if time_max == None :
            tf = datetime.date.today()
            datef = tf.strftime("%Y-%m-%d")
        else :
            tf = datetime.datetime.strptime(datetime.date.today().strftime("%Y-%m-%d")+" "+time_max, "%Y-%m-%d %H:%M:%S")
            datef = tf.strftime("%Y-%m-%d %H:%M:%S")
    else :
        if time_max == None :
            tf = datetime.datetime.strptime(date_max, "%Y-%m-%d")
            datef = tf.strftime("%Y-%m-%d")
        else :
            tf = datetime.datetime.strptime(date_max+" "+time_max, "%Y-%m-%d %H:%M:%S")
            datef = tf.strftime("%Y-%m-%d %H:%M:%S")

    if time_step_type == "year" :
        time_step = datetime.timedelta(years = time_step_value)
    elif time_step_type == "week" :
        time_step = datetime.timedelta(weeks = time_step_value)
    elif time_step_type == "day" :
        time_step = datetime.timedelta(days = time_step_value)
    elif time_step_type == "hour" :
        time_step = datetime.timedelta(hours = time_step_value)
    elif time_step_type == "minute" :
        time_step = datetime.timedelta(minutes = time_step_value)
    else :
        time_step = datetime.timedelta(seconds = time_step_value)


    # Variables mis

    variables_code = ""
    for va in variables : variables_code += " --variable " + va


    # Many files

    if many_files == "True" :
        for i in range(time_step_number) :
            date = t0.strftime("%Y-%m-%d %H:%M:%S")
            cmd = f"""
            env/bin/python -m motuclient \
                --motu https://nrt.cmems-du.eu/motu-web/Motu \
                --service-id {service} \
                --product-id {product} \
                --longitude-min {long_min} \
                --longitude-max {long_max} \
                --latitude-min {lat_min} \
                --latitude-max {lat_max} \
                --date-min {date} \
                --date-max {date} \
                --depth-min {depth_min} \
                --depth-max {depth_max} \
                {variables_code} \
                --out-name {name}_{date}.nc \
                --out-dir {folder} \
                --user {os.environ.get("username")} --pwd {os.environ.get("passwd")} \
            """
            p = subprocess.Popen(cmd, shell = True)
            t0 = t0 + time_step
            p.wait()


    # One file

    else :
        cmd = f"""
        env/bin/python -m motuclient \
            --motu https://nrt.cmems-du.eu/motu-web/Motu \
            --service-id {service} \
            --product-id {product} \
            --longitude-min {long_min} \
            --longitude-max {long_max} \
            --latitude-min {lat_min} \
            --latitude-max {lat_max} \
            --date-min {date0} \
            --date-max {datef} \
            --depth-min {depth_min} \
            --depth-max {depth_max} \
            {variables_code} \
            --out-name {name}.nc \
            --out-dir {folder} \
            --user {os.environ.get("username")} --pwd {os.environ.get("passwd")} \
        """
        print(cmd)
        p = subprocess.Popen(cmd, shell = True)
