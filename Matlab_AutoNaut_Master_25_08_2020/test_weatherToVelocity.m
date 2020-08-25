load('EstimatedState.mat');
jump = 200;
delT = time(2) - time(1);
radi2deg = 180/pi;
R = 6371000;
long = EstimatedState.lon;
lat = EstimatedState.lat;
time = EstimatedState.timestamp;
manual_lat = lat(jump:jump:end);
manual_long = long(jump:jump:end);

[estimated_time,v] = mission_cost([manual_lat;manual_long]*radi2deg);
boat_time = (time(end) - time(1))/3600;
Vel = R*sqrt(((lat(2:end) - lat(1:end-1))/delT).^2 + ((long(2:end) - long(1:end-1))/delT).^2);
% 
% %TODO:
% % -calculate wind velocity
% % -calculate wave velocity
% % -calculate current
% % -insert exact pisitions
% % -insert smoothed positions
%

%%
plot([v,Vel(2*jump:jump:end)])