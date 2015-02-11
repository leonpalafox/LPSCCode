%%
%Testing matching points in new image
%This script is a test, where you click points in a large image, and check
%if the mapping works for a smaller image

test_image = imread('Data/PSP_002292_1875_RED.png'); %Load larger image
test_image_small = imresize(test_image, 0.5); %reduce image by half
%%
%%Get SURF Features between images
ptsOriginal  = detectSURFFeatures(test_image);
ptsDistorted = detectSURFFeatures(test_image_small);

[featuresOriginal,   validPtsOriginal]  = extractFeatures(test_image,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(test_image_small, ptsDistorted);


indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
%%
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
%%
figure;
showMatchedFeatures(test_image,test_image_small,matchedOriginal,matchedDistorted);
title('Putatively matched points (including outliers)');
input('Press Any ket to continue','s')
%%Estimate Transformation
[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedDistorted, matchedOriginal, 'similarity');

Tinv  = tform.invert.T;
%%
%Read points form original image and map in the new image
points = readPointsSimple(test_image, 2);
close all
drawPoints(test_image, points)
close all
Tinv = [0.5, 0; 0, 0.5];
new_points = Tinv*[points];
drawPoints(test_image_small, new_points)