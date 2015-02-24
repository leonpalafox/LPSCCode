function cnn = train_cnn(images, labels)
%This function uses the CNN 
%create label array
[images, mu, sigma] = zscore(images);
num_labels = grp2idx(labels);
input_size = size(images,2)^0.5; %check the size of the images
numClasses=length(unique(num_labels));
labcnn = zeros(size(num_labels,1),numClasses);%This creates the labels int he required format
for class_idx = 1:numClasses
    labcnn(num_labels==class_idx, class_idx)=1;
end
subset = 30;
[trainLabels, idx] = datasample(labcnn, subset, 'Replace', false);
trainData = images(idx,:);

train_x = reshape(trainData',input_size,input_size, size(trainData, 1));
train_y = trainLabels';
%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error
rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 100;
opts.plot = 1; 
cnn = cnntrain(cnn, train_x, train_y, opts);
[er, bad] = cnntest(cnn, train_x, train_y)
figure; plot(cnn.rL);

%%

