function [matchedPoints1,matchedPoints2]=get_matching_features(f1,f2,vpts1,vpts2,pieceGray,uniq,app,piece,img_grid)
    show = false;
    show1 = false;
    indexPairs = matchFeatures(f1,f2,Unique=uniq,MatchThreshold=100);
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));

    points_bin = clean_featurse(pieceGray,matchedPoints1.Location);
    matchedPoints1 = matchedPoints1(points_bin);
    matchedPoints2 = matchedPoints2(points_bin);
    
 
    if(show)
        figure; ax = axes;
        % if (app ~= 0)
        %     ax = app.appSettings.UIAxesFeatures;
        % else
        %     fig = figure;
        %     ax = axes(fig);
        % end
        showMatchedFeatures(piece,img_grid,matchedPoints1,matchedPoints2,'montage','Parent',ax);
        title(ax, 'Candidate point matches');
        legend(ax, 'Matched points piece','Matched points grid');
    end

end