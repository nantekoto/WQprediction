clc
clear
load PredictValue_ANN
load PredictValue_ARMA
load PredictValue_LE
load PredictValue_WMLE

figure
plot(TrueValue,'*k')
hold on
plot(PredictValue_WMLE,'-k')
hold on
plot(PredictValue_LE,'--r')
hold on
plot(PredictionValue_ARMA,'-.m')
hold on
plot(PredictValue_ANN,':b')

legend({'Actual values','WMEL','LE','ARMA','ANN'},'Location','Best','FontSize',10,'Fontname','Times','Box','off')
set(gca,'XLim',[1 30],'YLim',[3 6],'xticklabel',[255,260,265,270,250,280],'fontsize',10,'fontname','times new roman');
ylabel('COD (mg/L)','FontSize',11,'Fontname','Times','FontWeight','bold')
xlabel('Time (week)','FontSize',11,'Fontname','Times','FontWeight','bold')

figure
scatter(TrueValue,PredictValue_WMLE,30,'b','d','filled','MarkerEdgeColor','k');
hold on;
scatter(TrueValue,PredictValue_LE,30,'y','^','filled','MarkerEdgeColor','k');
hold on
scatter(TrueValue,PredictionValue_ARMA,30,'r','s','filled','MarkerEdgeColor','k');
hold on
scatter(TrueValue,PredictValue_ANN,30,'g','o','filled','MarkerEdgeColor','k');
hold on
line([3,6],[3,6],'linestyle',':','linewidth',2,'color','k');
axis equal
legend({'WMEL','LE','ARMA','ANN','Standard line'},'Location','Best','FontSize',10,'Fontname','Times','Box','off')
set(gca,'XLim',[3 6],'YLim',[3 6],'fontsize',10,'fontname','times new roman');
ylabel('COD predicted (mg/L)','FontSize',11,'Fontname','Times','FontWeight','bold')
xlabel('COD observed (mg/L)','FontSize',11,'Fontname','Times','FontWeight','bold')
