function [v, P, K] = measUpdate(v_, P_, R, z)
            [H, HT, z_hat] = mJacobian(v_); % measurment Jacobian
            Qz = H*P_*HT + R; % measurement covariance, dim: 3*3
            if det(Qz) < 1e-6
                QzInv = pinv(Qz);
            else
                QzInv = inv(Qz);
            end
            
            % Kalman gain
            K = P_*HT*QzInv; 
            
            % update states and covariance
            v = v_ + K*(z-z_hat);
            P = (eye(2) - K*H)*P_;
            
end