function show_all_matrix(location_matrix,imgCell,num_row,num_col,img_grid)
[n,m,~]=size(img_grid);
for i=1:num_row*num_col;
        [j_row,k_col]=find(location_matrix==i)
        width=floor(m/num_col);
        height=floor(n/num_row);
        x=(k_col-1)*floor(m/num_col)+1;
        y=(j_row-1)*floor(n/num_row)+1;
        R_roi=[x y width height];
        subImage=imcrop(img_grid,R_roi);
        figure
        montage({subImage,imgCell{i}})
end
end