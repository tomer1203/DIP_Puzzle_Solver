function [features,vpts]=pull_features(img,grayScale,R_roi,sharpen)
    if (R_roi==0)
        roi=[1,1,size(img,2),size(img,1)];
    else
        roi=R_roi;
    end
    MetricThreshold=100;               %default 1000. decerase the tradhold- more features
    NumOctaves=4;                       %default 3 . recommend: 1-4 . increase the numOctuves- more features
    NumScaleLevels=6;                   %default 4. recommend  3-6 .increase the numScaleLevel- more features 
    if (sharpen == true)
        img = imsharpen(img,'Radius',10,'Amount',1);
    end
    gray_grid_4 = double(im2gray(img));    
    gray_grid_4 = (gray_grid_4 - min(gray_grid_4(:)))/(max(gray_grid_4(:)) - min(gray_grid_4(:)));
    points2_4 = detectSURFFeatures(gray_grid_4,MetricThreshold=MetricThreshold,NumOctaves=NumOctaves,NumScaleLevels=NumScaleLevels,ROI=roi);
    %    points2_4 = detectSIFTFeatures(gray_grid_4,Sigma=1.2);
    [f2d,vpts2d] = extractFeatures(gray_grid_4,points2_4,"Method","SURF");

    if (~grayScale)
        gray_grid_1 = double(img(:,:,1));
        gray_grid_2 = double(img(:,:,2));
        gray_grid_3 = double(img(:,:,3));
        gray_grid_1 = (gray_grid_1 - min(gray_grid_1(:)))/(max(gray_grid_1(:)) - min(gray_grid_1(:)));
        gray_grid_2 = (gray_grid_2 - min(gray_grid_2(:)))/(max(gray_grid_2(:)) - min(gray_grid_2(:)));
        gray_grid_3 = (gray_grid_3 - min(gray_grid_3(:)))/(max(gray_grid_3(:)) - min(gray_grid_3(:)));
        points2_1 = detectSURFFeatures(gray_grid_1,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels,ROI=roi);
        points2_2 = detectSURFFeatures(gray_grid_2,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels,ROI=roi);
        points2_3 = detectSURFFeatures(gray_grid_3,"MetricThreshold",MetricThreshold,"NumOctaves",NumOctaves,"NumScaleLevels",NumScaleLevels,ROI=roi);
        [f2a,vpts2a] = extractFeatures(gray_grid_1,points2_1,"Method","SURF");
        [f2b,vpts2b] = extractFeatures(gray_grid_2,points2_2,"Method","SURF");
        [f2c,vpts2c] = extractFeatures(gray_grid_3,points2_3,"Method","SURF");
        features = [f2a;f2b;f2c;f2d];
        vpts = [vpts2a;vpts2b;vpts2c;vpts2d];
    else
        features = [f2d];
        vpts = [vpts2d];
    end
end