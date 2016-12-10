clear
clc
load training
tic
for q=1:20
    for p=q+1:21
T=10;
J=47;
m=10;
D=zeros(m,1);
D(:,1)=1/m;
x1=training{q}(:,2);
x2=training{p}(:,2);
x=[x1;x2];% feature vector
y=ones(m,1);
y(6:m)=-1;% label
h=zeros(m,T*J);
alpha=zeros(T*J,1);
weak_hy=zeros(T*J,2);% weak hypothesis
for t=1:T*J
    j=mod(t-1,J)+1;
    mu1=0;mu2=0;
    for k=1:5
        mu1=mu1+x{k}(j)*D(k);
    end
    for k=6:10
        mu2=mu2+x{k}(j)*D(k);
    end
    mu1=mu1/sum(D(1:5));
    mu2=mu2/sum(D(6:10));
    weak_hy(t,:)=[mu1,mu2];
    temph=zeros(m,1);
    for k=1:10
        tempx=x{k}(j);
        temph(k)=weak(tempx,mu1,mu2);
    end
    sequence=find(y~=temph);
    error=numel(sequence)/m;
    if error>0.5
        weak_hy(t,:)=-weak_hy(t,:);
        sequence=find(y==temph);
    end
    et=sum(D(sequence));
    if et<0.01
        et=0.01;
    else if abs(1-et)<0.01
            et=0.99;
        end
    end
    alpha(t)=0.5*log((1-et)/et);
    ht=zeros(m,1);
    D=D.*exp(-alpha(t)*y.*temph);
    D=real(D);
    D=D/sum(D);
end
weak_parameter{q,p}={alpha,weak_hy};
disp([q,p]);
    end
end
toc
% sound(sin(2*pi*25*(1:8000)/100));





