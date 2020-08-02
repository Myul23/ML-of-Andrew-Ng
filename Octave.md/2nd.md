> # Octave

- R과 python처럼 변수 타입 선언이 완전히 불필요하다.
- 원소 차원의 부울 계산이 가능한 걸 보니 R과 유사성이 짙은 것으로 보인다.
- SAS처럼 데이터에서 띄어쓰기에 예민한 것으로 보인다.
- ':'는 R과 같이 선택된 벡터의 모든 원소를 불러온다.
- ','를 통해 R에서 ';'처럼 여러 함수를 한 번에 실행시킬 수 있다.
- R, python과 마찬가지로 break과 continue라는 명칭을 사용한다.

---

- %가 주석이며, bool을 숫자로 표현하고 not을 '~'로 표현한다.
- &&, ||, xor( , )
- '.'은 원소 단위의 계산을 의미한다.
- 열을 1로 행을 2로 표기한다.
- ';'를 끝에 추가하면, 출력을 막는다.
- ','를 ';'로 바꾸어 출력을 막으며 함수를 한 번에 실행하는 일석이조를 comma chaining이라 부른다.
- 함수를 파일로 저장하고 불러올 때는 파일 이름이 함수 이름이어야 한다. (function_name.m 참조)

```
if v(1) == 1,
  disp("The value is one");
elseif v(1) == 2,
  disp("The value is two");
else
  eisp("The value is not one or two");
end; %endif;
```

```
for i = 1:10,
  v(i) = 2^i;
end; %endfor;
```

```
i = 1;
while true,
  v(i) = 999;
  i = i + 1;
  if i == 6,
    break;
  end; %endif;
end; %endwhile;
```

---

- 원래 prompt 포인터가 octave의 버전.exe 같은 모양새지만, PS1(string)을 통해 모양을 바꿀 수 있다.
- format long: 약 14자리의 소수점을 보이게 셋팅. / format short: 약 4자리의 소수점을 보이게 셋팅.

---

### 1st

```
A = [1,2,3; 4,5,6; 7,8,9; 10,11,12]
v = [1; 2; 3]

[m, n] = size(A)

dim_A = size(A)
dim_v = size(v)

A_23 = A(2,3)
```

```
A = [1,2,4; 5,3,2]
B = [1,3,4; 1,1,1]

s = 2

add_AB = A + B
sub_AB = A - B

mul_As = A * s
div_As = A / s
add_As = A + s
```

```
A = [1,2,3; 4,5,6; 7,8,9]
v = [1; 1; 1]

Av = A * v
```

```
A = [1,2; 3,4; 5,6]
B = [1; 2]

mul_AB = A * B
```

```
A = [1,2; 4,5]
B = [1,1; 0,2]

I = eye(2)

IA = I * A
AB = A * B
BA = B * A
```

```
A = [1,2,0; 0,5,6; 7,0,9]

A_trans = A'
A_inv = inv(A)
A_invA = inv(A)*A
```

| func-name | transfer other prog.lang. | addition               |
| --------- | ------------------------- | ---------------------- |
| eye(n)    | numpy.eye( )              | n by n identity matrix |
| size( )   |                           |                        |

---

### 2nd

| constant              |                     | constant               |                                  |
| --------------------- | ------------------- | ---------------------- | -------------------------------- |
| help func_name        | q or help end       | pwd                    | present working directory        |
| cd address            | move to the address | ls                     | cmd, dir                         |
| load address.file.txt | load(address-)      | save file.csv var_name | R, write.csv(var_name, file.csv) |
| who                   | R, ls()             | whos                   | who + detail                     |
| clear var_name        | R, rm(var_name)     |
| hold on               | 다른 plot을 얹는다. | close                  | close plot picture               |
| exit                  |                     | quit                   |                                  |
|                       |                     |                        |                                  |
| matrix .\* martrix    | atomic multiply     | matrix .^ n            | calculate each atomic ^ n        |
|                       |                     |                        |                                  |
| pi                    | 3.1416              |

- clear: R, rm(list = ls())
- 일반적인 save는 압축 이진 형식을 취하기 때문에 사람이 읽을 수 없다.
- 이를 방지하고자 읽을 수 있는 확장자와 -ascii를 통해 ascii로 저장하게 한다.

| func-name   | function              |     | func-name  | function                               |
| ----------- | --------------------- | :-: | ---------- | -------------------------------------- |
| addpath()   | R, .libPaths(address) |
| disp( )     | display               |  -  | sprintf( ) | return string transfered from c-printf |
|             |                       |     |            |                                        |
|             |                       |     |            |                                        |
| magic(n)    | 마방진 square matrix  |
| sum( )      | sum                   |  -  | prod( )    | multiply all atomic values             |
| abs( )      | absolute value        |
| floor( )    | flooring              |  -  | ceil( )    | ceiling                                |
| log( )      | log                   |  -  | exp( )     | exponential                            |
| sin( )      |                       |  -  | cos( )     |                                        |
| flipud( )   | 완전히 뒤집기         |
| pinv( )     | pseudo-inverse        |  -  | inv( )     | inverse                                |
| var_name(:) | make m+n by 1 vector  |  -  | find(기준) | return indexs true value               |
|             |                       |     |            |                                        |
| axis([ ])   |

- pinv(X'\*X)\*X'\*y
- [r, c] = find(matirx >= n)
- print -dpng "myplot.png", myplot이란 이름으로 png 형태의 파일로 저장.
- imagesc(matrix), colorbar, colormap color_name: 행렬을 hitmap화해서 보는 것.

| func-name             | transfer other prog.lang. | addition                                     |
| --------------------- | ------------------------- | -------------------------------------------- |
| from:dist:to          | R, sep(from, to, dist)    |
| ones(m, n)            | numpy.ones( )             | all 1 value in m by n matrix                 |
| zeros(m, n)           | numpy.zeros( )            | all 0 value in m by n matrix                 |
| rand(m, n)            | qusghks rnlcksgek         | random number in m by n matrix               |
| randn(m , n)          | R, ndist() blah blah      | normal random number in m by n matrix        |
| matrix'               | R, t( )                   | transpose                                    |
|                       |                           |                                              |
| length( )             | len( )                    | return greater (column or row) vector length |
| max( )                | R, max( )                 | return maximum value on that                 |
|                       |                           |                                              |
| subplot( , , )        | R, par(mfrow = c( , ))    |
| plot(var, var, color) | plot( )                   | draw line                                    |
| hist(var, n)          | R, hist( ) / plt.hist( )  | draw histogram for n distances               |
| xlabel( )             | plt.xlabel( )             |
| ylabel( )             | plt.ylabel( )             |
| legend( )             | plt.legend( )             |
| title( )              | plt.title( )              |

- [val, ind] = max( ), 행렬에 대해선 열 단위로 maximum 값을 반환한다.
- max(matrix, [], 1 or 2): 열별 or 행별 최댓값

### vectorization

- vector 계산이나 행렬곱을 이용해 벡터연산으로 간단히 나타낼 수 있는 걸
- 벡터 안 쓰고 구현하겠다고 비효율적으로 loop 돌리지 말라는 얘기.

#### about j-function

```
prediction = 0.0;
for j = 1:n+1,
  prediction = prediction + theta(j) * x(j);
end;
% == prediction = theta' * x;
```

```in C++, linear algebra library
double prediction = 0.0;
for (int j = 0; j <= n; j++)
  prediction += thetapj[j] * x[j];
// == double prediction = theta.transpose() * x;
```
