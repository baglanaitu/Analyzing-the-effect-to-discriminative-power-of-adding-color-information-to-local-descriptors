% For colorful (contrast) images more points
clear; clc; close all;

I1 = imresize(imread('./images/colors/book_1_green.jpg'),1);
I2 = imresize(imread('./images/colors/book_2_green.jpg'),1);

tic
% Color offset 
sigma = 0.2;% 0.2
k = 4; % range [1 4], 4
alpha = 1.2; %range: [0.4 0.6], 1.2
W1 = clr_offset(I1, k, alpha, sigma);
W2 = clr_offset(I2, k, alpha, sigma);

% Detecting features
corners1 = detectSURFFeatures(W1);
corners2 = detectSURFFeatures(W2);


% Extract the features using SURF feature descriptor.
[features1,valid_points1] = extractFeatures(W1, corners1, 'Method', 'FREAK');
[features2,valid_points2] = extractFeatures(W2, corners2, 'Method', 'FREAK');
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