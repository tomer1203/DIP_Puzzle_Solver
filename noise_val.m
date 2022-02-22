function noise = noise_val(cam)
summ = 0;
for i = 1:10
    img11 = snapshot(cam);
    img11 = double(rgb2gray(img11));
    img11 = (img11 - min(img11(:)))/(max(img11(:)) - min(img11(:)));
    
    img12 = snapshot(cam);
    img12 = double(rgb2gray(img12));
    img12 = (img12 - min(img12(:)))/(max(img12(:)) - min(img12(:)));

    img13 = snapshot(cam);
    img13 = double(rgb2gray(img13));
    img13 = (img13 - min(img13(:)))/(max(img13(:)) - min(img13(:)));

    img14 = snapshot(cam);
    img14 = double(rgb2gray(img14));
    img14 = (img14 - min(img14(:)))/(max(img14(:)) - min(img14(:)));

    pause(0.1)
    img21 = snapshot(cam);
    img21 = double(rgb2gray(img21));
    img21 = (img21 - min(img21(:)))/(max(img21(:)) - min(img21(:)));
    
    img22 = snapshot(cam);
    img22 = double(rgb2gray(img22));
    img22 = (img22 - min(img22(:)))/(max(img22(:)) - min(img22(:)));

    img23 = snapshot(cam);
    img23 = double(rgb2gray(img23));
    img23 = (img23 - min(img23(:)))/(max(img23(:)) - min(img23(:)));

    img24 = snapshot(cam);
    img24 = double(rgb2gray(img24));
    img24 = (img24 - min(img24(:)))/(max(img24(:)) - min(img24(:)));

    noise1 = sum(abs(img21 - img11),'all');
    noise2 = sum(abs(img22 - img12),'all');
    noise3 = sum(abs(img23 - img13),'all');
    noise4 = sum(abs(img24 - img14),'all');
    
    summ = summ + noise1 + noise2 + noise3 + noise4;
end
noise = summ/40;
end




