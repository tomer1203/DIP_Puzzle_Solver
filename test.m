close all
clear;


cam = webcam(2)
preview(cam);
%closePreview(cam);
noise = noise_val(cam);
point = found_tach_point2(cam,noise);
imgg = snapshot(cam);
img = {};
for i = 1:10
  pause(0.1)
  imgg = snapshot(cam);
  img = [img,imgg ];
end

figure()
 for i = 1:10
    pause(0.1)
    imshow(img{i})
 end

path = "videos/20220201_122906.mp4"
tach_point = found_tach_point(path);








