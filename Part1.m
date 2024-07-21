syms t;

% Constants
spaceship_mass = 15e6; % Mass of the spaceship
blackhole_mass = 1.989e39; % Mass of the black hole
G = 6.67e-11; % Gravitational constant

% Black hole position
blackhole_x = -30e6;
blackhole_y = -50e6;

% Define r_x and r_y as anonymous functions
r_x = @(t) 30e6 * cos(t) - 30e6;
r_y = @(t) 40e6 * sin(t);

% Define the grid with the specified axis limits
x_range = -60e6:2e6:40e6;
y_range = 0:2e6:100e6;
[x, y] = meshgrid(x_range, y_range);

% Calculate the force components at each point in the grid
F_x = zeros(size(x));
F_y = zeros(size(y));

for i = 1:numel(x)
    % Calculate the distance between the grid point and the black hole
    distanceBetween = sqrt((x(i) - blackhole_x)^2 + (y(i) - blackhole_y)^2);
    
    % Calculate the force magnitude
    F = -G * spaceship_mass * blackhole_mass / distanceBetween^2;
    
    % Calculate the angle
    theta = atan2(y(i) - blackhole_y, x(i) - blackhole_x);
    
    % Calculate force components
    F_x(i) = F * cos(theta);
    F_y(i) = F * sin(theta);
end

% Plot the vector field
figure;
quiver(x, y, F_x, F_y, 'b');
hold on;

% Plot the parametric function
t_vals = linspace(0, 2.5, 100); % 100 points between t=0 and t=2.5
r_x_vals = arrayfun(r_x, t_vals);
r_y_vals = arrayfun(r_y, t_vals);
plot(r_x_vals, r_y_vals, 'r', 'LineWidth', 2);

% Add a marker at the end point to indicate the path direction
plot(r_x_vals(end), r_y_vals(end), 'r>', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

title('Gravitational Force Vector Field with Parametric Curve');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis equal;
axis([-60e6, 40e6, 0, 100e6]); % Set the axis limits
legend('Gravitational Force Vectors', 'Parametric Curve', 'End Point');

hold off;
