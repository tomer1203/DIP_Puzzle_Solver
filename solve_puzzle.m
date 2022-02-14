function solve_puzzle(num_of_pieces,num_row,num_col,cam,app)
%% initialize camera 
% start_ditection = 0;
%cam = webcam(2); % camera on
% preview(cam); % show camera output
%closePreview(cam); 

%% global vals
global flag_stop

%% pre prossing
msg = ['please wait a few seconds'];
f = uiprogressdlg(app.UIFigure,'Title','Proccesing','Message',msg,'Indeterminate','on');
noise = noise_val(cam); % it's take 1sec.

img_for_segmentation = snapshot(cam); %RGB
ImgGray = double(rgb2gray(img_for_segmentation));
img_for_segmentation = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

built_puzzle_img = imread("img\pzl_12_p1.jpg"); %RGB_grid
% img_grid = grid_puzzle(built_puzzle_img,num_of_pieces);
img_grid = imread("img\pzl_12_p3.jpg");
[seg_img,puz_edges] = segmentation(img_for_segmentation,2,5,0.5,60);

% filt_size = 5, extent_const = 0.3
imgCell = cut_images(img_for_segmentation,seg_img,4,10);

for i = 1:1
    piece = imgCell{i};
    figure
    imshow(piece);
    [location,reliability] = matching_features(piece,img_grid,num_row,num_col);
    
    fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
        ,i,location(1),location(2),reliability);
end
% delete(f);
close(f);


%% real time
while(~flag_stop)
    close all    

    app.Label.Text = 'Choose puzzle piece';
    app.Label.Visible = 'on';
%     f = uiconfirm(fig,'Choose puzzle piece','Proccesing','Icon','info');
    tach_point = found_tach_point2(cam,noise);
    centroids = center_of_mass(seg_img,[11,11],tach_point);
    labled = bwlabel(bwareafilt(logical(seg_img),[500,999999]));
    label = labled(floor(centroids(2)),floor(centroids(1)));
    if (label == 0)
       disp("WARNING DID NOT FIND LABEL");
    end
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
    mask_cut = temp(r_low:r_high,c_low:c_high);
    figure;
    imshow(mask_cut);
    app.Label.Visible = 'off';
%     delete(f);
%     close(f);
    
    [location,reliability] = matching_features(img_cut,img_grid,num_row,num_col);
    
    fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
        ,i,location(1),location(2),reliability);    
%     f = msgbox('Take out the choosen piece');
    textLabel = sprintf("The location for the piece is (%d,%d). Take out " + ...
        "the choosen piece",location(1),location(2));
    app.Label.Text = textLabel;
    app.Label.Visible = 'on';
    take_peice_out(cam,noise);
    close all;
    num_of_pieces = num_of_pieces -1;
%     delete(f);

    
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

    
    %f = msgbox('The job is done');
    %pause(5)
    %delete(f);
    uialert(app.UIFigure,msg,'The job is done','Icon','success');


end