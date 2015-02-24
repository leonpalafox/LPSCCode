function [patches, upper_x, upper_y, patches_structure] = generate_random_patches(config, num_patches)
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
patches_array{2}=[];
patches_array{4}=[];
patches_array{6}=[];
patches_array{8}=[];
for patch_idx = 1:num_patches
    patches(:,:, patch_idx) = hirise_img(upper_y(patch_idx):upper_y(patch_idx)+patch_size-1, upper_x(patch_idx):upper_x(patch_idx)+patch_size-1);
    for cell_size=2:2:8
        patches_HoG(1,:,patch_idx)={extractHOGFeatures(patches(:,:,patch_idx),'CellSize',[cell_size cell_size])}; 
        patches_array{cell_size}=[patches_array{cell_size} patches_HoG(1,:,patch_idx)];
        clear patches_HoG
    end    
[n, m, samples] = size(patches);
patches = reshape(permute(patches,[3 2 1]),samples,n*m);
patches = zscore(patches);
patches_PCA={pca(patches')};
patches_structure=struct('Patches', {patches}, 'HoG_Patches_2x2', {patches_array{2}}, 'HoG_Patches_4x4', {patches_array{4}}, 'HoG_Patches_6x6', {patches_array{6}},'HoG_Patches_8x8', {patches_array{8}}, 'Patches_PCA', {patches_PCA}); 
end
end


