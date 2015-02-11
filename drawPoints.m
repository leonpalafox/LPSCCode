function drawPoints(image_in, points)
%%This function draws a circle in the position of each of the points in the
%%points array
imshow(image_in)
hold on
xpoints = points(1,:);
ypoints = points(2,:);
for point_idx=1:length(xpoints)
    plot(xpoints(point_idx), ypoints(point_idx), 'go'); 
end
