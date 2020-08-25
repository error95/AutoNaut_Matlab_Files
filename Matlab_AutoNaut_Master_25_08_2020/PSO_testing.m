clear all
addpath('Weather')

start_lat = 60;
start_long = 0;
end_lat = 70;
end_long = 10;
save('constraints.mat','start_lat','start_long','end_lat','end_long')

lat_goals = []';
long_goals = []';
rad_goals = []';
val_goals = []';
num_goals = size(lat_goals,1);

save('measurement_goals.mat','lat_goals','long_goals','rad_goals','val_goals','num_goals')

latitude_points = [start_lat;lat_goals;end_lat];
longitude_points = [start_long;long_goals;end_long];

positions = 40;
% Possible bug woth many points
[latitude,longitude] = pathCreator(latitude_points,longitude_points,positions);

seed = [latitude(2:end-1)',longitude(2:end-1)', ones(1,positions-2)]';
[inputs,~] = size(seed);
nParticles = 1000;
maxIter = 100;
contInput = 2*(positions-2);
boolInput = positions-2;

[default,~,sun] = mission_cost(seed);
default
plot(sun)

%%
[x_2, x_val_2] = hybrid_PSO(@mission_cost,contInput,boolInput,seed,nParticles, maxIter);
% [x_2, x_val_2]= fminsearch(@mission_cost,seed);
%%
result_lat = [start_lat; x_2(1:inputs/3); end_lat];
result_long = [start_long; x_2(inputs/3 +1:inputs*(2/3)); end_long];
%%
% figure(1)
% plot([start_lat;result_lat;end_lat],[start_long;result_long;end_long])

figure(2)
X = repmat((1:maxIter)',1,nParticles+1);
defaultMtx = repmat(default,maxIter,1);
plot(X,[x_val_2,defaultMtx]);

figure(3)
geoplot(result_lat,result_long)
geolimits([55 70],[-5 10])

% [x, x_val] = boolean_PSO(@booleanFunction,20,10, 100);
% %%
% [x_2, x_val_2] = continious_PSO(@discreteContFunc,20,200, 100);
%%
% inputs = 200;
% start = [300 300];
% [x_3, x_val_3] = hybrid_PSO(@cost_function,inputs,inputs,pi/6,-pi/6,256, 256);
% %%
% position_matrix = triu(ones(inputs,inputs))';
% 
% input = x_3(inputs+1:2*inputs);
% 
% actuator_input = position_matrix*input;
%     
% velocities = [cos(actuator_input), sin( actuator_input)];
%     
% positions = position_matrix*velocities + start;
% 
% plot(positions(:,1),positions(:,2));