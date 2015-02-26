function [image_matrix_class, prob_plot] = run_classification(image_matrix, config, cnn, ar_size)
%%This function creates the pooled image
%%ar_size: The iwndow size so the classification works
%%Create the matrix
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = double(hirise_img)/255;
%%
prob_plot(1) = 0;
window_overlap = 0.1; %Overlap is 90%
image_matrix_class = repmat(image_matrix, 1,1,3); %create the array that has all the data
step = floor(ar_size*(1-window_overlap));
for window_row_idx = 1:step:(size(image_matrix,1)-ar_size)
    for window_col_idx = 1:step:(size(image_matrix,2)-ar_size)
        data_temp = hirise_img(window_row_idx:window_row_idx+ar_size-1, window_col_idx:window_col_idx+ar_size-1);%point to classify
        data_temp_3d = repmat(data_temp,1,1,10);
        net = cnnff(cnn, data_temp_3d);
        [~, h] = max(net.o);
        prob_plot(end+1) = unique(net.o(1,:));
        if unique(h)==1
            image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,1) = image_matrix_class (window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,1)+unique(net.o(1,:));
        elseif unique(h)==2
            image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,2) = image_matrix_class (window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,2)+1;
        else
            image_matrix_class(window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,3) = image_matrix_class (window_row_idx:window_row_idx+ar_size, window_col_idx:window_col_idx+ar_size,3)+1;
        end
    end
end
