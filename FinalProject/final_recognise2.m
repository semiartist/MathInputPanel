function result = final_recognise2(Inkdata , markMtx , thisInd)

% Written by Fei Chen
%
% THIS IS THE MAIN FUNCTION OF THE RECOGNIZER, IT WILL FOLLOW THE STEPS TO
% CALL EACH FUNCTION TO FINISH THE RECOGNISE PROCESS;
% INPUT:
%       Inkdata: the finished drawing strokes.
%       markMtx: is the marked boxes marker;
% OUTPUT:
%       result: Is a string used to display the result, including all the
%       prantesis added for each block;

% recognise 2 is to use the adaboose algorithm to recognise the numbers

recoFlag = 0;
% step 1: reassembly the strokes into a 3D matrix;
thisNum = Inkdata(markMtx(:,end,2) == thisInd);
load('temp2_sampleNameCell');

strokeNum = size(thisNum,1);
pntNum = 0;
for stroke = 1: strokeNum;
    thisStroke = thisNum{stroke};
    if stroke ==1;
        outMtx = thisStroke;
    else
        outMtx = final_addTo3DMatrix(outMtx, thisStroke);
    end
end;

if strokeNum ==1;
    currentMark = markMtx(markMtx(markMtx(:,end,2) == thisInd),2:end,1);
    recoFlag = sum(ismember(currentMark,2));
    result = '/';
end

if recoFlag == 0
    fVector = ada_getFeatures(outMtx);
    resultTT = ada_getResult2(fVector);
    result = sampleNameCell(resultTT);
    result = cell2mat(result);
end