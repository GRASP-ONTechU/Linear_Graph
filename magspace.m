function [y] = magspace(d1,d2,step)

if d1 > d2
    error('Error: d2 must be an integer greater than d1.');
elseif d1 == d2
     d2 = d2+1;
end

d1 = floor(d1);
d2 = ceil(d2);

if nargin == 2
    step = 1;
else
    if rem(1,step) ~= 0
        error('Error: Ensure 1 is desiable by the step size.');
    end
end

y = [];
for i = d1:d2-1 %linspace(d1,d2,(abs(d1-d2))/step+1)
    if i == d2-1
        for j = 1:step:10
            y = [y, double(j*10^i)];
        end
    else
        for j = 1:step:9
            y = [y, double(j*10^i)];
        end
    end
end
end