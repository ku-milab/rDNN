clear;
close;
addpath(genpath('.'));
addpath(genpath('/home/eh/Desktop/Data/ADNI/'));   %% Data path

%% initialize
% ADNI data path
Data_Path = '/home/eh/Desktop/Data/ADNI/';
Data_type1 = 'AD';
Data_type2 = 'NC';

% ex = sprintf('ex1_%s_%s',Data_type1, Data_type2);
ex = sprintf('ex170913_%s_%sData_AD_NC',Data_type1, Data_type2);
result_Path = sprintf('./Save_result/%s',ex);

DataClass = { Data_type1, Data_type2 };
threshold = 0.05;
opts.nfold = 10;
load ROI_info.mat;

%% save Path setting
% feature save path
if (exist(sprintf('./%s_Data_%s_%s/%s_F',ex,Data_type1,Data_type2,Data_type1)) + exist(sprintf('./%s_Data_%s_%s/%s_F',ex,Data_type1,Data_type2,Data_type2))) == 0
    for fold = 1 : 10
        mkdir(sprintf('./%s_Data_%s_%s/%s_F/fold_%d',ex,Data_type1,Data_type2,Data_type1,fold));
        mkdir(sprintf('./%s_Data_%s_%s/%s_F/fold_%d',ex,Data_type1,Data_type2,Data_type2,fold));
    end
else
    disp('Already exsits File Folder');
end
%result save path
if exist(result_Path,'dir')==0
    disp('not exist result_path');
    mkdir(result_Path);
    for i = 1 : 10        % opts.nfold
        mkdir(sprintf('Save_result/%s/fold%d',ex,i));
        mkdir(sprintf('Save_result/%s/Network/fold%d',ex,i));
    end
else
    disp('Exist result_path');
end
%% Data file name
Data_type = 1;
[Type1_file_name,num_type1] = Read_file_name (Data_Path,Data_type,Data_type1); % AD
[Type2_file_name,num_type2] = Read_file_name (Data_Path,Data_type,Data_type2); % NC


%% Template index
if ~exist('./Template_ROI_idx.mat')
    template_name = sprintf('%s/template/jakob-label-axialdown-256_256_256',Data_Path);
    Template_ROI_idx = Load_Tmplate_idx(template_name, ROI_info);
    Template_ROI_idx(:,2) = num2cell(ROI_info);
    
    save('Template_ROI_idx.mat','Template_ROI_idx')
else
    load('./Template_ROI_idx.mat');
end

% cross validation index
if exist('./Save_result/crossValidation_idx.mat','file') == 0
    AD_fold = crossvalind('Kfold', num_type1, opts.nfold); 
    NC_fold = crossvalind('Kfold', num_type2, opts.nfold);
    
    for fold = 1 : 10
    AD_te_fold{fold,1} = (AD_fold == fold);
    tmpfold = AD_fold((AD_fold~=fold));
    AD_val_fold{fold,1} = (AD_fold == tmpfold(1,1));
    AD_tr_fold{fold,1} = ( (AD_fold~=tmpfold(1,1)) & (AD_fold~=fold));
    
    NC_te_fold{fold,1} = (NC_fold == fold);
    tmpfold = NC_fold((NC_fold~=fold));
    NC_val_fold{fold,1} = (NC_fold == tmpfold(1,1));
    NC_tr_fold{fold,1} = ( (NC_fold~=tmpfold(1,1)) & (NC_fold~=fold));    
    
    save(sprintf('./Save_result/%s/crossValidation_idx.mat',ex), 'AD_fold', 'NC_fold','AD_te_fold','AD_val_fold','AD_tr_fold','NC_te_fold','NC_val_fold','NC_tr_fold' )
    end
    %% make shuffle index
    for fold = 1 : opts.nfold
        tef_size = (sum(AD_te_fold{fold})+sum(NC_te_fold{fold}));
        trf_size = (sum(AD_tr_fold{fold})+sum(NC_tr_fold{fold}));
        val_size = (sum(AD_val_fold{fold})+sum(NC_val_fold{fold}));
        
        test_ran{fold} = randperm(tef_size);  % shuffle
        train_ran{fold} = randperm(trf_size); % shuffle
        val_ran{fold} = randperm(val_size);   % shuffle
    end
        save(sprintf('./Save_result/%s/Shuffle_idx.mat',ex),'train_ran','test_ran','val_ran');
