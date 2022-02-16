function solve_puzzle(num_of_pieces,num_row,num_col,cam,appGui)
%% initialize camera 
% start_ditection = 0;
%cam = webcam(2); % camera on
% preview(cam); % show camera output
%closePreview(cam); 

%% global vals
global flag_stop
%% camera adjustments
% cam.Brightness = 120;
% cam.Focus      = 0;
% cam.Contrast = 31;
% cam.Exposure = -4;
% cam.Resolution='1920x1080';
%% pre prossing
msg = ['please wait a few seconds'];
f = uiprogressdlg(appGui.UIFigure,'Title','Proccesing','Message',msg,'Indeterminate','on');
noise = noise_val(cam); % it's take 1sec.

img_for_segmentation_rgb = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation_rgb));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

% img_grid = grid_puzzle(built_puzzle_img,num_of_pieces);
img_grid = imread(appGui.img);
[seg_img,~] = segmentation(img_for_segmentation,1,1,0.7,40);

%imshow(seg_img,'Parent',appGui.appSettings.UIAxesSeg);


% filt_size = 5, extent_const = 0.3
imgCell = cut_images(img_for_segmentation_rgb,seg_img,12,10);

for i = 1:10
    piece = imgCell{i};
    piece = imresize(piece,5);
    figure
    imshow(piece);
    [location,reliability] = matching_features(piece,img_grid,num_row,num_col,1);
    
    fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
        ,i,location(1),location(2),reliability);
end
close(f);

i = 1;
%% real time
while(~flag_stop)
    close all    

    appGui.Label.Text = 'Choose puzzle piece';
    appGui.Label.Visible = 'on';
%     f = uiconfirm(fig,'Choose puzzle piece','Proccesing','Icon','info');
    tuch_point = 0;
    tuch_point = found_tach_point2(cam,noise);
    while(tuch_point == 0)         
         appGui.Label.Text = 'Choose puzzle piece again';
         tuch_point = found_tach_point2(cam,noise);
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
        temp2 = img_for_segmentation.*cast(temp,"like",img_for_segmentation);
        % add padding to the edges of the images
        r_low = max(min(r)-padding,1);
        r_high = min(max(r)+padding,size(temp,1));
        c_low = max(min(c)-padding,1);
        c_high = min(max(c)+padding,size(temp,2));
        
        img_cut=temp2(r_low:r_high,c_low:c_high,:);
        % mask_cut = temp(r_low:r_high,c_low:c_high);
        % figure;
        % imshow(mask_cut);
        app.Label.Visible = 'off';
    %     delete(f);
    %     close(f);
        
    
        img_cut = imresize(img_cut,5);
        img_cut(img_cut==0) = -1;
        [location,reliability] = matching_features(img_cut,img_grid,num_row,num_col,1);
        
        
        fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
            ,i,location(1),location(2),reliability);
        textPrint = sprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
            ,i,location(1),location(2),reliability);
        appGui.appSettings.CoordinateandRealibiltyLabel.Text = textPrint;
    %     f = msgbox('Take out the choosen piece');
        textLabel = sprintf("The location for the piece is (%d,%d). Take out " + ...
            "the choosen piece",location(1),location(2));
        appGui.Label.Text = textLabel;
        appGui.Label.Visible = 'on';
        take_peice_out(cam,noise);
        close all;
        num_of_pieces = num_of_pieces -1;
    %     delete(f);
    
        if(num_of_pieces == 0)
            break; 
        end
    end
    % preprocessing again
    img_for_segmentation_rgb = snapshot(cam); %RGB
    ImgGray = double(rgb2gray(img_for_segmentation_rgb));
    img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
    

    [seg_img,~] = segmentation(img_for_segmentation,1,1,0.7,40);
    %imshow(seg_img,'Parent',appGui.appSettings.UIAxesSeg);

    noise = noise_val(cam); % it's take 1sec. 
    %delete(f);
    i = i+1;
end

    
    %f = msgbox('The job is done');
    %pause(5)
    %delete(f);
    uialert(appGui.UIFigure,msg,'The job is done','Icon','success');


end