pMCI_fold = crossvalind('Kfold', 160, 10);
sMCI_fold = crossvalind('Kfold', 214, 10);

for fold = 1 : 10
    pMCI_te_fold{fold,1} = (pMCI_fold == fold);
    tmpfold = pMCI_fold((pMCI_fold~=fold));
    pMCI_val_fold{fold,1} = (pMCI_fold == tmpfold(1,1));
    pMCI_tr_fold{fold,1} = ( (pMCI_fold~=tmpfold(1,1)) & (pMCI_fold~=fold));
    
    sMCI_te_fold{fold,1} = (sMCI_fold == fold);
    tmpfold = sMCI_fold((sMCI_fold~=fold));
    sMCI_val_fold{fold,1} = (sMCI_fold == tmpfold(1,1));
    sMCI_tr_fold{fold,1} = ( (sMCI_fold~=tmpfold(1,1)) & (sMCI_fold~=fold));
    
%     save(sprintf('./Save_result/%s/crossValidation_idx.mat',ex), 'pMCI_fold', 'sMCI_fold','pMCI_te_fold','pMCI_val_fold','pMCI_tr_fold','sMCI_te_fold','sMCI_val_fold','sMCI_tr_fold' )
end
%% make shuffle index
for fold = 1 : opts.nfold
    tef_size = (sum(pMCI_te_fold{fold})+sum(sMCI_te_fold{fold}));
    trf_size = (sum(pMCI_tr_fold{fold})+sum(sMCI_tr_fold{fold}));
    val_size = (sum(pMCI_val_fold{fold})+sum(sMCI_val_fold{fold}));
    
    test_ran{fold} = randperm(tef_size);  % shuffle
    train_ran{fold} = randperm(trf_size); % shuffle
    val_ran{fold} = randperm(val_size);   % shuffle
end

ensSP=[];
for fold = 1 : 10
    pMCI_Abnormal = ens{fold}.test(1:160,:);
    sMCI_Abnormal = ens{fold}.test(161:end,:);
    pLabel = ens{fold}.teLabel(1:160);
    sLabel = ens{fold}.teLabel(161:end);
    
    ensSP{fold}.train = pMCI_Abnormal(pMCI_tr_fold{fold,1},:);
    ensSP{fold}.test = pMCI_Abnormal(pMCI_te_fold{fold,1},:);
    ensSP{fold}.trLabel = pLabel(pMCI_tr_fold{fold,1});    
    ensSP{fold}.teLabel = pLabel(pMCI_te_fold{fold,1});
    
    ensSP{fold}.train = cat(1, ensSP{fold}.train, sMCI_Abnormal(sMCI_tr_fold{fold,1},:));
    ensSP{fold}.test = cat(1, ensSP{fold}.test, sMCI_Abnormal(sMCI_te_fold{fold,1},:));
    ensSP{fold}.trLabel = cat(1, ensSP{fold}.trLabel, sLabel(sMCI_tr_fold{fold,1}));
    ensSP{fold}.teLabel = cat(1, ensSP{fold}.teLabel, sLabel(sMCI_te_fold{fold,1}));
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

[perf, performance, weight, model] = Cal_perform(ensSP);

%% 
%%
%%
MCI_fold = crossvalind('Kfold', 374, 10);
for fold = 1 : 10
    MCI_te_fold{fold,1} = (MCI_fold == fold);
    tmpfold = MCI_fold((MCI_fold~=fold));
    MCI_val_fold{fold,1} = (MCI_fold == tmpfold(1,1));
    MCI_tr_fold{fold,1} = ( (MCI_fold~=tmpfold(1,1)) & (MCI_fold~=fold));
end
save(sprintf('./Save_result/MCI_NC_on_ADNC_Model/crossValidation_idx.mat'), 'MCI_fold', 'MCI_te_fold','MCI_val_fold','MCI_tr_fold','train_ran','test_ran')

NC_train_data = [];
MCI_Data = [];
MCI_train_data=[];
for fold = 1 : 10
   NC_train_data{fold,1} = ens{fold}.train((ens{fold}.trLabel==0),:);
   MCI_Data{fold,1} = ens{fold}.test((ens{fold}.teLabel==1),:);
   MCI_train_data{fold,1} = MCI_Data{fold,1}(MCI_tr_fold{fold,1},:);
   NC_test_data{fold,1} = ens{fold}.test((ens{fold}.teLabel==0),:);
   MCI_test_data{fold,1} = MCI_Data{fold,1}(MCI_te_fold{fold,1},:);
end

MCI_label = [1,0];
NC_label = [0,1];

