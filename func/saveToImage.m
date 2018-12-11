function saveToImage( fname, data, index )
templateHdrName = fullfile( '..', 'Template', 'jakob-label-axialdown-256_256_256.hdr' );
fid = fopen( templateHdrName, 'r' );
header = fread( fid, 'uint8' );
fclose( fid );

fid = fopen( [fname, '.hdr'], 'w' );
fwrite( fid, header );
fclose(fid);

templateImgName = fullfile( '..', 'Template', 'jakob-label-axialdown-256_256_256.img' );
fid = fopen( templateImgName, 'r' );
roiLabelImage = fread( fid, 'uint8' );
fclose( fid );

saveData = zeros( size(roiLabelImage) );
saveData(index) = data;
fid = fopen( [fname, '.img'], 'w' );
fwrite( fid, saveData );
fclose(fid);
