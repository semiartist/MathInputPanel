function markMtx = final_markBox(markMtx , allPoints)

% Written by Fei Chen
%
% THIS FUNCTION IS TO DO SEGMENT FOR THE MATH FORMULAE RECOGONIZER;
% INPUT:
%       allPoints: THE WHOLE POINT DATA, WITH A FORMAT OF CELL;

% markMtx is used to mark all the strokes with different layers.

% TEST AREA
% clear all ; close all ; clc;
% dbstop if error;
% load('testBox4');
% 
% for runner = 1:size(allPoints,1)
%     plot(allPoints{runner}(:,1),allPoints{runner}(:,2),'b.');
%     hold on; axis equal;
% end;

% end test area;

% get current layer:
thisLayer = size(markMtx,2);
nextLayer = thisLayer + 1;
markMtx(:,nextLayer,1:2) = 0;

%{
boxNum = max(markMtx(:,thisLayer,2));
for runner = 1: boxNum;
    thisInd = find(markMtx(:,thisLayer,2) == runner);
    currentBox = allPoints(thisInd);
    
    % first round: find the fractions in the big box
    newMark = final_ifFraction(currentBox);
    markMtx(thisInd,nextLayer,1) = newMark;
%{
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
%}
    if sum(newMark)~=0;
        fracMin = 1;fracMax = 0;
        fracInd = find(newMark~=0);
        for jumper = 1:size(fracInd,1);
            fracMin = min(fracMin, min(allPoints{(thisInd(fracInd(jumper)))}(:,1)));
            fracMax = max(fracMax, max(allPoints{(thisInd(fracInd(jumper)))}(:,1)));
        end
        fracMid = (fracMin + fracMax)/2;
        markMtx(thisInd(fracInd),nextLayer,2) = 2;
        for jumper = 1:size(currentBox,1);
            index = (thisInd((jumper)));
            if markMtx(index,nextLayer,1)==0
                thisLine = allPoints{index};
                thisMid = (min(thisLine(:,1)) + max(thisLine(:,1)))/2;
                if thisMid<fracMid
                    markMtx(index,nextLayer,2) = 1;
                elseif thisMid>fracMid
                    markMtx(index,nextLayer,2) = 3;
                end
            else
                markMtx(index,nextLayer,2) = 2;
            end
        end
    else
        markMtx(thisInd,nextLayer,2) = 1;
    end
    minValue = min(markMtx(thisInd,nextLayer,2));
    addValue = 1- minValue;
    markMtx(thisInd,nextLayer,2) = markMtx(thisInd,nextLayer,2)+addValue;
    % second round: find the rest is normal or exponential
end
%}

% sub devide current Box;
parentValues = unique(markMtx(:,thisLayer,2));
parentNum = size(parentValues,1);

