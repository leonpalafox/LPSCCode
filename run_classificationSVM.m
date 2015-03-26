function [image_matrix_class, prob_plot] = run_classificationSVM(config, svm_model, ar_size, scale_factor)
%%This function creates the pooled image
%%ar_size: The iwndow size so the classification works
%%mu and sigma train come from calculating the zscore in the classifier
%%Create the matrix
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = imresize(hirise_img, scale_factor);
hirise_img = double(hirise_img)/255;
image_matrix_class = create_matrix(hirise_img, 2);
%%
prob_plot(1) = 0;
window_overlap = 0.1; %Overlap is 10%
step = round(ar_size*(1-window_overlap));
count = 0;
testing_data = generate_test(hirise_img, step, ar_size);
img_idx = 1;
for window_row_idx = 1:step:(size(image_matrix_class(:,:,1),1)-ar_size)
    for window_col_idx = 1:step:(size(image_matrix_class(:,:,1),2)-ar_size)
          data_temp = testing_data(:,:,img_idx);
          [pred_class,score]=predict(svm_model,reshape(data_temp',1, ar_size*ar_size));%reshapeing the image
          image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,pred_class) = image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,pred_class)+1;
          img_idx = img_idx + 1;
    end
end
image_matrix_class = imresize(image_matrix_class, 1.0/scale_factor);
end