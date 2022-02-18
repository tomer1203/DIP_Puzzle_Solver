function points_bin = clean_featurse(pieces,featurse)
pieces_bin = pieces > 0.05;
pieces_fil = imboxfilt(double(pieces_bin),51);
pieces_bin = pieces_fil > 0.9 ;
% figure()
% imshow(pieces_bin)
featurse = floor(featurse);

points_bin = pieces_bin(featurse(:,2)+featurse(:,1)*size(pieces_bin,1))~=0;




end