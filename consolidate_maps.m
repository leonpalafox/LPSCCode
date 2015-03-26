function out_map = consolidate_maps(map_cell, range)
%map_cell is a cell thatc ontains all the maps that we need, we will only
%be using the one for the first index right now
%first we need to normalize each of th maps so they are ina comparabel
%dimension
cell_numb = size(map_cell, 2);%get the number of cells
cell_numb = range(end);
cell_start  = range(1);
final_map = zeros(size(map_cell{1}(:,:,1)));
for map_idx = cell_start:cell_numb
   max_index = max(max(map_cell{map_idx}(:,:,1))); %get the max probability
   map_cell{map_idx}(:,:,1) = map_cell{map_idx}(:,:,1)/max_index; %normalize to the max
   final_map = final_map + map_cell{map_idx}(:,:,1);
end
out_map = final_map;
  
