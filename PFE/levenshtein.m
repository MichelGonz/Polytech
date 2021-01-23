function [ed,err] = levenshtein(st1,st2)
% The role of this function is calculate the levenshtein distance between
% two strings st1 and st2, and also track separatelly number of deletions,
% insertions and substitutions.
% st1 is the original one and st2 is the modified one
% 
% [ed,err] =  levenshtein(st1,st2)
% - ed is an integer containing the value of the levenshtein distance;
% - err is a vector containing the values of the number of deletions,
%   insertions and substitutions, respectively.

%% Initializing the variables
a = 0;
m = length(st1); % Length of st1
n = length(st2); % Length of st2
C = zeros(1,m+1); % Is the dinamic vector
c = 0;
d = 0;
delta = 0;
ed = 0; % Levenshtein distance
dele = 0;
de = 0;
ins = 0;
sub = 0;
s = 0;
err = []; % Vector of number of deletions, insertions and substitutions

%% Initializing the dynamic vector
C = 0:m; 
%% Levenshtein distance dinamic approach

for j = 2:n+1
    c = C(1);
    C(1) = j-1;
    for i = 2:m+1
        if st1(i-1) == st2(j-1)
            delta = 0;
        else
            delta = 1;
        end
        d = min([c + delta, C(i-1) + 1, C(i) + 1]);
        c = C(i);
        C(i) = d;
    end
end

% The levenshtein distance corresponds to the last element of the vector C.
ed = C(m+1);
%% Counting the number of deletions, insertions and substitutions

for k = 2:m+1
    if C(k-1) == C(k)
        sub = sub + 1;
    end
    if C(k-1) < C(k)
        dele  = dele + 1;
    end
    ins = ed - (sub + dele);
end

err = [dele ins sub];
if err(2) < 0
    err(1) = sub - ed;
    err(2) = 0;
    err(3) = ed + ins;
end
end