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
        
        function obj = addNewLm(obj, Z, lmY)
            % z: distance between the particle and the lm
            dX2 = Z.^2 - (lmY-obj.y).^2;
            dX2(dX2<0) = 0; 
            
            lmX = obj.x + sqrt(dX2);
            obj.rgbPos(:,1) = lmX;
            obj.rgbCov = diag([1,1,1]);
            
        end
        
        function obj = updateLandmark(obj, Z, R)
            % update by EKF
            P = obj.rgbCov; % covariance matrix
            [H,dx,dy] = obj.computeJacobian(); % H: jacobian of h(x_k)
            Qz = H*P*H' + R; % Qz: measurement covariance; R: measurement noise
            if det(Qz) < 1e-6
                QzInv = pinv(Qz);
            else
                QzInv = inv(Qz);
            end
            
            K = P*H'*QzInv; % Kalman Gain
            Z_hat = sqrt(dx.^2 + dy.^2);
            dZ = Z - Z_hat;
            
            % update the states and the covariance
            obj.rgbPos(:,1) = obj.rgbPos(:,1) + K*dZ;
            obj.rgbCov = (eye(3) - K*H)*P;
            
        end
        
        function [H, dx, dy] = computeJacobian(obj)
            % Compute the H matrix in EKF
            dx = obj.rgbPos(:,1) - obj.x;
            dy = obj.rgbPos(:,2) - obj.y;
            H = diag(dx./sqrt(dx.^2+dy.^2)); % H: jacobian of h(x_k)
        end
        
        function w = computeWeight(obj, Z, R)
            P = obj.rgbCov; % covariance matrix
            [H, dx, dy] = obj.computeJacobian(); % H: jacobian of h(x_k)
            Qz = H*P*H' + R; % Qz: measurement covariance; R: measurement noise
            if det(Qz) < 1e-6
                % singular
                w = 1.0;
                return;
            end
   
            Z_hat = sqrt(dx.^2 + dy.^2);
            dZ = Z - Z_hat;

            w = exp(-0.5*dZ'*(Qz\dZ)) / sqrt(2*pi*det(Qz));
            
            return;
        end
            
        
        
    end
end



