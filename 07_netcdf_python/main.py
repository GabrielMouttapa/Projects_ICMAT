import netCDF4
import matplotlib.pyplot as plt
import numpy as np
from math import *
import matplotlib.colors as cl
import matplotlib.cm as cm

pas1 = 5
pas2 = 15
centi = 0.393701
norme = cl.Normalize(vmin=0.0, vmax=0.25, clip=False)
sm = cm.ScalarMappable(norm=norme, cmap="rainbow")
nc = netCDF4.Dataset("data/inputs/cmems_ibi_example.nc")
lon = nc.variables["longitude"][:]
lat = nc.variables["latitude"][:]
X1, Y1 = lon[::pas1], lat[::pas1]
X2, Y2 = lon[::pas2], lat[::pas2]
multi = plt.figure(figsize=(21*centi, 8*centi))
gs = multi.add_gridspec(1, 3, wspace=0)
axs = gs.subplots(sharex=True, sharey=True)
time = nc.variables["time"][:]
for i in range(3):

    vo = nc.variables["vo"][i, 0, :, :]
    uo = nc.variables["uo"][i, 0, :, :]
    v = np.sqrt(abs(vo**2 + uo**2))
    U1 = uo[::pas1, ::pas1]/v[::pas1, ::pas1]
    V1 = vo[::pas1, ::pas1]/v[::pas1, ::pas1]
    U2 = uo[::pas2, ::pas2]/v[::pas2, ::pas2]
    V2 = vo[::pas2, ::pas2]/v[::pas2, ::pas2]

    fig = plt.figure()
    plt.imshow(v, interpolation = "gaussian", cmap=sm.cmap, vmin=sm.norm.vmin, vmax=sm.norm.vmax, origin="lower", extent=[min(lon), max(lon), min(lat), max(lat)])
    plt.quiver(X1, Y1, U1, V1, color="black")
    if i==0:
        plt.title("Saturday June 12th")
    elif i==1:
        plt.title("Sunday June 13th")
    else:
        plt.title("Monday June 14th")
    plt.colorbar(sm)
    plt.savefig(f"data/outputs/velocities{i+1}.pdf")
    plt.close()
    
    plt.figure("multi")
    axs[i].imshow(v, interpolation = "gaussian", cmap=sm.cmap, vmin=sm.norm.vmin, vmax=sm.norm.vmax, origin="lower", extent=[min(lon), max(lon), min(lat), max(lat)])
    axs[i].quiver(X2, Y2, U2, V2, color="black")
axs[0].set_title("Saturday June 12th")
axs[1].set_title("Sunday June 13th")
axs[2].set_title("Monday June 14th")
plt.colorbar(sm, ax=axs, shrink = 0.6)
multi.savefig("data/outputs/velocities.pdf")
