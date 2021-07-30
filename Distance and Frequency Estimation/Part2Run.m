%% Project Part2 Run 
clear;
clc;
close all;
trials = 100;
S = zeros(1,trials);
D = zeros(1,trials);

for i = 1:trials
    [S(i),D(i)] = Estimation();
    i
end

mode_s = mode(round(S,2))
mode_d = mode(round(D,2))