clc;
clear;
close all;
%'../image_pices_test\pzl_12_7_1.jpg'
num_of_pieces = 12;
num_row = 3;
num_col = 4;
RGB = imread("img\pzl_12_p2.jpg");

ImgGray = double(im2gray(RGB));
I = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
% I2 = imadjust(I);
% figure
% montage({I,I2,RGB})
RGB_grid = imread("img\pzl_12_p1.jpg");
% RGB_grid = imsharpen(RGB_grid);
img_grid = grid_puzzle(RGB_grid,num_of_pieces);

%% Take the piece
[seg_img,puz_edges] = segmentation(I,2,5,0.3,60);
figure
imshow(seg_img);
% filt_size = 5, extent_const = 0.3
imgCell = cut_images(RGB,seg_img,num_of_pieces,10);

%%
for i = 1:num_of_pieces
piece = imgCell{i};
[location,reliability] = matching_features(piece,img_grid,num_row,num_col);
fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
    ,i,location(1),location(2),reliability);
[location_corr,reliability_corr] = correlation(piece,RGB_grid,num_row,num_col);      %add by royi
fprintf("CORRELATION\n")
fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...             %add by royi
    ,i,location_corr(1),location_corr(2),reliability_corr);                          %add by royi

end