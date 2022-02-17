clc
clear
close all

img=imread("img\temp_tests\15_pzl_webcam_test.jpg");
img_grid=imread("img\pzl_15_p3.jpg");
num_of_pieces=15;
num_row=3;
num_col=5;
dialtion_size1=1;
dialation_size2=2;
extent_filter=0.6;
center_size=20;
resize_factor=8;
show=false;
%noremelized and grayScale the images:

gray_grid = double(im2gray(img_grid));
gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));
if show
    figure
    imshow(gray_grid)
end
gray_img= double(im2gray(img));
gray_img = (gray_img- min(gray_img(:)))/(max(gray_img(:)) - min(gray_img(:)));
[seg_img,puz_edges] = segmentation(gray_img,dialtion_size1,dialation_size2,extent_filter,center_size);
imgCell = cut_images(img,seg_img,num_of_pieces,10);
%% features:
location_matrix_features=cell(num_row,num_col);
reliability_matrix_features=cell(num_row,num_col);
%% histograms
location_matrix_hist=cell(num_row,num_col);
reliability_matrix_hist=(cell(num_row,num_col));
%% 
location_matrix_shape=cell(num_row,num_col);
% piece = imgCell{9};
% piece=imresize(piece,resize_factor);
% A=4;

for i =1:num_of_pieces
    piece = imgCell{i};
    piece=imresize(piece,resize_factor);
    if (show)
        figure
        imshow(piece)
    end
    
    
    [location_features,reliability_features] = matching_features(piece,img_grid,num_row,num_col,show);
    [puzzel_shape loc_mat]=detect_pazzel_shape(piece,resize_factor)

    % fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
    %     ,i,location(1),location(2),reliability);
    location_matrix_features{location_features(2),location_features(1)}=[location_matrix_features{location_features(2),location_features(1)},i];
    reliability_matrix_features{location_features(2),location_features(1)}=[reliability_matrix_features{location_features(2),location_features(1)},reliability_features];
    location_matrix_shape{location_features(2),location_features(1)}=[location_matrix_shape{location_features(2),location_features(1)},puzzel_shape];
%     [location_hist,reliability_hist] = compere_histograms(piece,img_grid,num_row,num_col,show);
%     location_matrix_hist{location_hist(1),location_hist(2)}=[location_matrix_hist{location_hist(1),location_hist(2)},i];
%     reliability_matrix_hist{location_hist(1),location_hist(2)}=[reliability_matrix_hist{location_hist(1),location_hist(2)},reliability_hist];

end

(location_matrix_features)
(location_matrix_shape)


(reliability_matrix_features)
% (reliability_matrix_hist)