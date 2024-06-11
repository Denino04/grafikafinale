% Prompt user to input original shape coordinates
num_vertices = input('Enter the number of vertices for the original shape: ');
original_shape = zeros(2, num_vertices);
for i = 1:num_vertices
    fprintf('Enter coordinates for vertex %d:\n', i);
    original_shape(:,i) = input('');
end

% Connect the first and last vertices with a line
original_shape = [original_shape original_shape(:,1)];

% Initialize transformation matrix
transform_matrix = eye(3); % Identity matrix (no transformation)

% Prompt user to choose transformations and compound them
while true
    fprintf('Choose a transformation:\n');
    fprintf('1. Translation\n');
    fprintf('2. Rotation\n');
    fprintf('3. Scaling\n');
    fprintf('4. Reflection\n');
    fprintf('5. Finish and plot\n');
    choice = input('Enter your choice: ');

    switch choice
        case 1
            % Prompt user to input translation vector
            translation_vector = input('Enter translation vector [tx ty]: ');
            % Translation matrix
            translation_matrix = [1 0 translation_vector(1);
                                  0 1 translation_vector(2);
                                  0 0 1];
            % Compound with the current transformation matrix
            transform_matrix = translation_matrix * transform_matrix;
        case 2
            % Prompt user to input rotation angle
            rotation_angle_degrees = input('Enter rotation angle in degrees: ');
            % Convert rotation angle from degrees to radians
            rotation_angle_radians = deg2rad(rotation_angle_degrees);
            % Rotation matrix
            rotation_matrix = [cos(rotation_angle_radians) -sin(rotation_angle_radians) 0;
                               sin(rotation_angle_radians) cos(rotation_angle_radians) 0;
                               0 0 1];
            % Compound with the current transformation matrix
            transform_matrix = rotation_matrix * transform_matrix;
        case 3
            % Prompt user to input scaling factors
            scaling_factor = input('Enter scaling factors [sx sy]: ');
            % Scaling matrix
            scaling_matrix = [scaling_factor(1) 0 0;
                              0 scaling_factor(2) 0;
                              0 0 1];
            % Compound with the current transformation matrix
            transform_matrix = scaling_matrix * transform_matrix;
        case 4
            % Prompt user to input reflection axis
            reflection_axis = input('Enter reflection axis (X or Y): ', 's');
            % Reflection matrix
            if strcmp(reflection_axis, 'X')
                reflection_matrix = [-1 0 0;
                                     0 1 0;
                                     0 0 1];
            elseif strcmp(reflection_axis, 'Y')
                reflection_matrix = [1 0 0;
                                     0 -1 0;
                                     0 0 1];
            else
                error('Invalid reflection axis. Please enter either X or Y.');
            end
            % Compound with the current transformation matrix
            transform_matrix = reflection_matrix * transform_matrix;
        case 5
            % Finish and exit loop
            break;
        otherwise
            disp('Invalid choice. Please enter a number between 1 and 5.');
    end
end

% Perform transformations
transformed_shape = transform_matrix * [original_shape; ones(1, size(original_shape, 2))];

% Plot original and transformed shapes
figure;
plot(original_shape(1,:), original_shape(2,:), 'b-', 'LineWidth', 2);
hold on;
plot(transformed_shape(1,:), transformed_shape(2,:), 'r-', 'LineWidth', 2);
axis equal;
legend('Original Shape', 'Transformed Shape');
title('2D Compound Transformation');
xlabel('X');
ylabel('Y');
grid on;
