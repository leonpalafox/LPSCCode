function generate_image(config, upper_x, upper_y, class)
%%
%This function generates a large image with the classified patches marked
filename = config.data{2};
strfilename = strsplit(filename, '.');
strfilename = strfilename{1};
folder = 'Data\';
filename = strcat(strfilename, '.png');
filename = [folder filename];
hirise_img = imread(filename);
imshow(hirise_img)
patch_size = config.data{7}; %Size of each patch
patch_size = 60; %Size of each patch
num_patches = size(class,1);
for patch_idx = 1:num_patches
    if class(patch_idx) == 1;
        rectangle('Position', [upper_x(patch_idx), upper_y(patch_idx), patch_size-1, patch_size-1], 'EdgeColor', 'blue')
        hline1 = line(NaN,NaN,'LineWidth',4,'LineStyle','--','Color','blue');
    elseif class(patch_idx) == 2;
        rectangle('Position', [upper_x(patch_idx), upper_y(patch_idx), patch_size-1, patch_size-1], 'EdgeColor', 'red')
        hline2 = line(NaN,NaN,'LineWidth',4,'LineStyle','--','Color','red');
    elseif class(patch_idx) == 3;
        rectangle('Position', [upper_x(patch_idx), upper_y(patch_idx), patch_size-1, patch_size-1], 'EdgeColor', 'green')
        hline3 = line(NaN,NaN,'LineWidth',4,'LineStyle','--','Color','green');
    
    end
end
h=legend([hline1 hline2 hline3],'VRC','Empty Space', 'Crater');
htext=findobj(get(h,'children'),'type','text');
set(htext,'fontsize',16,'fontweight','bold');