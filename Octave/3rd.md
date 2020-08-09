> # Octave

---

```theta is 2-rows vector
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
