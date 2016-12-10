function result = final_isExp(inkData , markMtx , origInd, result)

% Written by Fei Chen
%
% THIS FUNCTION IS TO TELL IF THE NUMBER IS AN EXPONENTIAL OR NOT;
% INPUT:
%       inkData: The input Strokes
%       markMtx: the seg box matrix
%       origInd: the box sequence index
% OUTPUT:
%       result: the after defined matrix;

indexes = unique(markMtx(:,end,2));
boxNum =  size(result,2);
passInd = 0;
for box = 1:boxNum-1;
    if passInd ==1
        passInd =0;
    else
        item1 = result{box};
        item2 = result{box+1};
        if  (item1 =='1' ||item1 =='2' ||item1 =='3' ||item1 =='4' ||item1 =='5' ||...
                item1 =='6' ||item1 =='7' ||item1 =='8' ||item1 =='9' ||item1 =='0' ||...
                item1 =='x' ||item1 =='y'||item1 ==')') &&...
                (item2 =='1' ||item2 =='2' ||item2 =='3' ||item2 =='4' ||item2 =='5' ||...
                item2 =='6' ||item2 =='7' ||item2 =='8' ||item2 =='9' ||item2 =='0'||...
                item2 =='('||item2 =='-'|| item2 =='x'||item2 =='y')
            find1 =1 ; find2 = 1;
            item1Mid = 1; item2Mid = 0;
            if item1 == ')'
                item1Max = 0;
                item1Min = 1;
                prentInd = 0;
                % then to find the previous (;
                for runner = box-1:-1:1;
                    if result{runner} =='(';
                        if prentInd == 0;
                            item1Mid = (item1Max + item1Min)/2;
                            break
                        else
                            prentInd = prentInd - 1;
                        end
                    elseif result{runner} == ')'
                        prentInd == prentInd+1;
                    else
                        while isempty(find(origInd == runner))
                            runner = runner -1;
                        end
                        thisInd = indexes(find(origInd == runner));
                        thisStroke = find(markMtx(:,end,2) == thisInd);
                        strokeNum = size(thisStroke,1);
                        for jumper = 1:strokeNum;
                            item1Max = max(max(inkData{thisStroke(jumper)}(:,2)),item1Max);
                            item1Min = min(min(inkData{thisStroke(jumper)}(:,2)) , item1Min);
                        end
                    end
                end
                
                find1 = 0;
            end
            
            if item2 == '(';
                item2Max = 0;
                item2Min = 1;
                prentInd = 0;
                % then to find the next );
                for runner = box+2:1:boxNum;
                    if result{runner} == ')';
                        if prentInd == 0
                            item2Mid = (item2Max + item2Min)/2;
                            break
                        else
                            prentInd = prentInd -1;
                        end
                    elseif result{runner} == '(';
                        prentInd = prentInd + 1;
                    else
                        while isempty(find(origInd == runner))
                            runner = runner +1;
                        end
                        thisInd = indexes(find(origInd == runner));
                        thisStroke = find(markMtx(:,end,2) == thisInd);
                        strokeNum = size(thisStroke,1);
                        for jumper = 1:strokeNum;
                            item2Max = max(max(inkData{thisStroke(jumper)}(:,2)),item2Max);
                            item2Min = min(min(inkData{thisStroke(jumper)}(:,2)) , item2Min);
                        end
                    end
                end
                
                find2 = 0;
            end
            
            if find1;
                item1Max = 0;
                item1Min = 1;
                % find the first number's mid point;
                thisInd = indexes(find(origInd == box));
                thisStroke = find(markMtx(:,end,2) == thisInd);
                strokeNum = size(thisStroke,1);
                for jumper = 1:strokeNum;
                    item1Max = max(max(inkData{thisStroke(jumper)}(:,2)),item1Max);
                    item1Min = min(min(inkData{thisStroke(jumper)}(:,2)) , item1Min);
                end
                item1Mid = (item1Max + item1Min)/2;
            end
            if find2;
                % find the second item's mid point;
                item2Max = 0;
                item2Min = 1;
                thisInd = indexes(find(origInd == box+1));
                thisStroke = find(markMtx(:,end,2) == thisInd);
                strokeNum = size(thisStroke,1);
                for jumper = 1:strokeNum;
                    item2Max = max(max(inkData{thisStroke(jumper)}(:,2)),item2Max);
                    item2Min = min(min(inkData{thisStroke(jumper)}(:,2)) , item2Min);
                end
                item2Mid = (item2Max + item2Min)/2;
            end
            item1H = item1Max - item1Min;
            item2H = item2Max - item2Min;
            if item2Mid > item1Mid;
                if (item2Mid - item1Mid)/item1H > 0.3;
                    result{box+1} = ['^' , item2];
                    passInd = 1;
                end
            end
        end
    end
end;