else
    disp('Exsit CrossValidation index');
    load(sprintf('./Save_result/%s/crossValidation_idx.mat',ex));
    load(sprintf('./Save_result/%s/Shuffle_idx.mat',ex));
end
    
%% ttest
if ~exist(sprintf('./Save_result/%s/TreshIdx%.2f.mat',ex,threshold),'file')
    [p_value,Thresh_idx] = stat_map2(Data_Path,DataClass,Template_ROI_idx, ROI_info, AD_tr_fold, NC_tr_fold, threshold);
    save(sprintf('./Save_result/%s/TreshIdx%.2f.mat',ex,threshold),'Thresh_idx','p_value');
else
    load( sprintf('./Save_result/%s/TreshIdx%.2f.mat',ex,threshold));
end

%% Sampling
load ./Template/ROI_info.mat;
if ~exist(sprintf('./%s_Data_AD_NC/NC_F/NC_voxSet_ROI69.mat',ex),'file')
    disp('%%%%% Not exist features %%%%%');
    load(sprintf('./Save_result/%s/TreshIdx%.2f.mat',ex,threshold));
    for fold = 1 : opts.nfold
        AD_voxel_ROI = [];
        NC_voxel_ROI = [];        
        Sample_idx{fold} = RandomVoxelSampling(Thresh_idx{fold});
        disp('AD');
        for roi =1 : size(ROI_info,1)
            fprintf('%d',ROI_info(roi,1));
            
            for sub = 1 : num_type1
                load(sprintf('%sRavens_density_AD/%s',Data_Path,Type1_file_name{sub}));
                AD_voxel_ROI(:,:,sub) = RavensMap_AD(Sample_idx{fold}{roi,1});                   % Each ROI
            end
            save(sprintf('./%s_Data_AD_NC/AD_F/fold_%d/AD_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'AD_voxel_ROI');
            
            clear AD_voxel_ROI RavensMap_AD;
        end
        disp('NC');
        for roi =1 : size(ROI_info,1)
            fprintf('%d',ROI_info(roi,1));
            for sub = 1 : num_type2
                load(sprintf('%sRavens_density_NC/%s',Data_Path,Type2_file_name{sub}));
                NC_voxel_ROI(:,:,sub) = RavensMap_NORMAL(Sample_idx{fold}{roi,1});                   % Each ROI
            end
            save(sprintf('./%s_Data_AD_NC/NC_F/fold_%d/NC_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'NC_voxel_ROI');
            clear NC_voxel_ROI RavensMap_NORMAL;
        end
    end
    save(sprintf('./Save_result/%s/Sample_idx.mat',ex),'Sample_idx');
else 
    disp('%%%%% Exist feature %%%%%');
    disp('exist AD_voxSet*.mat');
end

clear ROI_info AD_file_name NC_file_name RavensMap_AD RavensMap_NC;

%% 3. Network initializing
opts = init_para();
% load(sprintf('./Save_result/%s/Shuffle_idx.mat',ex));
% load(sprintf('./Save_result/%s/crossValidation_idx',ex));
% load(sprintf('./Save_result/%s/Sample_idx.mat',ex),'Sample_idx');

AD_label = [1,0];
NC_label = [0,1];

% ex = 
load ROI_info.mat
%% network Training
for fold = 6:10
    for roi = 1 : size(ROI_info,1)
        fprintf('\n ROI %d',ROI_info(roi,1));
        opts = init_para();
% %         load(sprintf('ex170727_NC_AD/ROI_featureV%d.mat',Thresh_idx{roi,2}));
        load(sprintf('./%s_Data_AD_NC/AD_F/fold_%d/AD_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'AD_voxel_ROI');
        load(sprintf('./%s_Data_AD_NC/NC_F/fold_%d/NC_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'NC_voxel_ROI');
        
        train = [];
        test = [];
        Labels = [];
        val = [];
        
        trD = cat(3,AD_voxel_ROI(:,:,AD_tr_fold{fold}),NC_voxel_ROI(:,:,NC_tr_fold{fold}));
        teD = cat(3,AD_voxel_ROI(:,:,AD_te_fold{fold}),NC_voxel_ROI(:,:,NC_te_fold{fold}));
        valD = cat(3,AD_voxel_ROI(:,:,AD_val_fold{fold}),NC_voxel_ROI(:,:,NC_val_fold{fold}));
        
        trlabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_tr_fold{fold}),3),1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_tr_fold{fold}),3),1 ) ) ;
        telabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_te_fold{fold}),3) ,1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_te_fold{fold}),3),1 ) );
        vallabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_val_fold{fold}),3) ,1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_val_fold{fold}),3),1 ) );

        val.Data = valD(:,:,val_ran{fold});
        val.label = vallabel(val_ran{fold},:);
        
        test.Data = teD(:,:,test_ran{fold});
        test.label = telabel(test_ran{fold},:);
        
        train.Data = trD(:,:,train_ran{fold});
        train.label = trlabel(train_ran{fold},:);
        
        %% normalization
        [train.Data, trMu, trStd] = Normalization(train.Data);
        [test.Data] = Normalization(test.Data, trMu, trStd);
        [val.Data] = Normalization(val.Data, trMu, trStd);
        clear trMu trStd;
        
        %% training
        [res,sae,nn_result] = DSAE(train, test, val, opts);
        save(sprintf('Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_info(roi,1)),'res');
%         save(sprintf('Save_network/sae/sae%d.mat',Thresh_idx{roi,2}),'sae');
        save(sprintf('Save_result/%s/Network/fold%d/nn%d.mat',ex,fold,ROI_info(roi,1)),'nn_result');
        
        clear res sae nn_result;
    end
end

Data_type = 1;
[Type1_file_name,num_type1] = Read_file_name (Data_Path,Data_type,Data_type1); % AD
[Type2_file_name,num_type2] = Read_file_name (Data_Path,Data_type,Data_type2); % NC
AD_label = [1,0];
NC_label = [0,1];

%% Network test  #############################################
for fold = 1 : 10
    T_Performance = [];
   for roi = 1 : size(ROI_info,1)
      load(sprintf('./Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_info(roi,1)));

        fprintf('\n ROI %d',ROI_info(roi,1));
        opts = init_para();
% %         load(sprintf('ex170727_NC_AD/ROI_featureV%d.mat',Thresh_idx{roi,2}));
        load(sprintf('./%s_Data_AD_NC/AD_F/fold_%d/AD_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'AD_voxel_ROI');
        load(sprintf('./%s_Data_AD_NC/NC_F/fold_%d/NC_voxSet_ROI%d',ex,fold,ROI_info(roi,1)),'NC_voxel_ROI');
        
        train = [];
        test = [];
        Labels = [];
        val = [];
        
        trD = cat(3,AD_voxel_ROI(:,:,AD_tr_fold{fold}),NC_voxel_ROI(:,:,NC_tr_fold{fold}));
        teD = cat(3,AD_voxel_ROI(:,:,AD_te_fold{fold}),NC_voxel_ROI(:,:,NC_te_fold{fold}));
        valD = cat(3,AD_voxel_ROI(:,:,AD_val_fold{fold}),NC_voxel_ROI(:,:,NC_val_fold{fold}));
%         AADteName{:} = Type1_file_name(AD_te_fold{fold});
%         AANCteName{:} = Type2_file_name(NC_te_fold{fold});
        
        trlabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_tr_fold{fold}),3),1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_tr_fold{fold}),3),1 ) ) ;
        telabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_te_fold{fold}),3) ,1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_te_fold{fold}),3),1 ) );
        vallabel = cat(1,repmat(AD_label, size(AD_voxel_ROI(:,:,AD_val_fold{fold}),3) ,1 ),repmat(NC_label, size(NC_voxel_ROI(:,:,NC_val_fold{fold}),3),1 ) );

        val.Data = valD;
        val.label = vallabel;
        
        
        test.Data = teD;
        test.label = telabel;
        
