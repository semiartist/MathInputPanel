function result = final_isLayover(line1, line2)

% Written by Fei Chen
%
% THIS FUNCTION IS TO DETERMIN IF THE 2 LINES SHARES THE SAME X VALUE;
% INPUT:
%       line1: THE POINT MATRIX OF THE FIRST LINE;
%       line2: THE POINT MATRIX OF THE SECOND LINE;
% OUTPUT:
%       result: the boolean value,1 for yes, 0 for no;

result = 0;

max1 = max(line1);
max2 = max(line2);
min1 = min(line1);
min2 = min(line2);

max1X = max1(1); min1X = min1(1);
max2X = max2(1) ; min2X = min2(1);

if (min2X - min1X)*(max2X - max1X)<=0;
    result = 1;
elseif (min2X - min1X)*(min2X - max1X)<0 || (min1X - min2X)*(min1X- max2X)<0
    result =1;
end