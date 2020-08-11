> # 빅데이터 분석의 첫걸음 R코딩

- Author: 장용식, 최진호
- Book: <https://book.naver.com/bookdb/book_detail.nhn?bid=16324211>
- coding은 example들을 제외하고는 programming으로 넘겼습니다.

---

### Big-data

_3V: volume, velocity, variety_

- 인공지능(AI) = 전문가시스템 + 퍼지시스템 + 유전알고리즘 + 기계학습
- 생성적 적대 신경망(GAN, Generative Adversarial Network): 예술 분야의 창작 활동 등에 활용할 수 있는 이미지 생성 기술

---

## 데이터 구조의 이해

| 데이터 유형   | 설명                                                                            |
| ------------- | ------------------------------------------------------------------------------- |
| 벡터          | 동일한 데이터 유형(숫자 또는 문자 등)의 단일 값들이 일차원적으로 구성된 것이다. |
| 요인          | 문자 벡터에 데이터의 레벨이 추가된 데이터 구조                                  |
| 배열          | 동일한 데이터 유형을 갖는 1차원 이상의 데이터 구조                              |
| 리스트        | 각 원소들이 이름과 서로 다른 데이터 유형을 가질 수 있다.                        |
| 데이터 프레임 | 2차원 테이블 형태로, 각 열의 데이터는 동일한 데이터 유형이다.                   |

```{r}
score <- 70
score
score <- c(70, 85, 90)
score
```

> c( ): concatenate의 약자로 벡터 생성 함수

- assign("x", c(70,80,90))보단 x <- c(70, 85, 90)을 권장한다.

```{r}
score[4] <- 100; score[3] <-95
score
name <- c("알라딘", "자스민", "지니")
name
```

_식별자(identifer)_

- 변수 또는 ㅎ마수 등을 다른 것들과 구별하기 위해 사용하는 이름들을 지칭하는 용어.
- 일련의 문자, 숫자, '.', '\_'으로 구성된다. 단, '\_'이나숫자 + '.'으로 시작하면 안 된다.
- R에서 정의되어 있는 예약어도 사용할 수 없다.

```{r}
x <- seq(1, 10, by = 3)
x
x <- 1:10
x
x <- 10:1
x
x <- seq(1, 10, length.out = 5)
x
```

```{r}
x <- c(1,2,3)
y <- rep(x, times = 2)
y
y <- rep(x, each = 2)
y
```

_연산자_

| 산술 연산자 |   기호    |   예시   |   결과   |
| :---------: | :-------: | :------: | :------: |
|   더하기    |     +     |  2 + 3   |    5     |
|    빼기     |     -     |  10 - 3  |    7     |
|   곱하기    |    \*     |   3\*4   |    12    |
|   나누기    |     /     |  4 / 3   | 1.333333 |
|  거듭제곱   | ^ or \*\* |   2^3    |    8     |
|   나머지    |     %     |  10 % 3  |    1     |
|     몫      |    %/%    | 10 %/% 3 |    3     |

```{r}
x <- c(10, 20, 30, 40)
y <- c(2, 4, 6, 8)
z <- c(2, 4)
x + 5
x + y
x + z
```

| 비교 연산자 | 기호 |   예    | 결과  |
| :---------: | :--: | :-----: | :---: |
|    작음     |  <   | 3 < 10  | TRUE  |
|    이하     |  <=  | 3 <= 10 | TRUE  |
|     큼      |  >   | 3 > 10  | FALSE |
|    이상     |  >=  | 3 >= 10 | FALSE |
|    같음     |  ==  | 3 == 10 | FALSE |
|  같지 않음  |  !=  | 3 != 10 | TRUE  |

```{r}
3 < 10
x <- c(10, 20, 30)
x <= 10
x[x > 15]
```

```{r}
x <- c(10, 20, 30)
any(x <= 10)
all(x <= 10)
```

| 논리 연산자 |   기호    |      예       |      결과       |
| :---------: | :-------: | :-----------: | :-------------: |
|   논리합    |    \|     | TRUE \| FALSE |      TRUE       |
|   논리곱    |     &     | TRUE & FALSE  |      FALSE      |
|  논리부정   |     !     |  !0<br />!2   | FALSE<br />TRUE |
|  진위여부   | isTRUE( ) | isTRUE(FALSE) |      FALSE      |

