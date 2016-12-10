function newCell = final_addItem2Cell(cellName, itemName, index)

% Written by Fei Chen
%
% THIS FUNCTION ADD ONE ITEM TO THE CELL cellName
%
% INPUT:
%       cellName: the cell to be added items to
%       itemName: the item to be added to the cell
%       index: the place of the item should be appear in the cell
% OUTPUT:
%       cellName: the updated cell;

if ~iscell(cellName)
    error('the adding item is not a cell')
elseif index > max(size(cellName))+1
    error('the adding index is exceed the cell size')
end
[row col] = size(cellName);
if (row >= col && col~=1) || (row <= col && row~=1)
    error('This cell size is not a row or col!')
else
    if row >= col;
        direction = 'row';
    else
        direction = 'col';
    end
end

switch direction
    case 'row'
        newCell = cellName(1:index-1,1);
        newCell{end+1,1} = itemName;
        newCell(end+1:row+1,1) = cellName(index:end,1);
    case 'col'
        newCell = cellName(1,1:index-1);
        newCell{1,end+1} = itemName;
        newCell(1,end+1:col+1) = cellName(1,index:end);
end
