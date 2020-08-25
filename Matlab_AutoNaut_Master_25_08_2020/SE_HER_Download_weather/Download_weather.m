url = 'https://thredds.met.no/thredds/dodsC/fou-hi/mywavewam800mhf/mywavewam800_midtnorge.an.2020070418.nc';
ncid = netcdf.open(url);
varid = netcdf.inqVarID(ncid,'Hwave')
data = netcdf.getVar(ncid,varid)