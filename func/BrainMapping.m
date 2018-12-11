% To load *.hdr/*.img image
templateHeader = 'jakob-label-axialdown-256_256_256.hdr';
templateImage = 'jakob-label-axialdown-256_256_256.img';
fid = fopen( templateImage, 'r' );
img = fread( fid, 'uint8' );
fclose( fid );

labelImg3D = reshape( img, [256, 256, 256] );

% labels = unique(labelImg3D);
load ROI_num2.mat

%%
%% NC
newNCbrain = zeros(size(img,1),1);
for i = 1 : size(SVM_weight,2)
    newNCbrain((img==labels(i))) = NC(i);
end
newNCbrain = reshape( newNCbrain, [256, 256, 256] );
newNCbrain = newNCbrain*100;
% To save image header
outHeader = 'brain/NC_brain.hdr';
fid = fopen( templateHeader, 'r' );
hrd = fread( fid, 'uint8' );
fclose( fid );
fid = fopen( outHeader, 'w' );
fwrite( fid, hrd, 'uint8' );
fclose( fid );

% To save image data
outImage = 'brain/NC_brain.img';
imgnew = newNCbrain;
fid = fopen( outImage, 'w' );
fwrite( fid, imgnew, 'uint8' );
fclose( fid );
%% AD
newADbrain = zeros(size(img,1),1);
for i = 1 : size(SVM_weight,2)
    newADbrain((img==labels(i))) = AD(i);
end

newADbrain = reshape( newADbrain, [256, 256, 256] );
newADbrain = newADbrain*100;
% To save image header
outHeader = 'brain/AD_brain.hdr';
fid = fopen( templateHeader, 'r' );
hrd = fread( fid, 'uint8' );
fclose( fid );
fid = fopen( outHeader, 'w' );
fwrite( fid, hrd, 'uint8' );
fclose( fid );

% To save image data
outImage = 'brain/AD_brain.img';
newADbrain = newADbrain;
fid = fopen( outImage, 'w' );
fwrite( fid, newADbrain, 'uint8' );
fclose( fid );



m