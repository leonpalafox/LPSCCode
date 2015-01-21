function create_dataset(feature, config)
%%
%%This functions opens a given image and allows to create a dataset of
%%the indicated feature
%%Each image is saved using the descriptior of the hirise image as well as
%%the upper and lower coordinates in a mat file
%check if feature is in feature list
feature_list = strtrim(strsplit(config.data{3},',')); %get all of the features list
if isempty(strmatch(feature, feature_list, 'exact'))&&~strcmp(feature, 'negative')
    error('This is an unvalid feature')
end
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = 'Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);%The reduion level is a reduction level on 2^reduction_level
%Check if the filename exists in the workspace and if it does black out th
%craters that are already in the data, as well as to populate the data
%vector
%[data, hirise_img] = analyse_image(strfilename, hirise_img, feature);

waitfor(msgbox(['You will be tagging ' feature]));
if ~strcmp(feature, 'negative')
    n = config.data{4}; %Same number of positive examples for all features
else
    n = config.data{5};
end
coordinates = round(readPoints(hirise_img, n));%First we read the two points for the image
y_coord = coordinates(1,:); %careful with the orientation
x_coord = coordinates(2,:);
data = generate_datapoints(hirise_img, y_coord, x_coord, 4, config.data{7});%creates de datapoints with a given size


%We will generate a file that has all the coordinates of the data sets.
%structure is 
%data = [y_coord(1):y_coord(2)
%        x_coord(1):x_coord(2)]

close all
%Double check for size consistency


name = [feature '_data_'];
savename = [name, strfilename '.mat'];
save(savename,'data')



%save('hiriseTrainSubset.mat', 'numTrainImages', 'trainImages', 'trainLabels');