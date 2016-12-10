% convert the handwriting expression into matlab expression
% the index is from HMM programme

index=[2,11,3,21,6];
template=['1','2','3','4','5','6','7','8','9','0','+','-','*','/','x','y','^','.','(',')','='];
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


