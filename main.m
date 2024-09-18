% Pixel-wise low-light image enhancement based on metropolis theorem"
% 
% If you use this code, please cite the following paper:
% @article{demir2024pixel,
%   title={Pixel-wise low-light image enhancement based on metropolis theorem},
%   author={Demir, Yasin and Kaplan, Nur H{\"u}seyin and Kucuk, Sefa and Severoglu, Nagihan},
%   journal={Journal of Visual Communication and Image Representation},
%   pages={104211},
%   year={2024},
%   publisher={Elsevier}
% }

clc
clear all
close all

addpath('.\Metropolis-Theorem-main');

input_img = imread("images\1.jpg");
input_img = double(input_img);

IMAX = max(input_img(:));
input_img = uint8(IMAX*power(input_img/IMAX,.5));

R_channel = double(input_img(:,:,1));
G_channel = double(input_img(:,:,2));
B_channel = double(input_img(:,:,3)); 

[H,S,V] = rgb2hsv(input_img); 
I = V;  

global counter1 counter2;
global T0 gamma;
T0 = 300;   % initial temperature
gamma = 2; % cooling coefficient
counter1 = 0;  % patch matching counter
counter2 = 0;  % additional patch matching using MT counter


%Multi-scale decomposition with Metropolis theorem
hcomp = MT(I);
hcomp = imresize(hcomp,size(I));
lcomp = I-hcomp;

lcomp = lcomp-min(min(lcomp));
lcomp = lcomp/max(max(lcomp));

hcomp2 = MT(lcomp);
hcomp2 = imresize(hcomp2,size(lcomp));
aprlayer = lcomp-hcomp2;

aprlayer = aprlayer-min(min( aprlayer));
aprlayer = aprlayer/max(max( aprlayer));

finalaprlayer = double(aprlayer);

cond = mean(mean(max(input_img,[],3)))/255;
    
avg = mean(aprlayer(:));

global_gama = 2*cond;
spatial_gama = power(avg,finalaprlayer);
gama = spatial_gama; 

out = power(aprlayer,gama); 


hcomp = hcomp.*power(aprlayer+0.000001,gama-1); 


im_rec = out+hcomp;


alpha = 0.00001+0.05*cond*im_rec./(V+0.00001);

R_out = R_channel.*im_rec./(V+alpha);
G_out = G_channel.*im_rec./(V+alpha);
B_out = B_channel.*im_rec./(V+alpha);


output = cat(3,R_out,G_out,B_out);
return_img = output;

Output_img = uint8(return_img);

final_image = abs(double(Output_img));
enhanced_image = uint8(255*final_image/max(final_image(:)));

imshow(enhanced_image)
