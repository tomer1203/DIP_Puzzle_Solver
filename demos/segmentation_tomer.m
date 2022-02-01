function [seg_img,overlay,extent] = segmentation_tomer(img,filt_size,extent_const)% filt_size = 3, extent_const = 0.5
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
    
    % imshow(BW);
    % imshow(dial);
    % imshow(solidity);
%     imshow(extent);
    % imshow(imfill(extent,"holes"));
    % imshow(imfill(imfill(solidity,'holes'),"holes"));
    I = im2gray(im2single(img));
    evolved = activecontour(I,extent,200,"Chan-vese","ContractionBias",-0.1,"SmoothFactor",0.6);
    filled = imfill(evolved,"holes");
%     imshow(evolved);
%     imshow(filled);
    overlay = labeloverlay(img,filled);
    seg_img = filled;
%     imshow(C);
end