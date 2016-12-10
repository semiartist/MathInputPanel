function result = final_isEqualSign(allPoints, index1, index2)

% Written by Fei Chen
%
% THIS FUNCTION IS TO DETERMIN IF THE 2 STROKES MAKES AN EQUAL SIGN;
% INPUT:
%       line1: THE POINT MATRIX OF THE FIRST LINE;
%       line2: THE POINT MATRIX OF THE SECOND LINE;




% % TEST AREA
% dbstop if error
% clear all ; close all; clc;
% load('Inkdata.mat');
% allPoints = Inkdata;
% index1 = 1; index2 = 2;
% % %
%
% plot(line1(:,1), line1(:,2),'r.');
% hold on; axis equal;
% plot(line2(:,1), line2(:,2),'b.')

%{
% START OF THE PROGRAM
point  =0 ;
result = 0;

[p1 s1] = polyfit(line1(:,1) , line1(:,2) , 1);
[p2 s2] = polyfit(line2(:,1) , line2(:,2) , 1);

err1 = sum(abs(polyval(p1, line1(:,1)) - line1(:,2)))/size(line1,1);
err2 = sum(abs(polyval(p2, line2(:,1)) - line2(:,2)))/size(line2,1);

expan1 = max(line1) - min(line1);
expan2 = max(line2) - min(line2);

ratio1 = expan1(1) / expan1(2);
ratio2 = expan2(1) / expan2(2);

if ratio1 > 5
    point = point + 1;
end;

if ratio2 > 5
    point = point +1;
end

if ratio1>5 && ratio2 >5
    point = point + 1;
end;

if err1 < 0.001 && err2<0.001;
    point = point + 1;
end;
if err1 < 0.001;
    point = point + 1;
end
if err2 < 0.001;
    point = point + 1;
end

if abs(p1(1))<0.05 || abs(p2(1))<0.05;
    point = point +1;
end;





if point >=4;
    result = 1;
end;

%}

% below part is the redefined isEqualSign(*)

% with a pre defined the line1 and line2 are both horizontal lines,
% so in this case, we just need to tell if there are any other line which
% lies with them.
% The input could be changed to (allPoints, index1, index2);


% initialize
result = 0;
marker = 0;

% first need to define if the 2 lines are somewhat lay in the same area;
line1 = allPoints{index1};
line2 = allPoints{index2};
if final_isLayover(line1, line2)==0
    return
end;


for stroke = 1:size(allPoints,1)
    if stroke ~=index1 && stroke~=index2;
        thisLine = allPoints{stroke};
        if final_isLayover(line1,thisLine) + final_isLayover(line2, thisLine) ~=0;
            marker = marker +1;
        end
    end
end;

if marker ==0;
    result = 1;
end;