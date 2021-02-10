function [idx,min_d,idx1,min_d1]=nearest_point(tau,m,whlsj,whlsl,P)
% Calculate the position and shortest distance of the closest phase point to the last phase point
% input:m - embedded dimension, whlsj гн data, whlsl - length of data
% p - average period, idx - the position of nearest phase point to the last phase point
% min_d1 - the distance of nearest phase point to the last phase point (regardless of phase angle)

min_point=5;
MAX_CISHU=5;


% phase space reconstruction
LAST_POINT = whlsl-(m-1)*tau;  % number of phase points
for j=1:LAST_POINT
    for k=1:m
        Y(k,j)=whlsj((k-1)*tau+j);
    end
end

% max, min, and average phase point distance
max_d = 0.;
min_d = 1.0e+100;
avg_d = 0.;
for i = 1 : LAST_POINT-1
    avg_dd = 0.;
    for j = i+1 : LAST_POINT
        d = 0.;
        for k = 1 : m
            d = d + (Y(k,i)-Y(k,j))*(Y(k,i)-Y(k,j));
        end
        d = sqrt(d);
        if max_d < d
            max_d = d;
        end
        if min_d > d
            min_d = d;
        end
        avg_dd = avg_dd + d;
    end
    avg_dd = avg_dd/(LAST_POINT-i-1+1);
    avg_d = avg_d + avg_dd;
end
avg_d = avg_d/(LAST_POINT-1);

dlt_eps = (avg_d - min_d) * 0.08 ;
min_eps = min_d + dlt_eps / 8 ;
max_eps = min_d + 2 * dlt_eps  ;

DK = 1.0e+100;
Loc_DK = LAST_POINT-P;
for i = 1 : LAST_POINT-P
    d = 0.;
    for k = 1 : m
        d = d + (Y(k,i)-Y(k,LAST_POINT-1))*(Y(k,i)-Y(k,LAST_POINT-1));
    end
    d = sqrt(d);
    
    if (d < DK) & (d > min_eps)
        DK = d;
        Loc_DK = i;
    end
end

DK1 = 0.;
for k = 1 : m
    DK1 = DK1 + (Y(k,LAST_POINT)-Y(k,Loc_DK+1))*(Y(k,LAST_POINT)-Y(k,Loc_DK+1));
end
DK1 = sqrt(DK1);

old_Loc_DK=Loc_DK;

% The following program calculates the closest distance point of the last phase point (considering the phase angle):
% the distance is required to be as short as possible within the specified distance range, and the angle to DK1 is the smallest

max_eps = min_d + 2 * dlt_eps ;            % The maximum distance between the evolution phase point and the current phase point

point_num = 0  ;
cos_sita = 0.  ;
zjfwcs=0       ;

while (point_num == 0)
    % search phase points
    for j = 1 : LAST_POINT-1
        if abs(j-LAST_POINT) <=( P-1)      % candidate is too close to the current point
            continue;
        end
        
        % the distance of candidate and current point
        dnew = 0.;
        for k = 1 : m
            dnew = dnew + (Y(k,LAST_POINT)-Y(k,j))*(Y(k,LAST_POINT)-Y(k,j));
        end
        dnew = sqrt(dnew);
        
        if (dnew < min_eps)||( dnew > max_eps )   % out of range
            continue;
        end
        
        % Calculate and compare the angle's cosine
        DOT = 0.;
        for k = 1 : m
            DOT = DOT+(Y(k,LAST_POINT)-Y(k,j))*(Y(k,LAST_POINT)-Y(k,old_Loc_DK+1));
        end
        CTH = DOT/(dnew*DK1);
        
        if acos(CTH) > (3.14151926/4)      % angel >= 45
            continue;
        end
        
        if CTH > cos_sita   % reserve new smaller angel
            cos_sita = CTH;
            Loc_DK = j;
            DK = dnew;
        end
        point_num = point_num +1;
    end
    
    if point_num < min_point
        point_num = 0          ;     % re-search in larger range
        cos_sita = 0.;
        max_eps = max_eps + dlt_eps;
        zjfwcs =zjfwcs +1;
        if zjfwcs > MAX_CISHU
            DK = 1.0e+100;
            for ii = 1 : LAST_POINT-1
                if abs(LAST_POINT-ii) <= P-1      % candidate is too close to the current point
                    continue;
                end
                d = 0.;
                for k = 1 : m
                    d = d + (Y(k,LAST_POINT)-Y(k,ii))*(Y(k,LAST_POINT)-Y(k,ii));
                end
                d = sqrt(d);
                
                if (d < DK) & (d > min_eps)
                    DK = d;
                    Loc_DK = ii;
                end
            end
            break
        end
    end
end
idx=Loc_DK;  % he position of nearest point to the center point
min_d=DK;    % the distance of nearest point to the center point
point_num;

% calculate the closest distance point of the last phase point (phase angle is not considered)

min_d1 = 1e+100;
idx1 = LAST_POINT-1;

for jj = 1:LAST_POINT-1
    
    if abs(jj-LAST_POINT) <=( P-1)      % candidate is too close to the current point
        continue;
    end
    
    sum_d=0.;
    for k=1:m
        sum_d = sum_d+(Y(k,jj)-Y(k,LAST_POINT))^2;
    end
    sum_d = sqrt(sum_d);
    
    if (min_d1 > sum_d)&(sum_d > 0)
        min_d1 = sum_d;
        idx1 = jj;
    end
end