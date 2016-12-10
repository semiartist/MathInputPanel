function intNum = final_ifIntersect(line1, line2)

% Written by Fei Chen
%
% THIS FUNCTION IS TO tell how many intersection does this 2 lines has;
% INPUT:
%       line1: THE POINT MATRIX OF THE FIRST LINE;
%       line2: THE POINT MATRIX OF THE SECOND LINE;



% % TEST AREA
% dbstop if error
% clear all ; close all; clc;
% load('lineWrong');
% %

%{
plot(line1(:,1), line1(:,2),'r.');
hold on; axis equal;
plot(line2(:,1), line2(:,2),'b.')

[max1 ~] = max(line1);
[max2 ~] = max(line2);
[min1 ~] = min(line1);
[min2 ~] = min(line2);

bdLowX = max(min1(1),min2(1));
bdLowY = max(min1(2),min2(2));
bdHighX = min(max1(1),max2(1));
bdHighY = min(max1(2),max2(2));
plot([bdLowX,bdLowX,bdHighX, bdHighX] , [bdLowY, bdHighY, bdLowY,bdHighY],'co');
%}
intNum = 0;
if final_isLayover(line1, line2) ==0
    return
end

for runner = 1: size(line1,1)
    for jumper = 1:size(line2,1)
        dist(runner,jumper) = norm(line1(runner,:) - line2(jumper,:));
    end
end;

[row col] = find(dist<=0.012);
if size(row,1)==0
    intNum = 0;
else 
    intNum = 1;
end

if size(row,1)>1;
    
    for runner = 1: size(row,1)-1;
        for jumper = runner+1:size(col,1);
            mid1 = line1(row(runner,1),:) - line2(col(runner,1),:);
            mid2 = line1(row(jumper,1),:) - line2(col(jumper,1),:);
            midDist = norm(mid1 - mid2);
            if midDist > 0.01;
                intNum = intNum + 1;
                break
            end;
            
        end
    end
end

