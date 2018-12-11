% *************** ROI version ************
function Sorted_Pval = GroupDifference(Data_Path,threshold,type1,type2)
disp('Calculate the difference between groups');
% label number
load ROI_info.mat;  %% load matrix name 'labels'.
% load ROI_num2.mat;  %% num2 is remove WM and some roi  number of 71 roi
whole_Pval = [];
whole_idx = [];
%% make Threhold_imdexfile
for roi = 1 : size(ROI_info,1)
    Data = [];
    %% Path
    [ADfile_name,~] = Read_file_name (Data_Path,2,type1); % 2 = ROI index;
    [NCfile_name,~] = Read_file_name (Data_Path,2,type2);
    
    ROI_num = ROI_info(roi);
    %Nonz_MCI_DataPath = sprintf('/home/eunho/Documents/Nonz_MCI_ROI_index/Nonz_ROI_index_%d.mat',ROI_num);
    
    %% load template index
    % template index matrix name is 'find_index'
    load(sprintf('preprocessing/ROI_index/index_outImage_%d.img.mat',ROI_num));
        
    %% load data
    load(ADfile_name{roi,1});
    Data.AD = AD_vector_all;
    
    load(NCfile_name{roi,1});
    Data.NC = AD_vector_all;
    
    clear AD_vector_all;
    A_Data = cat(2,Data.AD,Data.NC);
    
    %% ttest
    P_value = [];
    nonzeroIdx = [];
    
    % num_sub = ceil(size(A_Data,2) * 50/100); %% 0 value select subject of 50%
    
    for ind = 1 : size(Data.AD,1)
        [~,P_value(ind)] = ttest2(Data.AD(ind,:), Data.NC(ind,:));
         P_value(isnan(P_value(ind))) = 1;
%         if size(find(A_Data(ind,:)==0),2) >= num_sub
%             nonzeroIdx(ind) = 0;
%         else
%             nonzeroIdx(ind) = 1;
%         end
        
    end
   
    %%       P_Rate is threshold value
    nonzP_value = (P_value<threshold)';
%     P_value = nonzP_value' .* P_value;
    Small_idx = find(nonzP_value~=0);

    thresh_idx = find_index(Small_idx);
    P_value = P_value(Small_idx);
        
    whole_idx = cat(1,whole_idx,thresh_idx);
    whole_Pval = cat(1, whole_Pval, P_value');
end
whole_Pval(:,2) = whole_idx';
Sorted_Pval = sortrows(whole_Pval,1);


end
% filename = opts.Thr_indexfile;

% clear thresh_idx Threshold_indexfile;



