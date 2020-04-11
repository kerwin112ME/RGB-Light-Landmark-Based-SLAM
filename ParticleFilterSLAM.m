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
            % move according to the motion of the robot
            % U = [dx; dy]: motion data (2*1 matrix)
            for ip = 1 : obj.numP
                obj.particles{ip} = move(obj.particles{ip}, U(1), U(2));
                
                % Cyclic Truncate
                obj.particles{ip}.x = mod(obj.particles{ip}.x, obj.mapL);
                obj.particles{ip}.y = mod(obj.particles{ip}.y, obj.mapL);
            end
            
        end
        
        function obj = updateParticles(obj, Z)
            % Z: rgb measurment data (3*1 matrix)
            
            w_sum = 0; % sum of all weights
            for ip = 1:obj.numP
                % first time observe
                if abs(obj.particles{ip}.rgbPos(1,1)) < 0.001
                    obj.particles{ip} = obj.particles{ip}.addNewLm(Z, obj.lmY);
                % non first time observe
                else
                    w = obj.particles{ip}.computeWeight(Z, obj.R); 
                    obj.particles{ip}.w = w; % update the particle weight
                    obj.particles{ip} = obj.particles{ip}.updateLandmark(Z, obj.R); % update the landmark by EKF
                    w_sum = w_sum + w;
                end
            end
        end
            
        
        function obj = resampling(obj)
            % normalize weight
            sumWeight = 0;
            for ip = 1 : obj.numP
                sumWeight = sumWeight + obj.particles{ip}.w;
            end
            
            for ip = 1 : obj.numP
                obj.particles{ip}.w = obj.particles{ip}.w / sumWeight;
            end
            
    
            % Systematic Resampling
            newP = obj;
            r = rand;   % select random number between 0 and 1
            w = obj.particles{1}.w;  % initial weight
            i = 1;  % index of the old particle
            j = 1;  % index of the new particle
            
            for pos = 1 : obj.numP
                Index = r/obj.numP + (pos-1)/obj.numP;
                while Index > w
                    i = i + 1;
                    w = w + obj.particles{i}.w;
                end
                
                newP.particles{j} = obj.particles{i};
                j = j + 1;
            end
            
            obj = newP;
            
        end
        
        function obj = resampling_(obj)
            % normalize weight
            sumWeight = 0;
            for ip = 1 : obj.numP
                sumWeight = sumWeight + obj.particles{ip}.w;
            end
            
            for ip = 1 : obj.numP
                obj.particles{ip}.w = obj.particles{ip}.w / sumWeight;
            end
            
            % Stratified Resampling
            newP = obj;
            w = obj.particles{1}.w;  % initial weight
            i = 1;
            j = 1;
            
            for pos = 1 : obj.numP
                Index = rand/obj.numP + (pos-1)/obj.numP;
                while Index > w
                    i = i + 1;
                    w = w + obj.particles{i}.w;
                end
                
                newP.particles{j} = obj.particles{i};
                j = j + 1;
            end
        end
        
        function [x,y] = computeLocation(obj)
            x = 0;   % estimate x of the robot
            y = 0;   % estimate y of the robot
            sumW = 0;  % sum of the weight
            for ip = 1 : obj.numP
                x = x + obj.particles{ip}.x * obj.particles{ip}.w;
                y = y + obj.particles{ip}.y * obj.particles{ip}.w;
                sumW = sumW + obj.particles{ip}.w;
            end
            
            x = x / sumW;
            y = y / sumW;
            
            
        end
        


    end

end
