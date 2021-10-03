function W = clr_offset(img, k, alpha, sigma)

% New color space
YCBCR = rgb2ycbcr(img);

% Channels
Y  = YCBCR(:,:,1);
CB = YCBCR(:,:,2);
CR = YCBCR(:,:,3);

Cb = double(YCBCR(:,:,2));
Cr = double(YCBCR(:,:,3));

% Mean values
mb = mean(mean(Cb));
mr = mean(mean(Cr));

sign_m = sign(mr - mb);
sign_C = sign(Cr - Cb);
abs_C = abs(Cr-Cb);
Yc = k*sign_m.*sign_C.*(abs_C.^alpha);

P = double(Y) + Yc;
norm_P = double(Y)./P + Yc./P;
P = cast(P,'uint8');

% exposure adjustement
Ye = (128 - mean(mean(double(P)))).*exp((-(norm_P-0.5).^2)/2*sigma^2); %???

% Final image
%W = cast(Yc,'uint8') + cast(Ye,'uint8') + cast(Y,'uint8');
W = Yc + Ye + double(Y);
W = cast(W,'uint8');

end