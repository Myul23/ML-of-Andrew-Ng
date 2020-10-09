import random

# 일반 유닛
class Unit:
    def __init__(self, name, hp, speed):
        self.name = name
        self.hp = hp
        self.speed = speed
        print(f"{self.name} 유닛이 생성되었습니다.")

    def move(self, location):
        print(f"{self.name} : {location} 방향으로 이동합니다. [속도 {self.speed}]")

    def damaged(self, damage):
        print(f"{self.name} : {damage} 데미지를 입었습니다.")
        self.hp -= damage
        print(f"{self.name} : 현재 체력은 {self.hp} 입니다.")
        if self.hp <= 0:
            print(f"{self.name} : 파괴되었습니다.")


# 공격 유닛
class AttackUnit(Unit):
    def __init__(self, name, hp, speed, damage):
        super().__init__(name, hp, speed)
        self.damage = damage

    def attack(self, location):
        print(f"{self.name} : {location} 방향으로 적군을 공격합니다. [공격력 : {self.damage}]")


# 마린
class Marine(AttackUnit):
    def __init__(self):
        AttackUnit.__init__(self, "마린", 40, 1, 5)

    # 스팀팩 : 일정 시간 동안 이동 및 공격 속도를 증가, 체력 10 감소
    def stimpack(self):
        if self.hp > 10:
            print(f"{self.name} : 스팀팩을 사용합니다. (HP 10 감소)")
            self.hp -= 10
        else:
            print(f"{self.name} : 체력이 부족하여 스팀팩을 사용하지 않습니다.")


# 탱크
class Tank(AttackUnit):
    # 시즈 모드: 탱크를 지상에 고정시켜 더 높은 파워로 공격.
    seize_developed = False

    def __init__(self):
        AttackUnit.__init__(self, "탱크", 150, 1, 35)
        self.seize_mode = False

    def set_seize_mode(self):
        if not Tank.seize_developed:
            return

        if not self.seize_mode:
            print(f"{self.name} : 시즈 모드로 전환합니다.")
            self.damage *= 2
            self.seize_mode = True
        else:
            print(f"{self.name} : 시즈 모르를 해제합니다.")
            self.damage /= 2
            self.seize_mode = False


# 공중 유닛
class Flyable:
    def __init__(self, flying_speed):
        self.flying_speed = flying_speed

    def fly(self, name, location):
        print(f"{name} : {location} 방향으로 날아갑니다. [속도 {self.flying_speed}]")


# 공중 공격 유닛
class FlyableAttackUnit(AttackUnit, Flyable):
    def __init__(self, name, hp, damage, flying_speed):
        AttackUnit.__init__(self, name, hp, 0, damage)
        Flyable.__init__(self, flying_speed)

    def move(self, location):
        self.fly(self.name, location)


# 레이스
class Wraith(FlyableAttackUnit):
    def __init__(self):
        super().__init__("레이스", 80, 20, 5)
        self.clocked = False

    def clocking(self):
        if not self.clocked:
            print(f"{self.name} : 클로킹 모드로 전환합니다.")
            self.clocked = True
        else:
            print(f"{self.name} : 클로킹 모드를 해제합니다.")
            self.clocked = False


def game_start():
    print("[System] 새로운 게임을 시작합니다.")


def game_over():
    print("Player : gg\n[Plqyer]님이 게임에서 퇴장하였습니다.")


# 실제 게임 진행
game_start()

m1 = Marine()
m2 = Marine()
m3 = Marine()
t1 = Tank()
t2 = Tank()
w1 = Wraith()

attack_units = [m1, m2, m3, t1, t2, w1]
direction = "1시"

# 전군 이동
for unit in attack_units:
    unit.move(direction)

# 탱크 시즈 모드 개발
Tank.seize_developed = True
print("[System] 탱크 시즈 모드 개발이 완료되었습니다.")

# 공격 모드 준비 (마린: 스팀팩, 탱크: 시즈 모드, 레이스: 클로킹)
for unit in attack_units:
    if isinstance(unit, Marine):
        unit.stimpack()
    elif isinstance(unit, Tank):
        unit.set_seize_mode()
    elif isinstance(unit, Wraith):
        unit.clocking()

# 전군 공격
for unit in attack_units:
    unit.attack(direction)

# 전군 피해
for unit in attack_units:
    unit.damaged(random.randint(5, 20))
    # 공격은 랜덤으로 5 ~ 20 받음

game_over()
