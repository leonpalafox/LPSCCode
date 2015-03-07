function generate_image(config, upper_x, upper_y, class, pixel_size)
%%
%This function generates a large image with the classified patches marked
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = '..\Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
imshow(hirise_img)
patch_size = pixel_size; %Size of each patch
num_patches = size(class,1);
for patch_idx = 1:num_patches
    if class(patch_idx) == 1;
        rectangle('Position', [upper_x(patch_idx), upper_y(patch_idx), patch_size-1, patch_size-1], 'EdgeColor', 'blue')
        hline1 = line(NaN,NaN,'LineWidth',4,'LineStyle','--','Color','blue');
    elseif class(patch_idx) == 2;
        rectangle('Position', [upper_x(patch_idx), upper_y(patch_idx), patch_size-1, patch_size-1], 'EdgeColor', 'red')
        hline2 = line(NaN,NaN,'LineWidth',4,'LineStyle','--','Color','red');
   
    end
end
h=legend([hline1 hline2],'VRC','Empty Space');
htext=findobj(get(h,'children'),'type','text');
set(htext,'fontsize',16,'fontweight','bold');