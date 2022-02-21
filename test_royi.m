clc
clear
close all
appGui=struct();
appGui.segParams = struct();
appGui.segParams.dial1=2;
appGui.segParams.dial2=7;
appGui.segParams.ext_filt=0.7;
appGui.segParams.center_size=45;
%% puzzel 24:
% img=imread("img\temp_tests\pzl_24_p2.jpg");%15_pzl_webcam_test.jpg
% img_grid=imread("img\pzl_24_p3.jpg");% pzl_15_p3.jpg
% num_of_pieces=24;
% num_row=4;
% num_col=6;
% dialtion_size1=1;
% dialation_size2=2;
% extent_filter=0.6;
% center_size=20;
% sigments_values=[1 4 0.6 30];
% resize_factor=4;
%% puzzel 20:
img=imread("img\temp_tests\20_1.jpg");%15_pzl_webcam_test.jpg
img_grid=imread("img\pzl_20_p3.jpg");% pzl_15_p3.jpg
num_of_pieces=20;
num_row=4;
num_col=5;
sigments_values=[1 3 0.7 50];
resize_factor=8;
%% puzzel 15:
% img=imread("img\temp_tests\15_pzl_webcam_test.jpg");%15_pzl_webcam_test.jpg
% img_grid=imread("img\pzl_15_p3.jpg");% pzl_15_p3.jpg
% num_of_pieces=15;
% num_row=3;
% num_col=5;
% sigments_values=[1 2 0.6 20];
% resize_factor=8;
%% puzzel 12:
% img=imread("img\temp_tests\pzl_12_p2.jpg");%15_pzl_webcam_test.jpg
% img_grid=imread("img\pzl_12_p3.jpg");% pzl_15_p3.jpg
% num_of_pieces=12;
% num_row=3;
% num_col=4;
% dialtion_size1=1;
% dialation_size2=2;
% extent_filter=0.6;
% center_size=20;
% sigments_values=[1 1 0.6 20];
% resize_factor=8;

show=false;


% segmenttion
gray_img= double(im2gray(img));
gray_img = (gray_img- min(gray_img(:)))/(max(gray_img(:)) - min(gray_img(:)));
%[seg_img,puz_edges] = segmentation(gray_img,dialtion_size1,dialation_size2,extent_filter,center_size);
[seg_img,puz_edges] = segmentation(gray_img,appGui.segParams.dial1,appGui.segParams.dial2,appGui.segParams.ext_filt,appGui.segParams.center_size);
% cut the image
imgCell = cut_images(img,seg_img,num_of_pieces,10);


tic

[location_matrix, reliability_matrix]=features_matrix_locations(img_grid,img,resize_factor,num_row,num_col,appGui,imgCell);

toc
disp(toc-tic+ "sec")

location_matrix_shape=cell(num_row,num_col);
for i =1:num_of_pieces
    piece = imgCell{i};
    piece=imresize(piece,resize_factor);
    if (show)
        figure
        imshow(piece)
    end
    
    roi=0;
    [location_features,reliability_features] = matching_features_surf(piece,img_grid,num_row,num_col,show,roi);
    [puzzel_shape loc_mat]=detect_pazzel_shape(piece,resize_factor);
    [A,B]=(find(location_matrix==i));
    location_matrix_shape{A,B}=puzzel_shape;
end
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

% piece = imgCell{9};
% piece=imresize(piece,resize_factor);
% A=4;

% [location,reliability] = compere_histograms(imgCell{10},img_grid,num_row,num_col,show)
for i =1:num_of_pieces
    piece = imgCell{i};
    piece=imresize(piece,resize_factor);
    if (show)
        figure
        imshow(piece)
    end
    
    roi=0;
    [location_features,reliability_features] = matching_features_surf(piece,img_grid,num_row,num_col,show,roi);
    [puzzel_shape loc_mat]=detect_pazzel_shape(piece,resize_factor);

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
pieces=imgCell{10};
pieces=imresize(pieces,resize_factor);
(reliability_matrix_features)
% (reliability_matrix_hist)