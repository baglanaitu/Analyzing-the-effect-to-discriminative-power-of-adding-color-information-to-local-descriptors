clear; clc; close all;

n = input('Enter a number: ');
I1 = imread('./images/reflection.jpeg');
I2 = imread('./images/reflection_skew.png');


% Color offset 
sigma = 0.2;
k = 3; % range [1 4]
alpha = 0.5; %range: [0.4 0.6]
W1 = clr_offset(I1, k, alpha, sigma);
W2 = clr_offset(I1, k, alpha, sigma);


    if n == 0 % FAST
        corners1 = detectFASTFeatures(W1,'MinContrast',0.1);
        corners2 = detectFASTFeatures(W2,'MinContrast',0.1);
    elseif n == 1 % Harris
        corners1 = detectHarrisFeatures(W1);
        corners2 = detectHarrisFeatures(W2);
    elseif n == 2 % SURF
        corners1 = detectSURFFeatures(W1);
        corners2 = detectSURFFeatures(W2);
    elseif n == 3 % KAZE
        corners1 = detectKAZEFeatures(W1);
        corners2 = detectKAZEFeatures(W2);
    elseif n == 4 % BRISK
        corners1 = detectBRISKFeatures(W1);
        corners2 = detectBRISKFeatures(W2);
    elseif n == 5 % ORB
        corners1 = detectORBFeatures(W1);
        corners2 = detectORBFeatures(W2);
    else
        disp("Wrong");
    end

    
% Extract the neighborhood features.
[features1,valid_points1] = extractFeatures(W1, corners1);
[features2,valid_points2] = extractFeatures(W2, corners2);

% Match the features.
indexPairs = matchFeatures(features1,features2);

% Retrieve the locations of the corresponding points for each image.
matchedPoints1 = valid_points1(indexPairs(:,1),:)
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Plotting
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
