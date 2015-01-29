function generate_windows(feature, config)
%This function generates the windows given different windows, sizes, it
%only creates coordinates, not actual windows from the image
feature_list = strtrim(strsplit(config.data{3},',')); %get all of the features list
if isempty(strmatch(feature, feature_list, 'exact'))&&~strcmp(feature, 'negative')
    error('This is an unvalid feature')
end
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
load(['coordinates_' strfilename '.mat'])
windows_size = config.data{7};
for size_idx = 1:length(windows_size)
    data = generate_datapoints(y_coord, x_coord, 4, windows_size(size_idx));%creates de datapoints with a given size
    %We will generate a file that has all the coordinates of the data sets.
    %structure is 
    %data = [y_coord(1):y_coord(2)
    %        x_coord(1):x_coord(2)]

    close all
    %Double check for size consistency


    name = ['window_size' num2str(windows_size(size_idx)) '_' feature '_data_'];
    savename = [name, strfilename '.mat'];
    save(savename,'data')
end