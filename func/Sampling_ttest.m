% *************** ROI version ************

function [thresh_idx,P_value] = Sampling_ttest(ROI_number,Data,Template_idx,Threshold)

%% make Threhold_imdexfile

%     A_Data = cat(2, Data.AD, Data.NC);

%     if size(Template_idx,1)>opt.num_voxel
    %% ttest
    P_value = [];
    nonzeroIdx = [];
    
        [~,P_value] = ttest2(Data.type1, Data.type2,'dim',2);

            P_value(isnan(P_value)) = 1;

    
    %% P_Rate is threshold value
  
    nonzP_value = (P_value<=Threshold)';
    
    Small_idx = find(nonzP_value~=0);
    
    thresh_idx{:,1} = Template_idx(Small_idx);
    thresh_idx{:,2} = ROI_number;
    thresh_idx{:,3} = Small_idx;
    thresh_idx{:,4} = P_value;
%     else
%         thresh_idx{:,1} = Template_idx;
%         thresh_idx{:,2} = ROI_number;
%         thresh_idx{:,3} = find(Template_idx~=0);
%     end
        
end

% filename = opts.Thr_indexfile;

% clear thresh_idx Threshold_indexfile;

% Nonz_AD_DataPath = sprintf('%sNonz_AD_ROI_index/ADNonz_ROI_index_%d.mat',Data_Path,ROI_info(roi));
% Nonz_NC_DataPath = sprintf('%sNonz_NC_ROI_index/NCNonz_ROI_index_%d.mat',Data_Path,ROI_info(roi));
% Nonz_MCI_DataPath = sprintf('/home/eunho/Documents/Nonz_MCI_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    

