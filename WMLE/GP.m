function [mDInput,tau] = GP(data)
% G-P method to calculate the embedded dimension m and the correlation dimension D

% lag time tau is calculated by tau.m
% rr value needs to be given in advance

% Input: one-dimensional time series
% Output: 
% 1. The slope kk of the part closest to the straight line on the lnr-lnCr curve
% 2. lnr-ln(Cr) curve diagram at different values of m

% May 29, 2017
%---------------------------------------------
clc;
clear;
close;
tic;
%--------------------------------------------------------------------------
wqtest = data;
startTimeStep = 50;
lastTimeStep = 200;
data = wqtest(startTimeStep:lastTimeStep);

[tau] = tau(data); 
%---------------------------------------------
mm = 20;
rr = 10;
mDInput = [];
%==========================================================================
% phase space reconstruction
for m = 2:mm
    N = length(data);
    M = N-(m-1)*tau; % the number of elements in phase space
    
    for j = 1:M           
        for i = 1:m
            X(i,j) = data((i-1)*tau+j);
        end
    end
    X;
    %--------------------------------------------------------------------------
    % calculation of ln_Cr and ln_r
    ln_Cr =[];ln_r=[];
    for r=0.5:0.1:rr
        sum_H = 0;
        for i=1:M
            for j=i+1:M
                d=norm((X(:,i)-X(:,j)),inf);
                if r>=d
                    sum_H1=1;
                    sum_H= sum_H + sum_H1;
                end
                sum_H=sum_H;
            end
        end
        Cr=2*sum_H/(M*(M-1)); % correlation function C£¨r)
        lnCr=log(Cr);
        lnr=log(r);
        ln_Cr = [ln_Cr,lnCr];
        ln_r = [ln_r,lnr];
    end
    %--------------------------------------------------------------------------
    x = ln_r;
    y = ln_Cr;
    mDInput = [mDInput,x',y'];
    %--------------------------------------------------------------------------
    % plot the lnr-ln(Cr) curve at different values of m 
    if m == 1
        plot(ln_r,ln_Cr','k.-');
        hold on;
    elseif m==2
        plot(ln_r,ln_Cr','bp-');
        hold on;
    elseif m==3
        plot(ln_r,ln_Cr','mo-');
        hold on;
    elseif m==4
        plot(ln_r,ln_Cr','r+-');
        hold on;
    elseif m==5
        plot(ln_r,ln_Cr','gd-');
        hold on;
    elseif m==6
        plot(ln_r,ln_Cr','y*-');
        hold on;
    elseif m==7
        plot(ln_r,ln_Cr','ch-');
        hold on;
    elseif m==8
        plot(ln_r,ln_Cr','kp-');
        hold on;
    elseif m==9
        plot(ln_r,ln_Cr','bo-');
        hold on;
    elseif m==10
        plot(ln_r,ln_Cr','m+-');
        hold on;
    elseif m==11
        plot(ln_r,ln_Cr','rd-');
        hold on;
    elseif m==12
        plot(ln_r,ln_Cr','g*-');
        hold on;
    elseif m==16
        plot(ln_r,ln_Cr','g*-');
        hold on;
    elseif m==13
        plot(ln_r,ln_Cr','g*-');
        hold on;
    elseif m==14
        plot(ln_r,ln_Cr','g*-');
        hold on;
    elseif m==15
        plot(ln_r,ln_Cr','g*-');
        hold on;
    end
    legend('m=2','m=3','m=4','m=5','m=6','m=7','m=8','m=9')
    axis([0,2,-8,0])
    xlabel('ln(r)');
    ylabel('ln(Cr)');
    toc;
end
%--------------------------------------------------------------------------
toc;