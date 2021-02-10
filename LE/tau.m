function [tau] = tau(data)
% Autocorrelation approach for calculating the time lag(tau) of chaotic time series
% input£ºdata       chaotic time series
% output£ºtau¡¡¡¡   time lag
% datetime£ºMay 29, 2017
%---------------------------------------
clc;
close;
clear;
tic;
%--------------------------------------------------------------------------
wqtest = data;
startTimeStep = 1;
lastTimeStep = 250;
data = wqtest(startTimeStep:lastTimeStep);
%--------------------------------------------------------------------------
% Autocorrelation function
[ACF,~] = autocorr(data,length(data)-1);  
ACF = ACF(2:end);        % remove tau=0
% take the time lag when autocorrelation decrease to 1-1/e of initial value
gate = (1-exp(-1))*ACF(1);
temp = find(ACF<=gate);
if (isempty(temp))
    disp('err: max delay time is too small!')
    tau = [];
else
    tau = temp(1);
end
% plot----------------------------------------------------------------------
figure;
plot(1:length(ACF),ACF)
xlabel('Time (week)');
ylabel('Autocorrelation coeficient');
%--------------------------------------------------------------------------
toc;
end