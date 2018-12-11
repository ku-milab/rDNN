addpath(genpath('/home/eh/Desktop/ADNI/'));  % data path

templateHeader = 'jakob-label-axialdown-256_256_256.hdr';
templateImage = 'jakob-label-axialdown-256_256_256.img';
fid = fopen( templateImage, 'r' );
img = fread( fid, 'uint8' );
fclose( fid );

ADdir = dir('Nonz_AD_ROI_index/*.mat');
file_name = sort_nat({ADdir.name});
file_name = file_name';
file_size = size(file_name,1);
AD_Feature = [];
for i = 1 : size(file_name,1)
    OpenfileName = sprintf('Nonz_AD_ROI_index/%s',file_name{i,1});
    load(OpenfileName);
    
    meanF = mean(AD_vector_all,1);
    
    AD_Feature(i,:) = meanF;
    
end
% 
% for i = 1 : 256
%      A = RavensMap_AD(:,:,i);
%      imagesc(A);
%      pause(0.03);
% end
MCIdir = dir('Nonz_MCI_ROI_index/*.mat');
file_name = sort_nat({MCIdir.name});
file_name = file_name';
file_size = size(file_name,1);
MCI_Feature = [];
for i = 1 : size(file_name,1)
    OpenfileName = sprintf('Nonz_MCI_ROI_index/%s',file_name{i,1});
    load(OpenfileName);
    
    meanF = mean(MCI_vector_all,1);
    
    MCI_Feature(i,:) = meanF;
    
end

NCdir = dir('Nonz_NC_ROI_index/*.mat');
file_name = sort_nat({NCdir.name});
file_name = file_name';
file_size = size(file_name,1);
NC_Feature = [];
for i = 1 : size(file_name,1)
    OpenfileName = sprintf('Nonz_NC_ROI_index/%s',file_name{i,1});
    load(OpenfileName);
    
    meanF = mean(NC_vector_all,1);
    
    NC_Feature(i,:) = meanF;
end