clear; clc; close all;

img = imread('images/manhattan.jpeg');
gray = rgb2gray(img);

% Proposed method
sigma = 0.2;
k = 4; % range [1 4]
alpha = 0.6; %range: [0.4 0.6]
color = clr_offset(img, k, alpha, sigma);

% Detecting features
corners1 = detectHarrisFeatures(gray);
corners2 = detectHarrisFeatures(color);

corners1
corners2
% Plot keypoints
figure (1)
J1 = insertMarker(img,corners1,'circle');
imshow(J1)
title("Original grayscale")
hold off

figure (2)
J2 = insertMarker(img,corners2,'circle');
imshow(J2)
title("Proposed method")
