> # An Introduction to Statistical Learning with Applications in R

- Author: Gareth James, Daniela Witten, Trevor Hastie and Robert Tibshirani
- [Introduction](https://www.google.com/search?sxsrf=ALeKk00UrzizCGPwJHhRI6VDgbrNBY5t7g%3A1595335394540&ei=4uIWX5zGIMz7wAPYmqf4Aw&q=Introduce+to+Statistical+Learning+with+R&oq=Introduce+to+Statistical+Learning+with+R&gs_lcp=CgZwc3ktYWIQAzIECCMQJ1CfIVifIWDdImgBcAB4AIABmwGIAaQCkgEDMC4ymAEAoAEBqgEHZ3dzLXdpesABAQ&sclient=psy-ab&ved=0ahUKEwicv_S7r97qAhXMPXAKHVjNCT8Q4dUDCAw&uact=5)
- Book: [seventh edition](https://www.google.com/search?sxsrf=ALeKk03Lx5KEuu8R-EzQ6KTwIVHdqNtfeg%3A1594810049744&source=hp&ei=wd4OX8-cKsesmAX2prHoCw&q=Introduce+to+Statistical+Learning+with+R+seventh&oq=Introduce+to+Statistical+Learning+with+R+seventh&gs_lcp=CgZwc3ktYWIQAzoECCMQJzoICAAQsQMQgwE6BQgAELEDOgIIADoECAAQAzoECAAQHjoGCAAQCBAeUNsPWNCuAWCssgFoAnAAeACAAcUBiAGQQJIBBDAuNTSYAQCgAQGqAQdnd3Mtd2l6&sclient=psy-ab&ved=0ahUKEwiPgfyzis_qAhVHFqYKHXZTDL0Q4dUDCAc&uact=5)

---

## 3. Linear Regression

Simple Linear Regression

- y를 설명하는 단 하나의 설명변수 x, 해석과 인과관계가 분명하게 들어난다.

Multiple Linear Regression

- 많은 예측변수로 반응변수 y를 설명하고자 함.
- 직관적인 인과관계에 대한 해석력은 줄었지만, 기본적으로 모델 설명력은 늘어난다.

Interaction Term

- 예측변수와 반응변수와의 관계가 애매함. (설명력이 약함.)
- 사전 지식에 따라 특정 변수들의 수리적 (곱셈) 관계가 반응변수와 더 관련이 있다.
- 거리(반응), 속도, 시간에서 속도, 시간을 그냥 예측변수로 쓰는 것보다 속도\*시간을 쓰는 게 거리와 관련이 있는 것처럼.

Non-linear Transormations of the Predictors

- 예측변수(들)와 반응변수(들)의 관계가 언제나 선형일 리는 없다.
- pearson 상관계수는 선형적 관계성의 측도일 뿐.
- 그러나 대체로 예측변수로 쓸 변수를 pearson 상관계수 보고 고르긴 함.

Qualitative Predictors

- 모든 예측변수는 양적 변수일 수 없다.
- 따라서, 범주형 변수는 수식에 포함되기 위해 더미화 시켜야 한다.
- 더미 변수 또한 interaction term을 통해 다른 변수와의 결합이 식에 많이 포함된다.

---

## 4. Classification

> classify를 위해서 Bayes’ Theoream을 이용, Bayes’ Classifier를 구해야 한다.<br />그러나 (대체로) 불가능하므로 Logistic Regression, LDA, QDA, KNN 방법을 비교

Logistic Regression

- 대체로 선형 회귀를 기본으로 해서 선형 회귀 기본 가정을 따른다.
- 그래서 대체로 선형으로 분리한다.
- logit을 통해 output을 [0,1]로 제한하는 방법이다.
- 따라서, 연관성 있는 두 측정값에 대한 모델이다.

LDA: Linear Discriminant Analysis

- 선형판별분석
- Gaussian(Noraml or Multiple Normal) 분포를 따르며, response를 선형 분리한다.
- 데이터를 특정 한 축에 사영(projection)한 후, 범주를 구분하는 직선을 찾는다.
- 데이터의 class 구성 비율에 따른 hyper parameter로 파이가 존재한다.
- p = 1은 등분산으로 LR과 같다.

QDA: Quadratic Discriminant Analysis

- 기본 회귀 가정처럼 Normal 분포를 따른다.
- 이름처럼 non-linear하게 respnse를 (이차) 곡선으로 분리한다.

KNN: K-Nearest Neighbors

- 주변에 몇 개의 데이터에 영향을 받을지에 대한 hyper parameter로 k가 존재한다.
- 선형일 때를 제외하면 가장 이상적인 방법이지만, 다른 방법론에 비해 악, 최악이 걸릴 가능성이 높다. 따라서 약간 하늘을 훔쳐본 정도로 만족해야 한다.

---

## 5. Resampling Methods

Validation set Approach

- 데이터를 랜덤하게 같은 양의 두 그룹으로 나누어 training, test로 사용한다.
- training으로 선정된 데이터에 너무 의존한다.

Cross-Validation

- test와 같은 크기에 validation 포함한 training과 test로 나누어 사용한다.
- Validation set Approach와 마찬가지로 training 데이터에 의존하는 경향을 보인다.
- 그래서 CV를 반복하는 방법을 생각해내게 된다.

LOOCV: Leave-One-Out Cross-Validation

- n개의 데이터에서 하나를 제거해서 CV하고 LOSS를 구하기를 반복한다.
- 일반적인 수식 모델에서는 대체로 Loss-function으로 MSE or SSE를 채택한다.
- 근데 빼낸 하나의 데이터를 validation set으로 선정한다는 얘기도 본 것 같은데.

k-fold CV: k-Fold Cross-Validation

- 전체를 몇 개의 그룹 수로 나눌 건지에 대한 hyper parameter로 k가 존재한다.
- 전체를 동일 갯수의 k개로 나누어 그 중 하나를 test로 고정시키고, 나머지 중에 하나를 validation으로, 나머지를 training으로 선정해 LOSS를 구하기를 반복한다.

Bootstrap

- 데이터를 랜덤 복원으로 뽑아 같은 양의 각기 다른 데이터로 만든다.
- 이 group을 전체 데이터 삼아 모델을 학습시킨다.

---

## 6. Linear Model Selection and Regularization

> Best Subset Selection을 선정하기 위한 방법으로 subset selection, regularization, dimension reduction을 비교

Subset Selection

- (전진선택법) Foward Selection, (후진삭제법) Backward Elimination, hybrid(or stepwise) selection
- 각각의 모델을 평가하고 비교할 측도로 Adjusted-R-squared, Cp, AIC, BIC가 있다.
- 이 측도들은 Loss나 Loss + Panelty로 구성된다.
- Cp: 범주형에서 배운 Cp의 panelty가 없는 버전으로 보이며, 단순 scale의 추가가 AIC라 유사하다.
- 비교 가능한 측도 중, 포함한 예측변수의 수 p에 대한 강한 panelry가 들어간 BIC를 제일 선호한다.

Regularization

- Ridge Regression: LOSS로 쓰인 SSE에 축소 모수 lambda와 회귀계수의 제곱합의 곱이 panelty처럼 식에 포함된 형태로, 이 term 때문에 회귀계수의 값이 절대 0이 되지 않는다.
- 그래서 처음 식에 있던 모든 예측변수를 사용한다.
- the Lasso: Ridge term에서 회귀계수의 제곱합이 아니라 회귀계수의 절댓값의 합이 식에 포함된 형태로, Ridge와 다르게 회귀계수가 0이 될 수 있다.
- 따라서, 어떤 예측변수는 모델에 포함하지 않을 수 있다.
- lambda term에 따라 lambda의 값이 커지면, 회귀계수의 값은 작아진다.

Dimension reduction

- PCR: Principal Component Analysis Regression (Supervised)
- PLS (Partial Least Squares): Supervised, first principal component is scaling sum
- PCR의 반응변수와의 관련성을 잃어버릴 수 있음을 배제하고자 만들어진 모델로, scaling으로 변환된 변수의 합을 하나의 변수로 취급해 몇 개의 scaling 합과 식을 구성한다.

---

## 7. Moving Beyond Linearity

> 선형을 일부 버리되, 설명력을 높이자는 계획이었으나 뜻대로 되는 것이 아니었다.

polynomial

- 다차항(회귀)을 뜻하며, 해석력은 감소하나 일반적으로 설명력은 소폭 증가한다.
- 같은 변수와 반응변수와의 수식적으로 다른 관계에 대한 term을 수식에 추가하는 거라, hat matrix가 orthogonal(직교)하게 구성되는 문제가 있는데, 다중공산성은 어쩔 수 없는 문제로 보여진다.
- 대체로 하진 않지만, non-orthogonal하게 만들어 구성하기도 한다.

Step Function

- 데이터의 모양이 구간마다 상이하여 poly로도 구성하기에 난감해 나온 방법이다.
- 특정 구간은 linear로 어떤 구간은 poly로 구성하는 등 구간마다 다른 함수를 적용한다.
- 구간마다 다른 함수라서 일부 만나는 구간은 불연속하거나 미분 불가능한 point가 된다.
- 이런 부드럽지 못한 point에 대해선 poly일 때는 한 단계(degree)를 낮추거나, 완전히 분리된 구간을 만드는 게 아니라 일부 겹치게 구간을 구성하기도 한다.

Spline

- 기억하는 게 맞다면, Poly, Step을 보완하고자 한 모델이다.
- Step과 다르게 조건 함수 I()로 구간에 대한 함수들을 하나의 식으로 표현하며, Step에서의 부드럽지 못한 point를 보완하고자 구간 poiint에 대한 term을 더하거나 하는 식의 편법 아닌 편법을 사용하는데 제대로 기억나지 않는다.

Local Regression

- 데이터가 얼마 없거나 그렇게 중요한 값을 나타내지 않는다고 판단되는 양끝 구간에 식과 함수 구성에 대한 데이터 가중치를 작게 주는 게 어떨까에서 출발했다.
- 따라서, 가중치에 대한 hyper parameter로 s가 존재히며, s에 따라 데이터에 가중치를 두어 부분 함수를 구성한다.
- Nearest-Neighbors의 개념과 유사하다.

GAMs: Generalized Additive Models

- 식과 모델을 예측변수별로 반응변수와의 관계의 합으로 구성하는 방법이다.
- 각 변수의 영향 구간에 변수 간 영향이 아닌 다른 인공적인 영향은 주지 않는다.
- 단점: important interactions will miss

---

## 8. Tree-Based Methods

Decision Tree

- 전형적인 classificatoin 방법론중 하나로, if-else로 해석하기 쉽다.
- plot으로 그려 class 예측하는 것도 직관적이며 쉬운 편에 속한다.

<hr style="border-style: dotted;" />

Bagging

- Bootstrap 기법을 이용해 만든 자기복제형 tree의 평균을 모델로 삼는다.

Random Forest

- Bagging보단 한 단계 나아간 방법으로, Bootstrap tree에 사용될 데이터의 크기 m 마저 randomly하게 구성한 방법이다.

Boosting

- Bootstrap 기법을 이용해 나눈 데이터에서 첫번째로 tree를 구성하고, 나머지 데이터는 validation처럼 사용해 모델을 고치는 방법이다.
- 당연하게도 첫번째 데이터가 굉장히 편향되어 있다면, tree의 split에 대한 hyper parameter는 validation에서 값이 요동치며 안정화시키기 힘들 것이다.
- 이를 쉽게 잡고자 hyper parameter로 수축 모수 lambda가 존재한다.
- 배울 때는 lambda의 값이 커지면 MSE 추정값은 작아진다고 배운 것 같은데 기억이 나지 않는다.

---

## 9. Support Vector Machines

> Perfect Separate isn't exists.

perfect separate

- Maximal Margin Classifier, maximal margin hyperplane
- Support Vectors (points), Support Vector Classifier

Support Vector Machine

- more flexible, not separable.
- kernel: linear kernel(alike Person correlation), polynomial kernel, radial kernel etc.
- Bigger tuning parameter, more support vectors, wider margin, higher bias, but lower variance.
- More than two classes, can use SVM.
- almost (perfect) separate data set is uesful on SVM?
- otherwise, Logistic Regression.
- but SVM exists perfect zero point.

---

## 10. Unsupervised Learning

> Unsupervised: sample response doesn’t exist, don’t set specific variable

PCA: Principal Component Analysis

- PCA(unsupervised) vs. PCR(supervised), ofcourse PLS(supervised)
- loading vector(eigen vector), score vector(scaled with loading vector)
- it MUST DO standardization before PCA.
- Sum of square of loading vector is 1, as expression of unit vector
- first loading vector a little related with linear regression(or LDA)
- PLA has certain limitation, if unsupervised
<hr style="border-style: dotted;" />

K-Means Clustering

- k is the number of subgroups
- minimize inner-variance grouping
- draw randomly
- repeat (find centroid(like perfect center)
- re-draw color nearest centroid)

Hierarchical Clustering

- tree-like visual representation
- linkage: Complete(maximal), Single(minimal), Average(mean), Centroid and so forth
- Euclidean distance, Correlation-based distance and so on
- BUT might be unrealistic
