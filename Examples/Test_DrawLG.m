clc;clear

DrawElement(1,0,1,0.25)

function DrawElement(n,y1,y2,r)
h = [-0.5 0 0.5];
xy = [n  n+r n; y1 (y1+y2)/2 y2];
pp = spline(h,xy);
yy = ppval(pp, -0.5:.05:0.5);
plot(yy(1,:),yy(2,:),'-b')
axis equal

end

%y = [0  0.5  0; 
    % 0  1   2]+1;