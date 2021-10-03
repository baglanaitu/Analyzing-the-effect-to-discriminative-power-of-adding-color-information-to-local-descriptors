function norm_img = ImageNormalization(img)
B = double(img(:,:,1));
G = double(img(:,:,2));
R = double(img(:,:,3));

norm_R = normalize(R);
norm_G = normalize(G);
norm_B = normalize(B);

norm_img = norm_R + norm_G + norm_B;
end