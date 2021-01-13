
function [AbstractErr,RelativeErr,AverageRelativErr]=wucha4(TrueValue,PredictValue)

mm = length(TrueValue);

for ii = 1:mm
    AbstractErr(ii) = TrueValue(ii)-PredictValue(ii);
    RelativeErr(ii) = abs(AbstractErr(ii)/TrueValue(ii));
  
    end
AbstractErr = AbstractErr;
RelativeErr = RelativeErr*100;
AverageRelativErr = sum(RelativeErr)/mm;

%---------------------------------------------------------------
% plot(y1,'k*')   %��ʱ������ͼ
% hold on; 
% plot(y2,'b-') 
% 
% legend('ʵ��ֵ','Ԥ��ֵ')
% xlabel('Time ( Week )')
% ylabel('COD( mg/l )')

% TrueValue2 = TrueValue;
% PredictValue2 = PredictValue;
% AbstractErr2 = AbstractErr';
% RelativeErr2 = RelativeErr';
% AverageRelativErr = AverageRelativErr;



