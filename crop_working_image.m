function crop_working_image(config)

%Now we load the image before the slump
folder = config.data{1};
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
filename = [folder filename];
img = imread(filename, 'ReductionLevel', 2);
%Next we choose the points that will serve as our upper left corner and
%lower right corner in the cropped image (i.e. that part of the image with
%rootless cones)
points = readPoints_v2(img, 2);
%readPoints_v2 comes out with an 2xn matrix with n being the number of points
%specified. Thus, the top left corner is in points(:,1) and the bottom
%right corner is in points(:,2)
cropped_image = img(points(2,1):points(2,2),points(1,1):points(1,2));

%First we save the files for analysis, these files have no scale image
folder = '..\Data\'; %Is going to save it one level up
filename = strcat(strfilename, '.png');
filename = [folder filename];
imwrite(cropped_image,filename)
end