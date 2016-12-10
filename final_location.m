function result = final_location(totalBoundry)

% THIS FUNCTION IS TO GET THE CURRENT STROKE'S POSITION AFTER THE WRITTING,
% THE INKDATA INDICATE THE CURRENT STROKE, AND THE TOTALSTROKE INDICATE ALL
% THE STROKE'S 

inkNum = size(totalBoundry,2);

startingX = totalBoundry(1,:);

[~ ,index] = sort(startingX);
result(1,: ) = index;
result(2,:) = 0;
for runner = 1: inkNum;
    if runner > 1;
        preInd = totalBoundry(:,result(1,:) == (runner-1));
        thisInd = totalBoundry(:,result(1,:) == runner);
        preTop = preInd(4,:);
        preBut = preInd(3,:);
        thisTop = thisInd(4,:);
        thisBut = thisInd(3,:);
        line1 = 3*(preTop - preBut)/4 + preBut;
        line2 = (thisTop - thisBut)/2 + thisBut;
        line3 = 3*(preInd(2,:) - preInd(1,:))/4;
        line4 = thisInd(1,:);
    
        if (thisTop - thisBut)< (preTop - preBut) && line2 > line1 && line4 > line3;
            result(2,runner) = 1;
        end
    end
end

