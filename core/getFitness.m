% This function calculate the fitness
% 
%
% This script is free software.
%
% (C) 2013 by Tao Lei (leitao@seas.upenn.edu)
%
% CHANGES:
%   2013-09-30  Created. 
function fitness = getFitness(comfort, powConsume)
%   Function to get the fitness of each individual within an population in one generation
%   INPUT    delayRecPerGen     The delay of each individual in the population
%            expect             The expected result? or the expected total delay                  
%   OUTPUT   fitness            Each individual's fitness

% expect = 45000;
% fitness = expect./(mean(comfort .* powConsume) - expect);

expect = 5500;
% fitness = 10 * (expect ./(mean(powConsume)) - 1);
fitness= expect./(mean(powConsume) - expect);
end



