

path = dir('./*.nii');
rotate = 'rotate_';


for i=1 : size(path,1)
    
    orig = load_nii(path(i,1).name);
    mriVolume = orig.img;
    
    new = orig;
    
    B = imrotate3(mriVolume,180,[0 0 1],'crop');
%     B = imresize3(mriVolume,[256,256,2]);
    new.img = B;
    
    % figure(1)
    % imagesc(squeeze(B(:,:,100)))
    % figure(2)
    % imagesc(squeeze(orig.img(:,:,100)))
    
    save_nii( new, [rotate, path(i,1).name] );
    
end