function lambda_1=largest_lyapunov_exponent(data,N,m,tau,P)
%the function is used to calcultate largest lyapunov exponent with the
%mended algorithm,which put forward by lv jing hu.
%data:the time series
%N:the length of data
%m:enbedding dimention
%tau:time delay
%P:the mean period of the time series,calculated with FFT
%lambda_1:return the largest lyapunov exponent

delt_t=1;
Y=reconstitution(data,N,m,tau );%reconstitute state space
M=N-(m-1)*tau;%M is the number of embedded points in m-dimensional space
for j=1:M
    d_max=1e+100;
    for jj=1:M                                              
        d_s=0;                                             
        if abs(j-jj)>P                                      
            for i=1:m
                d_s=d_s+(Y(i,j)-Y(i,jj))*(Y(i,j)-Y(i,jj));
                d_min=d_max;
                if d_s<d_min
                    d_min=d_s;
                    idx_j=jj;
                end
            end
        end
    end
    max_i=min((M-j),(M-idx_j));
    for k=1:max_i              
        d_j_i=0;
        for kk=1:m
            d_j_i=d_j_i+(Y(kk,j+k)-Y(kk,idx_j+k))*(Y(kk,j+k)-Y(kk,idx_j+k));
            d(k,j)=d_j_i;
        end
    end
end

[l_i,l_j]=size(d);
for i=1:l_i
    q=0;
    y_s=0;
    for j=1:l_j
        if d(i,j)~=0
            q=q+1;
            y_s=y_s+log(d(i,j));
        end
    end
    y(i)=y_s/(q*delt_t);
end
x=1:length(y);
pp=polyfit(x,y,1);
lambda_1=pp(1);
yp=polyval(pp,x);
plot(x,y,'-o',x,yp,'--')