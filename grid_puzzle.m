clc;
clear;
close all;

num_of_pices = 4;
img = dip_gray_imread("img\pzl_4_3.jpg");
[seg_img,overlay,extent] = segmentation_tomer(img,3,0.5);

corners = detectHarrisFeatures(extent);
imshow(img); hold on;
plot(corners.selectStrongest(20));