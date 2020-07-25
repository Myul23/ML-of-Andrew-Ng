> # Machine Learning

- Author: Andrew Ng
- Lectures: [Coursera](https://www.coursera.org/learn/machine-learning?action=enroll)
- [Sub-link](https://www.coursera.org/lecture/machine-learning/model-representation-db3jS?utm_source=link&utm_medium=in_course_lecture&utm_content=page_share&utm_campaign=overlay_button)

---

English version of modern definition of ML

> A computer program is said to learn from experence E with respect to some class of tasks T and perfomance measure P,, if its perfomance at tasks in T, as measured by p, improves with experience E.<p style="text-align: right;">- Tom Mitchell (Carnegie Mellon University)</p>

> Machine Learning은 매 만들어지고 사용하는 데이터를 뜻하는 경험(E)과 해당 경험을 위한 작업(T), 작업을 통해 얻어지는 perfomance의 측도인 성능(P)으로 구성된다.

- 학습 과제(well-posed learning problem) 중심 정의
- 경험이 증가함에 따라 작업을 수행하는 성능이 향상될 수 있다.
- 이런 것을 경험으로부터 학습(learn)했다고 표현한다.
- 이전 Arthur Samuel: ML이란 컴퓨터가 명시적 프로그램 없이 스스로 학습할 수 있는 능력을 공부하는 학문.

### Three compositions of ML

- contain Reinforcement

> In supervised learning, we are given a data set and already know what our correct output should look like, having the idea that there is a relationship between the input and the output.

- 지도 학습
- Supervised Learning means using data set includes correct outputs.
- Regression은 연속이라는 특징을 가진 값을 모형화하고 예측하려고 한다는 것을 뜻한다.
- Claasification은 연속하지 않은, 특히 범주적인 특징을 가진 값들에 대한 모형화와 예측을 시도하는 것이다.

> Unsupervised Learning allows us to approach problems with little or no idea what our results should look like. We can derive this structure by clustering the data based on relationships among the variables in the data.

- 비지도 학습
- class 데이터가 없는 경우, 모두 같은 class인 경우, class라는 변수 자체가 없는 경우로 나뉜다.
- 따라서, unsupervised Learning grouping은 Clustering으로 몇 개의 group, 몇 개의 구조로 구성되어 있는지를 묻는 것이며 해당 구조체를 cluster라고 부른다.
- Organize computing clusters, Social network analysis, Market segmentation, Astronomial data analysis

> 음설 관련 clustering<br />[W, s, v] = svd((repmat(sum(x.*x, 1), size(x, 1), 1).*x)\*x');<p style="text-align: right;">- Source: Sam Roweis, Yair Weiss & Eero Simoncelli</p>

- 대괄호에 대한 자유로운 접근과 세미콜론이 있는 것으로 보아 Java에 가깝지 않을까라는 생각이 드나, Octave라는 open source라고 한다.
- svd( ): 특이값 분해(singular value decomposition)

### Basic configuration concepts of ML

|         용어          |                                                                                                                                                                  |
| :-------------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|         가설          | h: hypothesis, 우리가 학습시켜 얻은 모델이자 모델의 수식<br />- h(x): X -> Y, h maps from x's to y's                                                             |
|         모수          | parameter, 모델을 결정함에 따라 구해야할 parameters도 결정된다.                                                                                                  |
| 비용 함수 (손실 함수) | Cost, Loss, J-func<br />모델 모수를 찾을 때 고려할 사항으로, 대체로 오차의 값을 최소화하는 회귀계수를 찾고자 한다.<br />- LOSS: MSE or SSE(최소제곱법) and so on |
|         목표          | Goal is usually minimize Cost function                                                                                                                           |

- 생각해보면 ISLR 때부터 parameter 값의 변동에 의한 Loss 값의 그래프는 반복해왔던 거인데, 잘 몰랐다.
- Contour: 일종의 등고선 그래프로 z축 값이 같은 이들을 연겷한 그래프
- 대체로 z축을 밀어넣어 2차원으로 필요한 등고선(contour line)만을 표시한다.

### Gradient descent

> Start with some parameters(alpha, beta, gamma, delta etc)<br />
> Keep changing parameters to reduce Cost untill we hopefully end up at a minimum

<img src="images/gradient_descent.jpg" />
<!-- > θj := θj − α \* ∂/(∂θj) \* J(θ0,θ1) -->

- 기울기 하강법
- 최소제곱법처럼 최적의 값을 찾기 위해 parameter마다 미분에서 최솟값을 구해야 한다.
- 수식과의 연계성을 고려해 parameter update는 모든 parameter를 한 번에 진행한다.
<p style="border: 1px dotted grey; opacity: 0.2;"></p>

- 모델 학습에서 모든 경우를 고려하지 않고도 최적의 비용함수 값을 찾는 방법으로 널리 사용된다.
- 지역적 최솟값을 찾는 걸 방지하고자 다른 시작점을 두어 반복해 최적의 최솟값을 찾기도 한다.

|         word         | description                                             |
| :------------------: | ------------------------------------------------------- |
|    Learnign Rate     | 발걸음, 보폭으로 표현되며 얼마만큼 움직일지에 대한 측도 |
|    Local Optimum     | 지역적 최솟값으로 기울기 하강법을 통해 찾은 극(소)값들  |
| simultaneosly update |
