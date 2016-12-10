function markMtx = final_segNumber2(allPoints)

% Written by Fei Chen
%
% THIS FUNCTION IS TO DO SEGMENT FOR THE MATH FORMULAE RECOGONIZER;
% INPUT:
%       allPoints: THE WHOLE POINT DATA, WITH A FORMAT OF CELL;

% markMtx is used to mark all the strokes, the rows represend each strokes
% the first layer is to mark the property,
%         1 for nominator,
%         2 for devid line,
%         3 for denominaotr,
%         5 for exponential,
%         9 for regular number/calculator,
% the second layer is to mark the box, from left to right, the box is from
% the bigges to the smaller;


% % TEST AREA
% dbstop if error
% clear all ; close all; clc;
% load('Inkdata14.mat');
% allPoints = Inkdata;
% for runner = 1:size(allPoints,1)
%     plot(allPoints{runner}(:,1),allPoints{runner}(:,2),'b.');
%     hold on; axis equal;
% end;
% %

markMtx =  final_findEqualSign(allPoints);

%{
markMtx = zeros(size(allPoints,1) , 5);
markMtx(:,1) = [1:size(allPoints,1)].';
strokeNum = size(allPoints,1);
% GET STROKE PROPERTIES
for stroke = 1: strokeNum;
    currentStroke = allPoints{stroke};
    currentMax = max(currentStroke);
    currentMin = min(currentStroke);
    diffXY = currentMax - currentMin;
    ratio = max(diffXY)/min(diffXY);
    strokeProperty(stroke,:) = [currentMin(1) , currentMax(1), currentMin(2) , currentMax(2),diffXY, ratio];
    plot(currentStroke(:,1) , currentStroke(:,2),'k.');
    hold on; axis equal;
end;

% FIRST ASSIGN EACH STROKE TO BOXES, WITH ONLY X VALUES
boxInd = 1;
for stroke1 = 1:strokeNum-1;
    for stroke2 = stroke1+1:strokeNum;
        if (strokeProperty(stroke2,1) - strokeProperty(stroke1,1))*(strokeProperty(stroke2,2) - strokeProperty(stroke1,2))<=0;
            if markMtx(stroke1,2) ==0
                markMtx(stroke1,2) = boxInd;
                markMtx(stroke2,2) = boxInd;
                boxInd = boxInd + 1;
            else
                markMtx(stroke2,2) = markMtx(stroke1,2);
            end;
        elseif (strokeProperty(stroke2,1) - strokeProperty(stroke1,1))*(strokeProperty(stroke2,1) - strokeProperty(stroke1,2))<0 ...
                || (strokeProperty(stroke1,1) - strokeProperty(stroke2,1))*(strokeProperty(stroke1,1) - strokeProperty(stroke2,2))<0
            if markMtx(stroke1,2)==0;
                markMtx(stroke1,2) = boxInd;
                markMtx(stroke2,2) = boxInd;
                boxInd = boxInd + 1;
            else
                markMtx(stroke2,2) = markMtx(stroke1,2);
            end;
        end
    end
end;
if markMtx(end,2) ==0;
    markMtx(end,2) = boxInd;
end;
%}
leftBox = allPoints(find(markMtx(:,2)==1));
if isempty(find(markMtx(:,2)==2))
    eqlBox = [];
else
    eqlBox = allPoints(markMtx(:,2) == 2);
end
if isempty(find(markMtx(:,2)==3))
    rightBox= [];
else
    rightBox = allPoints(find(markMtx(:,2)==3));
end
if size(leftBox,1)>=2|| size(rightBox,2)>=2;
    go = 1;
    
else
    go = 0;
end;
counter = 0;

while go && counter <100;
    layer = size(markMtx,2);
    nextLayer = layer +1;
    markType = unique(markMtx(:,end,1));
    markType(markType ==7) = [];
    markType(markType ==9) = [];
    if ~isempty(markType);
        markMtx = final_markBox(markMtx , allPoints);
        go = 1;
    else
        go =0;
    end
    counter = counter + 1;
end
disp('total loops to get the boxs are:\n')
disp(counter)
%{
% first round:
boxNum = max(markMtx(:,2));
for runner = 1: boxNum;
    currentBox = allPoints(markMtx(find(markMtx(:,2) == runner) , 1));
    thisInd = markMtx(find(markMtx(:,2) == runner));
    newInd = final_ifFraction(currentBox);
    % first deal with nominator
    currentInd = find(newInd ==1);
    if ~isempty(currentInd);
        markMtx(thisInd(currentInd),3) = markMtx(thisInd(currentInd),3)*10+1;
    end
    % then deal with the devider
    currentInd = find(newInd == 3);
    if ~isempty(currentInd)
        markMtx(thisInd(currentInd),3) = markMtx(thisInd(currentInd),3)*10+2;
    end
    % then deal with denominator
    currentInd = find(newInd ==2);
    if ~isempty(currentInd);
        markMtx(thisInd(currentInd),3) = markMtx(thisInd(currentInd),3)*10+3;
    end
    
    % then deal with others;
    currentInd = find(newInd ==0);
    if ~isempty(currentInd);
        markMtx(thisInd(currentInd),3) = markMtx(thisInd(currentInd),3)*10+0;
    end
    
    disp(newInd)
end

% second round:

%}

























