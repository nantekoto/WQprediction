function [MaxRelErr,AveRelErr]=ErrCal(TrueValue,PredictValue)
% calculate the error between prediction and true time series
mm = length(TrueValue);
for ii = 1:mm
    AbsErr(ii) = TrueValue(ii)-PredictValue(ii);
    RelErr(ii) = abs(AbsErr(ii)/TrueValue(ii));
    
end
MaxRelErr = max(RelErr);  % relative error
AveRelErr = sum(RelErr)/mm; % average relative error