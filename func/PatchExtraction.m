% make sample block
% Center_point_axis : center point of cube
% cube_size : patch cube size
%%
function [ADSample_Block,NCSample_Block,selected_idx,patch_idx] = PatchExtraction(idx,patch_size,type1_fileName,type2_fileName,num_patch)
fprintf('indexed the data\n');

%% voxel axis
                % % % % % % % Box_Cpoint_axis = voxel_Coord(idx(:));
Center_point_axis = zeros(size(idx,1),3);
[Center_point_axis(:,1),Center_point_axis(:,2),Center_point_axis(:,3)] = ind2sub([256,256,256],idx(:));

%% select patches 
Hc_size = (patch_size-1)/2;

[patch_idx, selected_idx] = selectPatches(Center_point_axis, Hc_size);
% num_patches =  100; %size(patches,1);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% cube of Smaple
for s=1 : size(type1_fileName,1)
    load(sprintf('%s',type1_fileName{s}));
    for p = 1 : num_patch %size(patches,1);
        temp = RavensMap_AD(patch_idx(p,1):patch_idx(p,2),patch_idx(p,3):patch_idx(p,4),patch_idx(p,5):patch_idx(p,6));
        ADSample_Block{s,1}{p,1} = temp;
    end 
end
clear temp;

% NC
for s=1 : size(type2_fileName,1)
    load(sprintf('%s',type2_fileName{s}));
    for p = 1 : num_patch %size(patches,1)
        temp = RavensMap_NORMAL(patch_idx(p,1):patch_idx(p,2),patch_idx(p,3):patch_idx(p,4),patch_idx(p,5):patch_idx(p,6));
        NCSample_Block{s,1}{p,1} = temp;
    end
end

% %% patch save
% for pat = 1 : num_patches
%     SPatches{:,1} = cat(1,ADSample_Block{:,1}{pat,1},NCSample_Block{:,1}{pat,1});
%     save(sprintf('Patch/Patch_N%d',pat),'SPatches');
% end