function RunSLAM(Ut, RGBt, NumP)
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
    
    tspan = size(Ut,2);
    PF = ParticleFilterSLAM(NumP); % declare a ParticleFilterSLAM
    
    for t = 1:tspan
        
        PF.predictParticles(Ut(t));
        
        PF.updateParticles(RGBt(t));
        
        PF.resampling();
        
        %
        % update the particles plot
        %
        
    end
    
end
        
        
    
    