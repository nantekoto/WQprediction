"""
Function:
Steps of ARMA model to predict the water quality dynamics, a DO example
Stationarity test (trend & ADF test) --> order determination (AFC/PAFC & AIC/BIC) --> modelling and moving prediction

@author: Sijie Tang
Contact at tangsj@mail.sustech.edu.cn
Copyrights owned by SUSTech,China
---------------------------------------------------------------------------------
Notices:
1. the format of the original data, here it's .m
2. the size the fitted data and test data

Version 1.0
Date: Jan 26, 2021
"""

import scipy.io as scio
import matplotlib.pyplot as plt
import statsmodels.api as sm
import pandas as pd
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from sklearn.metrics import mean_squared_error
import warnings

warnings.filterwarnings("ignore")

dataFile = 'AishanxiBridgeCOD.mat'
data = pd.Series(scio.loadmat(dataFile)["AishanxiBridgeCOD"].T[0])
data = data[0:280]


# moving average and moving average variance
def draw_trend(timeseries, size):
    # size: moving window size
    f = plt.figure(facecolor='white')
    rol_mean = timeseries.rolling(window=size).mean()
    rol_std = timeseries.rolling(window=size).std()
    timeseries.plot(color='blue', label='Original')
    rol_mean.plot(color='red', label='Rolling Mean')
    rol_std.plot(color='black', label='Rolling standard deviation')
    plt.legend(loc='best')
    plt.title('Rolling Mean & Standard Deviation')
    plt.show()


# Augmented Dickey-Fuller test for Stationarity:
def teststationarity(timeseries):
    dftest = sm.tsa.stattools.adfuller(timeseries)
    # describe the dftest
    dfoutput = pd.Series(dftest[0:4], index=['Test Statistic', 'p-value', '#Lags Used', 'Number of Observations Used'])
    for key, value in dftest[4].items():
        dfoutput['Critical Value (%s)' % key] = value
    return dfoutput

# to calculate the autocorrection and partial autocorrection
def draw_acf_pacf(timeseries, lags):
    f = plt.figure(facecolor='white')
    ax1 = f.add_subplot(211)
    plot_acf(timeseries, ax=ax1, lags=lags)
    ax2 = f.add_subplot(212)
    plot_pacf(timeseries, ax=ax2, lags=lags)
    plt.subplots_adjust(hspace=0.5)
    plt.show()

# error calculation
def error_cal(TrueValue, PredValue):  # calculate the relative error
    RelativeErr = list()
    for i in range(len(TrueValue)):
        Err = abs((TrueValue[i] - PredValue[i]) / TrueValue[i])
        RelativeErr.append(Err)
    return sum(RelativeErr) / len(RelativeErr), max(RelativeErr)


draw_trend(data, 12)
print(teststationarity(data))
draw_acf_pacf(data, 30)

# Calculate the order of ARMA model based on AIC & BIC
# AIC_order = sm.tsa.arma_order_select_ic(data,max_ar=5,max_ma=5,ic='aic')['aic_min_order']
BIC_order = sm.tsa.arma_order_select_ic(data, max_ar=5, max_ma=5, ic='bic')['bic_min_order']

order = BIC_order
cutoff = 250
train = data.values[:cutoff]
history = [x for x in train]  # array to list
test = data.values[cutoff:]
predictions = list()
for t in range(len(test)):  # moving prediction
    tempModel = sm.tsa.ARMA(history, order)
    model_fit = tempModel.fit(disp=0)
    output = model_fit.forecast()
    yhat = output[0]
    predictions.append(yhat)
    obs = test[t]
    history.append(obs)
    print('predicted=%f, expected=%f' % (yhat, obs))
MSE = mean_squared_error(test, predictions)
print('Test MSE: %.3f' % MSE)
plt.figure()
plt.plot(test)
plt.plot(predictions, color='red')
plt.show()
error = error_cal(test, predictions)
print('Average relative error: %.4f' % error[0][0])
print('Maximum relative error: %.4f' % error[1][0])

scio.savemat('..\PredictValue_ARMA.mat', {'PredictValue_ARMA':predictions})