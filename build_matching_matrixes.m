function [features_piece2,orientation_diff_mat,scale_diff_mat]=build_matching_matrixes(n,m,num_row,num_col,matchedPoints1,matchedPoints2)
    % Find numner of features in each piece
%     features_piece = zeros(num_row,num_col);
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
    
%             features_piece(j,k) = f2p.Count;
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

end