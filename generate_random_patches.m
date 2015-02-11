function [patches, upper_x, upper_y] = generate_random_patches(config, num_patches)
%%
%This function generates a set of random patches, while keeping track of
%their coordinates
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = 'Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = double(hirise_img)/255;
patch_size = config.data{7}; %Size of each patch
patch_size = 60; %Size of each patch
[max_y, max_x] = size(hirise_img);
upper_x = unidrnd(max_x-patch_size, 1, num_patches);
upper_y = unidrnd(max_y-patch_size, 1, num_patches);
for patch_idx = 1:num_patches
    patches(:,:, patch_idx) = hirise_img(upper_y(patch_idx):upper_y(patch_idx)+patch_size-1, upper_x(patch_idx):upper_x(patch_idx)+patch_size-1);
end
[n, m, samples] = size(patches);
patches = reshape(permute(patches,[3 2 1]),samples,n*m);
patches = zscore(patches);
end


