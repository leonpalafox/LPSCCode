
%%
%%This script generates two datasets, one is a dataset with positive
%%samples of the feature to classify, and another are negative samples.
%%this is a two class classifier
%Also, this file uses the matlab functionalities to run in parallel for
%different window sizes in the trining patters.

%First, we need to call a dialog to generate the settings file
%TODO generate GUI
%Here we do all by ourselves
%delete '*.mat'
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = 'C:\Users\leon\Documents\Data\GeneralData\ConeFields\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones, crater';
config.data{4} = 20;%positive examples (craters, cones, etc)
config.data{5} = 20; %negative examples
config.data{6} = 5; %hidden neurons
config.data{7} = [20, 40, 60]; %different sizes
config.data{8} = [8 8]; %Cell size for the HOG
%%
%Now that we have all the values, store all of them in an structure and
%save them in our config file
%
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
%crop_working_image(config)

%create_dataset('cones', config)
%create_dataset('negative', config)
%create_dataset('crater', config)
%break
%generate_windows('cones', config)
%generate_windows('negative', config)
%generate_windows('crater', config)

%%
[images, labels, features, image_structure] = read_reshape_dataset_labeled(config, 60);
image_matrix = create_matrix(config);
cnn = train_cnn(images, labels); %this retunr a function handler to work with the cnn
break
classified_map = run_classification(image_matrix, config, cnn, 60);
