#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#------------------------------------------------------------------------------
# PROGRAM: netcdf_to_mat.py
#------------------------------------------------------------------------------
# Version 0.1
# 13 June, 2021
# Michael Taylor
# https://patternizer.github.io
# michael DOT a DOT taylor AT uea DOT ac DOT uk
#------------------------------------------------------------------------------

import xarray as xr
import scipy.io as sp

#------------------------------------------------------------------------------
# SETTINGS
#------------------------------------------------------------------------------

netcdf_var = 'tas_mean'
netcdf_file = netcdf_var + '.nc'
matlab_var = 'variable'
matlab_file = 'variable.mat'
time_step = -1
flag_reorder = True

# map parameters

caxis_start = -4; caxis_end = 4
plot_file = matlab_var + '.png'
flag_map = True

#------------------------------------------------------------------------------
# LOAD: netCDF file with time frames gridded at 1x1 into (time,lon,lat) format
#------------------------------------------------------------------------------

ds = xr.open_dataset(netcdf_file, decode_cf=True)

if flag_reorder == True:
    dt = ds.transpose("bnds", "time", "lon", "lat")
else:
    dt = ds.copy()

#------------------------------------------------------------------------------
# CONVERT: netCDF to .mat
#------------------------------------------------------------------------------
    
matlab_dict = {}
matlab_dict[matlab_var] = dt[netcdf_var][time_step,:,:]
sp.savemat(matlab_file, matlab_dict)

# QUICK MAP: Mollweide projection with blue-white-red colormap

if flag_map == True:

    import matplotlib.pyplot as plt
    import cartopy.crs as ccrs; p = ccrs.Mollweide(central_longitude=0)
    fig, axs = plt.subplots(1,1, figsize=(15,10), subplot_kw=dict(projection=p))
    ds[netcdf_var][time_step,:,:].plot(ax=axs, transform=ccrs.PlateCarree(), vmin=caxis_start, vmax=caxis_end, cmap='bwr', cbar_kwargs={'orientation':'vertical','extend':'both','shrink':0.7, 'pad':0.1})         
    axs.coastlines(color='black')
    plt.savefig(plot_file, dpi=300); plt.close('all')

#------------------------------------------------------------------------------
print('** END: conversion')
