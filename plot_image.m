function plot_image(config, map, scale_factor)
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
hirise_img = imresize(hirise_img, scale_factor);
hirise_img = double(hirise_img)/255;
patches_img = imshow(map);
hold on
first_img = imshow(hirise_img);
set(first_img, 'AlphaData', first_img)