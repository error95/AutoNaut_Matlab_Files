clear all
close all
%%
url = "https://thredds.met.no/thredds/dodsC/fou-hi/mywavewam800mhf/mywavewam800_midtnorge.an.2020021918.nc";
% clc
% 
% start_lat_deg = 69.2;
% start_lon_deg = 18.4;
% end_lat_deg = 70.2;
% end_lon_deg = 30.6;
% 
% date = [2020 02 10 00 00 00];
% DateNumber = datenum(date);
% 
% 
% DateTime = datetime(DateNumber,'ConvertFrom','datenum');
% [year,month,day] =ymd(DateTime);
% [hour,~,~] = hms(DateTime);
% %/meps_extracted_2_5km_
% %/meps_full_2_5km_
% url = ['https://thredds.met.no/thredds/dodsC/meps25epsarchive/' ...
%         num2str(year,'%02.f') '/' ...
%         num2str(month,'%02.f') '/' ...
%         num2str(day,'%02.f') '/meps_det_2_5km_' ...
%         num2str(year,'%02.f') ...
%         num2str(month,'%02.f') ...
%         num2str(day,'%02.f') ...
%         'T' num2str(hour,'%02.f') 'Z.nc'];
%     %num2str(day,'%02.f') '/meps_extracted_2_5km_' ...
%     %num2str(day,'%02.f') '/meps_full_2_5km_' ...
info = ncinfo(url);
%%
latitude_map_log = ncread(url,'latitude');
longitude_map_log = ncread(url,'longitude');
%%
wind_speed_log = ncread(url,'ff');
%%
wind_dir_log = ncread(url,'dd');
%%
% current_dir = ncread(url,'Pdir');
%%
% current_speed = ncread(url,'hs_swell');
%%
wave_size_log = ncread(url,'mHs');
%%
wave_dir_log = ncread(url,'thq_sea');

%%
save('Wind_wave_data');

% 
% matrix = (abs((start_lat_deg- latitude).^2 + (start_lon_deg - longitude).^2 ));
% minMatrix = min(matrix(:));
% [row_idx_start,col_idx_start] = find(matrix==minMatrix);
% 
% matrix = (abs((end_lat_deg- latitude).^2 + (end_lon_deg - longitude).^2 ));
% minMatrix = min(matrix(:));
% [row_idx_end,col_idx_end] = find(matrix==minMatrix);
% 
% row_idxs = row_idx_end - row_idx_start;
% col_idxs = col_idx_end - col_idx_start;
% 
% 
% ml_start = 36; %2.300m
% ml_idxs = 30; % 10m
% 
% hybrid = ncread(url,'hybrid');
% 
% 
% startLoc_ml = [row_idx_start col_idx_start];
% count_ml = [row_idxs col_idxs];
% latitude_met = ncread(url,'latitude',startLoc_ml,count_ml);
% longitude_met = ncread(url,'longitude',startLoc_ml,count_ml);
% 
% for i=1:ml_idxs
% startLoc_ml = [row_idx_start col_idx_start i+ml_start-1 1]; %[x, y, hybrid (height), time]
% count_ml = [row_idxs col_idxs 1 1];
% %height{i} = ncread(url,'geopotential_ml',startLoc_ml,count_ml);
% deice_lwc{i} = ncread(url,'mass_fraction_of_cloud_condensed_water_in_air_ml',startLoc_ml,count_ml);
% x_wind{i} = ncread(url,'x_wind_ml',startLoc_ml,count_ml);
% y_wind{i} = ncread(url,'y_wind_ml',startLoc_ml,count_ml);
% %vert_wind{i} = ncread(url,'upward_air_velocity_ml',startLoc_ml,count_ml);
% air_temperature{i} = ncread(url,'air_temperature_ml',startLoc_ml,count_ml);
% specific_humidity{i} = ncread(url,'specific_humidity_ml',startLoc_ml,count_ml);
% icing_index{i} = ncread(url,'icing_index',startLoc_ml,count_ml);
% % % % % % % % %es =  6.112 * exp((17.67 * (air_temp{i}-273.16))./((air_temp{i}-273.16) + 243.5));
% % % % % % % % %e = (specific_humidity{i}.*hybrid(i+35)*1013.25)./(0.378 * specific_humidity{i} + 0.622);
% % % % % % % % %relative_humidity{i} = e./es;
% relative_humidity{i} = ((specific_humidity{i}.* hybrid(i+35)*101325)./(0.622+0.378*specific_humidity{i}))./(10.^((0.7859 + 0.03477*(air_temperature{i}-273.16))./(1+0.00412*(air_temperature{i}-273.16))+2));
% end
% altitudes = -((hybrid(ml_start:ml_start+ml_idxs-1).^(1/5.255)-1)*(15+273.15))/0.0065;
% 
% % startLoc_pl = [row_idx_start col_idx_start 1 pl 1]
% % count_pl = [row_idxs col_idxs 1 1 1]
% % 
% % 
% % 
% % air_temp = ncread(url,'air_temperature_pl',startLoc_pl,count_pl);
% % x_wind = ncread(url,'x_wind_pl',startLoc_pl,count_pl);
% % y_wind = ncread(url,'y_wind_pl',startLoc_pl,count_pl);
% % specific_humidity = ncread(url,'relative_humidity_pl',startLoc_pl,count_pl);
% % geopotential_pl
% 
%  wind_x = x_wind;
%  wind_y = y_wind;
%  deice_air_temperature = air_temperature;
%  deice_relative_humidity = relative_humidity;
% % 
% % save('altitudes','altitudes')
%  save('wind_x','wind_x')
%  save('wind_y','wind_y')
%  save('deice_air_temperature','deice_air_temperature')
%  save('deice_relative_humidity','deice_relative_humidity')
%  save('deice_lwc','deice_lwc')
%  save('hybrid','hybrid')
%  save('vert_wind','vert_wind')
% % 
%  deice_latitude = latitude_met;
%  deice_longitude = longitude_met;
%  wind_latitude = latitude_met;
%  wind_longitude = longitude_met;
%  save('deice_latitude','deice_latitude')
%  save('deice_longitude','deice_longitude')
%  save('wind_latitude','wind_latitude')
%  save('wind_longitude','wind_longitude')
% % 
%  pressure = hybrid(ml_start:ml_start+ml_idxs-1);
%  save('pressure','pressure');
% 
% 
% load('deice_f_altitude')
% for i = 1:40
%     altitude = i*50;
%     index = round(deice_f_altitude(altitude));
%     ice{i} = ((air_temperature{index} - 273.15) < 0).*(relative_humidity{index} > 0.99);
% end
% 
% load('elevation_latitude')
% load('elevation_longitude')
% load('elevation_map')
% for j = 1:40
%     for i=1:size(deice_latitude,1)
%         for k = 1:size(deice_latitude,2)
%             ele = elevation(deice_latitude(i,k),deice_longitude(i,k),elevation_latitude,elevation_longitude,elevation_map);
%             if j*50  <= ele
%                ice{j}(i,k) = 0;
%             end
%         end
%     end
% end
% 
%  figure
%  hold on
%  for i = 1:40
%      plot3(latitude_met,longitude_met,ice{i}.*i*50,'.');
%  end