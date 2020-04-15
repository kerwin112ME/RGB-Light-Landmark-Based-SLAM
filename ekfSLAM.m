classdef ekfSLAM
    properties
        mapL; % map length
        lmY; % y-position of the RGB landmarks
        X; % states: [x; y; Xr; Xg; Xb], dim:5*1
        Q; % motion noise variance, dim:2*2
        R; % measurement noise variance, dim:3*3
        P; % covariance matrix, dim:5*5
                
    end
    
    methods
        function obj = ekfSLAM(mapL_, lmY_, X0, P0, Q_, R_)
            obj.mapL = mapL_;
            obj.lmY = lmY_;
            obj.X = X0;
            obj.P = P0;
            obj.Q = Q_;
            obj.R = R_;
        end
        
        function [obj,A] = move(obj, u, simulation)
            % Ar: jacobian of process function f (robot states part)
            % Al: jacobian of process function f (lm states part)
            % u: motion, dim:2*1
            if simulation
                obj.X(1) = obj.X(1) + u(1) + (rand*(2*obj.Q(1,1))-obj.Q(1,1));
                obj.X(2) = obj.X(2) + u(2) + (rand*(2*obj.Q(2,2))-obj.Q(2,2));
            else
                obj.X(1) = obj.X(1) + u(1);
                obj.X(2) = obj.X(2) + u(2);
            end
            
            if nargout > 1
                A = eye(2);
            end
        end
        
        function obj = prediction(obj, u, simulation)
            % predict the states
            [obj, A] = obj.move(u, simulation);
            
            % predict the covariance
            obj.P(1:2,1:2) = A*obj.P(1:2,1:2)*A' + obj.Q;
            obj.P(1:2,3:5) = A*obj.P(1:2,3:5);
            obj.P(3:5,1:2) = obj.P(1:2,3:5)';
            
        end
        
        function [H, z_hat] = measJacobian(obj)
            % H: Jacobian of measurment hatch function h(x)
            x = obj.X(1); y = obj.X(2);
            xr = obj.X(3); xg = obj.X(4); xb = obj.X(5);
            yr = obj.lmY(1); yg = obj.lmY(2); yb = obj.lmY(3);
            
            rden = 2*sqrt((x-xr)^2+(y-yr)^2);
            gden = 2*sqrt((x-xg)^2+(y-yg)^2);
            bden = 2*sqrt((x-xb)^2+(y-yb)^2);
            
            H = zeros(3,5);
            H(1,:) = [2*(x-xr), 2*(y-yr), -2*(x-xr), 0, 0]./rden;
            H(2,:) = [2*(x-xg), 2*(y-yg), 0, -2*(x-xg), 0]./gden;
            H(3,:) = [2*(x-xb), 2*(y-yb), 0, 0, -2*(x-xb)]./bden;
            
            z_hat = sqrt((x-obj.X(3:5)).^2+(y-obj.lmY).^2);
            
        end
            
        
        function obj = measUpdate(obj, z)
            [H,z_hat] = obj.measJacobian(); % measurment Jacobian
            Qz = H*obj.P*H' + obj.R; % measurement covariance, dim: 3*3
            if det(Qz) < 1e-6
                QzInv = pinv(Qz);
            else
                QzInv = inv(Qz);
            end
            
            K = obj.P*H'*QzInv; % Kalman gain
            
            % update states and covariance
            obj.X = obj.X + K*(z-z_hat);
            obj.P = (eye(5) - K*H)*obj.P;
            
        end
              
        
    end
end
        
        
                
        
        
        
        
        
        
        
        
        
        
