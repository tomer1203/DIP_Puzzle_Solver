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

%noremelized and grayScale the images:

gray_grid = double(im2gray(img_grid));
gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));

gray_img= double(im2gray(img));
gray_img = (gray_img- min(gray_img(:)))/(max(gray_img(:)) - min(gray_img(:)));
[seg_img,puz_edges] = segmentation(gray_img,dialtion_size1,dialation_size2,extent_filter,center_size);
imgCell = cut_images(img,seg_img,num_of_pieces,10);


for i =1:num_of_pieces
piece = imgCell{i};
piece=imresize(piece,resize_factor);
figure
imshow(piece)
% classify_piece(piece,num_of_pieces);
[location,reliability] = matching_features(piece,img_grid,num_row,num_col);
fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
    ,i,location(1),location(2),reliability);
end

