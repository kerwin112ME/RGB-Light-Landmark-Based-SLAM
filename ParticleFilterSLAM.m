classdef ParticleFilterSLAM
    properties
        motionData;
        measurementData;
        numParticles;
        X = []; % X postions of all particles
        Y = []; % Y postions of all particles
        Weight = []; % Weights of all particles
        motionVariance;
        measurementVariance;
        
    end
        
    methods
        function obj = ParticleFilterSLAM(numParticles, varargin)
            
        end
        
        function updateParticles(U, Z)
            
        end
        
        function resampling()
            
        end
        
        function mapping()
            
        end
        
    end
    
    
end
        
        
            
            