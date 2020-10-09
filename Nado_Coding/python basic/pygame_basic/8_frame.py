import pygame                               # pygame 뼈대
#######################################

# 0. 기본 필수 초기화
pygame.init()                               # 초기화 작업

screen_width = 480                          # 가로 크기
screen_height = 640                         # 세로 크기
screen = pygame.display.set_mode((screen_width, screen_height))

# 화면 타이틀 설정
pygame.display.set_caption("GAME_NAME")     # 게임 이름

# FPS (Frame Per Second)
clock = pygame.time.Clock()

#######################################

# 1. 사용자 게임 초기화 (배경화면, 게임 이미지, 좌표, 속도, 폰트 등)

# 이벤트 루프
running = True                              # 게임이 진행 중인가?
while running:
    delta = clock.tick(60)                  # 게임 화면의 초당 프레임 수 설정, 1초 동안 얼마나 동작할 것인가. 대체로 30 or 60

    # 2. 이벤트 처리 (키보드, 마우스 등)
    for event in pygame.event.get():        # pygame에서 이벤트 루프 필수 코드, 어떤 이벤트가 발생하였는지 체크
        if event.type == pygame.QUIT:       # pygame.QUIT에 대한 이벤트가 생기면 프로그램을 종료합니다. 대체로 창 종료 버튼에 의한 이벤트다.
            running = False

    # 3. 게임 캐릭터 위치 정의

    # 4. (이미지 위치 업데이트 및) 충돌 처리

    # 5. 화면에 그리기

    pygame.display.update()                 # 바뀐 그림을 진짜로 반영합니다.

# pygame 종료
pygame.quit()
