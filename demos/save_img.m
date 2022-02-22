cam = webcam(2);
% cam.Brightness = ;
preview(cam);
pause(3);
img = snapshot(cam);
% corrected_img =prespective_transformation(img);
imshow(img);
imwrite(img,"4_ref.jpg");