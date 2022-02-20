
% sigments_values=[dialtion_size1 dialation_size2 extent_filter center_size]
% img- the unsoved puzzels
% resize_factor- recommend 8 
function [location_matrix, reliability_matrix]=features_matrix_locations(img_grid,img,sigments_values,resize_factor,num_row,num_col)
dialtion_size1=sigments_values(1);
dialation_size2=sigments_values(2);
extent_filter=sigments_values(3);
center_size=sigments_values(4);
num_of_pieces=num_row*num_col;
show=false;

% segmenttion
gray_img= double(im2gray(img));
gray_img = (gray_img- min(gray_img(:)))/(max(gray_img(:)) - min(gray_img(:)));
[seg_img,puz_edges] = segmentation(gray_img,dialtion_size1,dialation_size2,extent_filter,center_size);
% cut the image
imgCell = cut_images(img,seg_img,num_of_pieces,10);
%shape
location_matrix_shape=cell(num_row,num_col);
% features:
location_matrix=cell(num_row,num_col);
reliability_matrix=cell(num_row,num_col);
%scan all the pieces
for i =1:num_of_pieces
    piece = imgCell{i};
    piece=imresize(piece,resize_factor);
    if (show)
        figure
        imshow(piece)
    end
    
    roi=0;
    [location_features,reliability_features] = matching_features_surf(piece,img_grid,num_row,num_col,show,roi);
    location_matrix{location_features(2),location_features(1)}=[location_matrix{location_features(2),location_features(1)},i];
    reliability_matrix{location_features(2),location_features(1)}=[reliability_matrix{location_features(2),location_features(1)},reliability_features];
%     % shape...
%     [puzzel_shape loc_mat]=detect_pazzel_shape(piece,resize_factor);
%     location_matrix_shape{location_features(2),location_features(1)}=[location_matrix_shape{location_features(2),location_features(1)},puzzel_shape];
%    
end

% find if there any empty cells:
B = location_matrix;
B(cellfun(@isempty, B)) = {-1}; 
isNegative = cellfun(@(x)isequal(x,-1),B);
[location_row_empty,location_col_empty] = find(isNegative);
% number of problematic locaions:
%manage the duplicats??????
length_more_than_1=cellfun(@(x)length(x),B);
[location_row_problem,location_col_problem] = find(length_more_than_1>1);
if (~isempty(location_row_problem))
%     while(length(location_row_problem)>1)
%         number_of_location=length(location_col_empty);
%         if(number_of_location~=length(location_row_problem))
%             disp("problem- the number of empty not fit")
%         end  
%       for any location_problem
%           find the most probblie piece in this location
%           change the reliabilities
%           temp the other pieces
%           for number of duplicate in the same location
%               matthing feature by roi
%               fix the reliability matrix
       for i=1:length(location_row_problem)
           loc_problem_temp_row=location_row_problem(i);
           loc_problem_temp_col=location_col_problem(i);
           location_of_the_most_ralibility=find(reliability_matrix{loc_problem_temp_row,loc_problem_temp_col}==max(reliability_matrix{loc_problem_temp_row,loc_problem_temp_col}));
           temp_pieces=location_matrix{loc_problem_temp_row,loc_problem_temp_col}; %% all the pices as a vec *before* change!
           location_matrix{loc_problem_temp_row,loc_problem_temp_col}=temp_pieces(location_of_the_most_ralibility); %put the most realibility in the location matrix
%            find all the not most reliability and put them in temp_pieces as a vector
           temp_pieces_loc=find(reliability_matrix{loc_problem_temp_row,loc_problem_temp_col}<max(reliability_matrix{loc_problem_temp_row,loc_problem_temp_col}));
           temp_pieces=temp_pieces(temp_pieces_loc);
%            modify the reliability_matrix
           reliability_matrix{loc_problem_temp_row,loc_problem_temp_col}=max(reliability_matrix{loc_problem_temp_row,loc_problem_temp_col});

           
           for j=1:length(temp_pieces_loc)
               piece=imgCell{temp_pieces(j)};
               piece=imresize(piece,resize_factor);

               [location_new,reliability_new]= matching_features_by_roi(location_row_empty,location_col_empty,piece,img_grid,num_row,num_col);
               loc_1=location_new(1);
               loc_2=location_new(2);
               location_matrix{loc_2,loc_1}=[location_matrix{loc_2,loc_1},temp_pieces(j)];
               reliability_matrix{loc_2,loc_1}=[reliability_matrix{loc_2,loc_1},reliability_new];
               % find if there any empty cells:
               B = location_matrix;
               B(cellfun(@isempty, B)) = {-1}; 
               isNegative = cellfun(@(x)isequal(x,-1),B);
               [location_row_empty,location_col_empty] = find(isNegative);
               %repit
           end 
       end
       length_more_than_1=cellfun(@(x)length(x),B);
       [location_row_problem,location_col_problem] = find(length_more_than_1>1);
%     end
end


%manage the duplicats??????
length_more_than_1=cellfun(@(x)length(x),B);
[location_row_problem,location_col_problem] = find(length_more_than_1>1);
if(length(location_row_problem)==1)
    if(lenght(location_row_empty)~=1)
        disp("problem- the number of empty not fit")
    end
    temp=location_matrix{location_row_problem,location_col_problem}
    location_matrix{location_row_problem,location_col_problem}=temp(find(reliability_matrix{location_row_problem,location_col_problem}==max(reliability_matrix{location_row_problem,location_col_problem})));
    location_matrix{location_row_empty,location_col_empty}=temp(find(reliability_matrix{location_row_problem,location_col_problem}==min(reliability_matrix{location_row_problem,location_col_problem})));
    temp_reliability=min(reliability_matrix{location_row_problem,location_col_problem});
    reliability_matrix{location_row_problem,location_col_problem}=max(reliability_matrix{location_row_problem,location_col_problem});
    reliability_matrix{location_row_empty,location_col_empty}=temp_reliability;
end

reliability_matrix=cell2mat(reliability_matrix);
location_matrix=cell2mat(location_matrix);
end