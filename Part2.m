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

% Calculate the derivatives of r_x and r_y
dr_x_dt = matlabFunction(diff(r_x(t), t));
dr_y_dt = matlabFunction(diff(r_y(t), t));

% Calculate the force components as anonymous functions
F_x = @(x, y) -G * spaceship_mass * blackhole_mass * (x - blackhole_x) ./ ((x - blackhole_x).^2 + (y - blackhole_y).^2).^(3/2);
F_y = @(x, y) -G * spaceship_mass * blackhole_mass * (y - blackhole_y) ./ ((x - blackhole_x).^2 + (y - blackhole_y).^2).^(3/2);

% Define the integrand
integrand = @(t) F_x(r_x(t), r_y(t)) .* dr_x_dt(t) + F_y(r_x(t), r_y(t)) .* dr_y_dt(t);

% Calculate the work done along the path using integral
t_start = 0;
t_end = 2.5;
work_done = integral(integrand, t_start, t_end);

t_start = 1.6;
t_end = 2.5;
work_done_short = integral(integrand, t_start, t_end);

% Display the result
disp(['Work done along [0,2.5]: ', num2str(work_done), ' J']);
disp(['Work done along [1.6,2.5]: ', num2str(work_done_short), ' J']);

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
