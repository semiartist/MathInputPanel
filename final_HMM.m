function result = final_HMM(firstResult)

% % Written by Jingzhi Wang

dbstop if error
load HMMPARAMETER
% load Inkdata

%%
template=['1','2','3','4','5','6','7','8','9','0','+','-','*','/','x','y','e','.','(',')'];
% output=[20,15,11,5,2];% the output sequence
for runner = 1:size(firstResult,2);
    output(1,runner) = find(template == firstResult{runner});
end
l=numel(output);% l is the length of the expressions, aka the number of elements
len=numel(template);
if len>21
    A(22:len,:)=A(21,:);
    A(:,22:len)=A(:,21);
    B(22:len,22:len)=1;
    P(22:len)=1;
end
delta=zeros(l,len);
class=zeros(l,len);

for i=1:len
    delta(1,i)=P(i)*B(output(1),i);
end
if l>1
    for i=2:l
        for j=1:len
            temp=delta(i-1,:).*A(:,j)'.*B(output(i),j);
            delta(i,j)=max(temp);
            ifnomax=find(temp==max(temp));
            if numel(ifnomax)>1
                class(i,j)=output(i);
            else
                class(i,j)=ifnomax;
            end
        end
    end
    index=zeros(1,l);
    ifnomax=find(delta(end,:)==max(delta(end,:)));
            if numel(ifnomax)>1
                index(end)=output(end);
            else
                index(end)=ifnomax;
            end
    for i=l-1:-1:1
        index(i)=class(i+1,index(i+1));
    end
    result=template(index);
else 
    index=find(delta==max(delta));
    result=template(index(1));
end






