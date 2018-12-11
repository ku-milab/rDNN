function num_of_subj = app_sample_idx(Sample_idx,file_name,Dtype,fold)
numROI = 93;

% Data_type = 1;
if Dtype == 1 % AD'
%     %     [AD_file_name,~] = Read_file_name (Data_Path,Data_type,d_type);
%     num_of_subj = size(file_name,1);
%     for j =1 : numROI
%         for ap = 1 : size(file_name,1)
%             load(file_name{ap});
%             AD_voxel_ROI{ap,1} = RavensMap_AD(Sample_idx{j,1});                   % Each ROI
%         end
%         save(sprintf('ex170727_NC_MCI/ROI_ADF/AD_voxSet_ROI%d',j),'AD_voxel_ROI');
%         clear AD_voxel_ROI RavensMap_AD;
%     end
%     clear AD_file_name;
    
elseif Dtype == 2 % 'NC'
    
    num_of_subj = size(file_name,1);
    for j =1 : numROI
        for ap = 1 : size(file_name,1)
            load(file_name{ap});
            NC_voxel_ROI(:,:,ap) = RavensMap_NORMAL(Sample_idx{j,1});                   % Each ROI
        end
        save(sprintf('./Data_NC_MCI/MCI_F/fold_%d/NC_voxSet_ROI%d',fold,j),'NC_voxel_ROI');
        clear NC_voxel_ROI RavensMap_NORMAL;
    end
    
elseif Dtype == 3 % MCI'
    % apply voxel index
    %     Data_type = 1;
%     type2 = 'MCI';
    %     [MCI_file_name,~] = Read_file_name (Data_Path,Data_type,d_type);
    num_of_subj = size(file_name,1);
    for j =1 : numROI
        for ap = 1 : size(file_name,1)
            load(file_name{ap});
            MCI_voxel_ROI(:,:,ap) = RavensMap_MCI(Sample_idx{j,1});                   % Each ROI
        end
        save(sprintf('ex170727_NC_MCI/ROI_MCIF/MCI_voxSet_ROI%d',j),'MCI_voxel_ROI');
        clear MCI_voxel_ROI RavensMap_MCI;
    end
    
end
