% For colorful (contrast) images more points
clear; clc; close all;

I1 = imresize(imread('./images/kettle_1.jpg'),1);
I2 = imrotate(imresize(imread('./images/kettle_2.jpg'),1), -30);

tic;
% Color offset 
sigma = 0.2; %0.2
k = 3; % range [1 4] %4
alpha = 1.2; %range: [0.4 0.6] %0.5
W1 = clr_offset(I1, k, alpha, sigma);
W2 = clr_offset(I2, k, alpha, sigma);

% Detecting features
corners1 = detectBRISKFeatures(W1);
corners2 = detectBRISKFeatures(W2);


% Extract the features using SURF feature descriptor.
[features1,valid_points1] = extractFeatures(rgb2gray(I1), corners1, 'Upright',true);
[features2,valid_points2] = extractFeatures(rgb2gray(I2), corners2, 'Upright',true);
toc;

tic;
% Match the features.
indexPairs = matchFeatures(features1,features2);

% Retrieve the locations of the corresponding points for each image.
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Plotting
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
total_points = size(corners1)
matched_points = matchedPoints1
toc;

showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
[F,inliersIndex] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2, 'Method','RANSAC',...
    'NumTrials',2000,'DistanceThreshold',2);
fprintf('Number of inliers: %d\n', sum(inliersIndex))
perc = sum(inliersIndex)*100/size(matched_points,1)
title(['BRISK+proposed method, Inliers: ' num2str(sum(inliersIndex))])
% Plot keypoints
%{
J = insertMarker(I1,corners1,'circle');
imshow(J)
%}