for parent = 1: parentNum;
    parentValue = parentValues(parent);
    parentInd = find(markMtx(:,thisLayer,2) == parentValue);
    if find(markMtx(parentInd,2,1)==2)
        markMtx(parentInd,nextLayer,2) = markMtx(parentInd,thisLayer,2)*10+1;
        markMtx(parentInd,nextLayer,1) = 7;
        continue
    end;
    childName = unique(markMtx(parentInd,nextLayer,2));
    childNum= size(childName,1);
    for child = 1:childNum;
        childInd = parentInd(find(markMtx(parentInd,nextLayer,2) == childName(child)));
        % get children type
        childType = max(markMtx(childInd,nextLayer,1));
        boxInitial = 0;
        if boxInitial ==0
            box = markMtx(childInd(1),nextLayer,2);
            if box ==0;
                box = 1;
            end
            boxInitial = 1;
        end
        markMtx(childInd,nextLayer,2) = 0;
        
        for stroke1 = 1:size(childInd,1);
            addBoxFlag = 0;
            findMatch = 0;
            line1 = allPoints{childInd(stroke1)};
            if markMtx(childInd(stroke1),nextLayer,2) == 0;
                markMtx(childInd(stroke1),nextLayer,2) = box;
                addBoxFlag = 1;
            end
            for stroke2 = stroke1+1:size(childInd,1);
                line2 = allPoints{childInd(stroke2)};
                if final_isLayover(line1, line2)
                    findMatch = 1;
                    if markMtx(childInd(stroke1),nextLayer,2)==box;
                        if markMtx(childInd(stroke2),nextLayer,2)==0;
                            markMtx(childInd(stroke2),nextLayer,2) = box;
                        else
                            markMtx(childInd(stroke1),nextLayer,2) = markMtx(childInd(stroke2),nextLayer,2);
                            addBoxFlag = 0;
                        end
                    else
                        markMtx(childInd(stroke2),nextLayer,2)=markMtx(childInd(stroke1),nextLayer,2);
                    end
                end
            end
            if addBoxFlag
                box = box +1;
            end
        end
    end
    
    % order the sequence for the child boxes
    childSize = size(unique(markMtx(parentInd,nextLayer,2)),1);
    %     childLoc = zeros(childSize,2);
    childLoc = ones(childSize,1);
    for childn = 1:childSize;
        childInd = parentInd(find(markMtx(parentInd,nextLayer,2) == childn));
        for childm =1:size(childInd,1);
            childLoc(childn,1) = min(min(allPoints{childInd(childm)}(:,1)) , childLoc(childn,1));
            %             childLoc(childn,2) = max(max(allPoints{childInd(childm)}(:,1)) , childLoc(childn,2));
        end
    end
    position = markMtx(parentInd,nextLayer,2);
    newPosition = zeros(size(position));
    [~, loc] = sort(childLoc);
    for runner = 1:size(loc,1);
        newPosition(find(position == loc(runner)),1) = runner;
    end
    newPosition = newPosition + parentValue*10;
    markMtx(parentInd,nextLayer,2) = newPosition;
    
end

