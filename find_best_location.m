function [index_tmp,reliability]=find_best_location(features_piece2,orientation_diff_mat,scale_diff_mat,match_count)
    % replace any unmatched value with the maximum value found
    orientation_diff_mat(orientation_diff_mat==-1) = max(max(orientation_diff_mat));
    scale_diff_mat(scale_diff_mat==-1)             = max(max(scale_diff_mat));
    
    % The chance that the peice is in location i,j
%     features_weights_mat = features_piece./(sigmoid(scale_diff_mat-0.5).*sigmoid(orientation_diff_mat-0.5));
    features_weights_mat2 = features_piece2./(sigmoid(scale_diff_mat-0.5).*sigmoid(orientation_diff_mat-0.5));
    % features_weights_mat2 = features_piece2./sigmoid(orientation_diff_mat-0.5);
    
    % the sum 
%     weights_sum=sum(sum(features_weights_mat));
    weights_sum2=sum(sum(features_weights_mat2));
%     [maximum,index_tmp] = max(features_weights_mat(:));
    [maximum2,index_tmp2] = max(features_weights_mat2(:));

    % Reliability calculation:
    % features ratio * (2/(1+e^(-x/3))-1), x = sum of features in image
    % ratio_score = maximum/matchedPoints2.Count;
%     ratio_score = maximum/weights_sum;
    count_score = (2/(1+exp(-match_count/3))-1);

    ratio_score2=maximum2/(weights_sum2+eps);
%     reliability = ratio_score*count_score;
    reliability2 = ratio_score2*count_score;
    
    %to use strength matching
    reliability = reliability2;
    index_tmp = index_tmp2;
end