function [expression] = convert(formula)
% convert a handwriting formula into a matlab expression

expression=formula;
timesvoid=[1:10,15,16,20];
if ismember(15,formula) || ismember(16,formula)
   place=[find(formula==15),find(formula==16)];
   place(place==1)=[]
   for i=1:numel(place);
       temp=place(i)-1;
       if ismember(expression(temp),timesvoid)
           expression=[expression(1:temp),13,expression(temp+1:end)];
           place=place+1;
       end
   end
else
    place=find(formula==21);
    expression=[expression(1:place-1),21,expression(place:end)];
end


end

