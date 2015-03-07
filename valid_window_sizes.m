function valid_window_sizes()
first_layer = 5;
second_layer = 2;
third_layer = 5;
fourth_layer = 2;

for idx = 1:10
    value(idx) = (((idx*fourth_layer)+third_layer-1)*second_layer)+first_layer-1;
end

value

    