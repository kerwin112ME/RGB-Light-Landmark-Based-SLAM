classdef Particle
    properties
        x; % x position
        y; % y position
        w; % weight
        
        % landmarks
        rgbPos; % landmarks positions, dim:(3,2);  ex: [Rx Ry; Gx Gy; Bx By]
        rgbCov; % x positions' covariance, dim:(3,3); 
    end
    
    methods
        function obj = Particle(x_,y_,varargin)
            obj.x = x_;
            obj.y = y_;
            
            if nargin == 3
                obj.w = varargin{1};
            elseif nargin == 5
                obj.w = varargin{1};
                obj.rgbPos = varargin{2};
                obj.rgbCov = varargin{3};               
            end
        end
        
        function obj = move(obj, dx, dy)
            obj.x = obj.x + dx;
            obj.y = obj.y + dy;
        end
        
        function obj = addNewLm(obj, Z, R, lmY)
            % z: distance between the particle and the lm
            lmX = obj.x + sqrt(Z.^2 - (lmY-obj.y).^2);
            obj.rgbPos(:,1) = lmX;
            obj.rgbCov = diag([1,1,1]);
            
        end
        
        function obj = updateLandmark(obj, Z)
            
        end
        
    end
end



