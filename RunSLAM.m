function RunSLAM(Ut, RGBt, numP, lmY)
    % Input
    %   Ut: displacements at every time step. Dimension: 2*t
    %       ex, [dx; dy] = [0.1 0.15 0.11 ...; 0.02 0.1 0.08 ...]
    %   RGBt: measurement data (distance of RGB lights from the phone) at
    %       every time step. Dimension: 3*t
    %       ex, [Rdist; Gdist; Bdist] = [5.2 5.3 ...; 3.6 3.4 ...; 6.0 6.1
    %       ...]
    %   NumP: Number of particles
    %
    % Ouput
    %   dynamic plot of the particles
    
    %% initilize
    Q = zeros(3,3); % lm process noise 
    R = diag([0.5,0.5,0.5]); % lm measurement noise
    mapL = 10; % size of the map
    lmX_hat = [2.2;3.2;2.8]; % initial guess of the landmark x-positions
    
    tspan = size(Ut,2);
    PF = ParticleFilterSLAM(numP, mapL, lmY, Q, R); % declare a ParticleFilterSLAM
    
    % initialize the animation plot
    figure;
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
    for t = 1:tspan
        
        PF = PF.predictParticles(Ut(:,t));
        
        PF = PF.updateParticles(RGBt(t));
        
        PF = PF.resampling();
        
        
        %
        % update the particles plot
        %
        [est_x, est_y] = PF.computeLocation();
        plot(est_x,est_y,'o', 'color', '#FF00FF');
        hold on
        
        scatter = zeros(2,PF.numP);

        for ip = 1:PF.numP
            scatter(:,ip) = [PF.particles{ip}.x; PF.particles{ip}.y];
        end
        
        plot(scatter(1,:),scatter(2,:),'.','color','#D95319');
        hold on
        
        plot(lm_init(1,1),lm_init(2,1),'pentagram','MarkerSize',9,'LineWidth',3,'color','#FF0000') % plot Red Lm
        plot(lm_init(1,2),lm_init(2,2),'pentagram','MarkerSize',9,'LineWidth',3,'color','#00FF00') % plot Green Lm
        plot(lm_init(1,3),lm_init(2,3),'pentagram','MarkerSize',9,'LineWidth',3,'color','#0000FF') % plot Blue Lm
        hold off;
        
    end
    
end