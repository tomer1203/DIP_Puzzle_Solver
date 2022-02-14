img = imread("DIP_Puzzle_Solver\img\temp_tests\a.jpg");
background = imread("DIP_Puzzle_Solver\img\temp_tests\b.jpg");
subplot(3,1,1);
imshow(img);
subplot(3,1,2);
imshow(background);
subplot(3,1,3);
new = double((img-background)==0);
imshow(new);