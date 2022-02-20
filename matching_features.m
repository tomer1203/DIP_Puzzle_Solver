function [location,reliability,f2,vpts2] = matching_features(piece,img_grid,num_row,num_col,points2_flag,app,f2,vpts2,R_roi)
%global value for features
MetricThreshold=100;               %default 1000. decerase the tradhold- more features
NumOctaves=4;                       %default 3 . recommend: 1-4 . increase the numOctuves- more features
NumScaleLevels=6;                   %default 4. recommend  3-6 .increase the numScaleLevel- more features 
roi=1;
uniq=true;
grayScale = false;
show=true;
show1=false;
%
if (R_roi==0)
    roi=[1,1,size(img_grid,2),size(img_grid,1)];
else
    roi=R_roi;
end
%

% pieces = double(im2gray(piece));
% pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
%gray_grid = double(im2gray(img_grid));
%gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));

gray_grid_4 = double(im2gray(img_grid));
gray_grid_4 = (gray_grid_4 - min(gray_grid_4(:)))/(max(gray_grid_4(:)) - min(gray_grid_4(:)));


if(points2_flag == 0)
    disp("Calculating grid");
    gray_grid_4 = double(im2gray(img_grid));    
    gray_grid_4 = (gray_grid_4 - min(gray_grid_4(:)))/(max(gray_grid_4(:)) - min(gray_grid_4(:)));
    points2_4 = detectSURFFeatures(gray_grid_4,MetricThreshold=MetricThreshold,NumOctaves=NumOctaves,NumScaleLevels=NumScaleLevels);
    %    points2_4 = detectSIFTFeatures(gray_grid_4,Sigma=1.2);
    [f2d,vpts2d] = extractFeatures(gray_grid_4,points2_4,"Method","SURF");

    if (~grayScale)
        gray_grid_1 = double(img_grid(:,:,1));
        gray_grid_2 = double(img_grid(:,:,2));
        gray_grid_3 = double(img_grid(:,:,3));
        gray_grid_1 = (gray_grid_1 - min(gray_grid_1(:)))/(max(gray_grid_1(:)) - min(gray_grid_1(:)));
        gray_grid_2 = (gray_grid_2 - min(gray_grid_2(:)))/(max(gray_grid_2(:)) - min(gray_grid_2(:)));
        gray_grid_3 = (gray_grid_3 - min(gray_grid_3(:)))/(max(gray_grid_3(:)) - min(gray_grid_3(:)));
        points2_1 = detectSURFFeatures(gray_grid_1,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
        points2_2 = detectSURFFeatures(gray_grid_2,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
        points2_3 = detectSURFFeatures(gray_grid_3,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
        [f2a,vpts2a] = extractFeatures(gray_grid_1,points2_1,"Method","SURF");
        [f2b,vpts2b] = extractFeatures(gray_grid_2,points2_2,"Method","SURF");
        [f2c,vpts2c] = extractFeatures(gray_grid_3,points2_3,"Method","SURF");
        f2 = [f2a;f2b;f2c;f2d];
        vpts2 = [vpts2a;vpts2b;vpts2c;vpts2d];
    else
        f2 = [f2d];
        vpts2 = [vpts2d];
    end
end
tic;

piece = imsharpen(piece,'Radius',10,'Amount',1);
piece_4 =  double(im2gray(piece)); 
piece_4 = (piece_4 - min(piece_4(:)))/(max(piece_4(:)) - min(piece_4(:)));
points1_4 = detectSURFFeatures(piece_4,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
[f1d,vpts1d] = extractFeatures(piece_4,points1_4,"Method","SURF");

if (~grayScale)
    piece_1 = double(piece(:,:,1));
    piece_2 = double(piece(:,:,2));
    piece_3 = double(piece(:,:,3));
    piece_1 = (piece_1 - min(piece_1(:)))/(max(piece_1(:)) - min(piece_1(:)));
    piece_2 = (piece_2 - min(piece_2(:)))/(max(piece_2(:)) - min(piece_2(:)));
    piece_3 = (piece_3 - min(piece_3(:)))/(max(piece_3(:)) - min(piece_3(:)));
    % Find and matching features
    points1_1 = detectSURFFeatures(piece_1,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
    points1_2 = detectSURFFeatures(piece_2,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
    points1_3 = detectSURFFeatures(piece_3,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
    [f1a,vpts1a] = extractFeatures(piece_1,points1_1,"Method","SURF");
    [f1b,vpts1b] = extractFeatures(piece_2,points1_2,"Method","SURF");
    [f1c,vpts1c] = extractFeatures(piece_3,points1_3,"Method","SURF");

    f1 = [f1a;f1b;f1c;f1d];
    vpts1 = [vpts1a;vpts1b;vpts1c;vpts1d];
else
     f1 = [f1d];
     vpts1 = [vpts1d];
end








%points1_4 = detectSIFTFeatures(piece_4,Sigma=1.2);





% strongest = points1.selectStrongest(50);
% imshow(pieces); hold on;
% plot(strongest);hold off;

indexPairs = matchFeatures(f1,f2,Unique=uniq,MatchThreshold=100);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
toc;
if (show| show1)
    figure; 
    ax = axes;
end

% if (app ~= 0) 
%     ax = app.appSettings.UIAxesFeatures;
% else
%     fig = figure;
%     ax = axes(fig);
% end

if (show1)
    showMatchedFeatures(piece_4,gray_grid_4,matchedPoints1,matchedPoints2,'montage','Parent',ax);
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points piece','Matched points grid');
end


points_bin = clean_featurse(piece_4,matchedPoints1.Location);
matchedPoints1 = matchedPoints1(points_bin);
matchedPoints2 = matchedPoints2(points_bin);

% figure; ax = axes;
% if (app ~= 0)
%     ax = app.appSettings.UIAxesFeatures;
% else
%     fig = figure;
%     ax = axes(fig);
% end
if(show)
showMatchedFeatures(piece_4,gray_grid_4,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points piece','Matched points grid');
end
  % Find numner of features in each piece
[n,m,~] = size(img_grid);
features_piece = zeros(num_row,num_col);
features_piece2 = zeros(num_row,num_col);
orientation_diff_mat = zeros(num_row,num_col);
scale_diff_mat = zeros(num_row,num_col);
y = [matchedPoints2.Location(:,1)]; %.*(num_row/n);
x = [matchedPoints2.Location(:,2)]; %.*(num_col/m);

max_strength = max(matchedPoints2.Metric);
for j = 1:num_row
    for k = 1:num_col
        y_range = (y >= (k-1)*(m/num_col)) & (y < k*(m/num_col));
        x_range = (x >= (j-1)*(n/num_row)) & (x < j*(n/num_row));
        f2p = matchedPoints2(x_range & y_range);
       
%         d = ((f2p.Location(:,1)-x_center_of_mass).^2+(f2p.Location(:,2)-y_center_of_mass).^2); %without sqrt - ^2
%         d=1-d./(normelize);


        f1p = matchedPoints1(x_range & y_range);
        orientation_diff = abs(atan2(sin(f2p.Orientation-f1p.Orientation), cos(f2p.Orientation-f1p.Orientation)));
        scale_diff = f2p.Scale./f1p.Scale;
%         disp(sum(y_range));
%         disp(sum(x_range));
        strengths = log10((f2p.Metric/max_strength)+0.3)+0.89;

        features_piece(j,k) = f2p.Count;
        features_piece2(j,k) = sum(strengths);


        if (f2p.Count<=2)
            orientation_diff_mat(j,k)= -1;
            scale_diff_mat(j,k)      = -1;
        else
            orientation_diff_mat(j,k) = std(orientation_diff);
            scale_diff_mat(j,k)       = std(scale_diff);
        end
    end
end
orientation_diff_mat(orientation_diff_mat==-1) = max(max(orientation_diff_mat));
scale_diff_mat(scale_diff_mat==-1)             = max(max(scale_diff_mat));
% The chance that the peice is in location i,j
features_weights_mat = features_piece./(sigmoid(scale_diff_mat-0.5).*sigmoid(orientation_diff_mat-0.5));
% features_weights_mat = features_piece./sigmoid(orientation_diff_mat-0.5);
features_weights_mat2 = features_piece2./(sigmoid(scale_diff_mat-0.5).*sigmoid(orientation_diff_mat-0.5));
% features_weights_mat2 = features_piece2./sigmoid(orientation_diff_mat-0.5);
% the sum 
weights_sum=sum(sum(features_weights_mat));
weights_sum2=sum(sum(features_weights_mat2));
[maximum,index_tmp] = max(features_weights_mat(:));
[maximum2,index_tmp2] = max(features_weights_mat2(:));
% disp(orientation_diff_mat);
% orientation_diff_mat
% scale_diff_mat
% features_piece
% features_piece2
% Reliability calculation:
% features ratio * (2/(1+e^(-x/3))-1), x = sum of features in image
% ratio_score = maximum/matchedPoints2.Count;
ratio_score = maximum/weights_sum;
count_score = (2/(1+exp(-matchedPoints2.Count/3))-1);
% disp(ratio_score);
% disp(count_score);
ratio_score2=maximum2/weights_sum2;
reliability = ratio_score*count_score;
reliability2 = ratio_score2*count_score;

%to use strength matching
reliability = reliability2;
index_tmp = index_tmp2;

% rel_mat = count_score*features_weights_mat/weights_sum
% rel_mat2 = count_score*features_weights_mat2/weights_sum2
% reliability
% reliability2
location = zeros(2,1);
location(1) = fix(index_tmp/num_row)+1;
location(2) = mod(index_tmp,num_row);
if location(2) == 0
    location(1) = location(1) - 1;
    location(2) = num_row;
end
% fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%     ,i,location(1),location(2),reliability);