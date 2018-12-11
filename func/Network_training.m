function Network_training(opt, processed_Data_Path, Data_type1, Data_type2)
load(sprintf('./Save_result/%s/crossValidation_idx.mat',opt.ex));
load(sprintf('./Save_result/%s/Shuffle_idx.mat',opt.ex));


type1_label = [1,0];
type2_label = [0,1];

% ex = 
load ROI_info.mat
%% network Training
for fold = 1:opt.nfold
    for roi = 1 : size(ROI_info,1)
        fprintf('\n ROI %d',ROI_info(roi,1));
        opts = init_para();
% %         load(sprintf('ex170727_type2_type1/ROI_featureV%d.mat',Thresh_idx{roi,2}));
        load(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d',processed_Data_Path, Data_type1, fold, Data_type1, ROI_info(roi,1)),'type1_voxel_ROI');
        load(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d',processed_Data_Path, Data_type2, fold, Data_type2, ROI_info(roi,1)),'type2_voxel_ROI');
        
        train = [];
        test = [];
        Labels = [];
        val = [];
        
        trD = cat(3,type1_voxel_ROI(:,:,type1_tr_fold{fold}),type2_voxel_ROI(:,:,type2_tr_fold{fold}));
        teD = cat(3,type1_voxel_ROI(:,:,type1_te_fold{fold}),type2_voxel_ROI(:,:,type2_te_fold{fold}));
        valD = cat(3,type1_voxel_ROI(:,:,type1_val_fold{fold}),type2_voxel_ROI(:,:,type2_val_fold{fold}));
        
        trlabel = cat(1,repmat(type1_label, size(type1_voxel_ROI(:,:,type1_tr_fold{fold}),3),1 ),repmat(type2_label, size(type2_voxel_ROI(:,:,type2_tr_fold{fold}),3),1 ) ) ;
        telabel = cat(1,repmat(type1_label, size(type1_voxel_ROI(:,:,type1_te_fold{fold}),3) ,1 ),repmat(type2_label, size(type2_voxel_ROI(:,:,type2_te_fold{fold}),3),1 ) );
        vallabel = cat(1,repmat(type1_label, size(type1_voxel_ROI(:,:,type1_val_fold{fold}),3) ,1 ),repmat(type2_label, size(type2_voxel_ROI(:,:,type2_val_fold{fold}),3),1 ) );

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
        save(sprintf('Save_result/%s/fold%d/%s_f%dROI_%d.mat',opt.ex,fold,opt.ex,fold,ROI_info(roi,1)),'res');
%         save(sprintf('Save_network/sae/sae%d.mat',Thresh_idx{roi,2}),'sae');
        save(sprintf('Save_result/%s/Network/fold%d/nn%d.mat',opt.ex,fold,ROI_info(roi,1)),'nn_result');
        
        clear res sae nn_result;
    end
end







end