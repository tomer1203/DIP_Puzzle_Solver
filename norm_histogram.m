%% compere histograms between image :
%use matlab cose found in the web
% input: piece-     piece from the hole image; unormelized and RGB
%        RGB  -     unormelized and RGB refrencece image
%        num_row
%        num_col
%
%output: location- the assumed location of the puzzel piece in the image
%        relaibility- 

%notice : seperete_channle normelized the image
% 
% function [location,reliability] = norm_histogram(piece,RGB,num_row,num_col)
% 
% 
% 
% end
rgbImage=imread("pzl_12_p3.jpg");
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage, []);
axis on;
caption = sprintf('Original Color Image, %d rows by %d columns.', rows, columns);
title(caption, 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0, 0, 1, 1]);



smallSubImage = imread("p_6.jpg")
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage, []);
axis on;
caption = sprintf('Original Color Image, %d rows by %d columns.', rows, columns);
title(caption, 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0, 0, 1, 1]);
channelToCorrelate = 1;  % Use the red channel.
tic
correlationOutput = pdist2(smallSubImage(:,:,channelToCorrelate), rgbImage(:,:, channelToCorrelate));
toc









