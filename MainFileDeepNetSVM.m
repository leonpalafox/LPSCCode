
%%
%%This script generates two datasets, one is a dataset with positive
%%samples of the feature to classify, and another are negative samples.
%%this is a two class classifier

%First, we need to call a dialog to generate the settings file
%TODO generate GUI
%Here we do all by ourselves
delete '*.mat'
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = 'C:\Users\leon\Documents\Data\GeneralData\ConeFields\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones';
config.data{4} = 2;%positive examples
config.data{5} = 3; %negative examples
config.data{6} = 50; %hidden neurons
config.data{7} = [20, 40, 60]; %minimum size

%Now that we have all the values, store all of them in an structure and
%save them in our config file
%
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
%crop_working_image(config)
%break
create_dataset('cones', config)
create_dataset('negative', config)
break
[images, labels] = read_reshape_dataset_labeled(config);
c = cvpartition(labels,'k',2); %create two a training and a testing dataset
test_x = images(c.test(1),:);
train_x = images(c.training(1),:);
%run_stacked_autoencoder(images, labels, config)
%run_autoencoder(zscore(images(1:20,:)), config)
num_patches = 1000;
[patches, upper_x, upper_y] = generate_random_patches(config, num_patches);
%classify_patches %This scripts classifies the patches with the autoencoder
%classify_svm
%classifyCNN
