%% Function: ANN model to predict the water quality dynamics, a COD example
%
% @author: Sijie Tang
% Contact at tangsj@mail.sustech.edu.cn
% Copyrights owned by SUSTech, China
% ---------------------------------------------------------------------------------
% Notices:
% 1. the format of the original data, here it's .m
% 2. the size the fitted data and test data
%
% Version 1.0
% Date: Jan 13 2021
%%
clc;
clear;

%% training set
load('AishanxiBridgeCOD.mat');
data = AishanxiBridgeCOD(1:280);


for k = 1:6
    InputSize = 5*k;
    
    CutOff=250; % use the former 250 values for training
    TrainSet=zeros(InputSize,CutOff-InputSize);
    for i =1:InputSize
        for j=1:CutOff-InputSize
            TrainSet(i,j)=data(i+j-1); % input, former 30 values
        end
    end
    TrainLabel = data(InputSize+1:CutOff)'; % output, subsequent 1 value
    
    %% initialize and run ANN
    setdemorandstream(3); % fix the initial random value and training result
    for m = 1:7  % to find the best choice of neuron number
        NeuNum = 2^m;
        net=newff(minmax(TrainSet),[NeuNum,1],{'logsig','purelin'},'trainlm'); % 1 hidden layer 'logsig', 1 output layer 'purelin'
        net.trainParam.show = 100;% show the result each 100 epochs
        net.trainParam.epochs = 1000;% maximum 1000 epochs
        net.trainParam.goal= 1e-4;% performance goal of 0.0001
        net.trainParam.lr=0.05; % learning rate of 0.05
        [net,tr]=train(net,TrainSet,TrainLabel);
        
        %% test set
        
        TestSet=zeros(InputSize,length(data)-CutOff);
        for i =1:InputSize
            for j=1:length(data)-CutOff
                TestSet(i,j)=data(i+j-1+CutOff-InputSize); % input
            end
        end
        TestResult=sim(net,TestSet);% output
        
        %% test performance
        TestLabel = data(CutOff+1:end)';
        
        TrueValue = TestLabel;
        PredictValue = TestResult;
        
        [MaxRelErr(m,k),AveRelErr(m,k)] = ErrCal(TrueValue,PredictValue); % cal the error
        if all(AveRelErr >= AveRelErr(m,k)) % the smallest average relative error
            PredictValue_ANN = PredictValue;
            net_ANN = net;
        end
    end
end

%% plot

% figure % error vs neuron number
% plot(MaxRelErr)
% hold on
% figure
% plot(AveRelErr,'r')
% hold on
% x=find(AveRelErr==min(min(AveRelErr)));
% scatter([x x],[AveRelErr(x) MaxRelErr(x)])
% legend('MaxRelErr','AveRelErr')
% xlabel('neuron number')
% ylabel('error (%)')

figure % test period
plot(TestLabel,'*k')
hold on
plot(PredictValue_ANN,'-b')
legend('The active values','The predictive values')
xlabel('Time ( week )')
ylabel('COD ( mg/l )')
axis([0 30 0 8]);
[x1,x2]=ErrCal(TrueValue,PredictValue_ANN);

figure % training period
trainResult=sim(net_ANN,TrainSet);
plot(TrainLabel,'-ro','linewidth',1.5)
hold on
plot(trainResult,'-*','linewidth',1.5)

save PredictValue_ANN % here inputsize = 5*2 neuralnumber = 2^3