function heatMeshgrid(img, x_range, y_range, scaleFactors)


%     img is the input image.
%     x_range and y_range specify the x- and y-axis limits for the meshgrid.
%     meshgrid creates a 2D grid of X and Y coordinates with 100 points each, spanning the specified ranges.
%     imagesc displays the input image.
%     plot3 plots the meshgrid points over the image, using a scatter plot with dots ('Marker', '.'). The zeros(size(X(:))) term ensures that the z-coordinate is zero, since we’re only plotting 2D points.
%     axis image sets the aspect ratio to ‘image’, which ensures the grid lines are aligned with the image axes.
%     colormap gray sets the colormap to grayscale.
%     axis off turns off the axis labels and ticks.


    % Define the meshgrid parameters
x=round(linspace(x_range(1), x_range(2), 4));
y=round(linspace(y_range(1), y_range(2), 4));

[X1, Y1] = meshgrid(linspace(x(1), x(3), 170), ...
                       linspace(y_range(1), y_range(2), 170));
Z1=zeros(size(X1(:)));

[X2, ~] = meshgrid(linspace(x(2), x(4), 170), ...
                       linspace(y(2), y(3), 170));
Z2=linspace(scaleFactors(1), scaleFactors(2), length(X2(:)));

[X3, ~] = meshgrid(linspace(x(3), x(4), 170), ...
                       linspace(y(3), y(4), 170));
Z3=linspace(scaleFactors(1), scaleFactors(2), length(X2(:)));

Z3=Z3/max(Z3);
 % Display the meshgrid over the image
    imagesc(img);
    hold on;
    plot3(X1(:), Y1(:), Z1, X2(:), Y1(:), Z2, X3(:), Y1(:), Z3,  'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 2);
    axis image;
    colormap gray;
    axis off;
    hold off;
end