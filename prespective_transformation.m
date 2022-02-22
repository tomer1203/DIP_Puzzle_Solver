function convrt_img=prespective_transformation(RGB)
%% global values
N=9; %filter for lower noise
extent_filter=0.9;
dialtion_size1=2;
dialtion_size2=3;
minQuality=0.1;
filterSize=9;
fuctor=0.04;
%%
ImgGray = double(im2gray(RGB));
I1 = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
% imshow(I)

I1=medfilt2(I1,[N,N]);
% imshow(I);
BW = edge(I1,'sobel',0.01,'both','thinning');
% imshow(BW)
dial = imdilate(BW,strel("rectangle",[dialtion_size1,dialtion_size1]));%**
extent = bwpropfilt(dial, 'Extent', [0, extent_filter]);

dial = imdilate(extent,strel("rectangle",[dialtion_size2,dialtion_size2]));%**
% imshow(dial)
mask = imfill(double(dial),8,"holes");
imgCell = cut_images(RGB,mask,1,10);




figure;
imshow(RGB);
[x,y]=ginput(4);

[N,M,~]=size(RGB);
fixedPoints = [0 0; M 0; M N; 0 N];
tform = fitgeotrans([x(1) y(1); x(2) y(2); x(3) y(3); x(4) y(4)],fixedPoints,'projective');
convrt_img = imwarp(RGB,tform,'OutputView',imref2d(size(RGB)));
convrt_img=flipdim(convrt_img,2);
end