```{r}
x <- c(TRUE, TRUE, FALSE, FALSE)
y <- c(TRUE, FALSE, TRUE, FALSE)
x & y
x | y
xor(x, y)
```

> xor( ): exclusive or

| 특수값 | 기호 |                                                                   |
| :----: | :--: | ----------------------------------------------------------------- |
| 결측치 |  NA  | 데이터 누락                                                       |
|   널   | NULL | 변수 이름만 있는 경우                                             |
| (불능) | Inf  | 0이 아닌 수를 0으로 나눈 경우, 수렴하지 않아 값을 특정할 수 없다. |
| (부정) | NaN  | Not a number, 0을 0으로 나눈 경우와 같이 계산할 수 없는 경우      |

```{r}
x <- NULL
is.null(x)
y <- c(1, 2, 3, NA, 5)
y
z <- 10/0
z
u <- 0/0
u
```

### 요인, factor

```{r}
gender <- c('남', '여', '남')
gender
gender.factor <- factor(gender)
gender.factor
```

### 배열과 행렬

```{r}
x <- c(70, 80, 95)
arr <- array(x)
arr
z <- 1:6
arr <- array(z, dim = c(2,3))
arr
name <- list(c("국어", "음악"), c("알라딘", "자스민", "지니"))
score <- c(70, 80, 85, 90, 90, 75)
arr <- array(score, dim = c(2,3), dimnames = name)
arr
arr[1,]
arr[, 2]
```

```{r}
name <- list(c("1행", "2행"), c("1열", "2열", "3열"))
x <- 1:6
mtx <- matrix(x, nrow = 2)
mtx
mtx <- matrix(x, nrow = 2, dimnames = name, byrow = T)
mtx
y <- c(7, 8, 9)
mtx <- rbind(mtx, y)
rownames(mtx)[3] <- "3행"
mtx
z <- c(10, 11, 12)
mtx <- cbind(mtx, 2)
colnames(mtx)[4] = "4열"
mtx
```

### 리스트

```{r}
x <- list("알라딘", 20, c(70, 80))
x
x[1]
x[[1]]
x <- list(성명 = "알라딘", 나이 = 20, 성적 = c(70, 80))
x
x[1]
x[[1]]
```

### 데이터 프레임

```{r}
df <- data.frame(성명 = c("알라딘", "자스민"), 나이 = c(20, 19), 국어 = c(70, 85))
df <- cbind(df, 음악 = c(85, 90))
df
df <- rbind(df, data.frame(성명 = "지니", 나이 = 30, 국어 = 90, 음악 75))
df
df[3, 2]
df[3,]
df[, 2]
df[-2,]
df[, -3]
```

```{r}
df <- data.frame(성명 = c("알라딘", "자스민"), 나이 = c(20, 19), 국어 = c(70, 85))
str(df)
```

> data.frame(stringsAsFactors = T), 문자형 데이터는 다 범주화 시켜버린다.

```{r}
df[1, 2] <- 21
df
df[1, 1] <- "Aladin"
```

- 현재 성명은 범주를 알라딘, 자스민 딱 2개로 갖는 factor여서 수정 불가.

```{r}
df <- data.frame(성명 = c("알라딘", "자스민"), 나이 = c(20, 19), 국어 = c(70, 85), stringsAsFactors = F)
str(df)
df[1, 1] <- "Aladin"
df
```

### 데이터 파일 읽기

```{r}
data(package = "datasets")
```

```{r}
quakes
head(quakes)
tail(quakes, n = 10)
names(quakes)
dim(quakes)
str(quakes)
```

```{r}
write.table(quakes, "c:/dump/quakes.csv", sep = ',')
df <- read.csv("c:/dump/quakes.csv", header = T)
df
```

### 함수

_반복적인 코딩 시간의 절약, 검증된 코드 사용으로 프로그래밍 효과 up_

```{r}
getTriangleArea <- function(x, h) {
  area <- w*h / 2
  return(area)
}
getTriangleArea(10, 5)
```