function mD
% show the variation of the correlation dimension D with the embedded dimension m
% Input: mDInput, result of GP.m
% Output: values of correlation dimension D, corresponding to m=2,3,4,бнбн
% May 29, 2017
%---------------------------------------------
clc;
clear;
close;
tic;
%--------------------------------------------------------------------------
load('mDInput.mat');
kk = mDInput;
[~,mm] = size(kk);
%---------------------------------------
kk = kk(32:90,:);
%---------------------------------------
D=[];
for i = 1:2:(mm-1)
    x=kk(:,i);
    y=kk(:,(i+1));
    kb = polyfit(x,y,1);  % the slope and intercept, fitted by the least square method
    k=kb(1);
    D=[D,k];
end
D
%--------------------------------------------------------
% plot the variation curve of correlation dimension D with embedded dimension m
x1 = 1:(mm/2);
plot(x1+1,D,'k*-')
hold on;
%--------------------------------------------------------
% draw the fitted straight line of the m-D curve graph
m =3;
x2 = 1:m;
DD = D(1:m);
kb = polyfit(x2,DD,1);
k = kb(1);
b = kb(2);
DD = k*x1+b;
plot(x1+1,DD,'ro-')
xlabel('The embedding dimension m');
ylabel('The correlation coefficient D');
legend('The actual calculated value','The fitting straight line')
hold on;