function [fVal] = continiousFunction(input)
    map = [-ones(10,1);ones(10,1)];
    fVal =sum(sqrt((map-input).^2));
end

