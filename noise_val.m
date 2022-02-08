function noise = noise_val(cam)
summ = 0;
for i = 1:10
    img11 = snapshot(cam);
    img11 = double(rgb2gray(img11))/255;
    img12 = snapshot(cam);
    img12 = double(rgb2gray(img12))/255;
    pause(0.1)
    img21 = snapshot(cam);
    img21 = double(rgb2gray(img21))/255;
    img22 = snapshot(cam);
    img22 = double(rgb2gray(img22))/255;
    noise1 = sum(abs(img21 - img11),'all');
    noise2 = sum(abs(img22 - img12),'all');
    summ = summ + noise1 + noise2;
end
noise = summ/20;
end