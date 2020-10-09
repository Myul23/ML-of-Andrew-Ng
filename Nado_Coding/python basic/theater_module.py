# __pycache__에 현재 module에 대한 파일이 생긴다. 말 그래도 cache 역할을 하는 것으로 보인다.
# 일반 가격
def price(people):
    print(f"{people}명 가격은 {people * 10000}원입니다.")


# 조조할인 가격
def price_morning(people):
    print(f"{people}명 조조 할인 가격은 {people * 6000}원입니다.")


# 군인 할인 가격
def price_solider(people):
    print(f"{people}명 군인 할인 가격은 {people * 4000}원입니다.")
