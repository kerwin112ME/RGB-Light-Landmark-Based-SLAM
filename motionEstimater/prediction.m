function [v, P] = prediction(v_, u, P, Q)
    % predict the states
        dt = 0.05; %time step for accelerometer
        v = v_ + u.*dt;
    % predict the covariance
        P = P + Q;         
end