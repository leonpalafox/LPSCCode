
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
config.data{4} = 100;%positive examples (craters, cones, etc)
config.data{5} = 100; %negative examples
config.data{6} = 5; %hidden neurons
config.data{7} = [16, 20, 32, 40, 52]; %different sizes
config.data{8} = [8 8]; %Cell size for the HOG
%%
%Now that we have all the values, store all of them in an structure and
%save them in our config file
%
create_config_file(config, 'config.lpd');% For the moment, the config file
%is only to see in a text file all the variables
%crop_working_image(config)

create_dataset('cones', config)
create_dataset('negative', config)
%create_dataset('crater', config)
%break
generate_windows('cones', config)
generate_windows('negative', config)
%generate_windows('crater', config)

%%
new_class_flag = 1;
resize_factor = 1;
if new_class_flag == 1
    cnn_cell = cell(1,5);
    map_cell = cell(1,5);
    learning_plot_cell = cell(1,5);
end

parfor pixel_idx = 1:5
        [images, labels, features, image_structure] = read_reshape_dataset_labeledv2(config, config.data{7}(pixel_idx), resize_factor);
        [cnn, mu_train, sigma_train, learning_plot] = train_cnn(images, labels); %this retunr a function handler to work with the cnn
        learning_plot_cell{pixel_idx} = learning_plot;
        cnn_cell{pixel_idx} = cnn;
        [classified_map, prob_plot] = run_classificationv2(config, cnn_cell{pixel_idx}, config.data{7}(pixel_idx), resize_factor);
        map_cell{pixel_idx} = classified_map;
end
output_map = consolidate_maps(map_cell);
plot_learning_rates(learning_plot_cell, config);
plot_image(config, output_map, resize_factor);
test_new_image(cnn_cell)