for father = 1: parentNum;
    fatherValue = parentValues(father,1);
    childInd = find(markMtx(:,thisLayer,2) == fatherValue);
    childType = unique(markMtx(childInd,nextLayer,2));
    childNum = size(childType,1);
    newSeq = zeros(size(markMtx(childInd,nextLayer,2)));
    thisInd = fatherValue*10+1;
    fatherBase = fatherValue*10;
    if markMtx(childInd(1),2,2)==2
        markMtx(childInd , nextLayer,1) = 7;
    else
        for child = 1:childNum;
            thisChild = find(markMtx(childInd,nextLayer,2) == childType(child,1));
            currentBox = allPoints(childInd(thisChild));
            % first round: find the fractions in the child box
            if size(childInd(thisChild),1)>2;
                newMark = final_ifFraction(currentBox);
                mark = newMark;
                mark(mark ==0) = 8;
                mark(mark == 4) = 8;
                markMtx(childInd(thisChild),nextLayer,1) = mark;
                normalBox1 = find(newMark==0);
                normalBox2 = find(newMark == 4);
                normalBox = [normalBox1 ; normalBox2];
                fractionBox = find(newMark ==1);
                if ~isempty(fractionBox);
                    if isempty(normalBox1)
                        newSeq(thisChild) = newMark + thisInd-1;
                    else
                        newSeq(thisChild) = newMark +  thisInd;
                    end
                    
                else
                    cc = 1;
                    for stroke1 = 1: size(currentBox,1)
                        ints = 1;
                        line1 = currentBox{stroke1};
                        for stroke2 = stroke1+1:size(currentBox,1);
                            if stroke2 ~= stroke1;
                                line2 = currentBox{stroke2};
                                if final_ifIntersect(line1, line2);
                                    % newSeq(childInd(thisChild(stroke1)))
                                    if newMark(stroke1) ==0 && newMark(stroke2) == 0;
                                        newMark(stroke1) = cc;
                                        newMark(stroke2) = cc;
                                        cc = cc+1;
                                        ints = 0;
                                    else
                                        indd = max(newMark(stroke1) , newMark(stroke2));
                                        newMark(stroke1) = indd;
                                        newMark(stroke2) = indd;
                                        ints = 0;
                                    end
                                end
                            end
                        end
                        if ints && newMark(stroke1)==0;
                            newMark(stroke1) = cc;
                            cc = cc+1;
                        end
                    end
                    
                    % % % % %make a new sequence for this one;
                    childSize = size(unique(newMark),1);
                    %     childLoc = zeros(childSize,2);
                    childLoc = ones(childSize,1);
                    for childn = 1:childSize;
                        thisChildInd = childInd(thisChild(find(newMark == childn)));
                        for childm =1:size(thisChildInd,1);
                            childLoc(childn,1) = min(min(allPoints{thisChildInd(childm)}(:,1)) , childLoc(childn,1));
                            %             childLoc(childn,2) = max(max(allPoints{childInd(childm)}(:,1)) , childLoc(childn,2));
                        end
                    end
                    position =newMark;
                    newPosition = zeros(size(position));
                    [~, loc] = sort(childLoc);
                    for runner = 1:size(loc,1);
                        newPosition(find(position == loc(runner)),1) = runner;
                    end
                    newMark = newPosition;
                    % % % % % end of mark sequence
                    newSeq(thisChild) = newMark + thisInd-1;
                    % newSeq(thisChild) = markMtx(childInd(thisChild),nextLayer,2)- fatherBase + thisInd;
                end
                incre = size(unique(newMark) ,1);
                thisInd = thisInd + incre;
                
            elseif size(thisChild,1) ==2;
                
                line1 = allPoints{childInd(thisChild(1))};
                line2 = allPoints{childInd(thisChild(2))};
                if final_ifIntersect(line1, line2);
                    markMtx(childInd(thisChild),nextLayer,1) = 9;
                    newSeq(thisChild) = thisInd;
                else
                    min1 = min(line1(:,1));
                    min2 = min(line2(:,2));
                    if min1<min2
                        newSeq(thisChild(1)) = thisInd;
                        thisInd = thisInd + 1;
                        newSeq(thisChild(2)) = thisInd;
                    else
                        newSeq(thisChild(2)) = thisInd;
                        thisInd = thisInd + 1;
                        newSeq(thisChild(1)) = thisInd;
                    end
                    markMtx(childInd(thisChild),nextLayer,1) = 9;
                end
                thisInd = thisInd + 1;
                
            else
                markMtx(childInd(thisChild),nextLayer,1) = 9;
                newSeq(thisChild) =  thisInd;
                thisInd = thisInd + 1;
                % second round, to see if they are intersect;
                %{
            if sum(newMark)~=0;
                fracMin = 1;fracMax = 0;
                fracInd = find(newMark~=0);
                for jumper = 1:size(fracInd,1);
                    fracMin = min(fracMin, min(allPoints{(childInd(fracInd(jumper)))}(:,1)));
                    fracMax = max(fracMax, max(allPoints{(childInd(fracInd(jumper)))}(:,1)));
                end
                fracMid = (fracMin + fracMax)/2;
                markMtx(childInd(fracInd),nextLayer,1) = 2;
                for jumper = 1:size(currentBox,1);
                    index = (childInd((jumper)));
                    if markMtx(index,nextLayer,1)==0
                        thisLine = allPoints{index};
                        thisMid = (min(thisLine(:,1)) + max(thisLine(:,1)))/2;
                        if thisMid<fracMid
                            markMtx(index,nextLayer,2) = 1;
                        elseif thisMid>fracMid
                            markMtx(index,nextLayer,2) = 3;
                        end
                    else
                        markMtx(index,nextLayer,2) = 2;
                    end
                end
            else
                markMtx(childInd,nextLayer,2) = 1;
            end
                %}
            end
        end
        markMtx(childInd,nextLayer,2) = newSeq;
    end
end




















