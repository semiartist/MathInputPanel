function result = final_isHorizontalLine(pointMtx)

% WRITTEN BY FEI CHEN, 5/19/2016;
% THIS FUNCTION IS TO DETERMIN IF THE INPUT POINTS MATRIX FORMS A
% HORIZONTAL pointMtx
% input:
%      pointMtx: a matrix contains sevearl points
%
% output:
%      result: boolean value, 1 for yes, 0 for no;


% step 1, determin if it is a pointMtx;
point  = 0;
result = 0;

[p s] = polyfit(pointMtx(:,1) , pointMtx(:,2) , 1);
err = sum(abs(polyval(p, pointMtx(:,1)) - pointMtx(:,2)))/size(pointMtx,1);
if err <= 0.01;
    point = point + 1;
end
if abs(atan2d(p(1),1))<20;
    point = point + 1;
end;

% determin the ratio
expan = max(pointMtx) - min(pointMtx);
ratio = expan(1,1) / expan(1,2);
if ratio > 5;
    point = point + 1;
end;

if point >1;
    result =1;
end;