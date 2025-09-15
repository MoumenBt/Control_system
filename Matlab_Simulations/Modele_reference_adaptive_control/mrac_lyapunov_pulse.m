% MRAC (Lyapunov) with pulse-train reference
% Repo integration & extensions (metrics/plots): Moumen Bt
% Date: 2025-09-15

    close all; clc;

    %--- Reference model & plant params
    am = 2;          % reference model 'a' (stable >0)
    bm = 2;          % reference model 'b'
    a  = -1;         % plant 'a'
    b  = 0.5;        % plant 'b'
    gamma = 4;       % adaptation gain

    % helpful nominal thetas (not used directly in update law below)
    theta1 = bm / b;          
    theta2 = (am - a) / b;     

    %--- Time & input
    dt = 0.01;
    t  = 1:dt:200;
    N  = numel(t);

    period = 40;    % seconds between pulses
    width  = 20;    % pulse width
    amp    = 1;
    uc = amp * double(mod(t, period) < width);   % pulse train

    %--- States
    ym = zeros(1, N);   % reference model output
    x1 = zeros(1, N);   % aux/adaptation states (as in original script)
    x2 = zeros(1, N);
    x3 = zeros(1, N);
    x4 = zeros(1, N);
    x5 = zeros(1, N);   % plant output (tracked output)

    %--- Simulate (Forward Euler)
    for i = 1:N-1
        ym(i+1) = ym(i) + dt * (-am * ym(i) + bm * uc(i));
        x1(i+1) = x1(i) + dt * x2(i);
        x2(i+1) = x2(i) + dt * (-am*x2(i) - gamma*am*uc(i)*x5(i) + gamma*am*ym(i)*uc(i));
        x3(i+1) = x3(i) + dt * x4(i);
        x4(i+1) = x4(i) + dt * (-am*x4(i) + gamma*am*x5(i)^2 - gamma*am*ym(i)*x5(i));
        x5(i+1) = x5(i) + dt * (-a*x5(i) + b*uc(i)*x1(i) - b*x3(i)*x5(i));
    end

    %--- Metrics
    e   = ym - x5;                            % tracking error
    IAE = trapz(t, abs(e));                   % integral of absolute error
    RMSE = sqrt(trapz(t, e.^2) / (t(end) - t(1)));

    %--- Plots
    figure('Color','w'); hold on; grid on;
    plot(t, ym, 'LineWidth', 1.2);
    plot(t, x5, 'LineWidth', 1.2);
    plot(t, uc, 'LineWidth', 1.0);
    xlabel('Time (s)'); ylabel('Amplitude');
    title('MRAC (Lyapunov) — Reference vs Plant Output');
    legend('y_m (reference)', 'x_5 (plant output)', 'u_c (input)', 'Location', 'best');
    figure('Color','w'); grid on;
    plot(t, e, 'LineWidth', 1.0);
    xlabel('Time (s)'); ylabel('Error');
    title(sprintf('Tracking Error  |  IAE = %.3f,  RMSE = %.3f', IAE, RMSE));

    % print a quick summary
    fprintf('Final states: x1=%.4f  x3=%.4f  x5=%.4f\n', x1(end), x3(end), x5(end));
    fprintf('IAE=%.4f, RMSE=%.4f\n', IAE, RMSE);

