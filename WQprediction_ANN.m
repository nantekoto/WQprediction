%% Predicion of COD time sereies with ANN
% Jan 13 2021, SUSTech

%%
clc;
clear;

%% training set
load('AishanxiBridgeCOD.mat');
p0 = AishanxiBridgeCOD;

n=length(p0);
numInputNeur=30;
numTrainDatasets=200;
p=zeros(numInputNeur,numTrainDatasets);
startTimeStep=1; 
for i =1:numInputNeur
    for j=1:numTrainDatasets
       p(i,j)=p0(i+j-1+startTimeStep-1); % input, former 30 values 
    end
end
t=p0(numInputNeur+1:numInputNeur+1+numTrainDatasets-1)'; % output, subsequent 1 value

%% initialize and run ANN
setdemorandstream(3); % fix the initial random value and training result
net=newff(minmax(p),[5,1],{'logsig','purelin'},'trainlm'); % 1 hidden layer 'logsig', 1 output layer 'purelin'
net.trainParam.show = 100;% show the result each 100 epochs
net.trainParam.epochs = 1000;% maximum 1000 epochs
net.trainParam.goal= 1e-4;% performance goal of 0.0001
net.trainParam.lr=0.05; % learning rate of 0.05
[net,tr]=train(net,p,t);

%% validation set
validStartTimeStep=221;
numValid=30;
pValid=zeros(numInputNeur,numValid);
for i =1:numInputNeur
    for j=1:numValid
       pValid(i,j)=p0(i+j-1+validStartTimeStep-1); % input
    end
end
validResult=sim(net,pValid);% output

%% validation performance
tValid=p0(validStartTimeStep+numInputNeur:validStartTimeStep+numInputNeur+numValid-1)';

TrueValue = tValid;
PredictValue = validResult;
result = [TrueValue ; PredictValue];
[AbstractErr,RelativeErr,AverageRelativErr] = wucha4(TrueValue,PredictValue); % cal the error

%% plot 
figure % validation period
plot(tValid,'*k')
hold on 
plot(validResult,'-b')
legend('The active values','The predictive values')
xlabel('Time ( week )')
ylabel('COD ( mg/l )')
axis([0 30 0 20]); 

figure % training period
trainResult=sim(net,p);
plot(t,'-ro','linewidth',1.5)
hold on 
plot(trainResult,'-*','linewidth',1.5)
AverageRelativErr
mRErr = max(RelativeErr)