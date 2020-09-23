> # Octave

---

3rd

```theta is 2-rows vector example
function [jVal, gradient] = costFunction(theta)
  jVal = (theta(1) - 5)^2 + (theta(2) - 5)^2;
  gradient = zeros(2, 1);
  gradient(1) = 2*(theta(1) - 5);
  gradient(2) = 2*(theta(2) - 5);
```

```
options = optimset("GradObj", "on", "MaxIter", "100");
initialTheta = zeros(2, 1);
[optTheta, functionVal, exitFlag] = fminunc(@costFunction, initialTheta, options);
```

> fminunc( ): 함수 내 최솟값을 찾는 함수.

- optimset("Gradient_object", "turn up parameter on GradObj", "use Maximum_iterator", "value before")
- @: costFunction이 정의되어 있지 않을 때를 대비한 포인터라는데, 우린 정의를 먼저 해서 상관없다고 한다.
- [optTheta, ~ exitFlag]가 길어서 ag로 줄여버리기도 한다.
- exitFlag: 내가 아는 게 맞다면, 너무나 완벽한 최적의 값을 찾아서 반복을 더 진행하지 않았음을 의미한다.

---

5th

```
Theta1 = ones(10, 11)
Theta2 = 2*ones(10, 11)
Theta3 = 3*ones(1, 11)
thetaVec = [Theta1(:); Theta2(:); Theta3(:);]

Theta1 = reshape(thetaVec(1:110), 10, 11)
Theta2 = reshape(thetaVec(111:220), 10, 11)
Theta3 = reshape(thetaVec(221:231), 1, 11)
```

- Octave는 1부터 시작한다.

```
epsilon = 1e-4;
for i = 1:n;
  thetaPlus = theta;
  thetaPlus(i) += epsilon;
  thetaMinus = theta;
  thetaMinus -= epsilon;
  gradApprox(i) = (J(thetaPlus) - J(thetaMinus)) / (2*epsilon);
end;
```

```
Theta1 = rand(10, 11) * (2 * INIT_EPSILON) - INIT_EPSILON
Theta2 = rand(10, 11) * (2 * INIT_EPSILON) - INIT_EPSILON
Theta3 = rand(1, 11) * (2 * INIT_EPSILON) - INIT_EPSILON
```

- Octave rand( )는 (0, 1)이 기본이며, parameter로 matrix shape을 필요로 한다.
