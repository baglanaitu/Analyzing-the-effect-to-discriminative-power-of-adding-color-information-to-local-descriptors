% For colorful (contrast) images more points

clear; clc; close all;
img = imread('./images/uam.jpeg');
%{
% grayscale; elapsed time = 0.298099 seconds
tic
G = rgb2gray(img);
figure (1)
corners = detectFASTFeatures(G,'MinContrast',0.1);
J = insertMarker(G,corners,'circle');
imshow(J)
title("Grayscale image, " + "keypoints= " + string(size(corners,1)))
toc
%}

tic
% Color, elapsed time = 0.399266 seconds.
sigma = 0.2;
k = 3; % range [1 4]
alpha = 0.5; %range: [0.4 0.6]
W = clr_offset(img, k, alpha, sigma);

figure (2)
corners1 = detectFASTFeatures(W,'MinContrast',0.1);
J1 = insertMarker(W,corners1,'circle');
imshow(J1)
title("RGB image, " + "keypoints= " + string(size(corners1,1)))
toc




