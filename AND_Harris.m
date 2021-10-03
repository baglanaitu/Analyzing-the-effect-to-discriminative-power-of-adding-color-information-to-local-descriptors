clear; clc;

img = imread('./images/uam.jpeg');
B = img(:,:,1);
G = img(:,:,2);
R = img(:,:,3);

norm_R = R./img;
norm_G = G./img;
norm_B = B./img;

color = R | G | B;
corners = detectHarrisFeatures(color);
J = insertMarker(img,corners,'circle');
imshow(J)