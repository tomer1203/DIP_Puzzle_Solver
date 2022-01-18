function [target, not_target]= cala(mat_file, txt_file)   
load(mat_file);
Sta_2_1=data;

target1=Sta_2_1(:,end);
c=find(target1>0);


fileID = fopen(txt_file,'r');
txt = textscan(fileID,'%s','delimiter','\n');
txt1=txt{1};


window_size=600;

avg_house1=zeros(window_size+1,19);
avg_not_house1=zeros(window_size+1,19);

count_house=0;
count_not_house=0;
%for the first section:
%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:10;
for i=1:length(c);
    str1=txt1{i};
    location=c(i);
    if (str1(1:3)=="Hou")
        count_house=count_house+1;
        avg_house1=avg_house1+Sta_2_1(location:location+window_size,1:19);
    else
        count_not_house=count_not_house+1;
        avg_not_house1=avg_not_house1+Sta_2_1(location:location+window_size,1:19);
    end
end
end
target=avg_house1/count_house;
not_target=avg_not_house1/count_not_house;
end