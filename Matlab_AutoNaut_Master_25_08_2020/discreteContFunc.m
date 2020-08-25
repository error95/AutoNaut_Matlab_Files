function [fVal] = discreteContFunc(input)
    map = [-0*ones(10,1);zeros(10,1)];
    position = round(input);
    
    correct = (position == map);
    fVal = -sum(correct);
end

