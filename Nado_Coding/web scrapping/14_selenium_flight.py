# 과연 이걸 실행시킬 것인가.
reply = input("해당 파일은 selenium 활용편입니다. 프로그램을 실행하시겠습니까?\n")
reply = reply.lower()
if reply is "yes" or reply is "well": pass
else: quit()

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

browser = webdriver.Edge()
browser.maximize_window()  # 창 최대화

url = "https://flight.naver.com/flights/"
browser.get(url)

# 여행 날짜 선택하기
browser.find_element_by_link_text("가는날 선택").click()
# 현재 달 27, 28일 선택
# browser.find_element_by_link_text("27")[0].click()
# browser.find_element_by_link_text("28")[0].click()
# 다음달 27일 선택
# browser.find_element_by_link_text("27")[1].click()
browser.find_element_by_link_text("27")[0].click()
browser.find_element_by_link_text("28")[1].click()

# 여행 장소 선택하기
browser.find_element_by_xpath("//*[@id='recommendationList']/ul/li[1]").click()
# 항공권 검색
browser.find_element_by_link_text("항공권 검색").click()

# 로딩 화면 처리
# 첫번쨰 일정 시간만 기다리기
# 두번째 원하는 게 나올 때까지만 기다리기
try:
    elem = WebDriverWait(browser, 10).until(
        EC.presence_of_element_located(
            By.XPATH, "//*[@id='content']/div[2]/div/div[4]/ul/li[1]"))
    print(elem.text)
# 최대 10를 기다릴 건데, 조건 링크가 연결되면 당장 실시
finally:
    browser.quit()
