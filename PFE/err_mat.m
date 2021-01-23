function[E_mat] = err_mat(Err)

E_mat = [];
d = 0;
vec = cell2mat(Err(1));
for i = 2:662
    vec1 = cell2mat(Err(i));
    E_mat = [vec; vec1];
    vec = E_mat;
end

end