IMPORTANT: Output images are saved in respective folders. 
image quality enhancement - Einstein.jpg
close all;
clear all;
clc;
% Create a folder to save the results
resultFolder = 'output_images';
if ~exist(resultFolder, 'dir')
    mkdir(resultFolder);
end
% Create a folder to save the results from giraffe_image
imageName = 'einstein';
imageFolder = fullfile(resultFolder, imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end
input_image = imread('input_images/einstein.tif');
input_image = im2double(input_image);

figure(1); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'original_image.jpg'));
figure(2); histogram(input_image); ylim('auto'); 
saveas(gcf, fullfile(imageFolder, 'original_histogram.jpg'));
% for i = 1:-0.05:0.5
% P = imadjust(input_image,stretchlim(input_image,0.01),[0 1],i);
% figure(1); imshow(P);
% %figure(2); histogram(P); ylim('auto');
% pause
% end
% best result at gamma = 0.9

input_image = imadjust(input_image,stretchlim(input_image,0.01),[0 1],0.9);
figure(3); imshow(input_image);
figure(4); histogram(input_image); ylim('auto');
saveas(gcf, fullfile(imageFolder, 'adjusted_histogram.jpg'));
% can we sharpen the edges even more?


% w_lp = fspecial('average',3);
% input_image_lp = imfilter(input_image,w_lp,'replicate');
% input_image_hp = input_image - input_image_lp;
% input_image_sharp = input_image+input_image_hp;
% input_image_sharp = im2uint8(input_image_sharp);
% figure(5); imshow(input_image_sharp);
% figure(6); histogram(input_image_sharp); ylim('auto');



% w_laplacian = [0 1 0; 1 -4 1; 0 1 0];
% input_image_laplacian = imfilter(input_image_lp, w_laplacian,'replicate');
% input_image_sharp = uint8(255*(input_image-input_image_laplacian));
% figure(8); imshow(input_image_sharp);


input_image = im2uint8(input_image);
imwrite(input_image, 'output_images/giraffe/Final_giraff_out.jpg', 'quality', 90);

image quality enhancement - Lady.png
close all;
clear all;
clc;
imageName = 'lady.jpg';
imageFolder = fullfile("output_images", imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end
input_image = imread('input_images/lady.jpg');
input_image = im2double(input_image);
figure(1); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'original_image.jpg'));
figure(2); histogram(input_image); ylim('auto');
saveas(gcf, fullfile(imageFolder, 'original_histogram.jpg'));
% for i = 11:2:15
% P = medfilt2(input_image, [i i], 'symmetric');
% figure(3); imshow(P);
% figure(4); histogram(P); ylim('auto');
% pause;
% end
% optimal value= 11

input_image = medfilt2(input_image, [11 11], 'symmetric');
figure(3); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'image_after_medianFilter.jpg'));
figure(4); histogram(input_image); ylim('auto');
saveas(gcf, fullfile(imageFolder, 'adjusted_histogram_after_median.jpg'));
input_image = imadjust(input_image,stretchlim(input_image,0.01),[0 1]);
figure(5); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'after_contrast_stretching.jpg'));
figure(6); histogram(input_image); ylim('auto');

% Now we can also sharpen the edges
% for i = 3:3:30
% w_lp = fspecial('average', i);
% input_image_lp = imfilter(input_image, w_lp, 'replicate');
% input_image_hp = input_image - input_image_lp;
% E_sharp = E + E_hp;
% E_sharp = uint8(E_sharp*255);
% figure(100); imshow(E_sharp);
% pause;
% end
% we get best result for the size = 9

w_lp = fspecial('average', 9);
input_image_lp = imfilter(input_image, w_lp, 'replicate');
input_image_hp = input_image - input_image_lp;
input_image_sharp = input_image + input_image_hp;
figure(7); imshow(input_image_sharp);
figure(8); histogram(input_image_sharp); ylim('auto');
input_image_sharp = im2uint8(input_image_sharp);
imwrite(input_image_sharp, 'output_images/Taj_Mahal/Final_TajMahal.jpg', 'quality', 90);

image quality enhancement - disney.jpg, gray
close all;
clear all;
clc;
imageName = 'disney';
imageFolder = fullfile("output_images", imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end

input_image = imread('input_images/disney.jpg');
input_image_gray = rgb2gray(input_image);
input_image_gray = im2double(input_image_gray);
figure(1); imshow(input_image_gray);
saveas(gcf, fullfile(imageFolder, 'grayScale_image.jpg'));
figure(2); histogram(input_image_gray); ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'grayScale_histogram.jpg'));
input_image_gray = imadjust(input_image_gray,stretchlim(input_image_gray,0.01),[0 1],0.7);
figure(3); imshow(input_image_gray);
saveas(gcf, fullfile(imageFolder, 'After_contrast stretching_img.jpg'));
figure(4); histogram(input_image_gray);

