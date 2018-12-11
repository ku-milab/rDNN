function Template_ROI_idx = Load_Tmplate_idx(template_name, ROI_info)

templateHeader = sprintf('%s.hdr',template_name);
templateImage = sprintf('%s.img',template_name);
fid = fopen( templateImage, 'r' );
template_img = fread( fid, 'uint8' );
fclose( fid );

for roi = 1 : size(ROI_info,1)
    Template_ROI_idx{roi,1} = find(template_img == ROI_info(roi));
end

end
