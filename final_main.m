function [result caseType] = final_main(Inkdata);

% Written by Fei Chen
%
% THIS IS THE MAIN FUNCTION OF THE RECOGNIZER, IT WILL FOLLOW THE STEPS TO
% CALL EACH FUNCTION TO FINISH THE RECOGNISE PROCESS;
% INPUT:
%       Inkdata: the finished drawing strokes.
% OUTPUT:
%       result: Is a string used to display the result, including all the
%       prantesis added for each block;

% % TEST AREA
% dbstop if error
% clear all ; close all; clc;
% load('Inkdata.mat');
% allPoints = Inkdata;
% for runner = 1:size(allPoints,1)
%     plot(allPoints{runner}(:,1),allPoints{runner}(:,2),'b.');
%     hold on; axis equal;
% end;
% % end of the test data;


prentL = '(';
prentR = ')';
% STEP 1: SEG THE STROKES INTO BOXES;
tic
markMtx = final_segNumber2(Inkdata);
timer1 = num2str(toc);
disp1 = ['seg boxes takes ', timer1, ' seconds'];

% STEP 2: PRE SORT THE DATA AND RECOGNIZE THE DATA WITH ADABOOS PRETRAINED ALGORITHM.
tic
boxes = unique(markMtx(:,end,2));
equalFlag = 0;
for box = 1:size(boxes,1)
    thisInd = boxes(box,1);
    thisType = floor(thisInd/10);
    layer = 3;
    while thisType>10;
        thisType = floor(thisType/10);
        layer = layer + 1;
    end
    if thisType ~=2;
        % result{1,box} = final_recognise(Inkdata , markMtx , thisInd);
         result{1,box} = final_recognise2(Inkdata , markMtx , thisInd);
    else
        equalFlag = 1;
        result{1,box} = '=';
        % result{2,box} = '=';
    end
end
origInd = 1:size(result,2);
% then add the prantasis
% first add to each fraction
layerNum = size(markMtx,2);
for thisLayer = 3:layerNum;
    lastLayer = thisLayer - 1;
    if thisLayer == layerNum;
        nextLayer = thisLayer;
    else
        nextLayer = thisLayer +1;
    end
    
    lastBox = unique(markMtx(:,lastLayer,1));
    lastBoxNum = size(lastBox,1);
    for box = 1:lastBoxNum;
        thisBigBox = markMtx(markMtx(:,lastLayer,1)==lastBox(box),:,:);
        thisBox = unique(thisBigBox(:,thisLayer,1));
        thisBoxNum = size(thisBox,1);
        for mmm = 1:thisBoxNum;
            nnn = thisBox(mmm,1);
            if nnn == 1;
                thisSmallBox = thisBigBox(thisBigBox(:,thisLayer,1) == nnn,:,:);
                thisSmallInd = unique(thisSmallBox(:,thisLayer,2));
                for aaa = size(thisSmallInd,1):-1:1;
                    thisSmallBoxInd = min(thisSmallBox(thisSmallBox(:,thisLayer,2)==thisSmallInd(aaa,1),end,2));
                    boxLoc = find(boxes == thisSmallBoxInd);
                    realInd = origInd(1,boxLoc);
                    addLoc = realInd;
                    origAddLoc = boxLoc ;
                    result = final_addItem2Cell(result,prentL,addLoc);
                    origInd = final_changeIndex(origInd, origAddLoc);
                end
            elseif nnn ==3;
                thisSmallBox = thisBigBox(thisBigBox(:,thisLayer,1) == nnn,:,:);
                thisSmallInd = unique(thisSmallBox(:,thisLayer,2));
                for aaa = size(thisSmallInd,1):-1:1;
                    thisSmallBoxInd = min(thisSmallBox(thisSmallBox(:,thisLayer,2)==thisSmallInd(aaa,1),end,2));
                    boxLoc = find(boxes == thisSmallBoxInd);
                    realInd = origInd(1,boxLoc);
                    addLoc = realInd;
                    origAddLoc = boxLoc ;
                    result = final_addItem2Cell(result,prentR,addLoc+1);
                    origInd = final_changeIndex(origInd, origAddLoc+1);
                end
            end
            
            if nnn ==1 || nnn ==3;
                thisSmallBox = thisBigBox(thisBigBox(:,thisLayer,1) == nnn,:,:);
                thisSmallInd = unique(thisSmallBox(:,thisLayer,2));
                for aaa = size(thisSmallInd,1):-1:1;
                    indexes = unique((thisSmallBox(thisSmallBox(:,thisLayer,2)==thisSmallInd(aaa,1),end,2)));
                    if size(indexes,1) ~=1;
                        origMinInd = find(boxes ==min(indexes));
                        origMaxInd = find(boxes == max(indexes));
                        addLocMin = origInd(origMinInd);
                        addLocMax = origInd(origMaxInd)+1;
                        result = final_addItem2Cell(result,prentR,addLocMax);
                        origInd = final_changeIndex(origInd, origMaxInd);
                        result = final_addItem2Cell(result,prentL,addLocMin);
                        origInd = final_changeIndex(origInd, origMinInd);
                    end
                end
            end
        end
    end
end
[origInd, result] = final_addXY(result, origInd);
result = final_isExp(Inkdata , markMtx , origInd, result)

% then add the paratasis to the left and right box;
if equalFlag ==1;
    caseType = 1;
    %{
    % left side and right side need to add prentasis
    equalLoc = find(boxes ==unique(markMtx(markMtx(:,2,2)==2,end,2)));
    thisLoc = size(origInd,2);
    % add right to right
    result = final_addItem2Cell(result,prentR,origInd(thisLoc)+1);
    origInd = final_changeIndex(origInd, thisLoc+1);
    % add left to right
    result = final_addItem2Cell(result,prentL,origInd(equalLoc)+1);
    origInd = final_changeIndex(origInd, equalLoc+1);
    % add right to left
    result = final_addItem2Cell(result,prentR,origInd(equalLoc));
    origInd = final_changeIndex(origInd, equalLoc);
    % add left to left
    result = final_addItem2Cell(result,prentL,1);
    origInd = final_changeIndex(origInd, 1 );
    %}
    for runner = 1:size(result,2)
        if result{runner} == '=';
            leftBox = result(1,1:runner-1);
            rightBox = result(1,runner+1:end);
            break;
        end
    end
else
    caseType = 2;
    % no big prentasis needed for this
    leftBox = result;
    rightBox = [];
end;

%{
% then load HMM module;
resultLeft = final_HMM(leftBox);
if ~isempty(rightBox);
    resultRight = final_HMM(rightBox);
end

timer2 = num2str(toc);
disp2 = ['seg recgonize takes ', timer2, ' seconds'];
disp(disp1);
disp(disp2);
disp(result)
%}