% imgCell      = images organized by label
% featuresCell = features organized by label
% vptsCell     = vpts organized by label
function [label,reliability] = find_piece_label(piece,imgCell,featuresCell,vptsCell)
    grayScale = true;
    show=false;
    uniq=true;
    [f1,vpts1] = pull_features(piece,grayScale,0,true);
    N = size(imgCell);
    features_piece = zeros(N,1);
    orientation_diff_mat = zeros(N,1);
    scale_diff_mat       = zeros(N,1);
    

    for i=1:N
        f2    = featuresCell{i};
        vpts2 = vptsCell{i};
        
        % match the features
        indexPairs = matchFeatures(f1,f2,Unique=uniq,MatchThreshold=100);
        matchedPoints1 = vpts1(indexPairs(:,1));
        matchedPoints2 = vpts2(indexPairs(:,2));
        toc;
        
        
       
        if(show)
            % figure; ax = axes;
            % if (app ~= 0)
            %     ax = app.appSettings.UIAxesFeatures;
            % else
            %     fig = figure;
            %     ax = axes(fig);
            % end
            showMatchedFeatures(piece,imgCell{i},matchedPoints1,matchedPoints2,'montage','Parent',ax);
            title(ax, 'Candidate point matches');
            legend(ax, 'Matched points piece','Matched points grid');
        end
        
        
        % calculate the orientation alignment and scale alignment
        orientation_diff = abs(atan2(sin(matchedPoints2.Orientation-matchedPoints1.Orientation), ...
                                     cos(matchedPoints2.Orientation-matchedPoints1.Orientation)));
        scale_diff = matchedPoints2.Scale./matchedPoints1.Scale;
        
        % calculate the strength of the points
        strengths = log10((matchedPoints2.Metric/max_strength)+0.3)+0.89;
        features_piece(i) = sum(strengths);


        if (matchedPoints2.Count<=2)
            orientation_diff_mat(i)= -1;
            scale_diff_mat(i)      = -1;
        else
            orientation_diff_mat(i) = std(orientation_diff);
            scale_diff_mat(i)       = std(scale_diff);
        end
    end
    [index_tmp,reliability]=find_best_location(features_piece,orientation_diff_mat,scale_diff_mat,match_count);
    label      =index_tmp;
end