function [f] = findallfeatures(Inkdata,data)
% find all features

[strokes]=numel(Inkdata);%3.1.1 symbol strokes(1)
[cusp_feature] = cusp(Inkdata);%3.1.2 cusp features(1+4)
[aspect_ratio]=(max(data(:,1))-min(data(:,1)))/(max(data(:,2))-min(data(:,2)));%3.1.3 aspect ratio(1)
[intersect_feature] = isintersect(Inkdata);%3.1.4 intersection features(1+4)
[tdhistogram] = twoDhistogram(data);%3.1.5 2-dimensional point histogram(9)
[anghistogram] = anglehistogram(Inkdata,data);%3.1.6 angle histogram(4)
[fld] = FLdistance(Inkdata);%3.1.7 first and last distance(1)
[length] = arclength(Inkdata);%3.1.8 arc length(1)
[fitline_feature] = fitline(Inkdata);%3.1.9 fit line feature(1)
[dominant_feature] = dominantpoint(Inkdata);%3.1.10 dominant point features(4)
[S] = strokearea(Inkdata);%3.1.11 stroke area(1)
[SR] = sideratio(Inkdata,data);%3.1.12 side ratios(2)
[TP] = tbratio(Inkdata,data);%3.1.13 top and bottom ratios(2)
[minmax_feature] = minandmax(Inkdata);%3.1.14 min and max features(10)
f=[strokes;cusp_feature;aspect_ratio;intersect_feature;tdhistogram;...
    anghistogram;fld;length;fitline_feature;dominant_feature;S;SR;TP;minmax_feature];

end

