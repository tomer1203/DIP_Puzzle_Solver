clc;
clear;
close all;

num_of_pieces = 6;
num_row = 2;
num_col = 3;
RGB = imread("img\pzl_6_4.jpg");
RGB_grid = imread("img\pzl_24_5.jpg");
img_grid = grid_puzzle(RGB_grid,num_of_pieces);

%% Take the piece
[seg_img,overlay,extent] = segmentation_tomer(RGB,5,0.3); 
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
end