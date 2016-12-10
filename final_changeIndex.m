function newInd = final_changeIndex(origInd, index)

% Written by Fei Chen
%
% THIS FUNCTION CHANGES THE ORIGINAL INDEX MATRIX TO A UDPATED ONE;
%
% INPUT:
%       origInd: the original index matrix
%       index: the location where added something
% OUTPUT:
%       newInd: the udpated Index;

[a b] = size(origInd);
if a~=1 %|| b<a;
    error('the index matrix seems wrong!')
elseif index > b+1;
    error('the adding location is exceeded the index matrix!');
end

newInd = origInd;
adding = zeros(size(origInd));
if index~=b+1;
    adding(1, index:end) = 1;
    newInd = newInd + adding;
end

