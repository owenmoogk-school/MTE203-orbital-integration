syms t;

% Constants
spaceship_mass = 15e6; % Mass of the spaceship
blackhole_mass = 1.989e39; % Mass of the black hole
G = 6.67e-11; % Gravitational constant

% Black hole position
blackhole_x = -30e6;
blackhole_y = -50e6;

% Define r_x and r_y for the first path
r_x1 = @(t) 30e6 * cos(t) - 30e6;
r_y1 = @(t) 40e6 * sin(t) - 20e6*t.^2 + 50e6*t;

% Define r_x and r_y for the second path (slightly different)
r_x2 = @(t) 30e6 * cos(t) - 30e6; % Shifted by 0.1 radians
r_y2 = @(t) 40e6 * sin(t);

% Calculate the derivatives of r_x1 and r_y1
dr_x1_dt = matlabFunction(diff(r_x1(t), t));
dr_y1_dt = matlabFunction(diff(r_y1(t), t));

% Calculate the derivatives of r_x2 and r_y2
dr_x2_dt = matlabFunction(diff(r_x2(t), t));
dr_y2_dt = matlabFunction(diff(r_y2(t), t));

% Calculate the force components as anonymous functions
F_x = @(x, y) -G * spaceship_mass * blackhole_mass * (x - blackhole_x) ./ ((x - blackhole_x).^2 + (y - blackhole_y).^2).^(3/2);
F_y = @(x, y) -G * spaceship_mass * blackhole_mass * (y - blackhole_y) ./ ((x - blackhole_x).^2 + (y - blackhole_y).^2).^(3/2);

% Define the integrand for the first path
integrand1 = @(t) F_x(r_x1(t), r_y1(t)) .* dr_x1_dt(t) + F_y(r_x1(t), r_y1(t)) .* dr_y1_dt(t);

% Define the integrand for the second path
integrand2 = @(t) F_x(r_x2(t), r_y2(t)) .* dr_x2_dt(t) + F_y(r_x2(t), r_y2(t)) .* dr_y2_dt(t);

% Calculate the work done along the path for the first path
t_start = 0;
t_end = 2.5;
work_done1 = integral(integrand1, t_start, t_end);

% Calculate the work done along the path for the second path
t_start = 0;
t_end = 2.5;
work_done2 = integral(integrand2, t_start, t_end);

% Display the result
disp(['Work done along [0,2.5] for path 1: ', num2str(work_done1), ' J']);
disp(['Work done along [0,2.5] for path 2: ', num2str(work_done2), ' J']);

% Calculate the work done along the path for the first path
t_start = 1.6;
t_end = 2.5;
work_done1 = integral(integrand1, t_start, t_end);

% Calculate the work done along the path for the second path
t_start = 1.6;
t_end = 2.5;
work_done2 = integral(integrand2, t_start, t_end);

disp(['Work done along [1.6,2.5] for path 1: ', num2str(work_done1), ' J']);
disp(['Work done along [1.6,2.5] for path 2: ', num2str(work_done2), ' J']);


% Define the grid with the specified axis limits
x_range = -60e6:2e6:40e6;
y_range = 0:2e6:100e6;
[x, y] = meshgrid(x_range, y_range);

% Calculate the force components at each point in the grid
F_x_vals = F_x(x, y);
F_y_vals = F_y(x, y);

% Plot the vector field
figure;
quiver(x, y, F_x_vals, F_y_vals, 'b');
hold on;

% Plot the parametric function for the first path
t_vals = linspace(0, 2.5, 100); % 100 points between t=0 and t=2.5
r_x_vals1 = arrayfun(r_x1, t_vals);
r_y_vals1 = arrayfun(r_y1, t_vals);
plot(r_x_vals1, r_y_vals1, 'r', 'LineWidth', 2);

% Plot the parametric function for the second path
r_x_vals2 = arrayfun(r_x2, t_vals);
r_y_vals2 = arrayfun(r_y2, t_vals);
plot(r_x_vals2, r_y_vals2, 'g--', 'LineWidth', 2); % Different color and style

% Add markers at the end points to indicate the path directions
plot(r_x_vals1(end), r_y_vals1(end), 'r>', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(r_x_vals2(end), r_y_vals2(end), 'g>', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

title('Gravitational Force Vector Field with Two Parametric Curves');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis equal;
axis([-60e6, 40e6, 0, 100e6]); % Set the axis limits
legend('Gravitational Force Vectors', 'Path 1', 'Path 2', 'End Points');

hold off;
