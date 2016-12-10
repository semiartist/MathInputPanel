function cellName =  final_addCellItem(cellName , itemName);

% Written by Fei Chen
%
% THIS FUNCTION IS TO ADD A SMALL CELL TO A LARGER CELL;
% INPUT:



if ~iscell(cellName)&&~iscell(itemName);
    error('Check your input type! Both input should be cell!');
end


[a b] = size(cellName);

if b ==1;
    cellName{a+1,1} = itemName;
elseif a ==1;
    cellName(1,b+1) = itemName;
else
    error('Can not find a major direction to add item, check your input!');
end;

