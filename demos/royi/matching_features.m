function [location,reliability] = matching_features(piece,img_grid,num_row,num_col,show)
%global value for features
MetricThreshold=700;               %default 1000. decerase the tradhold- more features
NumOctaves=4;                       %default 3 . recommend: 1-4 . increase the numOctuves- more features
NumScaleLevels=6;                   %default 4. recommend  3-6 .increase the numScaleLevel- more features 
roi=1;
uniq=true;


pieces = double(im2gray(piece));
pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
gray_grid = double(im2gray(img_grid));
gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));

% Find and matching features
points1 = detectSURFFeatures(pieces,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
points2 = detectSURFFeatures(gray_grid,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
[f1,vpts1] = extractFeatures(pieces,points1);
[f2,vpts2] = extractFeatures(gray_grid,points2);

indexPairs = matchFeatures(f1,f2,Unique=uniq) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
if (show)
figure; ax = axes;
  showMatchedFeatures(pieces,gray_grid,matchedPoints1,matchedPoints2,'montage','Parent',ax);
  title(ax, 'Candidate point matches');
  legend(ax, 'Matched points piece','Matched points grid');
end
  % Find numner of features in each piece
[n,m,~] = size(img_grid);
features_piece = zeros(num_row,num_col);
y = [matchedPoints2.Location(:,1)]; %.*(num_row/n);
x = [matchedPoints2.Location(:,2)]; %.*(num_col/m);
mask=zeros(size(pieces));
mask(pieces>0)=1;
%% center of mass
% props = regionprops(true(size(piece)), piece, 'WeightedCentroid');
% x_center_of_mass=props.WeightedCentroid(1);
% y_center_of_mass=props.WeightedCentroid(2);
% 
% normelize=max([(1-x_center_of_mass).^2+(1-y_center_of_mass).^2,(1-x_center_of_mass).^2+(size(piece,1)-y_center_of_mass).^2 ...
%     (size(piece,2)-x_center_of_mass).^2+(1-y_center_of_mass).^2,(size(piece,2)-x_center_of_mass).^2+(size(piece,1)-y_center_of_mass).^2]);
%%
for j = 1:num_row
    for k = 1:num_col
        y_range = (y >= (k-1)*(m/num_col)) & (y < k*(m/num_col));
        x_range = (x >= (j-1)*(n/num_row)) & (x < j*(n/num_row));
        f2p = matchedPoints2(x_range & y_range);
       
%         d = ((f2p.Location(:,1)-x_center_of_mass).^2+(f2p.Location(:,2)-y_center_of_mass).^2); %without sqrt - ^2
%         d=1-d./(normelize);

%         disp(sum(y_range));
%         disp(sum(x_range));
        features_piece(j,k) =f2p.Count   ;%  sum(d>0);
    end
end
normelized_matrix=sum(sum(features_piece));
[maximum,index_tmp] = max(features_piece(:));
% Reliability calculation:
% features ratio * (2/(1+e^(-x/3))-1), x = sum of features in image
ratio_score = (maximum/matchedPoints2.Count);
count_score = (2/(1+exp(-matchedPoints2.Count/3))-1);
% disp(ratio_score);
% disp(count_score);
reliability = (maximum/matchedPoints2.Count)*(2/(1+ ...
    exp(-matchedPoints2.Count/3))-1);
% ratio_score2=maximum/normelized_matrix;
% count_score2 = (2/(1+exp(-matchedPoints2.Count/3))-1);
% reliability = ratio_score2*count_score2;

location = zeros(2,1);
location(1) = fix(index_tmp/num_row)+1;
location(2) = mod(index_tmp,num_row);
if location(2) == 0
    location(1) = location(1) - 1;
    location(2) = num_row;
end
% fprintf("The location for piece #%d is (%d,%d), reliability = %4f\n" ...
%     ,i,location(1),location(2),reliability);