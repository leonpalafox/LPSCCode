function image_structure = read_reshape_dataset_labeled(config, pixel_size)
%In this script, we take all the images and make them the same size
%as wellas we flatten them to input in a classifier
%%First we load the data matrix
folder  = '..\Data\';
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
% cell_size=config.data{8};
% cell_size=double(cell_size);


%%First we need to find alll of the mat files

%%
%%Check if the pixel size is within the range
if ~ismember(pixel_size, config.data{7})
    error('myApp:argChk', 'The pixel size is not within the range') 
end

mat_files = dir(['window_size' num2str(pixel_size) '_*_' strfilename '.mat']); %finds all the files that have widnows of the pixel size
%%
%Now we concatenate all of the data files in them
master_data=[];
master_label = {};
file_number = size(mat_files,1);
for file_idx = 1:file_number
    load(mat_files(file_idx).name)
    file_feat = strsplit(mat_files(file_idx).name, '_'); %we get the feature of this file
    file_feat = file_feat(3); 
    datap = size(data,3); %get the number of datapoints
    label_file=repmat(file_feat,1,datap);
    master_label = cat(2,master_label, label_file);%concatenate all the labels for this dataset
    master_data = cat(3,data,master_data);
    clear data
end
   
%data = [y_coord(1):y_coord(2)
%        x_coord(2):x_coord(2)]
%Now we need to load all the the JP2 images
image_files = dir([folder, '*.png']);
number_files = size(image_files,1);
number_mat_files = size(mat_files,1);
master_im_idx = 1;
unique_labels=unique(master_label);
% for file_idx= 1:number_files
file_idx=1;
     strfilename = strsplit(image_files(file_idx).name, '.');
     strfilename = strfilename{1};
    %Check if the file image has a correspondet mat file
    for mat_idx = 1:number_mat_files
        str = mat_files(mat_idx).name;
        if ~isempty(regexp(str, strfilename, 'match'))
            load(str)
            hirise_img = imread([folder image_files(file_idx).name]);%Load the file image
            hirise_img = double(hirise_img)/255;
            if mat_idx==1
                [image_array_rowsize,image_array_colsize]=size(hirise_img(data(2,1,size(data,3)):data(2,2,size(data,3)),data(1,1,size(data,3)):data(1,2,size(data,3))));
                image_array_3dsize=size(data,3)*number_mat_files*number_files;
                image_array = zeros(image_array_rowsize,image_array_colsize,image_array_3dsize);
            end
%             hoglabels(size(data,3)-(number_mat_files-mat_idx)*size(data,3)+1:size(data,3)*mat_idx,1)=unique_labels(mat_idx);
            for im_idx = 1:size(data,3)
                
                test_img = hirise_img(data(2,1,im_idx):data(2,2,im_idx),data(1,1,im_idx):data(1,2,im_idx)); %extract the imgaages
                image_array(:,:,master_im_idx) = test_img;
                temp2=extractHOGFeatures(test_img,'CellSize',[2 2]); 
                temp4=extractHOGFeatures(test_img,'CellSize',[4 4]); 
                temp8=extractHOGFeatures(test_img,'CellSize',[8 8]); 
                if im_idx==1 && mat_idx==1
                    features2=zeros(image_array_3dsize,size(temp2,2));
                    features4=zeros(image_array_3dsize,size(temp4,2));
                    features8=zeros(image_array_3dsize,size(temp8,2));
                    features2(master_im_idx,:)=temp2;
                    features4(master_im_idx,:)=temp4;
                    features8(master_im_idx,:)=temp8;
                else
                    features2(master_im_idx,:)=temp2;
                    features4(master_im_idx,:)=temp4;
                    features8(master_im_idx,:)=temp8;
                end       
                master_im_idx = master_im_idx+1;
            end
        end
     end
% end
data_folder = 'data\';
name = 'all_images_';
samples = num2str(size(master_label,2));
savename = [data_folder name, samples,'_', strfilename '.mat'];
save(savename,'image_array')
[n,m,samples]= size(image_array);
image_flat = reshape(permute(image_array,[3 2 1]),samples,n*m);
pcacoeff=pca(image_flat');
images = image_flat;
labels = master_label;
image_structure=struct('Original_Images',{images},'HoG_Features_2x2',features2,'Labels',{labels'});
end
%'HoG_Features_4x4',features4,'HoG_Features_8x8',features8,'PCA_Coefficients',pcacoeff,
