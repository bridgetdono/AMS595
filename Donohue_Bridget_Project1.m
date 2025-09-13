% AMS 595 Project 1 Part 1

pi_true = pi; % actual value of pi

% total number of points to test
maxN = 1e5;     
stepN = 1000;   

% set up arrays to store results
N_values = stepN:stepN:maxN;
pi_estimates = zeros(size(N_values));
errors = zeros(size(N_values));
times = zeros(size(N_values));

% go through different sample sizes
for idx = 1:length(N_values)
    N = N_values(idx);
    
    tic % start timing
    
    count_inside = 0;
    for i = 1:N
        x = rand; 
        y = rand; 
        if x^2 + y^2 <= 1
            count_inside = count_inside + 1;
        end
    end
    
    pi_est = 4 * (count_inside / N);
    elapsed = toc; % stop timing
    
    % save results
    pi_estimates(idx) = pi_est;
    errors(idx) = abs(pi_est - pi_true);
    times(idx) = elapsed;
end

% plot pi estimates compared to true value
figure;
plot(N_values, pi_estimates, 'b', 'LineWidth', 1.5); hold on;
yline(pi_true, 'r--', 'LineWidth', 1.5);
xlabel('Number of points');
ylabel('Estimated \pi');
title('Monte Carlo Estimate of \pi');
legend('Estimate', 'True value');
grid on;

% plot error as points increase
figure;
plot(N_values, errors, 'k', 'LineWidth', 1.5);
xlabel('Number of points');
ylabel('Error');
title('Error in \pi Estimate');
grid on;

% plot error vs runtime
figure;
plot(errors, times, 'm-o', 'LineWidth', 1.2);
xlabel('Error');
ylabel('Time (s)');
title('Error vs. Runtime');
grid on;

% AMS 595 Project 1 Part 2

% set decimal places of precision
precision = 3; 

count_inside = 0;
N = 0;

pi_est = 0;
pi_old = -1; % start with something different

tic % start timing
while round(pi_est, precision) ~= round(pi_old, precision) || N < 10
    % generate random point
    x = rand;
    y = rand;
    N = N + 1;
    
    % check if point is inside quarter circle
    if x^2 + y^2 <= 1
        count_inside = count_inside + 1;
    end
    
    % update estimate
    pi_old = pi_est;
    pi_est = 4 * (count_inside / N);
end
elapsed = toc; % end timing

% show results in command window
disp(['Target precision: ', num2str(precision), ' decimal places'])
disp(['Estimated pi: ', num2str(pi_est)])
disp(['Iterations needed: ', num2str(N)])
disp(['Time: ', num2str(elapsed), ' seconds'])

% AMS 595 Project 1 Part 3

function pi_est = AMS595_Project1_Part3

    try % ask the user for decimal places requested
        precision = input('Enter number of decimal places for pi: ');
    catch % added so that publish works
        precision = 3; % default if input fails
        disp(['Input not available – using default precision of ', num2str(precision), ' decimal places.']);
    end
    
    count_inside = 0;
    N = 0;
    pi_est = 0;
    pi_old = -1;

    % set up the figure
    figure;
    hold on;
    axis equal;
    xlim([0 1]);
    ylim([0 1]);
    title('Monte Carlo Estimation of \pi');
    xlabel('x'); ylabel('y');

    % draw the quarter circle outline
    theta = linspace(0, pi/2, 200);
    plot(cos(theta), sin(theta), 'k--');

    % text to update estimate on plot
    txt = text(0.5, 0.95, '\pi \approx 0', ...
        'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');

    % loop until pi is stable at the requested precision
    while round(pi_est, precision) ~= round(pi_old, precision) || N < 10
        x = rand;
        y = rand;
        N = N + 1;

        if x^2 + y^2 <= 1
            count_inside = count_inside + 1;
            plot(x, y, 'b.', 'MarkerSize', 8); % inside = blue
        else
            plot(x, y, 'r.', 'MarkerSize', 8); % outside = red
        end

        pi_old = pi_est;
        pi_est = 4 * (count_inside / N);

        % update text every 50 points
        if mod(N,50) == 0
            set(txt, 'String', ['\pi \approx ', num2str(pi_est, precision)]);
            drawnow;
        end
    end

    % final rounded result
    pi_final = round(pi_est, precision);

    % show results in command window
    disp(['Target precision: ', num2str(precision), ' decimal places']);
    disp(['Estimated pi: ', num2str(pi_final)]);
    disp(['Iterations needed: ', num2str(N)]);

    % update text with final result
    set(txt, 'String', ['\pi \approx ', num2str(pi_final)]);

    % return value
    pi_est = pi_final;
end

AMS595_Project1_Part3
