function [fVal] = booleanFunction(input)
    map = [-ones(10,1);ones(10,1)];
    fVal = sum(map.*input);
end
