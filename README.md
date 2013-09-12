AWS-MLEP
========

Matlab Toolbox for running EnergyPlus simulations in the cloud. 

Instructions
------------

1. Clone or download the github repository to you local computer. 
2. Copy your AWS credentials ("AWS.properties") file and your private key to the main folder. 
3. Open Matlab and navigate to the main folder. 
4. In mlepAwsInit.m add the path to your credentials file and private key pair. Save the file.
5. Run mlepAwsInit.m. 
    - This will save your settings in a global variable.
    - Add the necessary jar files to your Matlab dynamic java path. 
    - Save the necessary folder in your Matlab path. 
6. Go to the example folder. Follow the instructions that appear there. 



