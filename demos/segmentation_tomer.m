function [seg_img,overlay,extent] = segmentation_tomer(img,filt_size,extent_const)% filt_size = 5, extent_const = 0.3
%     RGB=imread("..\img\pzl_6_2.jpg");
%     imshow(RGB)
    % RGB = imread('kobi.png');
    % RGB=imresize(RGB,0.1);
    
%     img=dip_GN_imread("..\img\pzl_6_2.jpg");
    ImgGray = double(im2gray(img));
    ImgNormal = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

    BW=edge(ImgNormal,"prewitt");
    % imshow(imclose(BW,strel("rectangle",[2,2])));
    
    dial = imdilate(BW,strel("rectangle",[filt_size,filt_size]));
%     solidity = bwpropfilt(dial, 'Solidity', [0, 0.5]);
    extent = bwpropfilt(dial, 'Extent', [0, extent_const]);
    ext_dial = imdilate(extent,strel("rectangle",[20,20]));


% imshow(area_filter);
% imshow(imfill(area_filter,"holes"));
% imshow(imfill(area_filter,8,"holes"));
% imshow(imfill(extent,"holes"));
% imshow(imfill(imfill(solidity,'holes'),"holes"));
% I = im2gray(im2single(img));
% evolved = activecontour(I,ext_dial,10,"Chan-vese","ContractionBias",-0.1);
mask = imfill(double(ext_dial),8,"holes");
mask = imerode(mask,strel("rectangle",[10,10]));
%     imshow(evolved);
%     imshow(filled);
    overlay = labeloverlay(img,mask);
    seg_img = mask;
%     imshow(C);
end