classdef ParticleFilterSLAM
    properties
        mapL; % map length
        numP; % number of particles
        particles;
        lmY; % y position of the RGB landmarks
        Q; % motion variance
        R; % measurement variance

    end

    methods
        function obj = ParticleFilterSLAM(numP_, mapL_, lmY_, Q_, R_)
            
            obj.particles = cell(1,numP_);
            obj.mapL = mapL_;
            obj.numP = numP_;
            obj.lmY = lmY_;
            obj.Q = Q_;
            obj.R = R_;
            
            lmPos = zeros(3,2);
            lmPos(:,2) = obj.lmY;
            for i = 1:numP_
                obj.particles{i} = ...
                    Particle(mapL_*rand, mapL_*rand,1./numP_, lmPos, zeros(3,3));           
            end

        end

        function obj = predictParticles(obj, U)
            % 
            % move all the particles, predict their next states
            %
        end
        
        function obj = updateParticles(obj, Z)
            % Z: rgb measurment data (3*1 matrix)
            for ip = 1:obj.numP
                % first time observe
                if abs(obj.particles{ip}.rgbPos(1,1)) < 0.001
                    obj.particles{ip} = obj.particles{ip}.addNewLm(Z, obj.lmY);
                % non first time observe
                else
                    w = obj.particles{ip}.computeWeight(Z, obj.R); 
                    obj.particles{ip}.w = w; % update the particle weight
                    obj.particles{ip} = obj.particles{ip}.updateLandmark(Z, obj.R); % update the landmark by EKF
                end
            end
        end
            
        
        function obj = resampling(obj)
            %
            % add new particles and throw some particles away
            %
        end


    end

end


        
        
            
            
