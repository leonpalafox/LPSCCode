function [images, labels] = read_reshape_dataset_labeled(config)
%In this script, we take all the images and make them the same size
%as wellas we flatten them to input in a classifier
%%First we load the data matrix
folder  = 'Data\';
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
%%First we need to find alll of the mat files
files = dir('*.mat'); %Get all the mat files
%%
%Now we concatenate all of the data files in them
master_data=[];
master_label = {};
file_number = size(files,1);
for file_idx = 1:file_number
    load(files(file_idx).name)
    file_feat = strsplit(files(file_idx).name, '_'); %we get the feature of this file
    file_feat = file_feat(1); 
    datap = size(data,3); %get the number of datapoints
    label_file=repmat(file_feat,1,datap);
    master_label = cat(2,master_label, label_file);%concatenate all the labels for this dataset
    master_data = cat(3,data,master_data);
end
   
%data = [y_coord(1):y_coord(2)
%        x_coord(2):x_coord(2)]
%Now we need to load all the the JP2 images
image_files = dir([folder, '*.png']);
number_files = size(image_files,1);
mat_files = dir('*.mat');
number_mat_files = size(mat_files,1);
image_array = [];
master_im_idx = 1;
for  file_idx= 1:number_files
    strfilename = strsplit(image_files(file_idx).name, '.');
    strfilename = strfilename{1};
    %Check if the file image has a correspondet mat file
    for mat_idx = 1:number_mat_files
        str = mat_files(mat_idx).name;
        if ~isempty(regexp(str, strfilename, 'match'))
            load(str)
            hirise_img = imread([folder image_files(file_idx).name]);%Load the file image
            hirise_img = double(hirise_img)/255;
            for im_idx = 1:size(data,3)
                test_img = hirise_img(data(2,1,im_idx):data(2,2,im_idx),data(1,1,im_idx):data(1,2,im_idx),:); %extract the imgaages
                image_array(:,:,master_im_idx) = test_img;
                master_im_idx = master_im_idx+1;
            end
        end

    end
end
data_folder = 'data\';
name = 'all_images_';
samples = num2str(size(master_label,2));
savename = [data_folder name, samples,'_', strfilename '.mat'];
save(savename,'image_array')
[n,m,samples]= size(image_array);
image_flat = reshape(permute(image_array,[3 2 1]),samples,n*m);
images = image_flat;
labels = master_label;

