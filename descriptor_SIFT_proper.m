clear;clc;close all;

row=256;
column=256;
img1 = imresize(imread('./images/book_1.jpg'),[row,column]); 
img2 = imresize(imread('./images/reflection.jpeg'),[row,column]);
%{
% RGB with Color offset
sigma = 0.2;
k = 3; % range [1 4]
alpha = 0.5; %range: [0.4 0.6]
img1 = clr_offset(img1, k, alpha, sigma); % 
%img2 = clr_offset(img2, k, alpha, sigma); % 

% Grayscale image
%{
img=rgb2gray(img);  %128   921
% img=histeq(img);
%}

feature1 = doSIFT(img1, row, column);
%feature2 = doSIFT(img2, row, column);
%}
load('feature1')
load('feature2')
% Match the features.
indexPairs = matchFeatures(feature1(:,1),feature2(:,1));