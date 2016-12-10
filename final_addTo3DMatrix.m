function outMtx = final_addTo3DMatrix(bigMatrix, smallMatrix);

% WRITTEN BY Fei Chen
%
% THIS FUNCTION IS TO ADD A 2D MATRIX TO A 3D MATRIX. AND GENERATE 2
% DIFFERENT MATRIXS TO PROVIDE TO THE DISCRIMINATOR TO RECOGNISE.
%
% INPUT:
%        bigMatrix : the 3D(could be 2D) matrxi to be added;
%        smallMatrix: the 2D matrix to be added to the 3D matrix
% OUTPUT: 
%        outMtx: output matrix, the combination of the big and small matrix

[big1 big2 big3] = size(bigMatrix);
[small1 small2 small3] = size(smallMatrix);

if big1 ~= small1 && big2 ~= small2
    error('the matrix size is not equal in the combine matrix function');
end

if big1>=small1;
    tempMtx = zeros(big1,big2);
    tempMtx(1:small1,:) = smallMatrix;
    outMtx = bigMatrix;
    outMtx(:,:,big3+1) = tempMtx;
else
    tempMtx = zeros(small1, big2, big3);
    tempMtx(1:big1,:,:) = bigMatrix;
    tempMtx(:,:,big3+1) = smallMatrix;
    outMtx = tempMtx;
end


