function [Cluster,Err_cont] = custer_oligos(X,Y,F)
% This function performes the cluestring of the noisy oligos based on the
% nearest neighbor between two
% Y: Ensemble of Noisy Oligos
% X: Ensemble of Original Oligos
% It returns:
% - Cluster: It is a matrix of cell, whose each one is a cluster containing
%            the noisy oligos related to an original one.
% - Err: It is a matrix of cell, whose each cell ia cluster that contains
%        the number delections, insertions and subtituions beteween the
%        original oligo and its noisy versions.

%% Variables used in the program
a = []; % Auxiliar vector
dim_X = size(X); % Dimensions of the matrix X containing the original oligos
dim_Y = size(Y); % Dimensions of the matrix Y containing the noisy oligos
d_min = inf; % Intialization of the nearest neighbor parameter
d = 0; %Variable that keeps the the value of the levenshtein distance
corresp = zeros(dim_Y(1),2); % Vector that stores the correspondence of the indices of the 
                             % original and noisy oligos 
err = []; % Vector that stores the number of each type of errors
Err = zeros(dim_Y(1),7); % Stores the vectors err during the classfication stage
Cluster = cell(1,dim_X(1));

k = 0;
b = 0;
Err_cont = cell(1,dim_X(1));

l = 0;
%% Nearest neighbor classification
% The parameter of classifcation in this case is the Levenshtein distance 
% between the original and noisy oligos.
% The principle of this part is based on scroll through the ensemble of
% Noisy oligos and calculate the distance between each of than and each of
% the original ones. If the distance between one noisy and one original is 
% smaller than the distance of the noisy one and all the other original, 
% than it will belong to the cluster of related to the original one.

parfor j = 1:dim_Y(1)
    d_min = inf; 
    for i = 1:dim_X(1)
        [d, err]= levenshtein(deshuffled(X(i,:)),deshuffled(Y(j,:)));
        if d <= d_min
            err = F(j)*err;
            a = [j i err d F(j)];   
            d_min = d;
        end 
    end
    Err(j,:) = a;
    corresp(j,:) = a(1:2);
    d_min = inf;
end

%% Clustering
% The clusters are made based on the correspondance vector.
for i = 1:dim_X(1)
    b = 0;    
    C = [];
    E_rec = [];
    for j = 1:dim_Y(1)
        if corresp(j,2) == i && Err(j,2) == i
            k = Y(corresp(j,1),:);
            l = Err(j,3:7); 
            b = b+1;
            C(b,:) = k;
            E_rec(b,:) =  l;
        end 
    end
    Cluster{i} = C;
    Err_cont{i} = E_rec;
end 

end