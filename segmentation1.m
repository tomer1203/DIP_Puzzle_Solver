% img= Normalized image in grayscale for segmentation.
% dialation_size = increases the boldness of the lines def = 2
% dialation_size2 = increases the boldness of the lines def = 5
% extent_filter= filter segments according to their density(extent) def=0.3
% center_size= a size representing how large to make the center of each
% puzzle piece which is later used to seperate glued puzzle pieces def=60
function [seg_img,puz_edges] = segmentation1(img,dialtion_size1,dialation_size2,extent_filter,center_size)%def=(img,2,5,0.3,60)
    % instead of using edges we use image gradients since they are more
    show=true;
    % consistent 
    BW= imgradient(img)>0.2;
%     figure;
%     imshow(BW);
    % increase size of lines so that all the edge lines will get consistent
    dial = imdilate(BW,strel("rectangle",[dialtion_size1,dialtion_size1]));

    % filter out the edges according to their extent. this removes most of
    % the noise
    extent = bwpropfilt(dial, 'Extent', [0, extent_filter]);
%     figure;
%     imshow(extent);
    % another final dilation to hopefully close all puzzle lines
    puz_edges = imdilate(extent,strel("rectangle",[dialation_size2,dialation_size2]));

    % fill the shape edges to get a good segmentation
    mask = imfill(double(puz_edges),8,"holes");
    % possible to add erosion here
    mask = imerode(mask,strel("rectangle",[dialation_size2,dialation_size2]));
    if(show)
        figure;
        imshow(BW);
        title("BW")
        figure;
        imshow(extent);
        title("extent")
        figure;
        imshow(mask);
        title("MASK")
    end
    % this part cuts off glued pieces.
    distTrans = -bwdist(~mask);
    extended_dist = imextendedmin(distTrans,center_size);
    D2 = imimposemin(distTrans,extended_dist);
    Ld2 = watershed(D2);
    seg_img = mask;
    seg_img(Ld2 == 0) = 0;
%     figure;
%     imshow(seg_img);
end
