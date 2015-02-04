function [data, jp_image] = analyse_image(strfilename, jp_image_org, feature)
%%This function checks whether the current filename has already been
%%analyzed, if it has, it blacks out all of the already checked boxes, and
%%populates the data vector with the existent coordinates from before.
%%
%% This way, we can work in a systematic fashion tagging features
%Input:
%strfilneame: Is the name of the HiRise image, already stripped from the
%QLOOOK and extension strings
%jp_image_org: Is the original image that has already been loaded
%Output:
%data: is the vector that already has all of the boxes that we have already
%selected, is an empty array if nothing has been done
%jp_image: Image with the balckout spots

files = dir('*.mat'); %Get all the mat files
%Now we iterate over all the mat files to check for existing data
file_number = size(files,1);
data_file = 'None';
file_to_search = [feature '_data_' strfilename]; %search for the file that has those features

for file_idx = 1:file_number
    str = files(file_idx).name; %get the pattern
    if ~isempty(regexp(str, file_to_search, 'match'))
        data_file = str;
    end
end
if strcmp(data_file, 'None')
    data = [];
    jp_image = jp_image_org;
    return
else
    load(data_file)
    jp_image = jp_image_org;
end
%Now we are going to have a data file with the structure 
%We will generate a file that has all the coordinates of the data sets.
%structure is 
%data = [y_coord(1):y_coord(2)
%        x_coord(2):x_coord(2)]
datapoints = size(data,3);

for data_idx = 1:datapoints
    y_coord = data(1,:,data_idx); %careful with the orientation
    x_coord = data(2,:,data_idx);
    jp_image(x_coord(1):x_coord(2),y_coord(1):y_coord(2),:) = 0;
end


