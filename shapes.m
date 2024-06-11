function drawShapesGUI
    % Create the figure
    f = figure('Name', 'Drawing Shapes', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
    
    % Create the axes for the grid
    ax = axes('Parent', f, 'Position', [0.1, 0.2, 0.6, 0.7]);
    axis([0 20 0 20]);
    grid on;
    hold on;

    % Main menu for selecting shape
    shapeMenu = uicontrol('Style', 'popupmenu', 'String', {'Select Shape', 'Line', 'Circle', 'Ellipse'}, 'Position', [620, 550, 150, 30], 'Callback', @selectShape);
    
    % Algorithm selection menu
    algoMenu = uicontrol('Style', 'popupmenu', 'String', {'DDA', 'Bresenham'}, 'Position', [620, 480, 150, 30], 'Visible', 'off');
    
    % Button to clear the grid
    eraseButton = uicontrol('Style', 'pushbutton', 'String', 'Erase Lines', 'Position', [620, 440, 150, 30], 'Callback', @clearGrid);

    % Set up the callback for mouse clicks
    set(f, 'WindowButtonDownFcn', @getPoints);

    points = [];  % Array to store the clicked points
    selectedShape = '';

    function selectShape(~, ~)
        shapeValue = shapeMenu.Value;
        switch shapeValue
            case 2  % Line
                selectedShape = 'Line';
                algoMenu.Visible = 'on';
                points = [];
                disp('Selected Line. Click two points to draw the line.');
            case 3  % Circle
                selectedShape = 'Circle';
                algoMenu.Visible = 'off';
                points = [];
                disp('Selected Circle. Click the center and then the edge of the circle.');
            case 4  % Ellipse
                selectedShape = 'Ellipse';
                algoMenu.Visible = 'off';
                points = [];
                disp('Selected Ellipse. Click the center and then define the semi-major and semi-minor axes.');
            otherwise
                selectedShape = '';
                algoMenu.Visible = 'off';
        end
    end

    function getPoints(~, ~)
        if isempty(selectedShape)
            disp('Please select a shape first.');
            return;
        end

        % Get the current point
        pt = get(ax, 'CurrentPoint');
        x = round(pt(1, 1));
        y = round(pt(1, 2));

        % Ensure the point is within the grid bounds
        if x >= 1 && x <= 20 && y >= 1 && y <= 20
            points = [points; x, y];
            plot(x, y, 'ro');  % Plot the selected point
        end

        % If the required number of points are selected, draw the shape
        if strcmp(selectedShape, 'Line') && size(points, 1) == 2
            algo = algoMenu.Value;
            if algo == 1
                drawLineDDA(points(1, 1), points(1, 2), points(2, 1), points(2, 2));
            else
                drawLineBresenham(points(1, 1), points(1, 2), points(2, 1), points(2, 2));
            end
            points = [];  % Reset points array for the next line
        elseif strcmp(selectedShape, 'Circle') && size(points, 1) == 2
            radius = round(sqrt((points(2, 1) - points(1, 1))^2 + (points(2, 2) - points(1, 2))^2));
            drawCircle(radius, points(1, 1), points(1, 2));
            points = [];  % Reset points array for the next circle
        elseif strcmp(selectedShape, 'Ellipse') && size(points, 1) == 2  % Check if two points are selected for ellipse
        a = abs(points(1, 1) - points(2, 1));  % Semi-major axis
        b = abs(points(1, 2) - points(2, 2));  % Semi-minor axis
        drawEllipseMatlab(a, b, points(1, 1), points(1, 2));
        points = [];  % Reset points array for the next ellipse
        end
    end

    function drawLineDDA(x1, y1, x2, y2)
        % Calculate dx and dy
        dx = x2 - x1;
        dy = y2 - y1;

        % Determine the number of steps
        steps = max(abs(dx), abs(dy));

        % Calculate increments
        x_increment = double(dx) / steps;
        y_increment = double(dy) / steps;

        % Initialize current coordinates
        x = double(x1);
        y = double(y1);

        % Perform the line drawing
        for i = 1:steps
            x = x + x_increment;
            y = y + y_increment;
            plot(round(x), round(y), 'b.');  % Plot each point on the line
        end
    end

    function drawLineBresenham(x1, y1, x2, y2)
        % Calculate dx and dy
        dx = abs(x2 - x1);
        dy = abs(y2 - y1);
        sx = (x1 < x2) * 2 - 1;
        sy = (y1 < y2) * 2 - 1;
        err = dx - dy;

        while true
            % Plot the current point
            plot(x1, y1, 'b.');  

            % Check if the end point has been reached
            if x1 == x2 && y1 == y2
                break;
            end

            e2 = 2 * err;
            if e2 > -dy
                err = err - dy;
                x1 = x1 + sx;
            end
            if e2 < dx
                err = err + dx;
                y1 = y1 + sy;
            end
        end
    end

    function drawCircle(radius, centerX, centerY)
        x = 0;
        y = radius;
        d = 3 - 2 * radius;

        while x <= y
            % Plot the points using symmetry
            plotPoints(centerX, centerY, x, y);
            if d < 0
                d = d + 4 * x + 6;
            else
                d = d + 4 * (x - y) + 10;
                y = y - 1;
            end
            x = x + 1;
        end
    end

    function plotPoints(cx, cy, x, y)
        plot(cx + x, cy + y, 'b.');
        plot(cx - x, cy + y, 'b.');
        plot(cx + x, cy - y, 'b.');
        plot(cx - x, cy - y, 'b.');
        plot(cx + y, cy + x, 'b.');
        plot(cx - y, cy + x, 'b.');
        plot(cx + y, cy - x, 'b.');
        plot(cx - y, cy - x, 'b.');
    end

    function drawEllipseMatlab(a, b, centerX, centerY)
        % Calculate ellipse points
        theta = linspace(0, 2 * pi, 100);
        x = centerX + a * cos(theta);
        y = centerY + b * sin(theta);

        % Plot the ellipse on the axes
        plot(x, y, 'b-');
    end

    function clearGrid(~, ~)
        cla(ax);  % Clear the axes
        axis([0 20 0 20]);
        grid on;
        hold on;
        points = [];  % Reset points array
    end
end
