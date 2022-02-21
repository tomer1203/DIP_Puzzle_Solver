function [location,reliability,f2,vpts2] = matching_features(piece,img_grid,num_row,num_col,points2_flag,app,f2,vpts2,R_roi)
    %global value for features
    uniq=true;
    grayScale = true;
    show=false;
    show1=false;
    
    if(points2_flag == 0)
        disp("Calculating grid");
        [f2,vpts2] = pull_features(img_grid,grayScale,R_roi,false);
    end
    tic;
    [f1,vpts1] = pull_features(piece,grayScale,0,true);
    [location,reliability]=match_peice2Grid(piece,img_grid,num_row,num_col,f1,f2,vpts1,vpts2,app);
end