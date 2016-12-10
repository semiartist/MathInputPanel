% function strokeSeg = final_segNumber(allPoints)

% Written by Fei Chen
%
% THIS FUNCTION IS TO DO SEGMENT FOR THE MATH FORMULAE RECOGONIZER;
% INPUT:
%       allPoints: THE WHOLE POINT DATA, WITH A FORMAT OF CELL;



% % TEST AREA
dbstop if error
clear all ; close all; clc;
load('Inkdata.mat');
allPoints = Inkdata;

% %

strokeNum = size(allPoints,1);

for stroke = 1: strokeNum;
    currentStroke = allPoints{stroke};
    currentMax = max(currentStroke);
    currentMin = min(currentStroke);
    diffXY = currentMax - currentMin;
    ratio = max(diffXY)/min(diffXY);
    strokeProperty(stroke,:) = [currentMin(1) , currentMax(1), currentMin(2) , currentMax(2),diffXY, ratio];
    plot(currentStroke(:,1) , currentStroke(:,2),'k.');
    hold on;
end;

% TELL IF THEY HAVE A SAME X RANGE
potential = zeros(strokeNum);
for stroke1 = 1:strokeNum-1;
    for stroke2 = stroke1+1:strokeNum;
        if (strokeProperty(stroke2,1) - strokeProperty(stroke1,1))*(strokeProperty(stroke2,2) - strokeProperty(stroke1,2))<=0;
            potential(stroke1,stroke2) = 1;
            %             potential(stroke2, stroke1) = 1;
            
        elseif (strokeProperty(stroke2,1) - strokeProperty(stroke1,1))*(strokeProperty(stroke2,1) - strokeProperty(stroke1,2))<0 ...
                || (strokeProperty(stroke1,1) - strokeProperty(stroke2,1))*(strokeProperty(stroke1,1) - strokeProperty(stroke2,2))<0
            %{
            [left,leftNum] = min([strokeProperty(stroke1,1) , strokeProperty(stroke2,1)]);
            if leftNum ==1;
                leftValue = strokeProperty(stroke2,1) - strokeProperty(stroke1,1);
                midValue = strokeProperty(stroke1,2) - strokeProperty(stroke2,1);
                rightValue = strokeProperty(stroke2,2) - strokeProperty(stroke1,2);
            else
                leftValue = strokeProperty(stroke1,1) - strokeProperty(stroke2,1);
                midValue = strokeProperty(stroke2,2) - strokeProperty(stroke1,1);
                rightValue = strokeProperty(stroke1,2) - strokeProperty(stroke2,2);
            end;
                %}
                
                %             if midValue/(leftValue + rightValue)>=0.1;
                potential(stroke1,stroke2) = 1;
                %             potential(stroke2, stroke1) = 1;
                %             end;
        end
    end
end;

% PACK AND GO
index = zeros(2,strokeNum);
index(1,:) = 1:strokeNum;
[row col] = find(potential==1);

% PUT ALL THE NUMBER WITH OVERLAP IN X IN A SAME CELL;
for jumper = 1:size(row,1)
    for swimmer = 1: size(col,1)
        if row(jumper) == col(swimmer);
            row(jumper) = row(swimmer);
        end
    end
end;


seq = 1;
strokeSeq=1;
for runner = 1:strokeNum;
    
    if index(1,runner)~=0;
        
        while seq<=size(row,1)&&runner == row(seq);
            stroke1 = row(seq);
            stroke2 = col(seq);
            strokeSeg{strokeSeq} = {allPoints{stroke1}}; % ; allPoints{stroke2}};
            index(1,stroke1) = 0;
            index(2,stroke1) = strokeSeq;
            index(1,stroke2) = 0;
            index(2,stroke2) = strokeSeq;
            %             strokeSeq = strokeSeq +1;
            seq = seq +1;
        end
        strokeSeg{strokeSeq} = {allPoints{runner}};
        strokeSeq = strokeSeq +1;
    else
        
        if index(2,runner)~=0;
            location = index(2,runner);
            addTo = size(strokeSeg{location} ,1)+1;
            strokeSeg{location}{addTo,1} = allPoints{runner};
        end;
    end
    
    
    
