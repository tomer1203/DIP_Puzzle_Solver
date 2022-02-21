function [location,reliability]=match_peice2Grid(piece,img_grid,num_row,num_col,f1,f2,vpts1,vpts2,app)
    uniq=true;
    show=false;
    show1=false;
    pieceGray = im2gray(piece);
    img_gridGray = im2gray(img_grid);
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
        showMatchedFeatures(piece,img_grid,matchedPoints1,matchedPoints2,'montage','Parent',ax);
        title(ax, 'Candidate point matches');
        legend(ax, 'Matched points piece','Matched points grid');
    end
    
    
    points_bin = clean_featurse(pieceGray,matchedPoints1.Location);
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
        showMatchedFeatures(piece,img_grid,matchedPoints1,matchedPoints2,'montage','Parent',ax);
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
end