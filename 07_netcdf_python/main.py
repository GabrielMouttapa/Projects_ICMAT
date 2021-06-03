import netCDF4
import matplotlib.pyplot as plt
import numpy as np
from math import *

pas1 = 5
pas2 = 15
nc = netCDF4.Dataset("data/inputs/cmems_ibi_example.nc")
lon = nc.variables["longitude"][:]
lat = nc.variables["latitude"][:]
X1, Y1 = lon[::pas1], lat[::pas1]
X2, Y2 = lon[::pas2], lat[::pas2]
multi = plt.figure()
gs = multi.add_gridspec(1, 3, wspace=0)
axs = gs.subplots(sharex=True, sharey=True)
for i in range(3):

    vo = nc.variables["vo"][i, 0, :, :]
    uo = nc.variables["uo"][i, 0, :, :]
    v = np.sqrt(abs(vo**2 + uo**2))
    U1 = uo[::pas1, ::pas1]/v[::pas1, ::pas1]
    V1 = vo[::pas1, ::pas1]/v[::pas1, ::pas1]
    U2 = uo[::pas2, ::pas2]/v[::pas2, ::pas2]
    V2 = vo[::pas2, ::pas2]/v[::pas2, ::pas2]

    fig = plt.figure()
    plt.imshow(v, interpolation = "gaussian", cmap="gist_rainbow", vmin=0, vmax=0.6, origin="lower", extent=[min(lon), max(lon), min(lat), max(lat)])
    plt.quiver(X1, Y1, U1, V1, color="black")
    plt.savefig(f"data/outputs/velocities{i+1}.pdf")
    plt.close()
    
    plt.figure("multi")
    axs[i].imshow(v, interpolation = "gaussian", cmap="gist_rainbow", vmin=0, vmax=0.6, origin="lower", extent=[min(lon), max(lon), min(lat), max(lat)])
    axs[i].quiver(X2, Y2, U2, V2, color="black")
multi.savefig("data/outputs/velocities.pdf")
