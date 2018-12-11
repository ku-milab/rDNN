function [Type1Sample_Data,Type2Sample_Data,imgLabel,patch_idx]= mainPatchExtractionFromMRI(patch_size ,type1,type2, pvalue_threshold,num_patch)
disp('Patch Extraction');
%%read file name
state = 1;   % state is option of Ranvens map (1) or ROI index (2)

[type1_fileName,type1file_size] = Read_file_name(Data_Path,state,type1);
[type2_fileName,type2file_size] = Read_file_name(state,type2);
% load(type1_fileName{1,1});
totalNumData = type1file_size + type2file_size;

imgLabel = zeros(2,totalNumData);
imgLabel(1, 1:type1file_size) = 1;
imgLabel(2, type1file_size+1:totalNumData) = 1;
imgLabel = imgLabel';

%% compute the pvalue
% perform statistical test
mriSubPvals = GroupDifference(pvalue_threshold,type1,type2); % ttest each group and 
%%
idx = mriSubPvals(:,2);
mriSigniticantVoxels = mriSubPvals(:,1);

[Type1Sample_Data,Type2Sample_Data,~,patch_idx] = PatchExtraction(idx,patch_size,type1_fileName,type2_fileName,num_patch);
