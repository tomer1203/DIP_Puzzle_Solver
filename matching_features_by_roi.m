% input locations-location to check
%       scale=[width height]
%       pieces
%       grid_img
% output location realibilitirs matrix
function location_realibilitirs_matrix= matching_features_by_roi(locations_matrix,scale,pieces,img_grid)
MetricThreshold=100;               %default 1000. decerase the tradhold- more features
NumOctaves=4;                       %default 3 . recommend: 1-4 . increase the numOctuves- more features
NumScaleLevels=6;                   %default 4. recommend  3-6 .increase the numScaleLevel- more features 
MatchThreshold_parameter=100;                 % default is 1, increas help to find more match features

pieces = double(im2gray(piece));
pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
gray_grid = double(im2gray(img_grid));
gray_grid = (gray_grid - min(gray_grid(:)))/(max(gray_grid(:)) - min(gray_grid(:)));
[width height]=scale(1),scale(2);
[num_row,num_col]=size(locations_matrix);


%find the empty locations:
location_row=cell(1);
location_col=cell(1);
for i=1:row;
    for j=1:col;
        if location_matrix_features{i,j}==0
            location_row{1}=[location_row{1},i];
            location_col{1}=[location_col{1},j];
        end
    end
end
% number of problematic locaions:
number_of_location=length(location_col{1});
%
%surf feature for the pieces:
points1 = detectSURFFeatures(pieces,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels);
[f1,vpts1] = extractFeatures(pieces,points1,"Method","SURF");
%surf features for the 
for i=1:number_of_location;

end

end