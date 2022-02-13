function solve_puzzle(num_of_pieces,num_row,num_col)
%% initialize camera 

cam = webcam(2); % camera on
preview(cam); % show camera output
%closePreview(cam); 

%% global vals


%% pre prossing

f = msgbox('please wait a few seconds');
noise = noise_val(cam); % it's take 1sec.

img_for_segmentation = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

built_puzzle_img = imread("img\pzl_12_p1.jpg"); %RGB_grid
%img_grid = grid_puzzle(built_puzzle_img,num_of_pieces);
img_grid = imread("img\pzl_12_p3.jpg");
[seg_img,puz_edges] = segmentation(img_for_segmentation,1,2,0.3,60);
figure
imshow(seg_img);
% filt_size = 5, extent_const = 0.3
imgCell = cut_images(img_for_segmentation,seg_img,2,10);

% for i = 1:num_of_pieces
% piece = imgCell{i};
% figure
% imshow(piece);
% [location,reliability] = matching_features(piece,img_grid,num_row,num_col);
% 
% fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%     ,i,location(1),location(2),reliability);
% end
% fiture detection

piece = imgCell{1};
figure
imshow(piece);
[location,reliability] = matching_features(piece,img_grid,num_row,num_col);

fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
    ,1,location(1),location(2),reliability);

delete(f);


%% real time
while(1)
close all    
f = msgbox('Choose puzzle piece');
tach_point = found_tach_point2(cam,noise);
% take tach_point and return the choosen piece.
% take choosen piece and return it place.
delete(f);

f = msgbox('Take out the choosen piece');
% check movement and wait few seconds.
num_of_pieces = num_of_pieces -1;
delete(f);

if(num_of_pieces == 0) break; end
    
% pre prossing again
f = msgbox('Please wait a few seconds');
img_for_segmentation = snapshot(cam); %RGB
noise = noise_val(cam); % it's take 1sec. 
% segmentation
% fiture detection
delete(f);
end

f = msgbox('The job is done');
pause(5)
delete(f);

end