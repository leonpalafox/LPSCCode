
%%
%%This script generates two datasets, one is a dataset with positive
%%samples of the feature to classify, and another are negative samples.
%%this is a two class classifier

%First, we need to call a dialog to generate the settings file
%TODO generate GUI
%Here we do all by ourselves
%delete '*.mat'
config.labels = {'Data Folder', 'File to use', 'Features to classify', 'Positive Examples', 'Negative Examples', 'Hidden Neurons', 'Minimum image size'};
config.data{1} = 'C:\Users\leon\Documents\Data\GeneralData\ConeFields\';
config.data{2} = 'PSP_002292_1875_RED.QLOOK.JP2';
config.data{3} = 'cones, crater';
config.data{4} = 10;%positive examples (craters, cones, etc)
config.data{5} = 10; %negative examples
config.data{6} = 50; %hidden neurons
config.data{7} = [16, 20, 32, 40, 52]; %different sizes
config.data{8} = [8 8];

%Now that we have all the values, store all of them in an structure and
%save them in our config file
%
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
%crop_working_image(config)
%break
%create_dataset('cones', config)
%create_dataset('negative', config)
%create_dataset('crater', config)
%break
generate_windows('cones', config)
generate_windows('negative', config)
%generate_windows('crater', config)



%[images, labels, features, image_structure] = read_reshape_dataset_labeledv2(config, 20, 1);

%run_stacked_autoencoder(images, labels, config)
%run_autoencoder(zscore(images(1:20,:)), config)
num_patches = 10000;
%patches_structure = generate_random_patches(config, num_patches);
%classify_patches %This scripts classifies the patches with the autoencoder
new_class_flag = 1;
resize_factor = 1;
if new_class_flag == 1
    svm_cell = cell(1,5);
    map_cell = cell(1,5);
    learning_plot_cell = cell(1,5);
end


parfor pixel_idx = 1:5
        pixel_idx
        image_structure = read_reshape_dataset_labeled(config, config.data{7}(pixel_idx));
        [svm_model]=classify_svm_v4(image_structure);
        [image_matrix_class, prob_plot] = run_classificationSVM(config, svm_model,  config.data{7}(pixel_idx), resize_factor);
        svm_cell{pixel_idx} = svm_model;
        map_cell{pixel_idx} = image_matrix_class;
end
output_map = consolidate_maps(map_cell, 1:5);
plot_image(config, output_map, resize_factor);
save('svm_session.mat', 'svm_cell', 'config', 'map_cell', 'resize_factor')
