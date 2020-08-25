clear all
addpath('Analytical models')

start_lat = -100;
start_long = -100;
end_lat = 500;
end_long = 100;
save('constraints.mat','start_lat','start_long','end_lat','end_long')

lat_goals = [200]';
long_goals = [200]';
rad_goals = [5 ]';
val_goals = [00]';
num_goals = size(lat_goals,1);

save('measurement_goals.mat','lat_goals','long_goals','rad_goals','val_goals','num_goals')

latitude_points = [start_lat;lat_goals;end_lat];
longitude_points = [start_long;long_goals;end_long];

positions = 20;
% Possible bug with many points
[latitude,longitude] = pathCreator(latitude_points,longitude_points,positions);

seed = [latitude(2:end-1)',longitude(2:end-1)', ones(1,positions-2)]';
[inputs,~] = size(seed);
nParticles = 1000;
maxIter = 500;
contInput = 2*(positions-2);
boolInput = positions-2;

[default] = analytical_mission_cost(seed);
default


%%
[x_2, x_val_2] = hybrid_PSO(@analytical_mission_cost,contInput,boolInput,seed,nParticles, maxIter);
%  [x_2, x_val_2]= fminsearch(@analytical_mission_cost,seed);
%%
result_lat = [start_lat; x_2(1:inputs/3); end_lat];
result_long = [start_long; x_2(inputs/3 +1:inputs*(2/3)); end_long];
%
figure(1)
plot([start_lat;result_lat;end_lat],[start_long;result_long;end_long])

figure(2)
X = repmat((1:maxIter)',1,nParticles+1);
defaultMtx = repmat(default,maxIter,1);
plot(X,[x_val_2,defaultMtx]);
%%
hold on
figure(3)
plot(result_lat,result_long)
axis equal
