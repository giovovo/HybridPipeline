clear all, close all, clc


inputFeaturesNumber=19;
load([pwd,filesep, '..',filesep,'tempFolder',filesep,'testAccuracyEegBigMatrix' num2str(inputFeaturesNumber)])


%plot ([1 2;10,20])

xAxis = [5 10 15 20 25 30 38];

for i = 1 : inputFeaturesNumber
    figure
    hold on

    plot(xAxis,testAccuracyEegBigMatrix(i,xAxis,1)','k')
    plot(xAxis,testAccuracyEegBigMatrix(i,xAxis,2)','r')
    plot(xAxis,testAccuracyEegBigMatrix(i,xAxis,3)','g')
end

figure
plot(xAxis,mean(testAccuracyEegBigMatrix(1:inputFeaturesNumber,xAxis,1),1),'k')
hold on
plot(xAxis,mean(testAccuracyEegBigMatrix(1:inputFeaturesNumber,xAxis,2),1),'r')
plot(xAxis,mean(testAccuracyEegBigMatrix(1:inputFeaturesNumber,xAxis,3),1),'x')
legend('pengLab','CLISlabAlessandro','CLISLabAndres')
title(['Mean Test accuraccy for inputEegFeatures from 1 to ' num2str(inputFeaturesNumber) ])
xlabel(['Number of output features: 5 10 15 20 25 30 38'])
ylabel('Test accuracy')
