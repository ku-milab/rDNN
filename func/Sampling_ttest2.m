% *************** ROI version ************

function thresh_idx = Sampling_ttest2(ROI_info,Data_Path,Threshold,CV_idx)

%% make Threhold_imdexfile
for roi = 1 : size(ROI_info,1)
    Data = [];
    %% Path
    ROI_num = ROI_info(roi);
    Nonz_MCI_DataPath = sprintf('%sNonz_MCI_ROI_index/MCINonz_ROI_index_%d.mat',Data_Path,ROI_info(roi));
    Nonz_NC_DataPath = sprintf('%sNonz_NC_ROI_index/NCNonz_ROI_index_%d.mat',Data_Path,ROI_info(roi));
    %Nonz_MCI_DataPath = sprintf('/home/eunho/Documents/Nonz_MCI_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    
    %% load template index
    % template index matrix name is 'find_index'
    load(sprintf('index_outImage_%d.img.mat',ROI_num));
    
    %% load data
    load(Nonz_MCI_DataPath);
    Data.MCI = MCI_vector_all;
    % dataSize.AD = size(AD_vector_all,2);
    clear MCI_vector_all;
    
    load(Nonz_NC_DataPath);
    Data.NC = NC_vector_all;
    % dataSize.NC = size(AD_vector_all,2);
    clear NC_vector_all;
    A_Data = cat(2, Data.MCI, Data.NC);
    %     mean_Data = mean(A_Data,2);
%     num_sub = ceil(size(A_Data,2) * 30/100); %% 0 value select subject of 50%
    %% ttest
    P_value = [];
    nonzeroIdx = [];
    
    for ind = 1 : size(Data.MCI,1)
        [~,P_value(ind)] = ttest2(Data.MCI(ind,:), Data.NC(ind,:));
        if isnan(P_value(ind))
            P_value(ind) = 1;
        end
       
    end
    
    %% P_Rate is threshold value
  
    nonzP_value = (P_value<=Threshold)';
    
    Small_idx = find(nonzP_value~=0);
    
    thresh_idx{roi,1} = find_index(Small_idx);
    thresh_idx{roi,2} = ROI_num;
    thresh_idx{roi,3} = Small_idx;
end
end
% filename = opts.Thr_indexfile;

% clear thresh_idx Threshold_indexfile;



