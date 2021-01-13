# Chapter 7. 합성곱 신경망(CNN)
# 이어서 7장 합성곱 신경망에 대한 내용입니다.
# CNN은 Convolutional Neural Network의 줄임말로 이미지 인식 분야에서 굉장히 자주 등장하는 기법입니다.

# 7.1 전체 구조
# 지금까지의 신경망은 인접하는 계층의 모든 뉴런과 결합되어 있었음.
# 다시 말하자면 작더라도 모든 뉴런의 영향을 받았음.
# 이를 완전연결이라고 하고 Affine 계층을 통해 구성했음.
# CNN에는 Affine 대신에 합성곱 계층이 Activation 계층 뒤에 풀링 계층이 새롭게 도입됨.

# 7.2 합성곱 계층
# CNN은 각 계층 사이에 3차원 데이터같이 입체적인 데이터가 흐른다는 점에서 완전연결 신경망과 다름.

# 7.2.1 완전연결 계층의 문제점
# 다차원 데이터에 경우 데이터의 위치도 중요한 특징이 됨.
# 3차원 이미지 데이터를 생각해보면, 선이 그려진 그림은 주변의 같은 픽셀값을 갖는 것이 있을 것임
# 그러나 완전연결 계층은 이런 데이터의 위치 정보 값이 무시됨.
# 데이터를 1차원으로 flatten시키면서 위치 정보를 잃어버림.
# 완전연결 계층은 형상을 무시하고 모든 입력 데이터를 동등한 뉴런(같은 차원의 뉴런)으로 취급하여 형상에 담긴 정보를 살릴 수 없습니다.

# 특징 맵(feature map): CNN에서 합성곱 계층의 입출력 데이터를 부르는 말 (입력 특징 맵, 출력 특징 맵)

# 7.2.2 합성곱 연산
# 이미지 처리의 필터 연산
# 필터는 커널이라 칭해지기도 함. 필터는 한 합성곱 연산 계층에서 필터 집합을 의미
# 윈도우는 이번에 필터와 곱해질 입력 데이터의 (형)상을 의미
# 각 단일 곱셈-누산을 통해 출력 특징 맵의 원소를 구성하게 됨.

# 여기서 필터는 지금까지의 가중치와 같고, 편향 또한 마치 행렬 스칼라 덧셈처럼 연산할 수 있음.

# 합성곱 연산은 필터를 통해 커다란 양의 데이터를 출력할 수 있음은 말하지 않음.

# 7.2.3 패딩
# 말 그대로 두르는 거
# 합성곱을 수행하기 전에 입력 데이터 주변을 특정 값으로 채우기도 함. -> 패딩
# 패딩을 통해 출력 데이터의 형상이 입력 데이터의 형상과 달라지는(작아지는) 것을 막을 수 있다.

# 7.2.4 스트라이드
# 스트라이드는 합성곱에서 윈도우가 움직이는 칸의 수
# 다시 말해 이전 윈도우와 다음 윈도우의 거리(칸) 차이

# 앞선 패딩과 스트라이드를 이용했을 떄 입력 데이터의 형상이 어떤 크기로 출력 데이터의 형상이 되는지 수식화하면
# 출력 height = ((입력 height) + 2 * padding - (filter height))/stride + 1
# 출력 width = ((입력 width) + 2 * padding - (filter width))/stride + 1
# 다차원의 형상을 구성하는 것이기 때문에 모든 값은 양수여야 한다.

# 7.2.5 3차원 데이터의 합성곱 연산
# 흑백이 아닌 이미지에 대해선 각 채널마다 필터를 갖고 같은 위치의 값을 더해서 출력으로 넘김.
# 입력 데이터의 채널 수와 필터의 채널 수가 같아야 한다.

# 7.2.6 블록으로 생각하기
# 7.2.7 배치 처리 -> 그냥 배치 처리를 하면 한 번에 N개를 연산시켜야 한다고.
