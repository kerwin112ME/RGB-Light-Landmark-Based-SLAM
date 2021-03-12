function [PF,x_history,y_history] = RunSLAM(Ut, RGBt, numP, lmY, simulation)
    % Input
    %   Ut: displacements at every time step. Dimension: 2*t
    %       ex, [dx; dy] = [0.1 0.15 0.11 ...; 0.02 0.1 0.08 ...]
    %   RGBt: measurement data (distance of RGB lights from the phone) at
    %       every time step. Dimension: 3*t
    %       ex, [Rdist; Gdist; Bdist] = [5.2 5.3 ...; 3.6 3.4 ...; 6.0 6.1
    %       ...]
    %   NumP: Number of particles
    %   lmY: The y-position of the RGB landmarks
    %
    % Ouput
    %   dynamic plot of the particles
    %   PF: the ParticleFilterSLAM object
    %   x_history: x estimate trajectory
    %   y_history: y estimate trajectory
    %
    % run command:
    %   load('Input\test_input.mat')
    %   PF = RunSLAM(Ut, Zt, 1500, lmY, 1)
    
    %% initilize
    Q = zeros(3,3); % lm process noise 
    R = diag([1,1,1]); % lm measurement noisec;

    mapL = 6; % size of the map
    lmX_hat = [1.5;3.0;4.5]; % initial guess of the landmark x-positions
    
    tspan = size(Ut,2);
    PF = ParticleFilterSLAM(numP, mapL, lmY, Q, R); % declare a ParticleFilterSLAM
    
    % initialize the animation plot
    h = figure;
    scatter = zeros(2,numP); % the x,y positions of all particles
    for ip = 1:numP
        scatter(:,ip) = [PF.particles{ip}.x; PF.particles{ip}.y];
    end
    
    lm_init = [lmX_hat';lmY'];
    plot(scatter(1,:),scatter(2,:),'.','color','#D95319');
    
    hold on;
    
    plot(lm_init(1,1),lm_init(2,1),'pentagram','MarkerSize',9,'LineWidth',3,'color','#FF0000') % plot Red Lm
    plot(lm_init(1,2),lm_init(2,2),'pentagram','MarkerSize',9,'LineWidth',3,'color','#00FF00') % plot Green Lm
    plot(lm_init(1,3),lm_init(2,3),'pentagram','MarkerSize',9,'LineWidth',3,'color','#0000FF') % plot Blue Lm
 
    hold off;
    
    %% start the SLAM
    x_history = []; % record of all est_x
    y_history = []; % record of all est_y
    
    x_true = [2.5];
    y_true = [0];
    
    rng(1);
    filename = 'realWorldPF.gif';
    for t = 1:tspan
        
        PF = PF.predictParticles(Ut(:,t));
        
        PF = PF.updateParticles(Ut(:,t), RGBt(:,t));
        
        PF = PF.resampling();
        
        x_true(t+1) = x_true(t) + Ut(1,t);
        y_true(t+1) = y_true(t) + Ut(2,t);

        % update the particles plot
        
        scatter = zeros(2,PF.numP);

        for ip = 1:PF.numP
            scatter(:,ip) = [PF.particles{ip}.x; PF.particles{ip}.y];
        end
        
        plot(scatter(1,:),scatter(2,:),'.','color','#D95319');
        hold on
        
        [est_x, est_y] = PF.computeLocation();
        x_history(t) = est_x;
        y_history(t) = est_y;
       
        plot(est_x,est_y,'o','MarkerSize', 9,'LineWidth',3 , 'color', '#FF00FF');
        
        pe = plot(x_history, y_history, 'k-', 'LineWidth', 1.0);
        
        if simulation
            pt = plot(x_true, y_true, 'c-', 'LineWidth', 0.8);
        end

        plot(PF.lmX_est(1),lmY(1),'pentagram','MarkerSize',9,'LineWidth',3,'color','#FF0000') % plot Red Lm
        plot(PF.lmX_est(2),lmY(2),'pentagram','MarkerSize',9,'LineWidth',3,'color','#00FF00') % plot Green Lm
        plot(PF.lmX_est(3),lmY(3),'pentagram','MarkerSize',9,'LineWidth',3,'color','#0000FF') % plot Blue Lm
        hold off;
        
        % axis([0 mapL 0 mapL]);
        axis equal;
        grid on
        
        if simulation
            legend([pe pt],'estimate traj','true traj')
        end
        drawnow
        % Capture the plot as an image 
        frame = getframe(h);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        
        % Write to the GIF File 
        if t == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1); 
        end 
        
        %pause(0.005);
        
    end
    
end
