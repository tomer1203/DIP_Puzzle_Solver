function [location,reliability] = matching_features(piece,img_grid,num_row,num_col,app)

pieces = double(im2gray(piece));
pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
gray_grid = double(im2gray(img_grid));
gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));

% Find and matching features
points1 = detectSURFFeatures(pieces);
points2 = detectSURFFeatures(gray_grid);
[f1,vpts1] = extractFeatures(pieces,points1);
[f2,vpts2] = extractFeatures(gray_grid,points2);

indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

% figure; ax = axes;
ax = app.appSettings.UIAxesFeatures;
  showMatchedFeatures(pieces,gray_grid,matchedPoints1,matchedPoints2,'montage','Parent',ax);
  title(ax, 'Candidate point matches');
  legend(ax, 'Matched points piece','Matched points grid');

  % Find numner of features in each piece
[n,m,~] = size(img_grid);
features_piece = zeros(num_row,num_col);
y = [matchedPoints2.Location(:,1)]; %.*(num_row/n);
x = [matchedPoints2.Location(:,2)]; %.*(num_col/m);
for j = 1:num_row
    for k = 1:num_col
        y_range = (y >= (k-1)*(m/num_col)) & (y < k*(m/num_col));
        x_range = (x >= (j-1)*(n/num_row)) & (x < j*(n/num_row));
        f2p = matchedPoints2(x_range & y_range);
%         disp(sum(y_range));
%         disp(sum(x_range));
        features_piece(j,k) = f2p.Count;
    end
end
[maximum,index_tmp] = max(features_piece(:));
% Reliability calculation:
% features ratio * (2/(1+e^(-x/3))-1), x = sum of features in image
reliability = (maximum/matchedPoints2.Count)*(2/(1+ ...
    exp(-matchedPoints2.Count/3))-1);
location = zeros(2,1);
location(1) = fix(index_tmp/num_row)+1;
location(2) = mod(index_tmp,num_row);
if location(2) == 0
    location(1) = location(1) - 1;
    location(2) = num_row;
end
% fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%     ,i,location(1),location(2),reliability);