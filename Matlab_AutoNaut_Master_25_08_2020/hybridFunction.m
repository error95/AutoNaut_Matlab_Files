function [fVal] = hybridFunction(input)
    map = [-1*ones(10,1);zeros(10,1)];
    mapValue = [-10*ones(10,1);-0*ones(10,1)];
    position = round(input(21:40));
    
    correct = (position == map);
    fVal = sum((correct.*mapValue.*input(1:20))) + 5*sum(input(1:20));
end



