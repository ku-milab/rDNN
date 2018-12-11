function [ADBox,NCBox,Sample_idx] = Sample_Box(Idx,opts)

%% Make all to one of W-index
Sample_idx = [];
% for set=1 : opts.num_Sample
%     Sample_idx(:,set) = single(datasample(Idx,opts.rVoxel_IdxNum));
% end

Sample_idx = reshape(datasample(Idx,opts.rVoxel_IdxNum*opts.num_Sample),[opts.rVoxel_IdxNum,opts.num_Sample]);
clear set;

% AD
for s=1 : opts.Filename.ADsize % load AD Data and making block
    load(sprintf('%s',opts.Filename.AD{s}));
    temp = RavensMap_AD(Sample_idx);
    ADBox(:,:,s) = temp;
end

clear temp ADSample_Block;
% NC
for s =1 : opts.Filename.NCsize %load NC data
    load(sprintf('%s',opts.Filename.NC{s}));
    temp = RavensMap_NORMAL(Sample_idx);
    NCBox(:,:,s) = temp;
end


clear thresh_idx;

end

% Brain region x -> 55~ 201 y -> 38 ~ 217  z -> 26 ~ 165