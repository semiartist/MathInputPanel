function markMtx = final_findEqualSign(allPoints)

% Written by Fei Chen
%
% THIS FUNCTION IS TO FIND THE EQUAL SING IN A CELL OF STROKES;
% INPUT:
%       allPoints: the input point cell which contains all the strokes
% OUTPUT:
%       markMtx: which marks the 2nd column of it self,
%       1: for all the strokes on the left of the equal sign
%       2: for the equal sign
%       3: for the strokes on the right of the equal sign


% % TEST AREA
% dbstop if error
% clear all ; close all; clc;
% load('Inkdata4.mat');
% allPoints = Inkdata;
% 
% for runner = 1:size(allPoints,1)
%     plot(allPoints{runner}(:,1),allPoints{runner}(:,2),'b.');
%     hold on; axis equal;
% end;

% %

% get the basic information
strokeNum = size(allPoints,1);
% generate the basic markMtx;
markMtx = [1:strokeNum].';
markMtx(:,2) = 0;
markMtx(:,1,2) = 1;

for stroke1 = 1:strokeNum-1;
    line1 = allPoints{stroke1,1};
    if final_isHorizontalLine(line1);
        for stroke2 = stroke1+1:strokeNum;
            line2 = allPoints{stroke2,1};
            if final_isHorizontalLine(line2);
                if final_isEqualSign(allPoints, stroke1, stroke2);
                    markMtx([stroke1,stroke2],2,1:2) = 2;
                    % plot(line1(:,1), line1(:,2) , 'r.'); hold on;
                    % plot(line2(:,1) , line2(:,2),'r.'); axis equal;
                end
            end
        end
    end
end

% step find equal sign in the markMtx;
equalInd = find(markMtx(:,2) ==2);
if isempty(equalInd)
    markMtx(:,2,1:2) =1;
    return
elseif size(equalInd,1)>2;
    % THIS PART COULD BE REWRITE!
    error('multiple equal sign found, re-check your input!error code 221')
    % THIS PART COULD BE REWRITE!
end

line1 = allPoints{equalInd(1)};
line2 = allPoints{equalInd(2)};
eqlMin = min(min(line1(:,1)) , min(line2(:,1)));
eqlMax = max(max(line1(:,1)) , max(line2(:,1)));

for stroke = 1: strokeNum;
    if stroke ~=equalInd(1) && stroke~=equalInd(2);
        thisLine = allPoints{stroke};
        thisMin = min(thisLine(:,1));
        thisMax = max(thisLine(:,1));
        if thisMin>=eqlMax;
            markMtx(stroke,2,1:2) = 3;
        elseif thisMax<=eqlMin;
            markMtx(stroke,2,1:2) = 1;
        elseif thisMin<eqlMin
            markMtx(stroke,2,1:2) = 1;
        elseif thisMax > eqlMax
            markMtx(stroke,2,1:2) = 2;
        end
    end
end

if ~isempty(find(markMtx(:,2)==0));
    error('there may be some line can not be tell in side of equal sign, error code 222!');
end
