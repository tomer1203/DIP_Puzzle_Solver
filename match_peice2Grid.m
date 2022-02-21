function [location,reliability]=match_peice2Grid(piece,img_grid,num_row,num_col,f1,f2,vpts1,vpts2,app)
    uniq=true;
    show=false;
    show1=false;
    pieceGray = im2gray(piece);
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