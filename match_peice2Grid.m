function [location,reliability]=match_peice2Grid(piece,img_grid,num_row,num_col,f1,f2,vpts1,vpts2,app)
    uniq=true;

    pieceGray = im2gray(piece);
    % get the matching features
    [matchedPoints1,matchedPoints2]=get_matching_features(f1,f2,vpts1,vpts2,pieceGray,uniq,app,piece,img_grid);
    [n,m,~] = size(img_grid);

    % Find numner of features in each piece
    [features_piece2,orientation_diff_mat,scale_diff_mat]=build_matching_matrixes(n,m,num_row,num_col,matchedPoints1,matchedPoints2);
 

    % looks at all the gathered data and chooses the best match
    [index_tmp,reliability]=find_best_location(features_piece2,orientation_diff_mat,scale_diff_mat,matchedPoints2.Count);
    
    % calculate location
    location = zeros(2,1);
    location(1) = fix(index_tmp/num_row)+1;
    location(2) = mod(index_tmp,num_row);
    if location(2) == 0
        location(1) = location(1) - 1;
        location(2) = num_row;
    end
end