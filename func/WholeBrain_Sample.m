function Whole_Idx = WholeBrain_Sample(labels)

Whole_Idx = [];
%% make Threhold_imdexfile
for roi = 1 : size(labels,1);
    %% Path
    ROI_num = labels(roi);
    
    Nonz_AD_DataPath = sprintf('Nonz_AD_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    Nonz_NC_DataPath = sprintf('Nonz_Normal_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    %Nonz_MCI_DataPath = sprintf('/home/eunho/Documents/Nonz_MCI_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    
    %% load template index
    % template index matrix name is 'find_index'
    load(sprintf('preprocessing/ROI_index/index_outImage_%d.img.mat',ROI_num));
    
    %% load data
    load(Nonz_AD_DataPath);
    Data.AD = AD_vector_all;
    % dataSize.AD = size(AD_vector_all,2);
    
    load(Nonz_NC_DataPath);
    Data.NC = AD_vector_all;
    % dataSize.NC = size(AD_vector_all,2);
    clear AD_vector_all;
    A_Data = cat(2,Data.AD,Data.NC);
    mean_Data = mean(A_Data,2);
    %% P_Rate is threshold value
    nonzeroIdx = (mean_Data>=0.1);
    tmp_Idx = find_index((find_index .* nonzeroIdx)~=0);
%      find(isnan(mean_Data<=1))

    Whole_Idx = [Whole_Idx;tmp_Idx];
    
end


end