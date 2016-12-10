clear;clc;
dbstop if error;
load Inkdata
load training 
load weak_parameter

[Inkdata] = discard(Inkdata);
data=cell2mat(Inkdata);

[f] = findallfeatures(Inkdata,data);

%% pairwise adaboost classifier
T=5;
J=47;
m=21;
H=zeros(m-1,m);
for i=1:m-1
    for k=i+1:m
        weak_hy=weak_parameter{i,k}{2};
        alpha=weak_parameter{i,k}{1};
        temp=0;
        for t=1:J*T
            j=mod(t-1,J)+1;
            h=weak(f(j),weak_hy(t,1),weak_hy(t,2));
            temp=temp+alpha(t)*h;
        end
        temp=sgn(temp);
        H(i,k)=temp;
    end
end
score=zeros(21,1);
for i=1:m-1
    for j=i+1:m
        if H(i,j)==1
            score(i)=score(i)+1;
        else
            score(j)=score(j)+1;
        end
    end
end
result=find(score==max(score));
winner=result;
tie=numel(result);
if tie>1
    for i=1:tie-1
        if H(result(i),result(i+1))==1;
            winner=result(i);
        else 
            winner=result(i+1);
        end
    end
else
    winner=result;
end
template=['1','2','3','4','5','6','7','8','9','0','+','-','*','/','x','y','^','.','(',')','='];
disp(template(winner));








