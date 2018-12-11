function [res,sae,nn_result] = DSAE ( train, test, val, opts)


num_Set = size(train.Data,2); %number of sample

tr_x = train.Data;
tr_y = train.label;

te_x = test.Data;
te_y = test.label;

vali_x = val.Data;
val_y = val.label;


% 
in_Dimen = size(te_x,1);
hi_D1 = ceil(in_Dimen*1.5);
hi_D2 = ceil(in_Dimen*0.3);
num_Set = size(te_x,2);

opts.sae_Layer = [ in_Dimen hi_D1 hi_D2 ];
opts.NN_layer   = [ in_Dimen hi_D1 hi_D2 2];

for mSet = 1 : num_Set % size(Train_data,2) %50 %
    fprintf( '@@@  mSet num : %d @@@\n',mSet);
    %     trainTemp = squeeze(tr_x(:,mSet,:)); testTemp = squeeze(te_x(:,mSet,:));
    
    train_x = squeeze(tr_x(:,mSet,:)); test_x = squeeze(te_x(:,mSet,:)); val_x = squeeze(vali_x(:,mSet,:));
    
%     train_x = squeeze(tr_x(:,:)); test_x = squeeze(te_x(:,:)); val_x = squeeze(vali_x(:,:));
    
    %     [train_x, test_x] = gausNormalization( trainTemp, testTemp);      %normalize
    
    train_x = train_x';
    train_y = tr_y;
    
    test_x = test_x';
    test_y = te_y;
    
    val_x = val_x';
    val_y = val_y;
    
clear train test val;
    %% SDAE train
    rand('state',0)
    sae = saesetup(opts.sae_Layer);   % Layer setting 
   
    for sae_l = 1 : size(sae.ae,2)
        sae.ae{sae_l}.state                     = 0;
        sae.ae{sae_l}.activation_function       = 'tanh_opt'; %'sigm';  %'tanh_opt';
        sae.ae{sae_l}.learningRate              = opts.ae_learningRate;
        sae.ae{sae_l}.inputZeroMaskedFraction   = 0.5; %changed gaussian mask
        sae.ae{sae_l}.numepochs  =   opts.sae_numepochs;
        sae.ae{sae_l}.batchsize = opts.sae_batchsize;
        sae.ae{sae_l}.validation = 0;
       sae.ae{sae_l}.plot= opts.sae_plot;
       sae.ae{sae_l}.inputZeroMaskedFraction = opts.inputZeroMaskedFraction;
       sae.ae{sae_l}.nn_state =0;
%        sae.ae{sae_l}.output = 'linear';
        %sae.ae{sae_l}.inputSaltNPepper   = 1; %0.5;       % salt & pepper noise
    end
    % == opts of sae ==
    sae.plot =1;
    % unsupervised learning
    sae = saetrain(sae, train_x, opts);
    
    %% Set up for FFNN about Output of SDAE
    % Use the SDAE to initialize a FFNN
    
    % == Neural Networks Setting == %
    % nn = nnsetup([100 200 100 50 2]);  % input, output, 100 hidden unit, 2 class label
    nn = nnsetup(opts.NN_layer );
    nn.activation_function   = 'tanh_opt'; %'tanh_opt'; %'sigm';  %'tanh_opt';
    nn.learningRate          = opts.nn_learningRate ;
    nn.momentum              = 0.9;          %  Momentum
    nn.weightPenaltyL2       = 0.0001;       %  L2 regularization
    nn.dropoutFraction       = 0.5;          % 0 Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf)
%     nn.scaling_learningRate  = 0.99;         % 1 Scaling factor for the learning rate (each epoch)
    % nn.nonSparsityPenalty  = 0.001;        %  Non sparsity penalty
    % nn.neg_slope           = 0;
    nn.output                = 'softmax';
    nn.state                 = 0;
    nn.validation            = opts.nn_plot;
    %     nn.ROI_num               = ex;

    % === option setting === %
    nn.plot         = opts.nn_plot ;
    nn.validation   = opts.nn_validation ;
    nn.numepochs    = opts.nn_numepochs ;
    nn.batchsize    = opts.nn_batchsize ;
    
    % model init value
    % nn.W{1} = sae.ae{1}.W{1};
    % nn.W{2} = sae.ae{2}.W{1};
    for sae_l = 1 : size(sae.ae,2)
        nn.W{sae_l} = sae.ae{sae_l}.W{1};
    end
    
    %         %% mk validation set
    %         [train_x, train_y, val_x, val_y] = mk_valind(train_x, train_y,ex,ROI_num);
    %% Train the FFNN
    
    %result = nntrain(nn, train_x, train_y, opts, val_x, val_y);
    nn.state = 1;
    nn_result = nntrain(nn, train_x, train_y, opts, val_x, val_y);
    
    nn.state = 0;
    nn_result.state = 0;    
    [er, ~, nn_test] = nntest(nn_result, test_x, test_y);
    nn_result.train_label = train_y;  % .train_y to changed .train_label
    
     [val_er, ~, nn_val] = nntest(nn_result, val_x, val_y);
    res.val{mSet} = nn_val.a{1,nn_result.n};
    res.val_er{mSet} = val_er;
    % == results save == %
    disp(mSet);
    res.train{mSet} = nn_result.actv_train{nn.numepochs,1};
    res.test{mSet}  = nn_test.a{1,nn_result.n};
    res.trainLabel = train_y;
    res.testLabel = test_y;
    res.er{mSet} = er;
    res.result{mSet} = nn_result;
%     opts.nn_plot         = 0;
    fprintf('###########Error %.2f########',res.er{mSet});
% end
end


% %         fprintf('\n%d start\n',ROI_num);
    %     opts.shaffle_train = length(normTrain) / 10; %
    %     opts.shaffle_val = length(normVal) / 10;     %
    
