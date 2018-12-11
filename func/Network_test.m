function [Abnormality,er, Feature] = Network_test( nn_result, test, opts)
% 

num_Set = size(test.Data,2); %number of sample

te_x = test.Data;
te_y = test.label;


num_Set = size(te_x,2);
for mSet = 1 : num_Set % size(Train_data,2) %50 %
    fprintf( '@@@  mSet num : %d @@@\n',mSet);
    %     trainTemp = squeeze(tr_x(:,mSet,:)); testTemp = squeeze(te_x(:,mSet,:));
    
    test_x = squeeze(te_x(:,mSet,:));
    
    test_x = test_x';
    test_y = te_y;
    
    %% SDAE train
    rand('state',0)   
    
    disp(mSet);
    nn.state = 0;
    nn_result{mSet}.state = 0;    
    [Test_er, ~, nn_test] = nntest(nn_result{mSet}, test_x, test_y);

    Feature{mSet,1} = nn_test.a{1,nn_result{mSet}.n -1}(:,2:end);
    Abnormality.result{mSet,1} = nn_test.a{1,nn_result{mSet}.n};
    Abnormality.Label = test_y;
    er(mSet) = Test_er;

    fprintf('###########Error %.2f########',er(mSet));
end
