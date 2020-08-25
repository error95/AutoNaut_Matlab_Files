timestep = 1000;
timesteps = 500;
deg2rad = pi/180;
radi2deg = 180/pi;
start_lat = 65*deg2rad;
start_long = 0*deg2rad;
r = 6371000;
p0 = [r*cos(start_long)*cos(start_lat), r*sin(start_long)*cos(start_lat), r*sin(start_lat)]';
p = zeros(3,timesteps);
p(:,1) = p0;

[lat_size,long_size] = size(latitude);



for i = 1:timesteps
    time = i*timestep;
    hour = round(time/3600)*0 + 1;
    
    lat = atan2(p(3,i),sqrt(p(1,i)^2 + p(2,i)^2));
    long = atan2(p(2,i),p(1,i));
    
    long_lat = repmat(lat,lat_size,long_size);
    long_long = repmat(long,lat_size,long_size);
    distance = Haversine_deg(long_lat,long_long,latitude*deg2rad,longitude*deg2rad,r);
    [min_dist, index] = minmat(distance);
    % - Get current
    curr_dir = current_dir(index(1),index(2),hour)*deg2rad;
    curr_spd = current_speed(index(1),index(2),hour);
    current = [curr_spd*cos(curr_dir); curr_spd*sin(curr_dir)];
    % - Get wind
    wnd_dir = wind_dir(index(1),index(2),hour)*deg2rad;
    wnd_spd = wind_speed(index(1),index(2),hour);
    wind = [wnd_spd*cos(wnd_dir);wnd_spd*sin(wnd_dir)];
    % - Get waves
% % %     ww_dir = wave_dir(index(1),index(2),hour)*deg2rad;
% % %     ww_spd = wave_size(index(1),index(2),hour);
% % %     waves = [ww_spd*cos(ww_dir); ww_spd*sin(ww_dir)];
    % - Describe full function (possibly newton method??
    input = 0;
    v = weatherToVelocity(current,wind,[0; 0],3*(pi/2)); % TODO: finnish
    p(:,i+1) = p(:,i) + timestep*LatLongRot(lat,long)*v;
    p(:,i+1) = r*(p(:,i+1)/norm(p(:,i+1)));
end
%%
% [x,y,z] = sphere;
% x = x*r;
% y = y*r;
% z = z*r;
% 
% 
% figure(1)
% hold on
% s = surf(x,y,z);
% s.EdgeColor = 'none';
% 
% 
% plot3(p(1,:)',p(2,:)',p(3,:)')
% % scatter3([r 0 0 -r 0 0],[0 r 0 0 -r 0], [0 0 r 0 0 -r])
% axis equal
% 

%%
p_lat = atan2(p(3,:),sqrt(p(1,:).^2 + p(2,:).^2))*radi2deg;
p_long = atan2(p(2,:),p(1,:))*radi2deg;
close all
figure()
hold on


worldmap('Europe')
load coastlines
plotm(coastlat,coastlon)
plotm(p_lat,p_long,'r')



