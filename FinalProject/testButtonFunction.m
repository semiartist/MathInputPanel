

dbstop if error
clear all ; close all; clc;
load('Inkdata2.mat');
allPoints = Inkdata;
for runner = 1:size(allPoints,1)
    plot(allPoints{runner}(:,1),allPoints{runner}(:,2),'b.');
    hold on; axis equal;
end;

inkData = Inkdata;
str = [];
result = final_main(inkData);
for runner =1: size(result,2);
    str = [str,' ',result{1,runner}];
end