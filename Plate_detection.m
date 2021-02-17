close all;
clear all;


im = imread('Number Plate Images/image1.png');
im = imresize(im, [480 NaN]);
subplot(3,3,1),imshow(im),title('Resized Image')
imgray = rgb2gray(im);
subplot(3,3,2),imshow(imgray),title('Gray scale Image')
imbin = imbinarize(imgray);
subplot(3,3,3),imshow(imbin),title('Binary Image')
im = edge(imgray, 'sobel');
subplot(3,3,4),imshow(im),title('Edge Detection')
im = imdilate(im, strel('diamond', 2));
subplot(3,3,5),imshow(im),title('Dilated Image')
im = imfill(im, 'holes');
subplot(3,3,6),imshow(im),title('After filling holes')
im = imerode(im, strel('diamond', 10));
subplot(3,3,7),imshow(im),title('Eroded Image')
%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

im = imcrop(imbin, boundingBox);%crop the number plate area
im = imresize(im, [240 NaN]);%resize number plate to 240 NaN
im = imopen(im, strel('rectangle', [4 4]));
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500

 [h, w] = size(im);%get width
 subplot(3,3,8),imshow(im),title('Resize the Bounded Box')

imshow(im);

Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) && oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter] % Appending every subsequent character in noPlate variable.
   end
end