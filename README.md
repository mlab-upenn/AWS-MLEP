AWS-MLEP
========

Matlab Toolbox for running EnergyPlus simulations in the cloud. 

Instructions
------------

1. Clone or download the github repository to you local computer. 
2. Open Matlab and navigate to the main folder. 
3. In mlepAwsInit.m add the path to your credentials file and private key-pair file. Save the mlepAwsInit.m.
4. Run mlepAwsInit.m. 
    - This will save your settings in a global variable.
    - Add the necessary jar files to your Matlab dynamic java path. 
    - Save the necessary folder in your Matlab path. 
5. In Matlab, open the parallel cluster profile manager and set the profile to local. Edit the local profile to have as many workers as you would need. 
6. In the Matlab command line:
    - matlabpool open 6
7. Go to the Example folder. 
8. Run initInstances.m Change the numOfInst variable according to your needs. 
9. Run runAWSsimple.m 



