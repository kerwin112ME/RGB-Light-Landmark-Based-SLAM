classdef ParticleFilterSLAM
    properties
        mapL; % map length
        numP; % number of particles
        particles;
        Q; % motion variance
        R; % measurement variance

    end

    methods
        function obj = ParticleFilterSLAM(numP, varargin)
            
            obj.particles = cell(1,numP);
            for i = 1:numP
                obj.particles{i} = ...
                    Particle(mapL*rand, mapL*rand,1./numP, zeros(3,2), zeros(3*2,2);           
            end

        end

        function predictParticles(U)
            % 
            % move all the particles, predict their next states
            %
        end
        
        function updateParticles(Z)
            %
            % compute the weight of each particles, and then update the
            % landmark positions of all particles using EKF.
            %
        end

        function resampling()
            %
            % add new particles and throw some particles away
            %
        end


    end

end


        
        
            
            
