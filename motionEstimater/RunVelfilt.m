%% Run position estimate
    clear all; clc;
    addpath('..\Input\test0420');
    rotm = getrotm('accelerometer.csv', 'gyroscope.csv', 'magneticfield.csv');
    [vx_his, vy_his, traj] = velfilt('accelerometer.csv', 'gps.csv', rotm);
    
    dt = 0.05;
    U = zeros(2,160);
    
    for k = 2:size(vx_his,2)
        U(1,k-1) = vx_his(k)*dt;
        U(2,k-1) = vy_his(k)*dt;
    end
        