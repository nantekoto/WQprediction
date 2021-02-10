function [x_1,x_2]=prebylya_new(data,m,tau,lambda_1,~,idx)
% Calculate the prediction based on the maximum Lyapunov exponent
% x_1 - 1st prediction value, x_2 - 2nd prediction value
% m £­embedded dimension, lambda_1 - maximum Lyapunov exponent,
%idx - the position of nearest point to the center point
% min_d - the distance of nearest point to the center point

N=length(data);
Y=reconstitution(data,N,m,tau);   % phase space reconstruction
[m,M]=size(Y);

d=norm(Y(:,M)-Y(:,idx));
d2 =(d*2^(lambda_1))^2;
dm2 = norm(Y(2:m,M)-Y(2:m,idx));
deta=sqrt(d2-dm2);
if (isreal(deta)==0) || (deta>Y(m,M)*0.001)
    deta=Y(m,M)*0.001;
end
x_1 = Y(m,idx) + deta;
x_2 = Y(m,idx) - deta;
