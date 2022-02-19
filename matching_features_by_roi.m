% input  location_row_empty
% R      location_col_empty
%        pieces= the pieces to check
%        grid_img
%        num_row,num_col
% output location_new of the piece
%        reliability_new of the piece
function [location_new,reliability_new]= matching_features_by_roi(location_row_empty,location_col_empty,pieces,img_grid,num_row,num_col)
app=false;
%find the empty locations:
% number of problematic locaions:
number_of_location=length(location_col_empty);
if(number_of_location~=0) % more empty location
    relability_vec=zeros(1,number_of_location);
    location_vec_x=zeros(1,number_of_location);
    location_vec_y=zeros(1,number_of_location);
    for i=1:number_of_location;
        k_col=location_col_empty(i);
        j_row=location_row_empty(i);
        width=floor(m/num_col);
        height=floor(n/num_row);
        x=(k_col-1)*floor(m/num_col)+1;
        y=(j_row-1)*floor(n/num_row)+1;
        R_roi=[x y width height];
        [A,relability_vec(i)]=matching_features(pieces,img_grid,num_row,num_col,app,R_roi);
        [location_vec_x(i),location_vec_y(i)]=A;
        clear A;
    end
    reliability_new=max(relability_vec);
    cordinate=find(relability_vec=reliability_new);
    location_new=zeros(2,1);
    location_new(1)=location_vec_x(cordinate);
    location_new(2)=location_vec_y(cordinate);
    

end

end