ensMCINC=[];
for fold = 1 : 10
   ensMCINC{fold}.train = cat( 1, MCI_train_data{fold,1}, NC_train_data{fold,1});
   ensMCINC{fold}.test = cat (1, MCI_test_data{fold,1}, NC_test_data{fold,1});
   ensMCINC{fold}.trLabel = cat(1,repmat(MCI_label,size(MCI_train_data{fold,1},1),1), repmat(NC_label,size(NC_train_data{fold,1},1),1));
   ensMCINC{fold}.teLabel = cat(1,repmat(MCI_label,size(MCI_test_data{fold,1},1),1), repmat(NC_label,size(NC_test_data{fold,1},1),1));
end

%% make shuffle index
for fold = 1 : opts.nfold
    trf_size = size(ensMCINC{fold}.train,1);
    tef_size = size(ensMCINC{fold}.test,1);
    
    train_ran{fold} = randperm(trf_size); % random
    test_ran{fold} = randperm(tef_size);  % random
end

for fold = 1 : 10
    ensMCINC{fold}.train = ensMCINC{fold}.train(train_ran{fold},:);
    ensMCINC{fold}.test = ensMCINC{fold}.test(test_ran{fold},:);
    ensMCINC{fold}.trLabel = ensMCINC{fold}.trLabel(train_ran{fold},:);
    ensMCINC{fold}.teLabel = ensMCINC{fold}.teLabel(test_ran{fold},:);
end

[perf, performance, weight, model] = Cal_perform(ensMCINC);

%% Mapping MCINC
Mapping =1;  % 1 is template, 0 is Voxel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
template = load_nii('Template_cbq_256.nii');
template.hdr.dime.datatype = 16;  % transform the type of nii to 'float32'

Newbrain = template;
Newbrain.img = zeros( size(Newbrain.img) );

all_peformance = [];
for fold =1 : 10
    load(sprintf('Save_result/MCI_NC_on_ADNC_Model/Temp/Abnormality_feature_%d.mat',fold));
    all_peformance(fold,:) = T_Performance;
end

mean_performance = mean(T_Performance,1);
methodPath = 'MCI_NC_on_ADNC_model_Map/1_Performance_Map/';

for roi = 1 :93
    if Mapping==1
        Newbrain.img( Template_ROI_idx{roi,1} ) = mean_performance(1,roi);
        fName = sprintf('MCI_NC_PerformanceMap.nii');
    else
        Newbrain.img( Thresh_idx{1,1}{roi,1} ) = mean_performance(1,roi);
        fName = sprintf('MCI_NC_PerformanceMap_vox.nii');
    end
end
save_nii( Newbrain, [methodPath,fName] );



MCI_abnoramltiy = [];
for fold = 1:10
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Newbrain = template;
    Newbrain.img = zeros( size(Newbrain.img) );
    
    %% AD
    load('ADNI_MCI_demographic.mat')
    
    MCI_Demo = MCI_demo.Data;
    
%     MCI_Te_demo = MCI_Demo(pMCI_te_fold{fold,1},:);
    
    total_Test_demo{fold} = MCI_Demo;
    MCI_abnoramltiy{fold} = ens{fold}.test(1:374,:)*100;
    total_Test_demo{fold} = cat(2,total_Test_demo{fold},num2cell(MCI_abnoramltiy{fold}));
    
