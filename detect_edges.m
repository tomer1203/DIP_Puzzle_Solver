function straight_lines = detect_edges(RGB,num_of_pices)

ImgGray = double(im2gray(RGB));
img = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
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