% AHE algorithm
% for i = 0.01:0.01:0.08
%input_image_gray_ae = adapthisteq(D_gray, 'ClipLimit',i,'NumTiles',[30 15]);
%figure(5); imshow(input_image_gray_ae);
%figure(6); histogram(input_image_gray_ae); ylim('auto'); xlim([0 255]);
% pause
% end
% ClipLimit= 0.03(best result)
input_image_gray_ae = adapthisteq(input_image_gray, 'ClipLimit',0.03,'NumTiles',[30 15]);
figure(5); imshow(input_image_gray_ae);
saveas(gcf, fullfile(imageFolder, 'After_AHE.jpg'));
figure(6); histogram(input_image_gray_ae); ylim('auto'); xlim([0 255]);

% let's make the edges smoother
w_lp = fspecial('gaussian', [19 19], 3);
input_image_gray_lp = imfilter(input_image_gray_ae,w_lp,'replicate');
figure(7); imshow(input_image_gray_lp);
saveas(gcf, fullfile(imageFolder, 'Gaussian_FILTER.jpg'));
figure(8); histogram(input_image_gray_lp); ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'histogram_final_GrayScale_img.jpg'));
% specification - image should be saved as 8-bit .jpg image with quality = 90
input_image = im2uint8(input_image_gray_lp);
imwrite(input_image, 'output_images/disney/Final_disney_gray.jpg', 'quality', 90);

image quality enhancement - disney.jpg, color
close all;
clear all;
clc;
imageName = 'disney';
imageFolder = fullfile("output_images", imageName);

input_image = imread('input_images/disney.jpg');

figure(1); imshow(input_image);
% As we can see the pixels are accumulated in the dark region
figure(2); histogram(input_image(:,:,1));  ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'Histogram-red.jpg'));
figure(3); histogram(input_image(:,:,2));  ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'Histogram-green.jpg'));
figure(4); histogram(input_image(:,:,3));  ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'Histogram-blue.jpg'));

% Now we tried to switch to Y'CbCr and do the contrast enhancment on the luma matrix
% for i = 1:10
% Dycbcr = rgb2ycbcr(input_image);
% Dycbcr(:,:,1) = imadjust(Dycbcr(:,:,1),stretchlim(Dycbcr(:,:,1),0.01),[0 1],0.5+i/100);
% D_pom = ycbcr2rgb(Dycbcr);
% figure(100); imshow(D_pom);
% pause;
% end

% Then we tried to switch to HSV and do the contrast enhancment on the V matrix
% for i = 1:10
% Dhsv = rgb2hsv(input_image);
% Dhsv(:,:,3) = imadjust(Dhsv(:,:,3),stretchlim(Dhsv(:,:,3),0.01),[0 1],i/10);
% D_pom = hsv2rgb(Dhsv);
% figure(100); imshow(D_pom);
% pause;
% end

w_lp = fspecial('gaussian', [19 19], 3);

 %Y'CbCr at gamma = 0.5
Dycbcr = rgb2ycbcr(input_image);
 Dycbcr(:,:,1) = imadjust(Dycbcr(:,:,1),stretchlim(Dycbcr(:,:,1),0.01),[0 1],0.5);
 Dycbcr(:,:,1) = imfilter(Dycbcr(:,:,1),w_lp,'replicate');
 D_pom = ycbcr2rgb(Dycbcr);
 figure(5); imshow(D_pom);
 saveas(gcf, fullfile(imageFolder, 'Best of YCbCr.jpg'));
 set(gcf, 'Name', 'Best of YCbCr');

% HSV at gamma = 0.5
Dhsv = rgb2hsv(input_image);
Dhsv(:,:,3) = imadjust(Dhsv(:,:,3),stretchlim(Dhsv(:,:,3),0.01),[0 1],0.5);
Dhsv(:,:,3) = imfilter(Dhsv(:,:,3),w_lp,'replicate');
D_pom = hsv2rgb(Dhsv);
figure(6); imshow(D_pom);
saveas(gcf, fullfile(imageFolder, 'Best of HSV.jpg'));
set(gcf, 'Name', 'Best of HSV');

input_image = im2uint8(D_pom);
imwrite(input_image,'output_images/disney/Final_disney_best_color.jpg', 'quality', 90);

sharpen the image - lange.jpg
close all;
clear all;
clc;
imageName = 'lange';
imageFolder = fullfile("output_images", imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end
input_image = imread('input_images/lange.jpg');
input_image = im2double(input_image);

% we can see a lot of noise in the image (neck, face ...)
% contrast is very good
figure(1); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'original_image.jpg'));
figure(2); histogram(input_image); ylim('auto'); xlim([0 255]);
saveas(gcf, fullfile(imageFolder, 'histogram_original_image.jpg'));
% we need to sharpen the image without amplifying the noise
% Sharpen Image using Band-pass Filter
w_lp_wide = fspecial('gaussian', [19 19], 3);
w_lp_narrow = fspecial('gaussian', [300 300], 3);
input_image_wide = imfilter(input_image,w_lp_wide,'replicate');
input_image_narrow =  imfilter(input_image,w_lp_narrow,'replicate');
input_image = 2*input_image_wide - input_image_narrow;

