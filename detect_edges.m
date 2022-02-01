clc;
clear;
close all;

num_of_pices = 4;
img = dip_gray_imread("img\pzl_6_4.jpg");
BW = edge(img,"log");
figure
imshowpair(img,BW,'montage')
title("Edge detecting")

[H,T,R] = hough(BW);
peaks = houghpeaks(H,num_of_pices*4);
lines = houghlines(BW,T,R,peaks);

figure, imshow(img), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end