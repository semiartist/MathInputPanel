function outStr = final_tranStr(name, result);

outStr{1,1} = [name,'='];
for runner = 1:size(result,1);
    outStr{1+runner,1} = char(result(runner,1));
end

% outStr = strvcat(outStr);
    
    
    
