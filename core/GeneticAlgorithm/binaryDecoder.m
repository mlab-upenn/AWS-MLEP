function [q] = binaryDecoder(Ngene, genPop, Plimit)
%GADECODER function returns gene - matrix (mxn) where m are the number of variables
% to encode and n are the length of bits.
% Usage:
%   q = binaryDecoder(Ngene, gene, Plimit)
%
%       Ngene = number of bits to encode.
%       genPop = matrix MxN where each row represents an individual
%       chromosome.
%       Plimit = Limits for each of the variables (min - max values). Every
%       row
% represents a variable limit. The first element is the min and the second
% one is the max.
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Testing
% Ngene = 2;
% P = [5 10; 10 20];
% Plimit = [0 0;10 20];
% genPop = binaryEncoder(Ngene, P, Plimit)

% Get Number of Variables
Nvar = size(genPop, 2)/Ngene;
Npop = size(genPop, 1);

% Get Limits
Plo = repmat(Plimit(1,:),Npop, 1);
Phi = repmat(Plimit(2,:),Npop, 1);

% Init
Pqpop = zeros(Npop,Nvar);
gene = zeros(Nvar, Ngene);

for i = 1:Npop
    % Individual gene
    gene = reshape(genPop(i,:),Ngene,Nvar)';
    
    % Find quantization
    vec2 = power(ones(1,Ngene)*2,-1*[1:Ngene]);
    vec2 = repmat(vec2,Nvar,1);
    Pquant = sum(gene.*vec2,2) + 2^-(Ngene + 1);
    
    % Population Parameters
    Pqpop(i,:) = Pquant';
end

% De-Normalization
q = Pqpop.*(Phi-Plo) + Plo;
