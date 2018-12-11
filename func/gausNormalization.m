function [train, test] = gausNormalization( Train_data, Test_data )

% xTemp1 = []; xTemp2 = [];
% for fold = 1: size(Train_data, 2)
% 
%     trainMu = mean(Train_data);
%     trainStd = std(Train_data);
%     
%     xTemp1 = (Train_data - repmat(trainMu, [size(Train_data, 2),1 ]));
%     train(fold).x = xTemp1 ./ repmat(trainStd, [size(Train_data(fold).x, 1),1] );
%     train(fold).y = Train_data(fold).y;
%     
%     xTemp2 = (Test_data(fold).x - repmat(trainMu, [size(Test_data(fold).x, 1),1] ));
%     test(fold).x = xTemp2 ./ repmat(trainStd, [size(Test_data(fold).x, 1),1] );
%     test(fold).y = Test_data(fold).y;
%     
% end
    trSize = size(Train_data,1);
    teSize = size(Test_data,1);
    trainMu = mean(Test_data,1);
    trainStd = std(Test_data,0,1);

    xTemp1 = (Train_data - repmat(trainMu, trSize ,1 ));
    clear Train_data;
    train = (xTemp1 ./ repmat(trainStd, trSize,1 ));

    xTemp2 = (Test_data - repmat(trainMu, teSize,1 ));
    test = (xTemp2 ./ repmat(trainStd, teSize,1));
%     
%     train(find(isnan(train)==1))=0;
%     test(find(isnan(test)==1))=0;

end