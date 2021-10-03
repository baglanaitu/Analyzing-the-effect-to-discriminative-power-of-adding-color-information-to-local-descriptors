% For colorful (contrast) images more points
clear; clc; close all;

I1 = imread('./images/kettle_colors/red_1.jpg');
I2 = imread('./images/kettle_colors/red_2.jpg'); % original
%I2 = imrotate(imread('./images/kettle_2.jpg'), 60); % rotation
%I2 = imrotate(imresize(imread('./images/kettle_2.jpg'), 0.5), -20); % d+ro
%I2 = imresize(imread('./images/kettle_2.jpg'), 0.25); % downsampling
%I2 = imnoise(I2,'salt & pepper',0.02); % Add salt and pepper noise, with a noise density of 0.02

tic
% Color offset 
sigma = 0.2;
k = 4; % range [1 4]
alpha = 0.7; %range: [0.4 0.6]
W1 = clr_offset(I1, k, alpha, sigma);
W2 = clr_offset(I2, k, alpha, sigma);

% Detecting features
corners1 = detectSURFFeatures(W1);
corners2 = detectSURFFeatures(W2);


% Extract the features using SURF feature descriptor.
[features1,valid_points1] = extractFeatures(rgb2gray(I1), corners1, 'Upright',true);
[features2,valid_points2] = extractFeatures(rgb2gray(I2), corners2, 'Upright',true);
toc

tic
% Match the features.
indexPairs = matchFeatures(features1,features2);

% Retrieve the locations of the corresponding points for each image.
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Plotting
%showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
total_points = size(corners1)
matched_points = matchedPoints1
toc
% imshow(W1)

showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
[F,inliersIndex] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2, 'Method','RANSAC',...
    'NumTrials',2000,'DistanceThreshold',2);
fprintf('Number of inliers: %d\n', sum(inliersIndex))
perc = sum(inliersIndex)*100/size(matched_points,1)

title(['SURF + proposed method, Inliers: ' num2str(sum(inliersIndex))])
% Plot keypoints
%{
J = insertMarker(I1,corners1,'circle');
imshow(J)
%}