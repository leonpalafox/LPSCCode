function matrix = create_matrix(config)
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = double(hirise_img)/255;
matrix=zeros(size(hirise_img)); %This generates a matrix the same size as the image
%this matrix will be populated as the classifiers run
%%This script creates the result matrix
