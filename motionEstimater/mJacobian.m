function [H, HT, z_hat] = mJacobian(V)
	 % H: Jacobian of measurment hatch function h(x)
        H = zeros(1,2); 
        H = [(V(1)/sqrt(V(1)^2+V(2)^2)) (V(2)/sqrt(V(1)^2+V(2)^2))]; 
        HT = H.';         
        z_hat = sqrt(V(1).^2+V(2).^2);       
end