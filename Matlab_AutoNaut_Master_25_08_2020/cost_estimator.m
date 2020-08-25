
clear all
fun = @cost_function;
steps = 4400;

options = optimoptions('particleswarm','SwarmSize',1000,'MaxIterations', 20000,'HybridFcn',@fmincon);

lb = ones(steps,1)*-pi/5;
ub = ones(steps,1)*pi/5;

[x,fval] = particleswarm(fun,steps,lb,ub,options);
stepSize = 1;
    
startingPosition = [300,300];
current = [ 0 0];
position_matrix = triu(ones(steps,steps))';
currentMtx = kron(ones(steps,1),current);
actuator_input = position_matrix*x';
velocities = [cos(actuator_input), sin(actuator_input)]*stepSize + currentMtx;
positions = position_matrix*velocities + kron(ones(steps,1),startingPosition);
%% 
plot(positions(:,1),positions(:,2))
axis equal