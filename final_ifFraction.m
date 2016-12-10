function markInd = final_ifFraction(cellName)

% Written by Fei Chen
%
% THIS FUNCTION IS TO TELL IF THE INPUT CELL CONTAINS A FRACTION OR NOT, IT
% CAN TELL AT MOST 2 FRACTIONS IN ONE BIG CELL
%
% INPUT:
%       cellName: the input cell contains at least 3 strokes;
% OUTPUT:
%       markInd: a column vector marked with some values:
%       0: not Fraction
%       1: (MAIN) Nominator
%       2: (MAIN) Denominator
%       3: (MAIN) Devider
%       4: (Second) Nominator
%       5: (Second) Denominator
%       6: (second) Devider
%       7: (Third) Nominator
%       8: (Third) Denominator
%       9: (Third) Devider

% % TEST AREA % %
% clear all ; close all; clc;
% load('cellName2');
% dbstop if error;
% end test area

% judge if the input is a cell or contains more than 3 stroks;
markInd = zeros(size(cellName));
if ~iscell(cellName) || size(cellName,1)<3;
    return
end;

% 1 FIND DEVIDERS
strokeNum = size(cellName,1);
for stroke = 1:strokeNum;
    currentStroke = cellName{stroke};
    currentMax = max(currentStroke);
    currentMin = min(currentStroke);
    diffXY = currentMax - currentMin;
    ratio = abs(diffXY(1)/diffXY(2));
    strokeProperty(stroke,:) = [currentMin(1) , currentMax(1), currentMin(2) , currentMax(2),diffXY, ratio];
    if final_isHorizontalLine(currentStroke)
        markInd(stroke,1) = 2;
    else
        markInd(stroke,1) = 0;
    end;
    %     plot(currentStroke(:,1) , currentStroke(:,2),'k.');
    %     hold on; axis equal;
end

if find(markInd==2)==0;
    return
else
    potential = find(markInd == 2);
end;

% 1-1 % sort the intersect;

for line = 1:size(potential,1);
    line1 = cellName{potential(line,1)};
    for stroke = 1: strokeNum;
        if stroke~=potential(line,1) && markInd(stroke)~=2;
            line2 = cellName{stroke};
        else
            continue
        end;
        
        if final_ifIntersect(line1, line2);
            markInd(potential(line,1)) = 0;
        end
    end
end;

% 1-2 % find main axis;
% find base line;
potential = find(markInd == 2);
if isempty(potential)
    return
end;
for line = 1:size(potential,1);
    basePoint(line,1) = strokeProperty(potential(line),5);
    mid(line,1) = strokeProperty(potential(line),6)/2 + strokeProperty(potential(line),3);
    plot(cellName{potential(line)}(:,1) , cellName{potential(line)}(:,2),'r.');
end;

[baseLine, loc ] = max(basePoint);
main(1,3) = mid(loc,1);
main(1,1:2) = strokeProperty(potential(loc,1), 1:2);
markInd(:,1) = 0;
markInd(potential(loc,1) , 1) = 2;

% FIND NOMINATOR
devider = cellName{potential(loc,1)};
for stroke = 1:strokeNum;
    if stroke ~= potential(loc,1);
        thisStroke = cellName{stroke};
        if final_isLayover(devider, thisStroke) && strokeProperty(stroke,3)>main(1,3);
            
            markInd(stroke,1) = 1;
        elseif final_isLayover(devider, thisStroke) && strokeProperty(stroke,4)<main(1,3);
            markInd(stroke,1) = 3;
            
        elseif strokeProperty(stroke,1)>=main(1,1) && strokeProperty(stroke,2)>main(1,2);
            markInd(stroke,1) = 4;
        elseif strokeProperty(stroke,1)<main(1,1) && strokeProperty(stroke,2)<=main(1,2);
            markInd(stroke,1) = 0;
        else
            disp(markInd(stroke))
            error('error in telling the location between the stroke and the devider! error code:200');
        end
    end
end

% FIND DENOMINATOR

% MARK THE OUTPUT VECTOR

if isempty(find(markInd==1)) || isempty(find(markInd==2)) || isempty(find(markInd==3));
    markInd = zeros(size(cellName));
end;