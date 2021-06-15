import datetime
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as cl
import matplotlib.cm as cm
from math import *
import netCDF4
import motuclient
from dotenv import load_dotenv


# Parameters interpol

file1 = "data/inputs/global_2021-06-01.nc"
date1 = "2021-06-01 12:00:00"
file2 = "data/inputs/global_2021-06-02.nc"
date2 = "2021-06-02 12:00:00"
date_inter = "2021-06-01 18:00:00"


# Parameters plot

pas = 35
vmin = -0.1
vmax = 0.8
cmap = "rainbow"


# NetCDF variables

nc1 = netCDF4.Dataset(file1)
nc2 = netCDF4.Dataset(file2)
lon = nc1.variables["longitude"][:]
lat = nc1.variables["latitude"][:]
uo1 = nc1.variables["uo"][0, 0, :, :]
vo1 = nc1.variables["vo"][0, 0, :, :]
uo2 = nc2.variables["uo"][0, 0, :, :]
vo2 = nc2.variables["vo"][0, 0, :, :]


# Interpolation variables

dim_lon = len(lon)
dim_lat = len(lat)
u_inter = np.zeros([dim_lat, dim_lon])
v_inter = np.zeros([dim_lat, dim_lon])
t1 = datetime.datetime.strptime(date1, "%Y-%m-%d %H:%M:%S")
t2 = datetime.datetime.strptime(date2, "%Y-%m-%d %H:%M:%S")
t_inter = datetime.datetime.strptime(date_inter, "%Y-%m-%d %H:%M:%S")
diff_tot = t2 - t1
diff_inter = t_inter - t1
diff_tot_sec = diff_tot.seconds + 60*60*24*diff_tot.days
diff_inter_sec = diff_inter.seconds + 60*60*24*diff_inter.days
rap = diff_inter_sec/diff_tot_sec


# Interpolation

u_inter = (1-rap) * uo1+ rap * uo2
v_inter = (1-rap) * vo1 + rap * vo2


# Plot variables

centi = 0.393701
norme = cl.Normalize(vmin = vmin, vmax = vmax, clip = False)
sm = cm.ScalarMappable(norm = norme, cmap = cmap)
X, Y = lon[::pas], lat[::pas]
velocity_inter = np.sqrt(abs(v_inter**2 + u_inter**2))
U_inter = u_inter[::pas, ::pas]/velocity_inter[::pas, ::pas]
V_inter = v_inter[::pas, ::pas]/velocity_inter[::pas, ::pas]
name = f"global_{t_inter.year}-{t_inter.month}-{t_inter.day}_{t_inter.hour}h{t_inter.minute}m{t_inter.second}s"


# Plot

plt.figure(figsize = (20*centi, 12*centi))
plt.imshow(velocity_inter, interpolation = "gaussian", cmap = sm.cmap, vmin = sm.norm.vmin, vmax = sm.norm.vmax, origin = "lower", extent=  [min(lon), max(lon), min(lat), max(lat)])
plt.quiver(X, Y, U_inter, V_inter, color = "black")
plt.title(f"Global data at {date_inter}")
plt.colorbar(sm)
plt.savefig(f"data/outputs/{name}.jpg", dpi = 1000)
plt.savefig(f"data/outputs/{name}.pdf", dpi = 1000)