figure(3); imshow(input_image);

input_image = im2uint8(input_image);
imwrite(input_image,'output_images/lange/Final_lange_sharp.jpg');

text binarization - text_stripes.png
close all;
clear all;
clc;
imageName = 'text_strips';
imageFolder = fullfile("output_images", imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end
input_image = imread('input_images/text_stripes.tif');
input_image = im2double(input_image);

% Removing the stripes to correctly binarize the image
figure(1); imshow(input_image);
saveas(gcf, fullfile(imageFolder, 'original_image.tif'));
figure(2); histogram(input_image); ylim('auto');
saveas(gcf, fullfile(imageFolder, 'original_image_Histogram.jpg'));

% let's go through many combinations:
% for s = 30:10:70
%     for i = 35:10:75
%         w_lp = fspecial('gaussian', [i i], s);
%         I_lp = imfilter(input_image, w_lp, 'replicate');
% 
%         figure(3); imshow(I_lp);
%         J=mat2gray(I-I_lp);
%         figure(4); imshow(J);
%         figure(5); histogram(J); ylim('auto');
%         pause;
% 
%         % find the correct threshold
%         for j = 0.45:0.01:0.55
%             Jb = im2bw(J, j);
%             figure(6); imshow(Jb);
%         
%             display(s);
%             display(i);
%             display(j);
%             pause;
%         end
%     end
% end
% similar results, this seems nice:
% sigma = 60, MxN = 45x45 and threshold = 0.57 better then graythresh() <- Otsu's method
%Filtering and Binarization
w_lp = fspecial('gaussian', [45 45], 60);
I_lp = imfilter(input_image, w_lp, 'replicate');
figure(3); imshow(I_lp);
saveas(gcf, fullfile(imageFolder, 'gaussian filtered image.jpg'));
J = mat2gray(input_image-I_lp);
figure(4); imshow(J);
saveas(gcf, fullfile(imageFolder, 'image after subtracting gaussian filtered image.jpg'));
% by looking at the histogram we can choose threshold 
figure(5); histogram(J); ylim('auto');
saveas(gcf, fullfile(imageFolder, 'Subtracted_image_Histogram.jpg'));
% binarization using threshold of 0.57
Jb = im2bw(J, 0.57);
figure(6); imshow(Jb);

Jb = im2uint8(Jb);
imwrite(Jb,'output_images/text_strips/binarization.png');

testing the clahe function - mars_moon.tif
clear all;
close all;
clc; 
imageName = 'spine';
imageFolder = fullfile("output_images", imageName);
if ~exist(imageFolder, 'dir')
    mkdir(imageFolder);
end
% read in the image
mars = imread('input_images/spine.tif');

figure(1); imshow(mars);
saveas(gcf, fullfile(imageFolder, 'original_image.tif'));
% CHANGING THE NUMBER OF TILES 
tic
M1 = clahe(mars,[1 1],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(2);
imshow(M1);
saveas(gcf, fullfile(imageFolder, 'num_tiles = [1 1].jpg'));
set(gcf, 'Name', 'num_tiles = [1 1]');

tic
M4 = clahe(mars,[4 4],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(3);
imshow(M4); 
saveas(gcf, fullfile(imageFolder, 'num_tiles = [4 4].jpg'));
set(gcf, 'Name', 'num_tiles = [4 4]');

tic
M8 = clahe(mars,[8 8],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(4);
imshow(M8);
saveas(gcf, fullfile(imageFolder, 'num_tiles = [8 8].jpg'));
set(gcf, 'Name', 'num_tiles = [8 8]');

tic
M16 = clahe(mars,[16 16],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(5);
imshow(M16);
saveas(gcf, fullfile(imageFolder, 'num_tiles = [16 16].jpg'));
set(gcf, 'Name', 'num_tiles = [16 16]')
% CHANGING THE CLIP LIMIT 
tic
M0 = clahe(mars,[16 16],0.01);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(6);
imshow(M0);
saveas(gcf, fullfile(imageFolder, 'limit = 0.01 (num_tiles = [16 16]).jpg'));
set(gcf, 'Name', 'limit = 0.01')

tic
M0 = clahe(mars,[16 16],0.1);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(7);
imshow(M0);
saveas(gcf, fullfile(imageFolder, 'limit = 0.1 (num_tiles = [16 16]).jpg'));
set(gcf, 'Name', 'limit = 0.1')

tic
M0 = clahe(mars,[16 16],1);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(8);
imshow(M0);
saveas(gcf, fullfile(imageFolder, 'limit = 1 (num_tiles = [16 16]).jpg'));
set(gcf, 'Name', 'limit = 1')



% save the best image
imwrite(M16,'output_images/mars_moon/Final_mars_clahe_best.jpg');
