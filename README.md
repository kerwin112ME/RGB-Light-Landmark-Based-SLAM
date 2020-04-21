# RGB Light Landmark-Based SLAM
MEEN 689 Term Project

# About
A matlab version of landmark-based Fast SLAM using RGB light intensities as landmarks.

# Detail
Run RunSLAM.m function (input the motion data and measurement data) to run the whole project.

Particle.m:
  a class of a single particle.
  
ParticleFilterSLAM.m:
  a class of the SLAM algorithm, including methods like predictParticles(), updateParticles(), resampling() ... etc.


# Simulation
Run Particle Filter SLAM with
  number of particles: 2000  
  process noise variacne: 0.03  
  measurement noise variance: 1  
  ![](Plots/PF_simulation.png)  
  
Run EKF SLAM with  
  process noise variacne: 0.03  
  measurement noise variance: 1  
  ![](Plots/EKF_simiulation.png)  
  

  
