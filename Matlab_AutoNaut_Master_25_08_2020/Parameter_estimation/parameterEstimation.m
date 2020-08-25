
%Parameter estimation uses a least squares method to fit to estimate
%parameters for the liear model. Input is vessel, current and wind velocity
%and wave height, direction and frequency estimate.

%% Load weather and vessel states
clear('all')
load('GpsFix.mat');
load('EulerAngles.mat');
load('Wind_wave_data.mat');

d2r= pi/180;
m = 250;
psi_temp = EulerAngles.psi;
psi_t_temp = EulerAngles.timestamp;


% Finding vessel velocity and bearing from gps and IMU data
latitude_temp = GpsFix.lon*(d2r)^-1;
longitude_temp = GpsFix.lat*(d2r)^-1;
pos_t_temp = GpsFix.utc_time;
pos_ts_temp = GpsFix.timestamp;

psi_init = psi_temp(psi_temp ~= 0);
psi_t_init = psi_t_temp(psi_temp ~= 0);
latitude_init= latitude_temp(latitude_temp ~= 0);
longitude_init = longitude_temp(longitude_temp ~= 0);
pos_t_init = pos_t_temp(longitude_temp ~= 0);
pos_ts_init = pos_ts_temp(longitude_temp ~= 0);


step = 10;
longitude = latitude_init(1:step:end);
latitude = longitude_init(1:step:end);
pos_t = pos_t_init(1:step:end);
pos_ts = pos_ts_init(1:step:end);
psi = interp1(psi_t_init, psi_init, pos_ts,'pchip');


distances = Haversine_deg(latitude(1:end-1),longitude(1:end-1),latitude(2:end),longitude(2:end),6371*10^3);
bearing_vessel = bearing(d2r*latitude(1:end-1),d2r*longitude(1:end-1),d2r*latitude(2:end),d2r*longitude(2:end));
timesteps = pos_t(2:end) - pos_t(1:end-1);

speed = (distances./timesteps);
speed(isnan(speed)) = 0;
speed_b = reshape([speed'; zeros(size(speed'))],[],1);
V_n = reshape(rotZ_2(bearing_vessel)*speed_b,2,[]);

%Importing weather data
windSpd = mapDataExtraction(pos_t, latitude, longitude, latitude_map_log, longitude_map_log, wave_size_log);
windDir = mapDataExtraction(pos_t, latitude, longitude, latitude_map_log, longitude_map_log, wave_dir_log);
speed_wb = reshape([windSpd'; zeros(size(windSpd'))],[],1);
V_w = reshape(rotZ_2(windDir')*speed_wb,2,[]);
H = mapDataExtraction(pos_t, latitude, longitude, latitude_map_log, longitude_map_log, wave_size_log);
H_dir = mapDataExtraction(pos_t, latitude, longitude, latitude_map_log, longitude_map_log, wave_dir_log)*d2r;

%Temp
V_c = zeros(size(V_w)) + randn(size(V_w));
eta = bearing_vessel' -H_dir(1:end-1);
% psi = bearing_vessel;


%% Estimate parameters

N_vals = numel(psi) - 2;

A = zeros(2*N_vals,6);
b = zeros(2*N_vals,1);
for i =1:N_vals-1
    V_wi = diag(rotZ_2(psi(i))*(-V_n(:,i) + V_w(:,i)));
    V_ci = diag(rotZ_2(psi(i))*(-V_n(:,i) + V_c(:,i)));
    r_i = [(cos(eta(i))^2)*H(i)^2, (sin(eta(i))^2)*H(i)^2;
            0, 0];
    A(1 + (i-1)*2:2*i,1:6) = [V_wi, V_ci r_i];
    b(1 + (i-1)*2:2*i,1) = rotZ_2(psi(i))*(-V_n(:,i) + V_n(:,i+1))*(m/(timesteps(i)));
end
x = A\b;

%% Calculating result variance

varSum = zeros(2,1);

for i =1:N_vals
    varSum = varSum + (A(1 + (i-1)*2:2*i,1:6)*x - b(1 + (i-1)*2:2*i,1)).^2;
end

var = varSum/N_vals;


