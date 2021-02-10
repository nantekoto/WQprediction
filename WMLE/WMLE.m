%%
% Function:
% WMLE model to predict the water quality dynamics, a COD example
%
% @author: Sijie Tang
% Contact at tangsj@mail.sustech.edu.cn
% Copyrights owned by SUSTech, China
% ---------------------------------------------------------------------------------
% Notices:
% 1. we do not run the pre-calculation function, but take the results
% 2. the size the fitted data and test data
%
% Version 1.0 @ MATLAB R2014a (8.3.0.532)
% Date: Feb 5, 2021
%%
clc;
clear;

load('AishanxiBridgeCOD.mat')
wqtest2 = AishanxiBridgeCOD;

[DeNoiseAishanxiCOD,cxd,lxd]= wden(AishanxiBridgeCOD,'sqtwolog','s','one',2,'db5'); %wavelet denoise
wqtest = DeNoiseAishanxiCOD;

%%
m = 11;  % embedded dimension
tau = 3; % time lag

PredictChaos = [ ];
PredictStep = 30;
P = 1;
for ii = 1:PredictStep
    startTime = ii+0;
    numTimeStep = 250;
    lastTimeStep = startTime + numTimeStep;
    data = wqtest(startTime:lastTimeStep);
    N = length(data);  % lenth of time series
    
    lambda_1 = largest_lyapunov_exponent(data,N,m,tau,P);
    whlsj = data;
    whlsl = N;
    idx = nearest_point(tau,m,whlsj,whlsl,P);
    
    [x_1,x_2] = prebylya_new(data,m,tau,lambda_1,P,idx);
    wqtest(lastTimeStep+1);
    PredictChaos = [PredictChaos,x_1];
end
%%
TrueValue = wqtest2(lastTimeStep-PredictStep+1:lastTimeStep);
PredictValue_WMLE = PredictChaos';

result = [TrueValue' ; PredictValue_WMLE'];
[MaxRelErr,AveRelErr] = ErrCal(TrueValue,PredictValue_WMLE)
save PredictValue_WMLE