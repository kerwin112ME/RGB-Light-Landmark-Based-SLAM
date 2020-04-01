classdef ParticleFilterSLAM
    properties
        numP; % number of particles
        particles;
        motionVariance;
        measurementVariance;
        lmP; % landmarks' covariance matrices
        lm; % landmarks' positions

    end

    methods
        function obj = ParticleFilterSLAM(numP, varargin)
            
            obj.particles = cell(1,numP);
            for i = 1:numP
                %
                % declare and initialize all particles
                %
                
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


        
        
            
            
