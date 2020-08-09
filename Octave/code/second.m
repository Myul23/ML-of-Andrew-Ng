% 5 + 6 % 3 - 2 % 5 * 8 % 1 / 2 % 2^6
% 1 == 2 % 1 ~= 2
% 1 && 0 % 1 || 2 % xor(1, 0)

% PS1(">> ");
% semicolon don't show output

% a = 3 % a = 3; % b = "hi" % c = (3 > 1)

a = pi;
% format long % format short

disp(a);
disp(sprintf("2 decimals: %0.2f", a))
% disp(sprintf("6 decimals: %0.6f", a))

A = [1 2; 3 4; 5 6]
% semicolon means go next row here

v = [1 2 3]
v = [1; 2; 3]
v = 0:0.1:2 % R, v = sep(0, 2, 0.1)
v = 1:6

ones(2, 3)
C = 2*ones(2, 3)
% C = [2 2 2; 2 2 2]

w = ones(1, 3)
w = zeros(1, 3)
w = rand(1, 3)
w = rand(3, 3)
w = randn(1 ,3) % from normal distribution
w = -6 + sqrt(10)*randn(1, 10000);

hist(w)
hist(w, 50)

eye(4)
I = eye)(6)
% help eye

##########

size(A)
% sz = size(A)
% size(sz)
% size(A, 1) % size(A, 2)

v = [1 2 3 4]
length(v)
% length([1;2;3;4;5])
% length의 매개변수로 행렬을 넣는 것도 가능하지만, 편의를 이유로 쓰지 않는다.

% pwd % cd C:\dump\Octave
% load featuresX.dat % load("featuresX.dat")
% load priceY.dat

who

% featuresX
% size(featuresX) % 47, 2
% size(priceY) % 47, 1

% whos
% clear featuresX

% v = priceY(1:10)
% save hello.mat v; % .mat은 매트랩 확장자
% save hello.tst v -ascii;

A = [1 2; 3 4; 5 6]

A(3, 2)
A(2, :)
A(:, 2)
A([1 3], :)

A(:, 2) = [10; 11; 12]
A = [A, [100; 101; 102]];

A(:)

% example
A = [1 2; 3 4; 5 6]
B = [11 12; 13 14; 15 16]

C = [A B] % size(C)
C = [A; B] % size(C)

#########

A = [1 2; 3 4; 5 6]
B = [11 12; 13 14; 15 16]
C = [ 1 1; 2 2]

A * C
A .* B
A.^2

v = [1; 2; 3]
1 ./ v % 1 ./ A

log(v)
exp(v)
abs(v) % abs([-1; -2; -3})
% -v

v + ones(length(v), 1) == v + 1

A' % (A')'

a = [1 15 2 0.5]

val = max(a)
[val, ind] = max(a)
% max(A)

a < 3
find(a < 3)

A = magic(3) % 마방진
[r, c] = find(A >= 7)

sum(a)
prod(a)
floor(a)
ceil(a)

% 연습용
rand(3)
max(rand(3), rand(3))

max(A, [], 1) % 열별 최댓값
max(A, [], 2) % 행별 최댓값
max(max(A)) == max(A(:))

A = magic(9)
sum(A, 1) % 같은 값이 나와야 함.
sum(A, 2) % 여전히 같은 값.
sum(sum(A .* eye(9)))
% sum(sum(A .* flipud(eye(9)))

A = magic(3)
pinv(A)
A * pinv(A)

#########

t = [0:0.01:0.98]
y1 = sin(2*pi*4*t);
% plot(t, y1);
y2 = cos(2*pi*4*t);
% plot(t, y2);

plot(t, y1);
hold on;
plot(t, y2, 'r');
xlabel("time");
ylabel("value");
legend("sin", "cos")
title("my plot")

% cd C:\dump\Octave
% print -dpng "myplot.png"
close

% figure(1): plot(t, y1);
% figure(2): plot(t, y2);

subplot(1, 2, 1);
plot(t, y1);
plot(t, y2);
axis([0.5 1 -1 1]) % 바꿀 순간에 작업하고 있는 plot만 변한다.
clf

% Andrew Ng의 수에 대한 (색적) 무언가를 보기 위함이라고 하심.
A = magic(5)
imagesc(A)
imagesc(A), colorbar, colormap gray;
% 그냥 세 함수를 한 번에 실행시킨 거라고 하십니다.
imagesc(magic(15)), colorbar, colormap gray;

% a = 1, b = 2, c = 3
% a = 1; b = 2; c = 3;

#########

v = zeros(10, 1)

for i = 1:10,
  v(i) = 2^i;
end;

indices = 1:10;

for i = indices,
  disp(i);
end;

i = 1;
while i <= 5,
  v(i) = 100;
  i = i + 1;
end;

i = 1;
while true,
  v(i) = 999;
  i = i + 1;
  if i == 6,
    break;
   end;
end;

v(1) = 2;
if v(1) == 1,
  disp("The value is one");
elseif v(1) == 2,
  disp("The value is two");
else
  eisp("The value is not one or two");
end;

#########

% function_name(4)
% addpath("C:\dump\Octave") % addpath를 이용하면 굳이 wd를 옮길 필요 없다.

X = [1 1; 1 2; 1 3]
y = [1; 2; 3]
theta = [0; 1];
j = costFunctionJ(X, y, theta)

% theta = [0; 0];
% j = costFunctionJ(X, y, theta)
% (1^2 + 2^2 + 3^2) / (2*3)
