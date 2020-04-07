classdef Particle
    properties
        x; % x position
        y; % y position
        w; % weight
        
        % landmarks
        rgbPos; % landmarks positions, dim:(3,2);  ex: [Rx Ry; Gx Gy; Bx By]
        rgbCov; % positions' covariance, dim:(3*2,2); 
    end
    
    methods
        function obj = Particle(x_,y_,varargin)
            obj.x = x_;
            obj.y = y_;
            
            if varargin == 3
                obj.w = varargin{1};
            elseif varargin == 5
                obj.w = varargin{1};
                obj.rgbPos = varargin{2};
                obj.rgbCov = varargin{3};               
            end
        end
        
        function obj = move(obj, dx, dy)
            obj.x = obj.x + dx;
            obj.y = obj.y + dy;
        end
        
    end
end