%         test.Data = teD(:,:,test_ran{fold});
%         test.label = telabel(test_ran{fold},:);
        
        train.Data = trD(:,:,train_ran{fold});
        train.label = trlabel(train_ran{fold},:);
        
        ADtest_name = {Type1_file_name{AD_te_fold{fold}};}';
        NCtest_name = {Type2_file_name{NC_te_fold{fold}};}';
        
        Testfile_name{fold} = cat(1,ADtest_name,NCtest_name);
        Testfile_name{fold} = Testfile_name{fold}{test_ran{fold}};
        %% normalization
        [train.Data, trMu, trStd] = Normalization(train.Data);
        [test.Data] = Normalization(test.Data, trMu, trStd);
        [val.Data] = Normalization(val.Data, trMu, trStd);
      %%
      [train_Abnormality{roi}, tr_er{roi}, Active_feature_train{roi}] = Network_test(res.result, train);
      [test_Abnormality{roi}, er{roi}, Active_feature_test{roi}] = Network_test(res.result, test);
      
      T_Performance(roi) = (1 - mean(er{roi})) * 100;
   end
   
   Test_Labels = test.label;
   Train_Labels = train.label;
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   save(sprintf('./Save_result/%s/Temp/Abnormality_feature_%d.mat',ex,fold),'train_Abnormality','Train_Labels','test_Abnormality','Test_Labels','Testfile_name','T_Performance','er');
   save(sprintf('./Save_result/%s/Temp/Active_feature_%d.mat',ex,fold),'Active_feature_train','Active_feature_test');
   %% save performance
   ROI_performance{fold} = T_Performance;
   if fold == 10
      save( sprintf('./Save_result/%s/Temp/ROI_Performance.mat',ex), 'ROI_performance');
   end
   clear train_Abnormality test_Abnormality tr_er er Active_feature_train Active_feature_test
