function [ekf,x_history,y_history] = RunEkfSLAM(Ut, RGBt, simulation)
    % Input
    %   Ut: displacements at every time step. Dimension: 2*t
    %       ex, [dx; dy] = [0.1 0.15 0.11 ...; 0.02 0.1 0.08 ...]
    %   RGBt: measurement data (distance of RGB lights from the phone) at
    %       every time step. Dimension: 3*t
    %       ex, [Rdist; Gdist; Bdist] = [5.2 5.3 ...; 3.6 3.4 ...; 6.0 6.1
    %       ...]
    %   simulation: simulation = 1, run experiment input = 0
    %
    % Ouput
    %   dynamic plot of the particles
    %   ekf: the ParticleFilterSLAM object
    %   x_history: x estimate trajectory
    %   y_history: y estimate trajectory
    %
    % run command:
    %   load('Input\test_input.mat')
    %   ekf = RunEkfSLAM(Ut, Zt, 1)
    
    %% initilize
    Q = diag([0.03,0.03]); % lm process noise 
    R = diag([1,1,1]); % lm measurement noise
    X0 = [2.5;0;1.5;3;4.5];
    P0 = eye(5);
    lmY = [3;3;3];

    mapL = 5; % size of the map
    
    tspan = size(Ut,2);
    ekf = ekfSLAM(mapL, lmY, X0, P0, Q, R); % declare a ekfSLAM
    
    % initialize the animation plot
    figure;
    title('EKF SLAM')
    plot(X0(1),X0(2),'o','MarkerSize', 9,'LineWidth',3 , 'color', '#FF00FF');
    hold on;
    
    plot(X0(3),lmY(1),'pentagram','MarkerSize',9,'LineWidth',3,'color','#FF0000') % plot Red Lm
    plot(X0(4),lmY(2),'pentagram','MarkerSize',9,'LineWidth',3,'color','#00FF00') % plot Green Lm
    plot(X0(5),lmY(3),'pentagram','MarkerSize',9,'LineWidth',3,'color','#0000FF') % plot Blue Lm
 
    hold off;
    
    axis([0 mapL 0 mapL]);
    
    %% Start the SLAM
    x_history = [X0(1)]; % record of all est_x
    y_history = [X0(2)]; % record of all est_y
    
    x_true = [X0(1)];
    y_true = [X0(2)];
    
    for t = 1:tspan
        
        ekf = ekf.prediction(Ut(:,t), simulation);
        
        ekf = ekf.measUpdate(RGBt(:,t));
        
        x_true(t+1) = x_true(t) + Ut(1,t);
        y_true(t+1) = y_true(t) + Ut(2,t);

        % update the particles plot  
        x_history(t+1) = ekf.X(1);
        y_history(t+1) = ekf.X(2);
       
        pm = plot(ekf.X(1),ekf.X(2),'o','MarkerSize', 9,'LineWidth',3 , 'color', '#FF00FF');
        hold on;
        
        pe = plot(x_history, y_history, 'k-', 'LineWidth', 0.8);

        if simulation
            pt = plot(x_true, y_true, 'c-', 'LineWidth', 0.8);
        end

        pr = plot(ekf.X(3),lmY(1),'pentagram','MarkerSize',9,'LineWidth',3,'color','#FF0000') % plot Red Lm
        pg = plot(ekf.X(4),lmY(2),'pentagram','MarkerSize',9,'LineWidth',3,'color','#00FF00') % plot Green Lm
        pb = plot(ekf.X(5),lmY(3),'pentagram','MarkerSize',9,'LineWidth',3,'color','#0000FF') % plot Blue Lm
        hold off;
        
        legend([pe pt],'estimate traj','true traj')
        axis([0 mapL 0 mapL]);
        
        pause(0.1);
        
    end
    
end

    
    
    
    
    
    
    
    
    
    
    
    
    