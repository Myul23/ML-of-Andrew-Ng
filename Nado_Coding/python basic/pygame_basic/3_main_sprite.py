import pygame

pygame.init()                                   # 초기화 작업

screen_width = 480                              # 가로 크기
screen_height = 640                             # 세로 크기
screen = pygame.display.set_mode((screen_width, screen_height))

# 화면 타이틀 설정
pygame.display.set_caption("Myul")              # 게임 이름

# 배경 이미지 불러오기, 상대 주소가 되지 않더라.
background = pygame.image.load("C:\\Github Projects\\programming\\Python\\example\\pygame_basic\\background.png")

# 캐릭터 스프라이트 불러오기
character = pygame.image.load("C:\\Github Projects\\programming\\Python\\example\\pygame_basic\\character.png")
character_size = character.get_rect().size      # 캐릭터의 전체 범위를 네모로 인식하는데 이때의 크기를 반환한다.
character_width = character_size[0]
character_height = character_size[1]
character_x_pos = (screen_width - character_width) / 2
character_y_pos = screen_height - character_height

# 현재 아무 것도 실행하는 것이 없어 창을 종료한다.
# pygame에선 이벤트 roof가 돌아가야 (즉, 실행 중인 함수가 있어야) 창을 유지한다.

# 이벤트 루프
running = True                                  # 게임이 진행 중인가?
while running:
    for event in pygame.event.get():            # pygame에서 이벤트 루프 필수 코드, 어떤 이벤트가 발생하였는지 체크
        if event.type == pygame.QUIT:           # pygame.QUIT에 대한 이벤트가 생기면 프로그램을 종료합니다. 대체로 창 종료 버튼에 의한 이벤트다.
            running = False

    # screen.fill((0, 0, 255))                  # 배경 색으로 채우기
    screen.blit(background, (0, 0))             # 이미지를 해당 위치에 그립니다 당연히 왼쪽, 위 값 기준
    screen.blit(character, (character_x_pos, character_y_pos))

    pygame.display.update()                     # 바뀐 그림을 진짜로 반영합니다.

# pygame 종료
pygame.quit()
