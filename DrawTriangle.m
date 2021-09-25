function DrawTriangle(size,x,y,angle,color,style)
%clc;clear; close all
% size = 1;
% x = 5;
% y = 5;
% angle = pi/4;
% color = 'b';
% style = ':';

x1 = x + size*cos(angle);
y1 = y + size*sin(angle);

x2 = x + sqrt(2*(size/2)^2)*cos(angle+2*pi/3);
y2 = y + sqrt(2*(size/2)^2)*sin(angle+2*pi/3);

x3 = x + sqrt(2*(size/2)^2)*cos(angle-2*pi/3);
y3 = y + sqrt(2*(size/2)^2)*sin(angle-2*pi/3);

line([x1 x2],[y1 y2],'color',color,'LineStyle',style);
line([x2 x3],[y2 y3],'color',color,'LineStyle',style);
line([x3 x1],[y3 y1],'color',color,'LineStyle',style);
end