end

% Prob_Ab = [];
% temp = [];
% % for fold = 1: 10
%    for roi = 1 : 93
%        temp = [];
%        for mSet = 1 : size(Abnormality{roi}.result,1)
%            temp = [temp, Abnormality{roi}.result{mSet,1}(:,1)];
%        end
%        Prob_Ab = cat(2, Prob_Ab, mean(temp,2));
%    end
%     
% % end
% MMSE_cog = [24;22;23;26;24;26;25;25;25;23;20;21;25;23;21;25;26;24;23; ... % AD
%             27;29;29;30;30;30;30;30;28;30;28;29;30;29;30;29;29;30;28;26;29;29;28]; % NC
%         size(MMSE_cog)
%         size(Prob_Ab)
% CORR = corr(MMSE_cog, Prob_Ab);
% CORR = MMSE_cog * Prob_Ab ;


%%  test ########################################################################################################

AD_label = [1,0];
NC_label = [0,1];

%  er = [];
%  ens = [];
% for fold = 1 : 10
%     
%     load(sprintf('./Save_result/%s/Temp/Abnormality_feature_%d.mat',ex,fold));
%     ens{fold}.trLabel = train_Abnormality{1}.Label;
%     ens{fold}.teLabel = test_Abnormality{1}.Label;
%     for roi = 1 :  size(ROI_info,1)
%         if exist(sprintf('./Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_info(roi,1)))
%             tmp = [];
%             rng(0);
%             for i=1 : size(test_Abnormality{roi}.result,1)
%                 %                 if ~isnan(sum(res.train{i}(:,1)))
%                 tmp.train(:,i) = train_Abnormality{roi}.result{i,1}(:,1);
%                 tmp.test(:,i) = test_Abnormality{roi}.result{i,1}(:,1);
%                 %                 else
%                 %                     tmp.train(:,i) = zeros(size(res.train{1,i}(:,1)));
%                 %                     tmp.test(:,i) = zeros(size(res.test{1,i}(:,1)));
%                 %                 end
%             end
%             
%             Input_size = size(tmp.train,2);
%             structure = [ Input_size 50 2 ];
% %             ENNtrain_label = [];
% %             NNtest_label = [];
%             ENN = nnsetup(structure);
%             opts.nfold = 10;
%             
%             % opts.nn_learningRate = 0.003;
%             opts.nn_plot = 0;
%             ENN.activation_function   = 'tanh_opt'; %'tanh_opt'; %'sigm';  %'tanh_opt';
%             ENN.momentum              = 0.9;          %  Momentum
%             ENN.weightPenaltyL2       = 0.0001;       %  L2 regularization
%             ENN.dropoutFraction       = 0.5;          % 0 Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf)
%             %     nn.scaling_learningRate  = 0.99;         % 1 Scaling factor for the learning rate (each epoch)
%             ENN.nonSparsityPenalty  = 0.001;        %  Non sparsity penalty
%             % nn.neg_slope           = 0;
%             ENN.output                = 'softmax';
%             ENN.state                 = 1;
%             ENN.validation            = opts.nn_plot;
%             ENN.validation = 0;
%             % === option setting === %
%             ENN.plot           =0 ;
%             ENN.validation     = 0 ;
%             ENN.numepochs      = 100;
%             ENN.batchsize      = 50;
%             ENN.learningRate   = 0.0003;
%             opts.nn_validation = 0;
%             
%             
% %             Ens{fold}.teLabel = tmp.trLabel;
% %             Ens{fold}.teLabel = tmp.teLabel;
% 
%             
%             [FNNT, L]  = nntrain(ENN, tmp.train, ens{fold}.trLabel, opts, tmp.test, ens{fold}.teLabel );
%             ens{fold}.train(:,roi) = FNNT.actv_train{ENN.numepochs,1}(:,1);
%             FNNT.state = 0;
%             [er{fold}(roi), bad, testResult] = nntest(FNNT, tmp.test, ens{fold}.teLabel);
%             ens{fold}.test(:,roi) = testResult.a{size(structure,2)}(:,1);
%             fprintf('[%d fold : ROI%d, %f]\n',fold ,ROI_info(roi,1) , er{fold}(roi) );
% %             fprintf('\n %d', bad);
%         end
%     end
% end
% 
% for fold = 1 : 10
%      fprintf('%f\n',er(fold));
% end
% fprintf('structure %d\n',structure);
% fprintf('mean : %f    //  Performance : %f\n',mean(er),1-mean(er))



%% %%%%%%%%%%%%%%%%%%%%%%%%%%  ens mean
ens = [];  
% ex = 'ex170701';
load ROI_info.mat;
for fold = 1 : 10
    load(sprintf('./Save_result/%s/Temp/Abnormality_feature_%d.mat',ex,fold));
    for roi = 1 :  size(ROI_info,1)
        if exist(sprintf('./Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_info(roi,1)))
%             load(sprintf('./Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_info(roi,1)));
            
            tmp = [];
            
            for i=1 : size(test_Abnormality{roi}.result,1)
%                 if ~isnan(sum(res.train{i}(:,1)))
                    tmp.train(:,i) = train_Abnormality{roi}.result{i,1}(:,1);
                    tmp.test(:,i) = test_Abnormality{roi}.result{i,1}(:,1);
%                 else
%                     tmp.train(:,i) = zeros(size(res.train{1,i}(:,1)));
%                     tmp.test(:,i) = zeros(size(res.test{1,i}(:,1)));
%                 end
            end
            tmp.trLabel = train_Abnormality{roi}.Label;
            tmp.teLabel = test_Abnormality{roi}.Label;
            % %         [tmp.train,tmp.test] = NNNN(tmp);
            tmp.train = mean(tmp.train,2);
            tmp.test  = mean(tmp.test,2);
            ens{fold}.train(:,roi) = tmp.train;
            ens{fold}.test(:,roi) = tmp.test;

            %         ens{fold}.train(:,2) = tmp.train;
            %         ens{fold}.test(:,2) = tmp.test;
        end
        ens{fold}.trLabel = tmp.trLabel(:,1);
        ens{fold}.teLabel = tmp.teLabel(:,1);
    end
    
end


for fold =1 : size(ens,2)
        for roi = 1 : size(ROI_info,1)
%     if any(strcmp('train',fieldnames(ens{1,3})))
        type1p = ens{fold}.train(ens{fold}.trLabel(:,1)==1,:);
        type2p = ens{fold}.train(ens{fold}.trLabel(:,1)==0,:);
        [~,p] = ttest2(type1p,type2p);
        if isnan(p)
            p(isnan(p)==1)=1;
        end
        
        ensf{fold}.p = p;
        ensf{fold}.train = ens{fold}.train(:,p<0.001);
        ensf{fold}.test = ens{fold}.test(:,p<0.001);
        ensf{fold}.trLabel = ens{fold}.trLabel;
        ensf{fold}.teLabel = ens{fold}.teLabel;
%     end
        end
end

[perf, performance, weight, model] = Cal_perform(ens);
% [perf_fs, performance_fs, weight_f, model_f] = Cal_perform(ensf);

save(sprintf('%s',ex),'perf','performance','weight','model','ens');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SVlabel = ens{1,1}.trLabel( model.linear{cv}.sv_indices );
SValpha = model.linear{cv}.sv_coef;
SVdata = ens{1,1}.train( model.linear{cv}.sv_indices, : );

SVM_weight = (SVlabel.*SValpha)'* SVdata;
[sortedValues, sortedIndexes] = sort(SVM_weight, 'descend');
sortedIndexes(1:10)
MMSE = cell2mat(MMSE);

corr(ens{1,1}.test(:,sortedIndexes(1:10)), MMSE);

 opts = init_para();

bar([1,2,3,4,5,6,7,8,9,10],corr(ens{1,1}.test(:,sortedIndexes(1:10)), MMSE));

xticklabels({'superior occipital gyrus right','middle occipital gyrus left',...
                 'middle frontal gyrus right','superior frontal gyrus left',...
        'lateral occipitotemporal gyrus left','middle temporal gyrus right',...
             'superior parietal lobule left' , 'superior parietal lobule right',...
                             'precuneus left', 'occipital lobe WM right'})

                         
                         
%% classification NN ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% %  Best performance  rand seed 4(92.99)   , 11(93.00)!!
% for Rs =19 : 30
rng(30);

    er = [];
% performance = 0;
for fold = 1 : 10
    
    
    NNtrain_label = [];
    NNtest_label = [];
    FN = nnsetup([ 93 200 50 2 ]);
    opts.nfold = 10;
    
    FN.activation_function   = 'tanh_opt'; %'tanh_opt'; %'sigm';  %'tanh_opt';
    FN.momentum              = 0.9;          %  Momentum
    FN.weightPenaltyL2       = 0.0001;       %  L2 regularization
    FN.dropoutFraction       = 0.5;          % 0 Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf)
    %     nn.scaling_learningRate  = 0.99;         % 1 Scaling factor for the learning rate (each epoch)
    % nn.nonSparsityPenalty  = 0.001;        %  Non sparsity penalty
    % nn.neg_slope           = 0;
    FN.output                = 'softmax';
    FN.state                 = 0;
    FN.validation            = opts.nn_plot;
    FN.validation = 1;
    % === option setting === %
    FN.plot         = 0 ;
    FN.validation   = 0 ;
    FN.numepochs    = 200;
    FN.batchsize    = 50;
    FN.learningRate          = 0.003 ;
    
    
    NNtrain_label = ens{fold}.trLabel;
    NNtrain_label(:,2) = ~ens{fold}.trLabel;
    
    NNtest_label = ens{fold}.teLabel;
    NNtest_label(:,2) = ~ens{fold}.teLabel;
    
    [nnc_tr, L]  = nntrain(FN, ens{fold}.train, NNtrain_label, opts, ens{fold}.test, NNtest_label );
    
    [er(fold), bad, nnc_te] = nntest(nnc_tr, ens{fold}.test, NNtest_label);
    
    [performan(fold)]= cal_Performance(nnc_te.labels(:,1), nnc_te.labels(:,2), nnc_te.a{1,4});
%     fprintf('%f ', er(fold) );
    
end

%%
All_PPV = [];
All_NPV = [];
All_ACC = [];
All_SEN = [];
All_SPE = [];
All_AUC = [];
for fold = 1 : 10
   All_PPV(fold) = performan(fold).PPV;
   All_NPV(fold) = performan(fold).NPV;
   All_ACC(fold) = performan(fold).ACC;
   All_SEN(fold) = performan(fold).SEN;
   All_SPE(fold) = performan(fold).SPE;
   All_AUC(fold) = performan(fold).AUC;
end
performan(11).PPV = mean(All_PPV);
performan(11).NPV = mean(All_NPV);
performan(11).ACC = mean(All_ACC);
performan(11).SEN = mean(All_SEN);
performan(11).SPE = mean(All_SPE);
performan(11).AUC = mean(All_AUC);

performan(12).PPV = std(All_PPV);
performan(12).NPV = std(All_NPV);
performan(12).ACC = std(All_ACC);
performan(12).SEN = std(All_SEN);
performan(12).SPE = std(All_SPE);
performan(12).AUC = std(All_AUC);
%% 

p = signrank(x,y)


for fold = 1 : 10
     fprintf('%f\n',er(fold));
end
fprintf('seed : %d //   mean : %f    //  Performance : %f\n', 30 ,mean(er),1-mean(er))

% end
% 
 er = [];
for fold = 1 : 10
    
    structure = [ 93 200 50 2 ];
    
    NNtrain_label = [];
    NNtest_label = [];
    FN = nnsetup(structure);
    opts.nfold = 10;
    
    % opts.nn_learningRate = 0.003;
    opts.nn_plot = 0;
    FN.activation_function   = 'tanh_opt'; %'tanh_opt'; %'sigm';  %'tanh_opt';
    FN.momentum              = 0.9;          %  Momentum
    FN.weightPenaltyL2       = 0.0001;       %  L2 regularization
    FN.dropoutFraction       = 0.5;          % 0 Dropout level (http://www.cs.toronto.edu/~hinton/absps/dropout.pdf)
    %     nn.scaling_learningRate  = 0.99;         % 1 Scaling factor for the learning rate (each epoch)
    % nn.nonSparsityPenalty  = 0.001;        %  Non sparsity penalty
    % nn.neg_slope           = 0;
    FN.output                = 'softmax';
    FN.state                 = 0;
    FN.validation            = opts.nn_plot;
    FN.validation = 0;
    % === option setting === %
    FN.plot         = 0 ;
    FN.validation   = 0 ;
    FN.numepochs    = 200;
    FN.batchsize    = 50;
    FN.learningRate          = 0.0003;
    opts.nn_validation = 0;
    
    
    NNtrain_label(:,1) = ens{fold}.trLabel;
    NNtrain_label(:,2) = ~ens{fold}.trLabel;
    
    NNtest_label(:,1) = ens{fold}.teLabel;
    NNtest_label(:,2) = ~ens{fold}.teLabel;
    
    [FNN, L]  = nntrain(FN, ens{fold}.train, NNtrain_label, opts, ens{fold}.test, NNtest_label );
    
    [er(fold), bad, nn] = nntest(FNN, ens{fold}.test, NNtest_label);
    fprintf('%f', er(fold) );
    
    [performan(fold)]= cal_Performance(nnc_te.labels(:,1), nnc_te.labels(:,2), nnc_te.pre);
end

for fold = 1 : 10
     fprintf('%f\n',er(fold));
end
fprintf('structure %d\n',structure);
fprintf('mean : %f    //  Performance : %f\n',mean(er),1-mean(er))

All_PPV = [];
All_NPV = [];
All_ACC = [];
All_SEN = [];
All_SPE = [];
All_AUC = [];
for fold = 1 : 10
   All_PPV(fold) = performan(fold).PPV;
   All_NPV(fold) = performan(fold).NPV;
   All_ACC(fold) = performan(fold).ACC;
   All_SEN(fold) = performan(fold).SEN;
   All_SPE(fold) = performan(fold).SPE;
   All_AUC(fold) = performan(fold).AUC;
end
performan(11).PPV = mean(All_PPV);
performan(11).NPV = mean(All_NPV);
performan(11).ACC = mean(All_ACC);
performan(11).SEN = mean(All_SEN);
performan(11).SPE = mean(All_SPE);
performan(11).AUC = mean(All_AUC);

performan(12).PPV = std(All_PPV);
performan(12).NPV = std(All_NPV);
performan(12).ACC = std(All_ACC);
performan(12).SEN = std(All_SEN);
performan(12).SPE = std(All_SPE);
performan(12).AUC = std(All_AUC);




% 
% 
% for fold = 1 : 10
%     SVlabel = ens{fold}.trLabel( model.linear{fold}.sv_indices );
%     SValpha = model.linear{fold}.sv_coef;
%     SVdata = ens{fold}.train( model.linear{fold}.sv_indices, : );
%     SVM_weight{fold} = (SVlabel.*SValpha)' * SVdata;
% end
% 
% 
% % 
% save(sprintf('%s_Ens_and_performace.mat',ex),'ens','ensf','performance','perf');
% % save('Ens_and_performace71.mat','ens','ensf','performance','performance_fs','perf','perf_fs');
%     
% sac = 0;
% for fold = 1 : size(ens,2)
%     a = [];
%     b = [];
%     a{1} = sparse(double(ens{fold}.train));
%     b{1} = sparse(double(ens{fold}.test));
%     [predicted, accuracy, w, model] = buildClassifier_L1_RV ...
%                     ( a, ens{fold}.trLabel, b, ens{fold}.teLabel, []);
%                 sac = sac + accuracy;
%     accc(fold) = accuracy;
% end
% fprintf('\n acc %f',sac/10);
%     
% 
% 
% ADf = ens{1,6}.test((ens{1,6}.teLabel==1),:);
% NCf = ens{1,6}.test((ens{1,6}.teLabel~=1),:);
% y = [1:93];
% x = [1:93];
% 
% errorbar(x, [a', b'],[a_std', b_std']);
% 
% 
% %%
% figure(1)
% 
% clf;
% 
% D=[a',b'];       % data
% S=[a_std',b_std']; % st dev (10%)
% 
% h=bar(D);
% set(h,'BarWidth',1);
% hold on;
% 
% ngroups = size(D,1);
% nbars = size(D,2);
% groupwidth = min(0.8, nbars/(nbars+1.5));
% 
% colormap([0 0 1; 0 1 0]);   % blue / red
% 
% for i = 1:nbars
% x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
% errorbar(x,D(:,i),S(:,i),'r.','linewidth',0.1);
% end
% 
% legend('Abnormality of AD','Abnormality of NC');
% % set(gca,'XTickLabel',[1:93],'fontsize',14)
% % ylabel('Percentage','fontsize',14)
% 
% 
% 
% 
% 
% 
% %% classfier SVM
% [perf, perform_mean,performance] = Cal_perform(Ens,opts);
% save(sprintf('Final_Data/output_data/ex%s/perform/Performance_ensemble.mat',ex),'perf','perform_mean','performance');
% 
% ADtr = res.train{1,1}(res.trainLabel(:,1)==1);
% NCtr = res.train{1,1}(res.trainLabel(:,2)==1);
% ADte = res.test{1,1}(res.testLabel(:,1)==1);
% NCte = res.test{1,1}(res.testLabel(:,2)==1);
% 
% per = res.train{1,1}(res.train{1,1}(:,1)>0.5);
% per = (res.train{1,1}(:,1)>0.5);
% perfor = sum(res.trainLabel(:,1)==per);
% 
% pert = res.test{1,1}(res.test{1,1}(:,1)>0.5);
% pert = (res.test{1,1}(:,1)>0.5);
% pertest = sum(res.testLabel(:,1)==pert);
% 
% figure(1)
% bar(ADtr);
% figure(2)
% bar(NCtr);
% 
% figure(3)
% bar(ADte);
% figure(4)
% bar(NCte);
% 
% %%
% for i=1 : 93
%     figure(i)
% %     subplot(1,1,i)
% %     bar(Thresh_idx{i,4})
%     histogram(Thresh_idx{i,4},'BinLimits',[0, 0.05]);
%     pause()
% end
% 
% figure(1); histogram(Thresh_idx{69,4},'BinLimits',[0, 0.05]);
% figure(2); histogram(Thresh_idx{69,4},'BinLimits',[0, 0.05]);
Demo = {AD_demo.Data; NC_demo.Data{:}};
x{1} = 0;
x{2} = 'A_b_potp';
y{2} = 'b';
y{1} = 1;

Demoscore = [];
for s = 1 : size(A,1)
    for p = 1 : size(Demo,1)
        if  any(strfind(A{s,1},Demo{p,2}))
            fprintf('Yeha %d\n\n',p);
            Demoscore{s} = {Demo{p,:}}';
        end
    end
        
end

for i = 1 : size(Demoscore,2)
    MMSE(i,1) = Demoscore{i}(7);
end


