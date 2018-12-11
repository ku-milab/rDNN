function make_Subspace(opt, processed_Data_Path, Data_type1, Data_type2)



load ./Template/ROI_info.mat;

load(sprintf('./Save_result/%s/TreshIdx%.2f.mat',opt.ex,threshold));
for fold = 1 : opts.nfold
    type1_voxel_ROI = [];
    type2_voxel_ROI = [];
    Sample_idx{fold} = RandomVoxelSampling(Thresh_idx{fold});
    fprintf('%s',Data_type1);
    for roi =1 : size(ROI_info,1)
        fprintf('%d',ROI_info(roi,1));
        
        for sub = 1 : size(opt.Type1_file_name,1)
            load(sprintf('%s/%s',opt.type1_Data_Path,opt.Type1_file_name{sub}));
            
            if Data_type1 == 'AD'
                type1_voxel_ROI(:,:,sub) = RavensMap_AD(Sample_idx{fold}{roi,1});
                
            elseif Data_type1 == 'MCI'
                type1_voxel_ROI(:,:,sub) = RavensMap_MCI(Sample_idx{fold}{roi,1});
                
            elseif Data_type1 == 'pMCI'
                type1_voxel_ROI(:,:,sub) = RavensMap_pMCI(Sample_idx{fold}{roi,1});
                
            end
        end
        save(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d',processed_Data_Path, Data_type1, fold, Data_type1, ROI_info(roi,1)),'type1_voxel_ROI');

    end
    fprintf('%s',Data_type2);
    
    for roi =1 : size(ROI_info,1)
        fprintf('%d',ROI_info(roi,1));
        for sub = 1 : size(opt.Type2_file_name,1)
            load(sprintf('%s/%s', opt.type2_Data_Path, opt.Type2_file_name{sub}));
            
            if Data_type1 == 'CN'
                type2_voxel_ROI(:,:,sub) = RavensMap_CN(Sample_idx{fold}{roi,1});                   % Each ROI
            elseif Data_type1 == 'sMCI'
                type2_voxel_ROI(:,:,sub) = RavensMap_sMCI(Sample_idx{fold}{roi,1});                   % Each ROI
                
            end
               
        end
        save(sprintf('./%s/%s_F/fold_%d/%s_voxSet_ROI%d',processed_Data_Path, Data_type2, fold, Data_type2, ROI_info(roi,1)),'type2_voxel_ROI');
    end
end
save(sprintf('./Save_result/%s/Sample_idx.mat',opt.ex),'Sample_idx');







end