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
        function obj = ParticleFilterSLAM(numP, lmY)
            
            obj.particles = cell(1,numP);
            lmPos = zeros(3,2);
            lmPos(:,2) = lmY;
            for i = 1:numP
                obj.particles{i} = ...
                    Particle(mapL*rand, mapL*rand,1./numP, lmPos, zeros(3,3));           
            end

        end

        function obj = predictParticles(obj, U)
            % 
            % move all the particles, predict their next states
            %
        end
        
        function obj = updateParticles(obj, Z)
            % Z: rgb measurment data (3*t matrix)
            for ip = 1:obj.numP
                % first time observe
                if abs(obj.particles{ip}.rgbPos(1,1)) < 0.001
                    obj.particles{ip}.addNewLm(Z, obj.R, obj.lmY);
                % non first time observe
                else
                    w = obj.computeWeight(obj.particles{ip}, Z);
                    obj.particles{ip}.w = w;
                    obj.particles{ip}.updateLandmark(Z, R);
                end
            end
        end
        
        function w = computeWeight(obj, Z)
        
        end

        function obj = resampling(obj)
            %
            % add new particles and throw some particles away
            %
        end


    end

end


        
        
            
            
