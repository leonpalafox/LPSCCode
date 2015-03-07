<<<<<<< HEAD
function [patches, upper_x, upper_y, patches_structure] = generate_random_patches(config, num_patches, pixel_size)
=======
function patches_structure = generate_random_patches(config, num_patches)
>>>>>>> origin/master
%%
%This function generates a set of random patches, while keeping track of
%their coordinates
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = double(hirise_img)/255;
<<<<<<< HEAD
patch_size = pixel_size; %Size of each patch
=======
patch_size = config.data{7}; %Size of each patch
patch_size = 20; %Size of each patch
>>>>>>> origin/master
[max_y, max_x] = size(hirise_img);
upper_x = unidrnd(max_x-patch_size, 1, num_patches);
upper_y = unidrnd(max_y-patch_size, 1, num_patches);
patches_array{2}=[];
patches_array{4}=[];
patches_array{6}=[];
patches_array{8}=[];
<<<<<<< HEAD
patches = zeros(patch_size, patch_size, num_patches);

for patch_idx = 1:num_patches
    patches(:,:, patch_idx) = hirise_img(upper_y(patch_idx):upper_y(patch_idx)+patch_size-1, upper_x(patch_idx):upper_x(patch_idx)+patch_size-1);
    for cell_size=2:2:8
        patches_HoG(1,:,patch_idx)={extractHOGFeatures(patches(:,:,patch_idx),'CellSize',[cell_size cell_size])}; 
        patches_array{cell_size}=[patches_array{cell_size} patches_HoG(1,:,patch_idx)];
        clear patches_HoG
    end
end    
[n, m, samples] = size(patches);
patches = reshape(permute(patches,[3 2 1]),samples,n*m);
%patches = zscore(patches);
patches_PCA={pca(patches')};
patches_structure=struct('Patches', {patches}, 'HoG_Patches_2x2', {patches_array{2}}, 'HoG_Patches_4x4', {patches_array{4}}, 'HoG_Patches_6x6', {patches_array{6}},'HoG_Patches_8x8', {patches_array{8}}, 'Patches_PCA', {patches_PCA}); 

end


=======
[patches_rowsize, patches_colsize]=size(hirise_img(upper_y(num_patches):upper_y(num_patches)+patch_size-1,upper_x(num_patches):upper_x(num_patches)+patch_size-1));
patches_3dsize=num_patches;
patches=zeros(patches_rowsize,patches_colsize,patches_3dsize);
for patch_idx = 1:num_patches
    patches(:,:, patch_idx) = hirise_img(upper_y(patch_idx):upper_y(patch_idx)+patch_size-1, upper_x(patch_idx):upper_x(patch_idx)+patch_size-1);
    temp2=extractHOGFeatures(patches(:,:,patch_idx),'CellSize',[2 2]);
    temp4=extractHOGFeatures(patches(:,:,patch_idx),'CellSize',[4 4]);
    temp8=extractHOGFeatures(patches(:,:,patch_idx),'CellSize',[8 8]);    
    if patch_idx==1
       patches_HoG2=zeros(num_patches,size(temp2,2));
       patches_HoG4=zeros(num_patches,size(temp4,2));
       patches_HoG8=zeros(num_patches,size(temp8,2));
       patches_HoG2(patch_idx,:)=temp2;
       patches_HoG4(patch_idx,:)=temp4;
       patches_HoG8(patch_idx,:)=temp8;
    else
       patches_HoG2(patch_idx,:)=temp2;
       patches_HoG4(patch_idx,:)=temp4;
       patches_HoG8(patch_idx,:)=temp8;
    end
end

[n, m, samples] = size(patches);
patches = reshape(permute(patches,[3 2 1]),samples,n*m);
patches = zscore(patches);
patches_PCA=pca(patches');
patches_structure=struct('Patches', {patches}, 'HoG_Patches_2x2', patches_HoG2, 'HoG_Patches_4x4', patches_HoG4,'HoG_Patches_8x8', patches_HoG8, 'Patches_PCA', patches_PCA, 'Upper_X',{upper_x},'Upper_Y', {upper_y}); 
end
>>>>>>> origin/master
