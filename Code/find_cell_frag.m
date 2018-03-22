%To find labels of adjacent regions
function [up,down,left,right] = find_cell_frag(label, matrix_0, matrix_1)

 [row, col] = find(matrix_1 == label);
 %move up and left
 row_up = row-1;
 if row_up <0
    row_up =1; 
 end
 col_left = col -1;
 if col_left <0
    col_left = 1; 
 end
 %move down and right
 row_down = row+1;
 col_right = col+1;
 %iterate through all the rows and columns
 n = size(row);
 m = size(col);
 %for the ones above and below
 upper = zeros(n);
 lower = zeros(n);
 
 leftie = zeros(m);
 rightie =  zeros(m);
 for i = 1:n(1)
     upper(i) = matrix_0(row_up(i),col(i));
     lower(i) = matrix_0(row_down(i),col(i));
     leftie(i) = matrix_0(row(i),col_left(i));
     rightie(i) = matrix_0(row(i),col_right(i));
 end
 
 %find unique elements
 up = unique(upper);
 left = unique(leftie);
 down = unique(lower);
 right = unique(rightie); 
end