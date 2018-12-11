function [datanorm, valnorm, data] = gausNorm( data )

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
    dataSize = size(data);
    
    Mu = mean(mean(data,1),2);
    Std = std(std(data,0,1),0,2);

    temp = (data - repmat(Mu, [dataSize(1) dataSize(2) 1]));
    data = (temp ./ repmat(Std, [dataSize(1) dataSize(2) 1] ));
    
    temp1 = data(1:198,:,:);
    temp2 = data(199:end,:,:);
    
    datanorm = cat(1, temp1(1:195,:,:), temp2(1:195,:,:));
    valnorm = cat(1, temp1(196:end,:,:), temp2(196:end,:,:));
%     temp = (Test_data - repmat(trainMu, testSize ));
%     test = (temp ./ repmat(trainStd, testSize ));
%     
%     temp = (Val_data - repmat(trainMu, valSize ));
%     val = (temp ./ repmat(trainStd, valSize ));
    
    clear temp Mu Std
    
    [datanorm] = concat_Data(datanorm);
    [valnorm] = concat_Data(valnorm);
%     test = concat_Data(test);
%     val = concat_Data(val);
end