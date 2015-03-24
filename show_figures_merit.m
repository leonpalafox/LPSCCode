function show_figures_merit(config, cnn_cell, resize_factor)
%This presents some figures of meritt given the classifiers.
%First we need to load labels 
for pixel_idx = 1:5
    input_size =  config.data{7}(pixel_idx);
    [images, labels, features, image_structure] = read_reshape_dataset_labeledv2(config, config.data{7}(pixel_idx), resize_factor);
    %images = zscore(images);
    test_x = permute(reshape(images',input_size,input_size, size(images, 1)),[2,1,3]); %we have to add the permute so it is an image
    %net = cnnff(cnn_cell{pixel_idx}, test_x);
    %[~, h] = max(net.o);
    h = predict(cnn_cell{pixel_idx}, images);
    num_labels = grp2idx(labels);
    classperf(num_labels, h')
    
end