end

plot(strokeProperty(:,1) , strokeProperty(:,3) , 'ro');
axis equal; grid on;
plot(strokeProperty(:,2) , strokeProperty(:,4),'bo');


% SEPRATE INDIVIDUAL NUMBER OR OPERATORS
equalFlag= 0;
for runner = 1: size(strokeSeg,2);
    currentPatch = strokeSeg{runner};
    patchNum = size(currentPatch,1);
    while ~isempty(currentPatch);
        line1 = currentPatch{1};
        line1Flag = 1;     removeFlag =1;
        currentPatch(1) = [];
        if ~isempty(currentPatch);
            for jumper = 1:size(currentPatch,1);
                line2 = currentPatch{jumper};
                if final_ifIntersect(line1, line2)~=0;
                    thisBox{1,1} = line1;
                    thisBox{2,1} = line2;
                    if exist('currentBox');
                        currentBox = final_addCellItem(currentBox,thisBox);
                    else
                        currentBox{1,1} = thisBox;
                    end;
                    clear thisBox;
                    line1Flag = 0;
                    currentPatch(1) = [];removeFlag = 0;
                    break
                elseif final_isEqualSign(line1, line2);
                    equalFlag = 1;
                    leftBox = currentBox;
                    thisBox{1,1} = line1;
                    thisBox{2,1} = line2;
                    if exist('equalBox');
                        equalBox = final_addCellItem(equalBox,thisBox);
                    else
                        equalBox{1,1} = thisBox;
                    end;
                    clear thisBox currentBox;
                    line1Flag = 0;
                    currentPatch(1) = []; removeFlag = 0;
                    break
                end
            end
        end
        if line1Flag
            thisBox{1,1} = line1;
            if exist('currentBox');
                currentBox = final_addCellItem(currentBox,thisBox);
            else
                currentBox{1,1} = thisBox;
            end;
            clear thisBox;
        end
    end
    if ~isempty(currentPatch) && size(currentPatch,1)==1 && removeFlag;
        line1 = currentPatch{1};
        thisBox{1,1} = line1;
        if exist('currentBox');
            currentBox = final_addCellItem(currentBox,thisBox);
        else
            currentBox{1,1} = thisBox;
        end;
        clear thisBox;
    end
end





%{
if exist('currentBox')
    position = size(currentBox,1)+1;
else
    position = 1;
end
if patchNum > 1;
    for tom = 1:patchNum-1;
        flag1 = 1;
        for sam = tom+1:patchNum;
            flag2 = 1;
            line1 = currentPatch{tom};
            line2 = currentPatch{sam};
            if final_ifIntersect(line1, line2)~=0;
                thisBox{1,1} = line1;
                thisBox{2,1} = line2;
                currentBox{position,1} = thisBox;
                position = position + 1;
                flag1 = 0;
                flag2 = 0;
                clear thisBox;
                
            elseif final_isEqualSign(line1, line2);
                leftBox = currentBox;
                clear currentBox;
                equalBox{1,1} = line1;
                equalBox{2,1} = line2;
                equalFlag = 1;
                position = 1;
                flag1 = 0;
                flag2 = 0;
                %                     continue
                
            else
                thisBox{1,1} = line2;
                currentBox{position,1} = thisBox;
                position = position + 1;
                clear thisBox;
            end
        end
        if flag1
            thisBox{1,1} = line1;
            currentBox{position,1} = thisBox;
            position = position + 1;
            clear thisBox;
        end
    end
    
else
    currentBox{position,1} = currentPatch;
end
end
%}
if equalFlag;
    rightBox = currentBox;
else
    leftBox = currentBox;
end