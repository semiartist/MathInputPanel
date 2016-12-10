function [origInd, result] = final_addXY(result, origInd);

% Written by Fei Chen
%
% THIS FUNCTION IS TO DETERMIN TO ADD * BEFORE X AND Y IN THE MAIN FUNCTION;
% INPUT:
%       result: the recognize result, after all the pratasis added
%       origInd: the box location index matrix
% OUTPUT:
%       result: the added result for the function
%       origInd: the updated origInd matrix

boxNum = size(result,2);
for box = boxNum:-1:2;
    item1 = result{box-1};
    item2 = result{box};
    if (item1 =='1' ||item1 =='2' ||item1 =='3' ||item1 =='4' ||item1 =='5' ||...
            item1 =='6' ||item1 =='7' ||item1 =='8' ||item1 =='9' ||item1 =='0' ||...
            item1 =='x' ||item1 =='y'||item1 ==')') ...
            &&(item2 == 'x' || item2 == 'y');
        % add an * in between them;
        result = final_addItem2Cell(result,'*',box);
        origInd = final_changeIndex(origInd, find(origInd ==box) );
    end
end;
        