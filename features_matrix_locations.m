
% sigments_values=[dialtion_size1 dialation_size2 extent_filter center_size]
% img- the unsoved puzzels
% resize_factor- recommend 8 
function [location_matrix, reliability_matrix]=features_matrix_locations(img_grid,img,resize_factor,num_row,num_col,app,imgCell)
% dialtion_size1=appGui.segParams.dial1;
% dialation_size2=appGui.segParams.dial2 ;
% extent_filter=appGui.segParams.ext_filt ;
% center_size=appGui.segParams.center_size;
num_of_pieces=num_row*num_col;
show=false;

% features:
location_matrix=cell(num_row,num_col);
reliability_matrix=cell(num_row,num_col);
%scan all the pieces
 %extruct the features from the grid
 piece=imgCell{1}; points2_flag=0;f2=0;vpts2=0;R_roi=0;
 [~,~,f2,vpts2]=matching_features(piece,img_grid,num_row,num_col,points2_flag,app,f2,vpts2,R_roi);
%scan all the pieces and match to the correct cordinatte
for i =1:num_of_pieces
    piece = imgCell{i};
    piece=imresize(piece,resize_factor);
    if (show)
        figure
        imshow(piece)
    end    
    points2_flag=1;R_roi=0;
    [location_features,reliability_features,~,~] =matching_features(piece,img_grid,num_row,num_col,points2_flag,app,f2,vpts2,R_roi); %###
    location_matrix{location_features(2),location_features(1)}=[location_matrix{location_features(2),location_features(1)},i];
    reliability_matrix{location_features(2),location_features(1)}=[reliability_matrix{location_features(2),location_features(1)},reliability_features];
   
end
disp("locatuin and reliability before manege locations:")
location_matrix
reliability_matrix
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

%       for any location_problem
       for i=1:length(location_row_problem)
%          find the most probblie piece in this location
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

               [location_new,reliability_new]= matching_features_by_roi(location_row_empty,location_col_empty,piece,img_grid,num_row,num_col,app);
               loc_1=location_new(1);
               loc_2=location_new(2);
               location_matrix{loc_2,loc_1}=[location_matrix{loc_2,loc_1},temp_pieces(j)];
               reliability_matrix{loc_2,loc_1}=[reliability_matrix{loc_2,loc_1},reliability_new];
                %print visuzl matrix 
                j+1
                location_matrix
                reliability_matrix
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