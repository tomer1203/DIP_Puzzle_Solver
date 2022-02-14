function convrt_img=prespective_transformation(I)
[x,y]=find_corner(I);
figure;
imshow(I);
hold on;
plot(x,y);
hold off;
[N,M,~]=size(I);
fixedPoints = [0 0; M 0; M N; 0 N];
tform = fitgeotrans([x(1) y(1); x(2) y(2); x(3) y(3); x(4) y(4)],fixedPoints,'projective');
convrt_img = imwarp(I,tform,'OutputView',imref2d(size(I)));
convrt_img=flipdim(convrt_img,2);
end