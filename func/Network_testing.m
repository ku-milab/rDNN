function Network_testing(opt, processed_Data_Path, Data_type1, Data_type2)
load(sprintf('./Save_result/%s/crossValidation_idx.mat',opt.ex));
load(sprintf('./Save_result/%s/Shuffle_idx.mat',opt.ex));

for fold = 1 : opt.nfold
    T_Performance = [];
   for roi = 1 : size(ROI_info,1)
      load(sprintf('./Save_result/%s/fold%d/%s_f%dROI_%d.mat',opt.ex,fold,opt.ex,fold,ROI_info(roi,1)));

        fprintf('\n ROI %d',ROI_info(roi,1));
        opts = init_para();
% %         load(sprintf('opt.ex170727_type2_type1/ROI_featureV%d.mat',Thresh_idx{roi,2}));
        load(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d', processed_Data_Path, Data_type1, fold, Data_type1, ROI_info(roi,1)),'type1_voxel_ROI');
        load(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d', processed_Data_Path, Data_type2, fold, Data_type2, ROI_info(roi,1)),'type2_voxel_ROI');
        
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

        val.Data = valD;
        val.label = vallabel;
        
        
        test.Data = teD;
        test.label = telabel;
        
        train.Data = trD(:,:,train_ran{fold});
        train.label = trlabel(train_ran{fold},:);
        
        type1test_name = {Type1_file_name{type1_te_fold{fold}};}';
        type2test_name = {Type2_file_name{type2_te_fold{fold}};}';
        
        Testfile_name{fold} = cat(1,type1test_name,type2test_name);
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
   save(sprintf('./Save_result/%s/All_features/Abnormality_feature_%d.mat',opt.ex,fold),'train_Abnormality','Train_Labels','test_Abnormality','Test_Labels','Testfile_name','T_Performance','er');
   save(sprintf('./Save_result/%s/All_features/Active_feature_%d.mat',opt.ex,fold),'Active_feature_train','Active_feature_test');
   %% save performance
   ROI_performance{fold} = T_Performance;
   if fold == 10
      save( sprintf('./Save_result/%s/All_features/ROI_Performance.mat',opt.ex), 'ROI_performance');
   end
   clear train_Abnormality test_Abnormality tr_er er Active_feature_train Active_feature_test
end

end