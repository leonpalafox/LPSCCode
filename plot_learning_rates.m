function h = plot_learning_rates(learning_rates_cell, config)
%This plots the learning rates using the CNN
cell_numb = size(learning_rates_cell, 2);%get the number of cells
h = figure; %generate the figure
hold on
cc=hsv(cell_numb);
Legend=cell(cell_numb,1);
for cell_idx = 1:cell_numb %go over all the rates
    %x = log10(1:size(learning_rates_cell{cell_idx},2));
    semilogx(learning_rates_cell{cell_idx}, 'color', cc(cell_idx,:), 'LineWidth', 2)
    Legend{cell_idx}=strcat('Window size:', num2str( config.data{7}(cell_idx)));
end 
set(gca,'XScale','log');
xlabel('Epochs')
ylabel('Accuracy (% Error on Training Data)')
legend(Legend)
set(gca,'FontSize',21,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize',21,'fontWeight','bold')
grid on
set(h, 'Position', [2824, 281, 1750, 1093])