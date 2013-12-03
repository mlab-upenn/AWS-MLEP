function genPop = binaryEncoder(Ngene, P, Plimit)
%GAENCODER function returns gene - matrix (mxn) where m are the number of variables
% to encode and n are the length of bits.
% Usage:
%   genPop = binaryEncoder(Ngene, P, Plimit)
%
%       Ngene = number of bits to encode.
%       P = matrix MxN. Rows are the parameters for each individual. 
%       Plimit = Limits for each of the variables (min - max values). First
%       row shows the lower limit of the parameters while second row 
%       represents the maximum value.
%
% (C) 2013 by Willy Bernal(willyg@seas.upenn.edu)

% Ngene = 2;
% P = [5 10; 10 20];
% Plimit = [0 0;10 20];

% For each chromosome/individual
Npop = size(P,1);

% Get Number of Variables
Nvar = size(P,2);

% Get Limits
Plo = repmat(Plimit(1,:),Nvar, 1);
Phi = repmat(Plimit(2,:),Nvar, 1);

% Normalize w.r.t 0-1
Pnorm = (P - Plo)./(Phi-Plo);

% Set Variables for encoding
vec2 = power(ones(1,Ngene)*2,-1*[0:Ngene-1]);
vec2 = repmat(vec2,Nvar,1);
vec2(:,1) = 0;
gene = zeros(Nvar,Ngene);
genPop = zeros(Npop,Ngene*Nvar);

% For each individual
for i = 1:Npop
    % Encode
    for j = 1:Ngene
        gene(:,j) = (Pnorm(i,:)' - 2^(-j)-sum(fliplr(gene(:,1:j)).*vec2(:,1:j),2)>=0);
    end
    
    % Concatenate strings
    geneNew = gene';
    geneNew = geneNew(:)';
    
    % Population chromosomes 
    genPop(i,:) = geneNew;
end
