close all
clear;

%% initialize camera 

cam = webcam(2) % camera on
preview(cam); % show camera output
%closePreview(cam); 

%% global vals
num_of_pieces = 6;

%% pre prossing

f = msgbox('pleas wiat a few seconds');
img_for_segmentation = snapshot(cam); %RGB
noise = noise_val(cam); % it's take 1sec. 
% segmentation
% fiture detection
delete(f);


%% real time
while(1)
    
f = msgbox('choose pazzel piece');
tach_point = found_tach_point2(cam,noise);
% take tach_point and return the choosen piece.
% take choosen piece and return it place.
delete(f);

f = msgbox('take out the choosen piece');
% check movement and wait few seconds.
num_of_pieces = num_of_pieces -1;
delete(f);

if(num_of_pieces == 0) break; end;
    
% pre prossing again
f = msgbox('pleas wiat a few seconds');
img_for_segmentation = snapshot(cam); %RGB
noise = noise_val(cam); % it's take 1sec. 
% segmentation
% fiture detection
delete(f);
end

f = msgbox('The job done');
pause(5)
delete(f);
