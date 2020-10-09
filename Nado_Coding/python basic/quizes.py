# 나도코딩, 파이썬 기초편 퀴즈 & 코딩 모음
# 모든 퀴즈가 도는 걸 방지하고자 다중 if-문으로 필요한 경우만 한 번 움직이도록 합니다.


class QuitTheSession(Exception):
    def __init__(self, number):
        self.number = str(number)

    def __str__(self):
        return self.number + "번을 종료합니다."


try:
    number = int(input("코드를 돌릴 퀴즈의 번호를 입력하세요: "))
    if number == 1:
        # 변수를 이용하여 다음 문장을 출력하시요
        # 변수명: station, 변수값: "사당", "신도림", "인천공항"
        # 출력 문장: XX행 열차가 들어오고 있습니다.

        for i in range(1, 4):
            station = input("역 이름을 입력하세요: ")
            print(station, "행 열차가 들어오고 있습니다.", sep="", end="\n\n")
    elif number == 2:
        # 당신은 최근에 코딩 스터디 모임을 새로 만들었습니다.
        # 월 4회 스터디를 하는데 3번은 온라인으로 하고 1번은 오프라인으로 하기로 했습니다.
        # 조건: 랜덤으로 날짜 뽑기, 월별 날짜는 다름을 감안하여 최소 일수인 28이내로,
        #       매월 1 ~ 3일은 스터디 준비로 제외
        # 출력 문장: 오프라인 스터디 모임 날짜는 매월 x일로 선정되었습니다.

        import random

        print(f"오프라인 스터디 모임 날짜는 매월 {random.randint(4, 28)}일로 선정되었습니다.")
    elif number == 21:
        import random

        print("오프라인 스터디 모임 날짜는", end=" ")
        for i in range(1, 13):
            x = random.randint(4, 28)
            print(f"'{i}월 {x}일", end=" ")
        print("로 선정되었습니다.")
    elif number == 3:
        # 사이트별로 비밀번호를 만들어주는 프로그램을 작성하세요.
        # 조건: http(s): // 제외, 처음 만나는 온점(.) 이후 부분을 제외
        #       남은 글자 중 처음 세자리 + 글자 갯수 + 글자 내'e' 갯수 + '!'으로 구성

        check = True
        while check:
            pattern = input("비밀번호를 만들고 싶은 사이트를 넣어주세요: ")
            possible = False
            if pattern.startswith("http://"):
                pattern = pattern.replace("http://", "")
                possible = True
            elif pattern.startswith("https://"):
                pattern = pattern.replace("https://", "")
                possible = True
            else:
                print("http(s)://가 없습니다.")
            if possible:
                array = pattern.split(".")[:-1]
                pattern = ""
                for i in array:
                    if len(pattern) == 0:
                        pattern = i
                    else:
                        pattern = pattern + "." + i
                print(f"생성된 비밀번호: {pattern[:3]}{len(pattern)}{pattern.count('e')}!")
            check = bool(input("다른 사이트를 입력하시겠습니까?: "))
    elif number == 4:
        # 당신의 학교에서 파이썬 코딩 대회를 주최합니다.
        # 참석률을 높이기 위해 댓글 이벤트를 진행하기로 했습니다.
        # 댓글 작성자들 중에 추첨을 통해 1명은 치킨, 3명은 커피 쿠폰을 받게 됩니다.
        # 추첨 프로그램을 작성하세요.
        # 조건: 편의상 댓글은 20명이 작성하였고, 아이디는 1 ~ 20으로 가정,
        #       댓글과 상관없이 무작위로 추첨하되 중복 불가,
        #       random 모듈의 shuffle과 sample을 활용
        # 출력 예제
        # -- 당첨자 발표 --
        # 치킨 당첨자 : 1
        # 커피 당첨자 : [2, 3, 4]
        # -- 축하합니다 --

        import random

        users = list(range(1, 21))
        # 원래라면 여기가 크롤링 및 댓글 확인이 되어야 했으나 해당 퀴즈는 그걸 신경쓰지 않는다.
        random.shuffle(users)
        first = random.sample(users, 1)[0]
        second = random.sample(users, 3)
        # 근데 random으로 뽑을 거면 굳이 shuffle이랑 sample을 같이 쓰는 이유가 없는데.
        while first in second:
            second = random.sample(users, 3)
        second.sort()
        print(f"-- 당첨자 발표 --\n치킨 당첨자: {first}\n커피 당첨자: {second}\n-- 축하합니다 --")
    elif number == 5:
        # 당신은 Cocoa 서비스를 이용하는 택시 기사님입니다.
        # 50명의 승객과 매칭 기회가 있을 때, 총 탑승 승객 수를 구하는 프로그램을 작성하세요.
        # 조건: 승객별 운행 소요 시간은 5 ~ 50분 사이의 난수, 소요 시간 5 ~ 15분 사이의 승객만 매칭.
        # 출력 예제
        # [0] 1번째 손님(소요시간: 15분)
        # ...
        # [0] 50번째 손님(소요시간: 16분)
        # 총 탑승 승객: 2 분

        import random

        total = 0
        for i in range(1, 51):
            time = random.randint(5, 50)
            if time <= 15:
                print("[0]", end=" ")
                total += 1
            else:
                print("[ ]", end=" ")
            print("%2d번째 손님 (소요시간 : %2d분)" % (i, time))
        print("총 탑승 승객 : {} 분".format(total))
    elif number == 6:
        # 표준 체중을 구하는 프로그램을 작성하세요.
        # 남자: 키(cm) ^ 2 * 22, 여자: 키(cm) ^ 2 * 21
        # 조건: 표준 체중은 별도의 함수 내에서 계산(함수명: std_weight, 전달값: height, gender),
        #       표준 체중은 소수점 둘째자리까지 표시
        # 출력 예제: 키 175cm 남자의 표준 체중은 67.38Kkg 입니다.

        def std_weight(height, gender):
            if gender == "남자" or gender == "남성" or gender == "남":
                print(
                    f"키 {height}cm 남자의 표준 체중은 {round(pow(height/100, 2)*22, 2)}kg 입니다."
                )
            elif gender == "여자" or gender == "여성" or gender == "여":
                print(
                    f"키 {height}cm 여자의 표준 체중은 {round(pow(height/100, 2)*21, 2)}kg 입니다."
                )
            else:
                print("성별을 알 수 없습니다.")

        check = True
        while check:
            print("BMI 프로그램입니다. 키(cm)와 성별을 입력해주세요.")
            height, gender = input("예) 175 남자: ").split(sep=" ")
            std_weight(int(height), gender)
            check = bool(input("다시 입력하시겠습니까? "))
    elif number == 7:
        # 당신의 회사에서는 매주 1회 작성해야 하는 보고서가 있습니다.
        # 1주차부터 50주차까지의 보고서 파일을 만드는 프로그램을 작성하세요.
        # 조건: 파일명: '1주차.txt', '2주차.txt', ...
        # 출력 예제(보고서는 항상 아래와 같은 형태로 출력되어야 합니다.)
        # - X 주차 주간보고 -
        # 부서:
        # 이름:
        # 업무 요약:
        check = input(f"{number}번은 50개의 업무 보고서를 만듭니다.\n실행하시려면 Yes를 입력해주세요: ")
        if check.lower() != "yes":
            raise QuitTheSession(number)
        else:
            for i in range(1, 51):
                name = str(i) + "주차.txt"
                with open(name, "w", encoding="utf8") as upmu:
                    upmu.write(f"- {i} 주차 주간보고 -\n부서 :\n이름 :\n업무 요약 :")
    elif number == 8:
        # 주어진 코드를 활용하여 부동산 프로그램을 작성하시오.
        # 출력 예제
        # 총 3대의 매물이 있습니다.
        # 강남 아파트 매매 10억 2010년
        # 마포 오피스텔 전세 5억 2007년
        # 송파 빌라 월세 500/50 2000년

        class House:
            # 매물 초기화
            def __init__(self, location, house_type, deal_type, price, completion_year):
                self.location = location
                self.house_type = house_type
                self.deal_type = deal_type
                self.price = price
                self.completion_year = completion_year

            # 매물 정보 표시, 나도 모르겠다.
            def show_detail(self):
                print(self.location, self.house_type, end="")
                print(self.deal_type, self.price, f"{self.completion_year}년")

        print("총 3대의 매물이 있습니다.")
        House("강남", "아파트", "매매", "10억", 2010).show_detail()
        House("마포", "오피스텔", "전세", "5억", 20007).show_detail()
        House("송파", "빌라", "월세", "500/50", 2000).show_detail()
        # 값이 3개보다 많아지면 당연히 for문을 이용하는 게 낫다.
    elif number == 9:
        # 동네에 항상 대기 손님이 있는 맛있는 치킨집이 있습니다.
        # 대기 손님의 치킨 요리 시간을 줄이고자 자동 주문 시스템을 구축하려 합니다.
        # 시스템 코드를 확인하고 적절한 예외처리 구문을 넣으시오.
        # 조건: 1보다 작거나 숫자가 아닌 입력값이 들어올 때는 타입에러로 처리, 대기 손님이 주문할 수 있는 치킨량은 10마리,
        #       치킨 소진 시 사용자 정의 에러[SoldOutError]를 발생시키고("재고가 소진되어 더 이상 주문을 받지 않습니다.") 프로그램 종료

        class SoldOutError(Exception):
            pass

        chicken = 10
        waiting = 1  # 현재 만석, 대기번호 1부터 시작
        while True:  # 무한 루프는 언제나 조심 또 조심
            try:
                if chicken <= 0:
                    raise SoldOutError

                print(f"[남은 치킨: {chicken}]")
                order = int(input("치킨 몇 마리 주문하시겠습니까? "))
                if order > chicken:
                    print("재료가 부족합니다.")
                elif order < 1:
                    raise ValueError
                else:
                    print(f"[대기번호 {waiting}] {order}마리 주문이 완료되었습니다.")
                    waiting += 1
                    chicken -= order
            except ValueError:
                print("입력값이 잘못되었습니다.")
            except SoldOutError:
                print("재고가 소진되어 더 이상 주문을 받지 않습니다.")
                break
            except:
                print("알 수 없는 에러가 발생했습니다.")
    elif number == 101:
        check = int(input("몇 번을 돌리시겠습니까? (1 ~ 4): "))
        if check == 1 or check == 4:
            import theater_module

            theater_module.price(3)
            theater_module.price_morning(4)
            theater_module.price_solider(5)
        if check == 2 or check == 4:
            import theater_module as mv

            mv.price(3)
            mv.price_morning(4)
            mv.price_solider(5)
        if check == 3 or check == 4:
            from theater_module import *

            price(3)
            price_morning(4)
            price_solider(5)
    elif number == 102:
        import travel.thailand

        trip_to = travel.thailand.ThailandPackage()
        trip_to.detail()
        from travel import vietnam

        trip_to = vietnam.VietnamPackage()
        trip_to.detail()
    elif number == 103:
        import os

        print(os.getcwd())  # 현재 directory

        folder = "sample_dir"
        if os.path.exists(folder):
            print("이미 존재하는 폴더입니다.")
            os.rmdir(folder)
            print(folder, "폴더를 삭제하였습니다.")
        else:
            check = input(f"{number}번은 sample_dir 폴더를 만듭니다.\n실행하시려면 Yes를 입력해주세요: ")
            if check.lower() != "yes":
                raise QuitTheSession(number)
            else:
                os.makedirs("folder")
                print(folder, "폴더를 생성하였습니다.")
except ValueError:
    print("입력이 잘못되었습니다.")
except QuitTheSession as qts:
    print(qts)
finally:
    print("세션을 종료합니다.")