%     mean_MCI_abnormality{fold} = mean(MCI_abnoramltiy{fold},1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Newbrain = template;
%     Newbrain.img = zeros( size(Newbrain.img) );
    
    %%% mean AD
%     methodPath = 'spMCI_Map/2_Regional_Abnormality/';
%     for roi = 1:93
%         if Mapping==1
%             Newbrain.img( Template_ROI_idx{roi,1} ) = mean_MCI_abnormality{fold}(1,roi);
%             fName = sprintf('MCIsMCI_mean_pMCI_abnormality_ROI_fold%d.nii',fold);
%         else
%             Newbrain.img( Thresh_idx{1,1}{roi,1} ) = mean_MCI_abnormality{fold}(1,roi);
%             fName = sprintf('MCIsMCI_mean_pMCI_abnormality_Vox_fold%d.nii',fold);
%         end
%     end
%     save_nii( Newbrain, [methodPath,fName] );
    
%     Newbrain = template;
%     Newbrain.img = zeros( size(Newbrain.img) );
%     
%     %%%% mean sMCI
%     methodPath = 'spMCI_Map/2_Regional_Abnormality/';
%     for roi = 1:93
%         if Mapping==1
%             Newbrain.img( Template_ROI_idx{roi,1} ) = mean_sMCI_abnormality{fold}(1,roi);
%             fName = sprintf('MCIsMCI_mean_sMCI_abnormality_ROI_fold%d.nii',fold);
%         else
%             Newbrain.img( Thresh_idx{1,1}{roi,1} ) = mean_sMCI_abnormality{fold}(1,roi);
%             fName = sprintf('MCIsMCI_mean_sMCI_abnormality_Vox_fold%d.nii',fold);
%         end
%     end
%     save_nii( Newbrain, [methodPath,fName] );
end


for fold = 1 : 10
    mean_abnormality(fold,:) = mean(MCI_abnoramltiy{fold},1);
end

Newbrain = template;
Newbrain.img = zeros( size(Newbrain.img) );

%%%% mean sMCI
for fold = 1 : 10
methodPath = 'MCI_NC_on_ADNC_model_Map/2_Regional_Abnormality/';
for roi = 1:93
    if Mapping==1
        Newbrain.img( Template_ROI_idx{roi,1} ) = mean_abnormality(fold,roi);
        fName = sprintf('MCIsMCI_mean_sMCI_abnormality_ROI_fold%d.nii',fold);
    else
        Newbrain.img( Thresh_idx{1,1}{roi,1} ) = mean_abnormality(fold,roi);
        fName = sprintf('MCIsMCI_mean_sMCI_abnormality_Vox_fold%d.nii',fold);
    end
end
save_nii( Newbrain, [methodPath,fName] );
end

%%%% mean sMCI

Newbrain = template;
Newbrain.img = zeros( size(Newbrain.img) );
methodPath = 'MCI_NC_on_ADNC_model_Map/2_Regional_Abnormality/';
for roi = 1:93
    if Mapping==1
        MA = mean(mean_abnormality,1);
        Newbrain.img( Template_ROI_idx{roi,1} ) = MA(1,roi);
        fName = sprintf('MCIsMCI_mean_sMCI_abnormality_ROI_fold%d.nii',fold);
    else
%         Newbrain.img( Thresh_idx{1,1}{roi,1} ) = mean_abnormality(fold,roi);
%         fName = sprintf('MCIsMCI_mean_sMCI_abnormality_Vox_fold%d.nii',fold);
    end
end
save_nii( Newbrain, [methodPath,fName] );



save('MCI_NC_on_ADNC_model_Map/MCI_NC_on_ADNC_model_Map_MCI_Demographic.mat','total_Test_demo');




%% SVM Weight 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
template.hdr.dime.datatype = 16;  % transform the type of nii to 'float32'
Newbrain = template;
Newbrain.img = zeros( size(Newbrain.img) );

SVlabel = ensMCINC{fold}.trLabel( model.linear{1}.sv_indices );
SValpha = model.linear{1}.sv_coef;
SVdata = ensMCINC{fold}.train( model.linear{1}.sv_indices, : );

SVM_weight = (SVlabel.*SValpha)'* SVdata;

% [sortedValues, sortedIndexes] = sort(SVM_weight, 'descend');
% sortedIndexes(1:10)
methodPath = 'MCI_NC_on_ADNC_model_Map/3_SVM_weight';
for roi = 1 : 93  % size(thresh_idx,1)
    if Mapping==1
    Newbrain.img( Template_ROI_idx{roi,1} ) = SVM_weight(1,roi);
    save_nii( Newbrain, [methodPath,'/spMCI_Weight_Map.nii'] );
    else
    Newbrain.img( thresh_idx{1,1}{roi,1} ) = SVM_weight(1,roi);
    save_nii( Newbrain, [methodPath,'/spMCI_Weight_Map_vox.nii'] );
    end
end

% To save image header

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             activation = cov( trainFeatures{1} ) * SVM_weight' * inv( cov( trainLabel ) );
activation = cov( ens{fold}.train ) * SVM_weight' * inv( cov( model.linear{1,1}.predict ) );

activation = activation / norm( activation );
%             activation = (12 * ( activation-min(activation) ) / ( max(activation)-min(activation) ) - 6)/6;

%            ActivationPatterns = [ ActivationPatterns, activation ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
template = load_nii('Template_cbq_256.nii');
template.hdr.dime.datatype = 16;  % transform the type of nii to 'float32'

Newbrain = template;
Newbrain.img = zeros( size(Newbrain.img) );

methodPath = 'MCI_NC_on_ADNC_model_Map/3_SVM_weight';
% assign values to nii image
for roi = 1:93
    if Mapping==1
    Newbrain.img( Template_ROI_idx{roi,1} ) = activation(roi);
    Fname = '/spMCI_Activation_brain.nii';
    else
    Newbrain.img( thresh_idx{1,1}{roi,1} ) = activation(roi);
    Fname = '/spMCI_Activation_brain_Vox.nii';
    end
end

save_nii( Newbrain, [methodPath, Fname]);