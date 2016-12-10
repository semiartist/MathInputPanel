function [index] = HMMcalculation(output)
% output is the sequence from the recognizer
% index is the result modified by the HMM 

load HMMPARAMETER

template=['1','2','3','4','5','6','7','8','9','0','+','-','*','/','x','y','^','.','(',')','='];

l=numel(output);% l is the length of the expressions, aka the number of elements
len=numel(template);

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
    index=index(1);
    result=template(index);
end
disp(result);
disp(' ');
[expression] = convert(index);
matlab_result=template(expression);
disp('matlab expression:');
disp(matlab_result);
disp(' ');


% calculate the equation or see if the equation is correct
if ismember(15,index) && ~ismember(16,index)
    [x]=solve(matlab_result);
    disp('x=');disp(x);
else if ismember(16,index) && ~ismember(15,index)
        [y]=solve(matlab_result);
        disp('y=');disp(y)
    else if ismember(16,index) && ismember(15,index)
        [x,y]=solve(matlab_result);
        disp('x=');disp(x);
        disp('y=');disp(y);
        else
            if eval(matlab_result)==0
                disp('wrong equation');
            else
                disp('correct equation');
            end
        end       
    end
end
end

