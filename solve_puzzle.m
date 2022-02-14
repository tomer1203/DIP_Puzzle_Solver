function solve_puzzle(num_of_pieces,num_row,num_col,cam)
%% initialize camera 
% start_ditection = 0;
%cam = webcam(2); % camera on
% preview(cam); % show camera output
%closePreview(cam); 

%% global vals
% while(start_ditection == 0)
%     % nothing
% end
global flag_stop

%% pre prossing

f = msgbox('please wait a few seconds');
noise = noise_val(cam); % it's take 1sec.

img_for_segmentation = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

built_puzzle_img = imread("img\pzl_12_p1.jpg"); %RGB_grid
%img_grid = grid_puzzle(built_puzzle_img,num_of_pieces);
img_grid = imread("img\pzl_12_p3.jpg");
[seg_img,puz_edges] = segmentation(img_for_segmentation,1,1,0.5,60);

% filt_size = 5, extent_const = 0.3
imgCell = cut_images(img_for_segmentation,seg_img,4,10);

for i = 1:4
piece = imgCell{i};
figure
imshow(piece);
[location,reliability] = matching_features(piece,img_grid,num_row,num_col);

fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
    ,i,location(1),location(2),reliability);
end
delete(f);


%% real time
while(~flag_stop)
close all    
f = msgbox('Choose puzzle piece');
tach_point = found_tach_point2(cam,noise);
centroids = center_of_mass(seg_img,[11,11],tach_point);
delete(f);

f = msgbox('Take out the choosen piece');

pause(10)
close all;
num_of_pieces = num_of_pieces -1;
delete(f);

if(num_of_pieces == 0) break; end
    
% pre prossing again
%f = msgbox('Please wait a few seconds');
img_for_segmentation = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

[seg_img,puz_edges] = segmentation(img_for_segmentation,1,1,0.5,60);


noise = noise_val(cam); % it's take 1sec. 
% segmentation
% fiture detection
%delete(f);
end

f = msgbox('The job is done');
pause(5)
delete(f);

end