function solve_puzzle(num_of_pieces,num_row,num_col,cam,appGui)
%% initialize camera 
% start_ditection = 0;
%cam = webcam(2); % camera on
% preview(cam); % show camera output
%closePreview(cam); 
%% global vals
global flag_stop
global points2
points2 = 0;
points2_flag = 0;
f2 = 0;
vpts2 = 0;
%% camera adjustments
% cam.Brightness = 120;
%  cam.FocusMode   = 'manual';
% cam.Contrast = 31;
% cam.Exposure = -4;
% cam.Resolution='1920x1080';
%% pre prossing
msg = ['please wait a few seconds'];
f = uiprogressdlg(appGui.UIFigure,'Title','Proccesing','Message',msg,'Indeterminate','on');

% in_metrix = magic(5);
img_for_segmentation_rgb = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation_rgb));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

% img_for_segmentation_rgb_copy = img_for_segmentation_rgb;

% img_grid = grid_puzzle(built_puzzle_img,num_of_pieces);
% dialtion_size1=appGui.segParams.dial1;
% dialation_size2=appGui.segParams.dial2 ;
% extent_filter=appGui.segParams.ext_filt ;
% center_size=appGui.segParams.center_size;
returnValue = -1;
while(returnValue == -1)
    img_for_segmentation_rgb = snapshot(cam); %RGB
    ImgGray = double(rgb2gray(img_for_segmentation_rgb));
    img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

    [seg_img,~] = segmentation(img_for_segmentation,appGui.segParams.dial1,appGui.segParams.dial2,appGui.segParams.ext_filt ,appGui.segParams.center_size);
    figure;
    imshow(seg_img);
    [returnValue,imgCell] = cut_images(img_for_segmentation_rgb,seg_img,num_of_pieces,10,appGui);
end
figure;
imshow(seg_img);
img = snapshot(cam);
img_grid = imread(appGui.img);
% num_of_pieces = 24;
% num_row = 4;
% num_col = 6;
% sigments_values = [1 2 0.6 20];
resize_factor = 8;


%out_metrix = next_pieces(seg_img,in_metrix);

%imshow(seg_img,'Parent',appGui.appSettings.UIAxesSeg);


% filt_size = 5, extent_const = 0.3
Cell_features = {};
Cell_vpts = {};

imgCell = imgCell(:,1);
tic;
[location_matrix, reliability_matrix] = features_matrix_locations(img_grid,img,resize_factor,num_row,num_col,appGui,imgCell);
toc;
in_metrix = location_matrix;
num_of_imgs = size(imgCell);
tic;
for i = 1:num_of_imgs(1)
    imgCell{i} = imresize(imgCell{i},resize_factor);
    [features,vpts] = pull_features(imgCell{i},true,false,true);
    Cell_features{i} = features;
    Cell_vpts{i} = vpts;
end
toc;
% for i = 1:24
%     piece_1 = imgCell_1{i};
%     piece_1 = imresize(piece_1,8);
%   
% 
%     [location,reliability,f2,vpts2] = matching_features(piece_1,img_grid,num_row,num_col,points2_flag,0,f2,vpts2);
%     points2_flag = 0;
%     
%     fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%         ,i,location(1),location(2),reliability);
% 
% close all
% end
close(f);

i = 1;
%% real time
while(~flag_stop)
    %tic 
    %timerVal = tic
    appGui.Label.Text = 'Choose puzzle piece';
    appGui.Label.Visible = 'on';
%     f = uiconfirm(fig,'Choose puzzle piece','Proccesing','Icon','info');
    tuch_point = 0;
    tuch_point = found_tach_point2(cam);
    while(tuch_point == 0)         
         appGui.Label.Text = 'Choose puzzle piece again';
         tuch_point = found_tach_point2(cam);
    end

    centroids = center_of_mass(seg_img,[11,11],tuch_point,appGui);

    labled = bwlabel(bwareafilt(logical(seg_img),[500,999999]));
    label = labled(floor(centroids(2)),floor(centroids(1)));
    if (label == 0)
        textLabel = sprintf("Finding Label Failed Please Select a New peice");
        app.Label.Text = textLabel;
        app.Label.Visible = 'on';
    else
        temp = labled==label;
        [r,c]=find(labled==label);
        padding = 20;
        temp2 = img_for_segmentation_rgb.*cast(temp,"like",img_for_segmentation_rgb);
        % add padding to the edges of the images
        r_low = max(min(r)-padding,1);
        r_high = min(max(r)+padding,size(temp,1));
        c_low = max(min(c)-padding,1);
        c_high = min(max(c)+padding,size(temp,2));
        
        img_cut = temp2(r_low:r_high,c_low:c_high,:); % The choosen peice 
        figure;
        imshow(img_cut);
        app.Label.Visible = 'off';
        
        img_cut = imresize(img_cut,8);
        [label,reliability] = find_piece_label(img_cut,imgCell,Cell_features,Cell_vpts);
        figure;
        
        imshow(imgCell{label});
        [x,y] = find(location_matrix == label);
        
%         fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%             ,i,location(1),location(2),reliability);
%         textPrint = sprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%             ,i,location(1),location(2),reliability);
%         appGui.appSettings.CoordinateandRealibiltyLabel.Text = textPrint;
        textLabel = sprintf("The location for the piece is (%d,%d). Take out " + ...
            "the choosen piece",y,x);
        appGui.Label.Text = textLabel;

        %appGui.Label.Text = textLabel;
        appGui.Label.Visible = 'on';
        take_peice_out(cam,appGui,num_of_pieces);
        close all;
        num_of_pieces = num_of_pieces -1;

    
        if(num_of_pieces == 0)
            break; 
        end

    end
    % preprocessing again
    img_for_segmentation_rgb = snapshot(cam); %RGB
    ImgGray = double(rgb2gray(img_for_segmentation_rgb));
    img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
    

    %imshow(seg_img,'Parent',appGui.appSettings.UIAxesSeg);

    %noise = noise_val(cam); % it's take 1sec. 
    i = i+1;
    %in_metrix = next_pieces(seg_img,in_metrix,centroids);
   [seg_img,~] = segmentation(img_for_segmentation,appGui.segParams.dial1,appGui.segParams.dial2,appGui.segParams.ext_filt ,appGui.segParams.center_size);
end

  
    msg = ['You can go to the sea'];
    uialert(appGui.UIFigure,msg,'The job is done','Icon','success');


end