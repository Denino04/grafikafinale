function polygonFill()

    % Initialize figure
    figure;
    axis([0 20 0 20]); % Set the size of the graph to 1000x1000
    hold on;
    title('Draw a polygon by clicking on the figure');
    
    % Wait for the user to draw the polygon
    fprintf('Click on the figure to draw the polygon. Press ''Enter'' when done.\n');
    polygon = drawPolygon();
    
    % Display options
    fprintf('Choose fill algorithm:\n');
    fprintf('1. Boundary fill\n');
    fprintf('2. Flood fill\n');
    algorithm = input('Enter your choice: ');

    % Fill the polygon based on the selected algorithm
    switch algorithm
        case 1
            fill_color = input('Enter fill color ([R, G, B]): ');
            boundaryFill(polygon, fill_color);
        case 2
            fill_color = input('Enter fill color ([R, G, B]): ');
            floodFill(polygon, fill_color);
        otherwise
            fprintf('Invalid choice. Exiting.\n');
    end

end

function polygon = drawPolygon()
    polygon = [];
    while true
        [x, y] = ginput(1);
        if isempty(x) || isempty(y)
            break;
        end
        polygon = [polygon; x, y];
        plot(x, y, 'bo');
    end
    polygon = [polygon; polygon(1,:)]; % Close the polygon
end

function boundaryFill(polygon, fill_color)
    % Get polygon boundaries
    minX = min(polygon(:,1));
    maxX = max(polygon(:,1));
    minY = min(polygon(:,2));
    maxY = max(polygon(:,2));
    
    % Boundary fill algorithm
    for x = minX:maxX
        for y = minY:maxY
            if inpolygon(x, y, polygon(:,1), polygon(:,2))
                plot(x, y, 's', 'Color', fill_color / 255, 'MarkerFaceColor', fill_color / 255); % Scale color values
            end
        end
    end
end

function floodFill(polygon, fill_color)
    % Get the boundary color (color of the axes background)
    boundary_color = getBoundaryColor();
    
    % Create a matrix to track filled pixels
    filled = false(1000);
    
    % Start flood fill from the centroid of the polygon
    start_x = round(mean(polygon(:,1)));
    start_y = round(mean(polygon(:,2)));
    
    % Create a stack to hold points to be processed
    stack = zeros(1000, 2); % Preallocate stack to avoid resizing
    stack_top = 0; % Stack top pointer
    
    % Push starting point onto the stack
    stack_top = stack_top + 1;
    stack(stack_top, :) = [start_x, start_y];
    
    % Flood fill until the stack is empty
    while stack_top > 0
        % Pop a point from the stack
        x = stack(stack_top, 1);
        y = stack(stack_top, 2);
        stack_top = stack_top - 1;
        
        % Check if the pixel is within the polygon and not already filled
        if inpolygon(x, y, polygon(:,1), polygon(:,2)) && ~filled(y, x)
            % Fill the pixel
            plot(x, y, 's', 'Color', fill_color / 255, 'MarkerFaceColor', fill_color / 255); % Scale color values
            filled(y, x) = true; % Mark pixel as filled
            
            % Push neighboring pixels onto the stack
            if x > 1 % Left
                stack_top = stack_top + 1;
                stack(stack_top, :) = [x-1, y];
            end
            if x < 1000 % Right
                stack_top = stack_top + 1;
                stack(stack_top, :) = [x+1, y];
            end
            if y > 1 % Up
                stack_top = stack_top + 1;
                stack(stack_top, :) = [x, y-1];
            end
            if y < 1000 % Down
                stack_top = stack_top + 1;
                stack(stack_top, :) = [x, y+1];
            end
        end
    end
end


function color = getpixelcolor(x, y)
    ax = gca;
    img = getframe(ax);
    color = img.cdata(y, x, :);
end

function color = getBoundaryColor()
    ax = gca;
    color = get(ax, 'Color'); % Get the color of the axes background
end
