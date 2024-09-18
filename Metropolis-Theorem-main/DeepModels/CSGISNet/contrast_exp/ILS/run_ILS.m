clc;
clear;

fileDir = '' ;% input dir
outputDir = '';
inDir = dir(fileDir);
len = length(inDir);

for i=3:len
    path_in = strcat(fileDir,inDir(i).name);
    I = im2double(imread(path_in));

    % PNLS
    lambda = 30;
    gamma = 10/255;
    iter = 10;
    
    tic,
    
    Smoothed = ILS_Welsch(I, lambda, gamma, iter);
   % Idetexture = PNLS_DT(I);
 
    toc,
    
    out_ILS = strcat(outputDir,'ILS/',inDir(i).name);
    imwrite(Smoothed, out_ILS);
    %print('ok');
end


fileDir =  '/1T/datasets/VOC_SPS/val_small/' ;% input dir
outputDir = '/1T/WJ/Easy2Hard-master/test_results/VOC/';
inDir = dir(fileDir);
len = length(inDir);

for i=3:len
    path_in = strcat(fileDir,inDir(i).name);
    I = im2double(imread(path_in));
    [m,n,c] = size(I);
    % ILS
    lambda = 30;
    gamma = 10/255;
    iter = 10;
    
    tic,
    
    Smoothed = ILS_Welsch(I, lambda, gamma, iter);
 
    toc,
    
    out_ILS = strcat(outputDir,'ILS/',inDir(i).name);
    imwrite(Smoothed, out_ILS);
    %print('ok');
end