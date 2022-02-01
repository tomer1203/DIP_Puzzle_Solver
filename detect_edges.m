clc;
clear;
close all;

num_of_pices = 4;
num_row = 2;
num_col = 2;
RGB = imread("img\pzl_4_3.jpg");
img = dip_gray_imread("img\pzl_4_3.jpg");
[seg_img,overlay,extent] = segmentation_tomer(img,3,0.5);

% BW = edge(img,"log");
figure
imshowpair(img,extent,'montage')
title("Edge detecting")
%%
[H,T,R] = hough(extent);
peaks = houghpeaks(H,num_of_pices*4);
lines = houghlines(extent,T,R,peaks);
% Filter the horizontal and vertical lines
theta_values = abs([lines.theta]);
filtered_lines = (theta_values > 80 & theta_values ...
    < 100) | (theta_values >= 0 & theta_values < 10);
straight_lines = lines(filtered_lines);
%%
figure, imshow(img), hold on
max_len = 0;
for k = 1:length(straight_lines)
   xy = [straight_lines(k).point1; straight_lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of straight_lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(straight_lines(k).point1 - straight_lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

%% Find corners and cutting the image
point1 = [straight_lines.point1];
point2 = [straight_lines.point2];
rows = zeros(length(point1),1);
columns = zeros(length(point1),1);

for i = 1:(length(point1)/2)
    rows(i) = point1(i*2-1);
    columns(i) = point1(i*2);
    rows(i+length(point1)/2) = point2(i*2-1);
    columns(i+length(point1)/2) = point2(i*2);
end

corners = zeros(4,1);
corners(1) = min(columns); % left
corners(2) = max(columns); % right
corners(3) = min(rows); % down
corners(4) = max(rows); % up

img_grid = RGB(corners(1):corners(2),corners(3):corners(4),:);
figure
imshow(img_grid);

%% Distribution the puzzle
[m,n] = size(img_grid);

