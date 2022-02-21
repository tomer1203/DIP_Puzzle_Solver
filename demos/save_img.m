cam = webcam(2);
% cam.Brightness = ;
preview(cam);
img = snapshot(cam);
% corrected_img =prespective_transformation(img);
imshow(img);
imwrite(img,"20_2.jpg");