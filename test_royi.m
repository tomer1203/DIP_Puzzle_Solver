img=imread("img\12_pzl_webcam_ref.jpg");
I=prespective_transformation(img);
imwrite(I,"img\12_pzl_webcam_ref_resize.jpg")
figure;
montage({img,I});
points = detectSURFFeatures(im2gray(I));
figure;
imshow(I); hold on;
plot(points);
hold off
