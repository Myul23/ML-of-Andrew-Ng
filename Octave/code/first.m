A = [1,2,3;4,5,6;7,8,9;10,11,12]
v = [1; 2; 3]

[m, n] = size(A)

dim_A = size(A)
dim_v = size(v)

A_23 = A(2,3)

##########

A = [1,2,4; 5,3,2]
B = [1,3,4; 1,1,1]

s = 2

add_AB = A + B
sub_AB = A - B

mul_As = A * s
div_As = A / s
add_As = A + s

##########

A = [1,2,3; 4,5,6; 7,8,9]
v = [1; 1; 1]

Av = A * v

##########

A = [1,2; 3,4; 5,6]
B = [1; 2]

mul_AB = A * B

##########

A = [1,2; 4,5]
B = [1,1; 0,2]

I = eye(2)

IA = I * A
AB = A * B
BA = B * A

##########

A = [1,2,0; 0,5,6; 7,0,9]

A_trans = A'
A_inv = inv(A)
A_invA = inv(A)*A
