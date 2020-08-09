> # Machine Learning

- Instructor: Andrew Ng
- Lectures: [Coursera](https://www.coursera.org/learn/machine-learning?action=enroll)
- [Sub-link](https://www.coursera.org/lecture/machine-learning/model-representation-db3jS?utm_source=link&utm_medium=in_course_lecture&utm_content=page_share&utm_campaign=overlay_button)

---

## Classification, _discrete valued response_

### 1. Binary (class) classification

_단일 분류, 반응변수가 베르누이(0 or 1)를 따르는 경우_

```
y ∈ {0, 1} - 0: Negative Class
            \ 1: Positive Class
```

- 관심사가 악성 종양인지 아닌지를 판단하는 것이라면, positive를 악성 종양으로 negative를 그렇지 않은 일반 종양으로 분류할 수 있다.

#### 1. linear regression model

| concept               | description                                         |
| --------------------- | --------------------------------------------------- |
| threshold             | minimum (percent) value that decides to 1 on simple |
| **Decision Boundary** | line like separate class due to multivariate input  |

- 선형식이 무릇 그렇듯 (비표본 오류로 인한) 데이터 오염과 극값의 영향을 잘 받는다.
- response =/= [0, 1]

<img src="images/logistic_sigmoid.JPG" style="display: block; margin: auto;" />

- g-function is a Sigmoid function (or Logistic function)
- logit을 이용해 response를 [0, 1]로 제한한다.

```
hθ(x) = Pr(y = 1|x; θ) = 1 - Pr(y = 0|x; θ)
probability that y = 1, given x, parameterized by θ
```

```
predict "y = 1", if hθ(x) ≥ threshold, when z ≥ value_of_z_range
predict "y = 0", if hθ(x) < threshold, when z < value_of_z_range

z = 0, e^0 = 1 → g(z) = 0.5

θ'x ≥ 0, y = 1
```

- hθ(x), g(z), θ'x로 다양하게 response 범위를 나타낼 수 있다.
- 어떻게 설정하냐에 따라 parameter의 부호가 달라지지만, 기본은 변하지 않는다.
- for decision boundary, set region each class

#### 2. Logistic regression model

- response의 범위 제한을 위해 모델로부터 나온 값을 변형하는 것에서 한 단계 나아가 모델에 변형식을 넣는다.
- 복잡한 sigmoid나 logit을 MSE에 넣게 되면, (극솟값이 하나가 아니라서) non-convex (비볼록 함수)가 나온다.
- 이러면 기울기 하강법을 사용할 수 없어 최대가능도추정법(MLE, Maximum Likelihood Estimation)를 이용한 새로운 Cost function을 사용한다.
- 미분을 하면 제곱이 1/2를 가져갈 거라 cost로 묶어버렸다.

<img src="images/logistic_cost.JPG" style="display: block; margin: auto;" />

```
Cost(hθ(x), y) = 0, if hθ(x) = y
Cost(hθ(x), y) → ∞, if y = 0 and hθ(x) → 1
Cost(hθ(x), y) → ∞, if y = 1 and hθ(x) → 0
```

- -MLE: Cost(hθ(x), y) = - y\*ln(hθ(x)) - (1 - y)\*ln(1 - hθ(x))

<img src="images/logistic_gradient_descent.JPG" style="display: block; margin: auto;" />

- 여전히 gradient descent을 최소의 cost 값을 찾는 최적화 알고리즘으로 사용한다.
- 선형 회귀의 기울기 하강법을 진행할 때와 식이 같다.
- Octave에선 fminunc라는 함수를 통해 상황에 따라 더 나은 최적화 알고리즘을 사용해 optimized parameter를 구한다.

<table>
  <tr>
    <td colspan="3">Other optimization algorithm</td>
    <td>than gradient descent</td>
  </tr>
  <tr>
    <td rowspan="3">Conjugate gradient</td>
    <td rowspan="3">BFGS</td>
    <td rowspan="3">L-BFGS</td>
    <td>No need to manually pick α</td>
  </tr>
  <tr>
    <td>Often faster than gradient descent.</td>
  </tr>
  <tr>
    <td>More complex</td>
  </tr>
</table>

### 2. Multiclass classification

_다중 분류, 여러 개의 binary classification으로 나누는 게 알고리즘의 핵심_

1. One-vs-all (one-vs-rest)

<!--
> Train a logistic regression classifier hθ^i(x) for each class to predict the probability that y = i<br />
> On a new input x, to make prediction, pick the claa i that maximizes
-->

```
hθ^i(x) = Pr(y = i|x; θ), i = 1,2,3
```

- 모든 class에 대해 해당 class와 나머지의 binary 분류로 만들어 학습시킨다.
- 당연하게도 class의 갯수만큼 binary classifier가 나온다.
- 새로운 데이터에 대해서 가장 가능성, hθ^i(x)이 높은 class로 분류한다.

---

<!--
> Overfitting: If we have too many features, the learned hypothesis may fit the training set very well(cost is almost 0), but fail to generalize to new examples (predict prices on new examples).
-->

## Overfitting

|                   underfitting                    |                  overfitting                   |
| :-----------------------------------------------: | :--------------------------------------------: |
|                     과소적합                      |                    과대적합                    |
|     강한 편향, High bias (데이터 설명력 부족)     |                    low bias                    |
|                   low variance                    |  높은 분산, High variance (모델 예측력 부족)   |
|            강한 선입견(preconception)             |              not generalize well               |
| 데이터랑 모양이 다른 경우로 모델 평가가 형편없다. | 오차를 줄이는데 집중해서 변동성이 너무 커졌다. |

- 역사적으로 또는 기술적으로 정해진 이름들이라 조금 다르게 받아들여질 수 있다.

### 1. Reduce number of features

> Manually select which features to keep.<br />
> Model selection algorithm.

- 변수를 모델에서 제외하는 것은 해당 변수로만 설명 가능하던 response의 부분 정보을 버린다는 것과 같다.

### 2. Regularization

_정규화, 수축(shrink) 모수의 추가_

> Keep all the features, but reduce magnitude/values of parameters θj​.<br />
> Works well when we have a lot of features, each of which contributes a bit to predicting y.

<!--
- Small values for parameters θ -> "Simpler" hypothesis, Less prone to overfitting
-->

- 모델에 설명력이 약한 변수나 poly-term에 큰 수를 곱해 panalty로 cost-function을 구성하면, cost를 최소화시키기 위해 panelty term의 parameter는 0으로 수렴하게 되고, 이를 통해 해당 term을 모델에 넣지 않은 것 같은 효과를 낸다. 이것이 정규화의 핵심이다.
- 그러나 parameter의 값이 0으로 수렴할 뿐이지, 실제로 0의 값을 가지지는 못해 어떤 변수도 배제하지 않는다.

<img src="images/regularization.JPG" style="display: block; margin: auto;" />

- λ (lambda, regularization parameter, 정규화 모수)
- θ0, y-절편의 값은 (x0 = 1이라) 모델 수축(단순화)에 영향력을 행사하지 못하므로 summation에 들어가지 않는다.
- θ0를 summation에 추가하는 작은 차이가 단위에 따라 큰 차이를 만들 수 있습니다.

|            |     λ가 너무 작으면      |         λ가 너무 크면          |
| :--------: | :----------------------: | :----------------------------: |
| J(θ), cost |   MSE term이 좌지우지    | regularization term이 좌지우지 |
| 변수 갯수  | 필요 없는 변수 제거 불가 |    모든 변수를 없애는 결과     |
| 결과적으로 |       overfitting        |          underfitting          |

1. Gradient descent

<img src="images/regularization_gradient_descent.JPG" style="display: block; margin: auto;" />

- Regularization term으로 인해 절편을 제외한 모든 θ가 learning rate term 이전에 θ(1 - α\*λ/m)이 된다.
- θ에 곱해지는 수는 α\*λ가 양수 소숫값이라 1보다 약간 작은 숫자가 된다.

2. Normal Equation (Non-invertibility)

<img src="images/regularization_normal_equation.JPG" style="display: block; margin: auto;" />

- regualization을 하는 가장 큰 이유는 적절한 회귀계수의 선정과 overfitting을 피하고자 함이다.
- 따라서, Normal Equation에는 이전과 같은 regualization은 필요가 없다.
- 그러나 singular matrix가 되면 안 되기에 약간의 값을 추가해주는데, 이 모양이 regualization term과 유사하다.

3. logistic regression (gradient descent)

<img src="images/regularization_logistic.JPG" style="display: block; margin: auto;" />
