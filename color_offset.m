clear; close; clc;

img = imread('images/reflection.jpeg');
gray = rgb2gray(img);

% RGB channels
B = double(img(:,:,1));
G = double(img(:,:,2));
R = double(img(:,:,3));

% New color space
YCBCR = rgb2ycbcr(img);

% Channels
Y  = YCBCR(:,:,1);
CB = YCBCR(:,:,2);
CR = YCBCR(:,:,3);

% Mean values
mb = mean(CB);
mr = mean(CR);

% Optional
if mean(mb)>mean(mr)
    disp("more bluish")
elseif mean(mb)<mean(mr)
    disp("more reddish")
elseif mean(mb) == mean(mr)
    disp("same")
end

% Channel components 
%Cb = -0.169*R - 0.331*G +0.5*B + 128;
%Cr = 0.5*R - 0.419*G +0.081*B + 128;

% Color offset
sigma = 0.2;
k = 3; % range [1 4]
alpha = 0.5; %range: [0.4 0.6]

Y = double(Y);
Cr = double(CR);
Cb = double(CB);
sign_m = sign(mr - mb);
sign_C = sign(Cr - Cb);
abs_C = abs(Cr-Cb);
Yc = k*sign_m(1,1)*sign_C(1,1).*(abs_C.^alpha);

% RGB stuff
% Y = 0.299*R + 0.587*G + 0.114*B;
% Grayscale value with offset
P = Y + Yc;
norm_P = Y./P + Yc./P;
P = cast(P,'uint8');

% exposure adjustement
Ye = (128 - mean(P)).*exp((-(norm_P-0.5).^2)/2*sigma^2); %???

% Final image
%W = cast(Yc,'uint8') + cast(Ye,'uint8') + cast(Y,'uint8');
W = Yc + Ye + Y;
W = cast(W,'uint8');

M = W;
corners = detectBRISKFeatures(M);
[features,valid_points] = extractFeatures(M, corners);

J = insertMarker(img,corners,'circle');
imshow(J)
features