function result = final_getSize(inkData)

% THIS FUNCTION IS TO GET THE BOUNDRY OF THE 

inkNum = size(inkData,1);
xmin = 2; xmax = 0;
ymin = 1; ymax = 0;

for ll = 1: inkNum;
    thisxmin = min(inkData{ll,1}(:,1));
    thisxmax = max(inkData{ll,1}(:,1));
    thisymin = min(inkData{ll,1}(:,2));
    thisymax = max(inkData{ll,1}(:,2));
    xmin = min(xmin,thisxmin);
    xmax = max(xmax, thisxmax);
    ymin = min(ymin, thisymin);
    ymax = max(ymax, thisymax);
end

result = [xmin; xmax ; ymin; ymax];
