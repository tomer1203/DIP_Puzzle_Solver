function [location,reliability,f2,vpts2] = matching_features_sift(piece,img_grid,num_row,num_col,points2_flag,app,f2,vpts2)
%global value for features
MetricThreshold=100;               %default 1000. decerase the tradhold- more features
NumOctaves=4;                       %default 3 . recommend: 1-4 . increase the numOctuves- more features
NumScaleLevels=6;                   %default 4. recommend  3-6 .increase the numScaleLevel- more features 
roi=1;
uniq=true;


% pieces = double(im2gray(piece));
% pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
%gray_grid = double(im2gray(img_grid));
%gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));

gray_grid_4 = double(im2gray(img_grid));
gray_grid_4 = (gray_grid_4 - min(gray_grid_4(:)))/(max(gray_grid_4(:)) - min(gray_grid_4(:)));
if(points2_flag == 0)
% lab_grid    =rgb2lab(img_grid);
% gray_grid_1 = double(img_grid(:,:,1));
% gray_grid_2 = double(img_grid(:,:,2));
% gray_grid_3 = double(img_grid(:,:,3));
% figure;
% imshow(lab_grid(:,:,1),[]);
% figure;
% imshow(lab_grid(:,:,2),[]);
% figure;
% imshow(lab_grid(:,:,3),[]);
% gray_grid_1 = double(lab_grid(:,:,1));
% gray_grid_2 = double(lab_grid(:,:,2));
% gray_grid_3 = double(lab_grid(:,:,3));
    gray_grid_4 = double(im2gray(img_grid));

% gray_grid_1 = (gray_grid_1 - min(gray_grid_1(:)))/(max(gray_grid_1(:)) - min(gray_grid_1(:)));
% gray_grid_2 = (gray_grid_2 - min(gray_grid_2(:)))/(max(gray_grid_2(:)) - min(gray_grid_2(:)));
% gray_grid_3 = (gray_grid_3 - min(gray_grid_3(:)))/(max(gray_grid_3(:)) - min(gray_grid_3(:)));
    gray_grid_4 = (gray_grid_4 - min(gray_grid_4(:)))/(max(gray_grid_4(:)) - min(gray_grid_4(:)));

    
%     points2_4 = detectSURFFeatures(gray_grid_4,MetricThreshold=MetricThreshold,NumOctaves=NumOctaves,NumScaleLevels=NumScaleLevels);
    points2_4 = detectSIFTFeatures(gray_grid_4);
    [f2d,vpts2d] = extractFeatures(gray_grid_4,points2_4);

    f2 = [f2d];
    vpts2 = [vpts2d];
end


piece_4 =  double(im2gray(piece));

piece_4 = (piece_4 - min(piece_4(:)))/(max(piece_4(:)) - min(piece_4(:)));

% Find and matching features

% points1_4 = detectSURFFeatures(piece_4,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
points1_4 = detectSIFTFeatures(piece_4);
[f1d,vpts1d] = extractFeatures(piece_4,points1_4,"Method","SIFT");

f1 = [f1d];
vpts1 = [vpts1d];


indexPairs = matchFeatures(f1,f2,Unique=uniq,MatchThreshold=100);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));


points_bin = clean_featurse(piece_4,matchedPoints1.Location);
matchedPoints1 = matchedPoints1(points_bin);
matchedPoints2 = matchedPoints2(points_bin);

% figure; ax = axes;
if (app ~= 0)
    ax = app.appSettings.UIAxesFeatures;
else
    fig = figure;
    ax = axes(fig);
end
showMatchedFeatures(piece_4,gray_grid_4,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points piece','Matched points grid');

  % Find numner of features in each piece
[n,m,~] = size(img_grid);
features_piece = zeros(num_row,num_col);
% features_piece2 = zeros(num_row,num_col);
% orientation_diff_mat = zeros(num_row,num_col);
% scale_diff_mat = zeros(num_row,num_col);
y = [matchedPoints2.Location(:,1)]; %.*(num_row/n);
x = [matchedPoints2.Location(:,2)]; %.*(num_col/m);
max_strength = max(matchedPoints2.Metric);
for j = 1:num_row
    for k = 1:num_col
        y_range = (y >= (k-1)*(m/num_col)) & (y < k*(m/num_col));
        x_range = (x >= (j-1)*(n/num_row)) & (x < j*(n/num_row));
        f2p = matchedPoints2(x_range & y_range);
        f1p = matchedPoints1(x_range & y_range);

        features_piece(j,k) = f2p.Count;



    end
end

% The chance that the peice is in location i,j

% the sum 
[maximum,index_tmp] = max(features_piece(:));
% disp(orientation_diff_mat);
% orientation_diff_mat
% scale_diff_mat
% features_piece
% features_piece2
% Reliability calculation:
% features ratio * (2/(1+e^(-x/3))-1), x = sum of features in image
ratio_score = maximum/matchedPoints2.Count;
count_score = (2/(1+exp(-matchedPoints2.Count/3))-1);
% disp(ratio_score);
% disp(count_score);
reliability = ratio_score*count_score;


%to use strength matching
% reliability = reliability2;
% index_tmp = index_tmp2;

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