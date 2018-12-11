function Sample_idx = RandomVoxelSampling(thresh_idx,Data_Path,Dtype)
%% Make all to one of W-index

numROI = size(thresh_idx,1);
% find minimum voxel size
for i =1 : numROI
    num_voxel_ROI(i,1) = size(thresh_idx{i,1},1);
end
% maxNV = max(num_voxel_ROI(num_voxel_ROI<200));
% num_voxel = min(num_voxel_ROI);
% init number of voxel set
% for i = 1 : numROI
%     if num_voxel_ROI(i) < 200
%         select_Nvoxel(i,1) = num_voxel_ROI(i);
%         num_set(i,1) = 1; % if total voxel of ROI < 200  --> #of set = 1
%     else
%         select_Nvoxel(i,1) = maxNV;
%         num_set(i,1) = ceil(size(thresh_idx{i,1},1)/select_Nvoxel(i,1) * 3);   % if total voxel of ROI < 200  --> #of set = 1
%     end
% end
num_voxel = 300;
for i = 1 : numROI
   num_set(i,1) = ceil(num_voxel_ROI(i) / num_voxel) * 3;
end

% find voxel index
for i = 1 : numROI
    temp = [];
    for j = 1 : num_set(i)
        temp(:,j) = datasample(thresh_idx{i,1},num_voxel);
    end
    Sample_idx{i,1} = temp;
end

% % apply voxel index
% Data_type = 1;
% type1 = 'AD';
% [AD_file_name,~] = Read_file_name (Data_Path,Data_type,type1);
% for ap = 1 : size(AD_file_name,1)
%     load(AD_file_name{ap});
%     for j =1 : numROI
%         AD_voxel{j,1} = RavensMap_AD(Sample_idx{j,1});                   % Each ROI
%         AD_voxel{j,2} = thresh_idx{j,2};
%     end
%     save(sprintf('Features/AD_F/AD_sub_voxSet%d',ap),'AD_voxel');
%     clear AD_voxel RavensMap_AD;
% end
% Data_type = 1;
% type2 = 'NC';
% [NC_file_name,~] = Read_file_name (Data_Path,Data_type,type2);
% for ap = 1 : size(AD_file_name,1)
%     load(NC_file_name{ap});
%     for j =1 : numROI
%         NC_voxel{j,1} = RavensMap_NORMAL(Sample_idx{j,1});                   % Each ROI
%         NC_voxel{j,2} = thresh_idx{j,2};
%     end
%     save(sprintf('Features/NC_F/NC_sub_voxSet%d',ap),'NC_voxel');
%     clear AD_voxel RavensMap_Normal;
% end
%%%%%%%%%%%%%%%%%%%%%%%  ROI
% Data_type = 1;
% if Dtype == 'AD'
%     [AD_file_name,~] = Read_file_name (Data_Path,Data_type,type1);
%     for j =1 : numROI
%         for ap = 1 : size(AD_file_name,1)
%             load(AD_file_name{ap});
%             AD_voxel_ROI{ap,1} = RavensMap_AD(Sample_idx{j,1});                   % Each ROI
%         end
%         save(sprintf('Features/ROI_ADF/AD_voxSet_ROI%d',j),'AD_voxel_ROI');
%         clear AD_voxel_ROI RavensMap_AD;
%     end
%     clear AD_file_name;
% elseif Dtype == 'NC'
%     
%     % apply voxel index
%     Data_type = 1;
%     type2 = 'NC';
%     [NC_file_name,~] = Read_file_name (Data_Path,Data_type,type2);
%     for j =1 : numROI
%         for ap = 1 : size(NC_file_name,1)
%             load(NC_file_name{ap});
%             NC_voxel_ROI{ap,1} = RavensMap_NORMAL(Sample_idx{j,1});                   % Each ROI
%         end
%         save(sprintf('Features/ROI_NCF/NC_voxSet_ROI%d',j),'NC_voxel_ROI');
%         clear NC_voxel_ROI RavensMap_NORMAL;
%     end
%     
% elseif Dtype == 'MCI'    
%     % apply voxel index
%     Data_type = 1;
%     type2 = 'MCI';
%     [MCI_file_name,~] = Read_file_name (Data_Path,Data_type,type2);
%     for j =1 : numROI
%         for ap = 1 : size(MCI_file_name,1)
%             load(MCI_file_name{ap});
%             MCI_voxel_ROI{ap,1} = RavensMap_MCI(Sample_idx{j,1});                   % Each ROI
%         end
%         save(sprintf('Features/ROI_MCIF/MCI_voxSet_ROI%d',j),'MCI_voxel_ROI');
%         clear MCI_voxel_ROI RavensMap_MCI;
%     end
%     
% end

end
