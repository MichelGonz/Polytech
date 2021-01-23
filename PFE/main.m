
% Main code PFE
% Author: GONZAGA DOS SANTOS, Michel
% Nice France

clc
tic
%% Reading the Data set
% The data set is a .txt file containing the oligos
% We have:
% - The Original Oligos data set
% - The Noisy Oligos data set
clear all
% Orginal oligos data set:
load('C:\Users\miche\Documents\PFE\Oligos originaux\Original_oligos.mat'); 

% Noisy data set:  
load('C:\Users\miche\Documents\PFE\Oligos Bruit\len.mat');

%Frequency vector
load('C:\Users\miche\Documents\PFE\Oligos Bruit\lena_frequencies_vector_seq2.mat');
%% Clustering
[C,Err] = custer_oligos(Original_oligos(1:662,1:91),lena_oligos_mat(1:40000,1:91),lena_frequencies_vector);

% Error matrix Matrix
Err_mat = err_mat(Err);
toc
