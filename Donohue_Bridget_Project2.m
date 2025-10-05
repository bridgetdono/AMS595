% AMS 595 Project 2
% Bridget Donohue
%% Mandelbrot Fractal
N_X = 1200; % number of vertical samples (>= 1000)
x_all = linspace(-2, 1, N_X); % x range
y_lower = 0.0; % lower bound (inside fractal)
y_upper = 1.5; % upper bound (above fractal)
boundary_y = NaN(size(x_all)); % detected y-boundary

%% Bisection Method
% use bisection to find the boundary y where the indicator changes sign
tic;
for k = 1:length(x_all)
    x = x_all(k);

    % indicator function along vertical line at x
    fn = @(y) (fractal(x + 1i * y) > 0) * 2 - 1;

    % check that signs differ on endpoints before calling bisection
    fs = fn(y_lower);
    fe = fn(y_upper);
    if sign(fs) == sign(fe)
        % no crossing on this vertical line
        continue
    end

    boundary_y(k) = bisection(fn, y_lower, y_upper);
end
elapsed_bisection = toc;
disp(['boundary detection completed in ', num2str(elapsed_bisection, '%.1f'), ' s.']);

% filter the detected boundary
valid = ~isnan(boundary_y);
x_detected = x_all(valid);
y_detected = boundary_y(valid);

% remove outliers (to keep reasonable y range)
mask = (y_detected > -1) & (y_detected < 2);
x_detected = x_detected(mask);
y_detected = y_detected(mask);

if isempty(x_detected)
    error('no boundary points detected. try increasing y_upper or N_X.');
end

%% Polynomial Fitting
% choose a contiguous region of detected boundary to avoid flat tails
% drop the outer 10 percent on each side to clean the data
n_keep = length(x_detected);
drop = round(0.10 * n_keep);
i1 = drop + 1;
i2 = n_keep - drop;
if i2 < i1
    % fallback if too few points after dropping
    i1 = 1;
    i2 = n_keep;
end
x_fit = x_detected(i1:i2);
y_fit = y_detected(i1:i2);

%make sure there are enough points for a stable fit
if length(x_fit) < 100
    % try a smaller drop if not enough points
    drop_fb = round(0.05 * n_keep);
    i1 = drop_fb + 1;
    i2 = n_keep - drop_fb;
    if i2 < i1
        i1 = 1;
        i2 = n_keep;
    end
    x_fit = x_detected(i1:i2);
    y_fit = y_detected(i1:i2);
    if length(x_fit) < 100
        error('not enough points for polynomial fit. increase N_X or adjust bounds.');
    end
end

order = 15; % polynomial order
p = polyfit(x_fit, y_fit, order); %polynomial coefficients

% evaluate polynomial on dense grid inside fitted range
x_plot = linspace(min(x_fit), max(x_fit), 1200);
y_plot = polyval(p, x_plot);

%% Curve Length
s = min(x_fit);
e = max(x_fit);
len = poly_len(p, s, e); % calculates integral of sqrt(1 + (dy/dx)^2)

%% Results and Plot
disp(['Number of X-samples requested: ', num2str(N_X)]);
disp(['Detected boundary points (after filtering): ', num2str(length(x_detected))]);
disp(['Points used for polynomial fit: ', num2str(length(x_fit))]);
disp(['Polynomial order used: ', num2str(order)]);
disp(['Fitted X-range: [', num2str(s), ', ', num2str(e), ']']);
disp(['Estimated upper-boundary length: ', num2str(len)]);

% plot detected points and polynomial fit
figure('name', 'Mandelbrot Upper Boundary and 15th-order Fit', ...
       'numbertitle', 'off', 'units', 'normalized', 'position', [0.1 0.1 0.6 0.6]);
hold on;
plot(x_detected, y_detected, '.', 'markersize', 6);
plot(x_plot, y_plot, '-', 'linewidth', 1.5);
xlabel('x');
ylabel('y (boundary)');
title('Upper Boundary of Mandelbrot Set and 15th-order Polynomial Fit');
legend('Detected boundary points', '15th-order polynomial fit', 'Location', 'Best');
grid on;
hold off;

%% Local Functions
function it = fractal(c)
    % returns the number of iterations until divergence for complex c
    max_it = 100; % iteration cap
    thresh = 2.0; % divergence threshold

    z = 0 + 0i;
    it = 0;
    for k = 1:max_it
        z = z^2 + c;
        if abs(z) > thresh
            it = k;
            return
        end
    end
    % if not divergent within max_it, return 0
end

function m = bisection(fn_f, s, e)
    % finds y in [s, e] where fn_f(y) changes sign using bisection
    max_it = 60; % max iterations
    tol = 1e-6; % tolerance

    fs = fn_f(s);
    fe = fn_f(e);

    if fs == 0
        m = s; return
    elseif fe == 0
        m = e; return
    elseif sign(fs) == sign(fe)
        m = nan; return
    end

    a = s;
    b = e;
    for iter = 1:max_it
        m = 0.5 * (a + b);
        fm = fn_f(m);
        if fm == 0
            return
        end
        if sign(fm) == sign(fs)
            a = m;
            fs = fm;
        else
            b = m;
            fe = fm;
        end
        if abs(b - a) < tol
            m = 0.5 * (a + b);
            return
        end
    end
    m = 0.5 * (a + b);
end

function l = poly_len(p, s, e)
    % computes arc length of polynomial y = polyval(p, x) on [s, e]
    n = length(p) - 1;
    if n >= 1
        dp = p(1:end-1) .* (n:-1:1);
    else
        dp = 0;
    end
    % integrand for arc length
    ds = @(x) sqrt(1 + (polyval(dp, x)).^2);
    % numerical integration
    l = integral(ds, s, e);
end