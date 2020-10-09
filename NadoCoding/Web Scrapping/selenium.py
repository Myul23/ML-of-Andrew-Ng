# internet, edge://version: 85.0.564.68
# edgedriver, WebDriver
# workspace에서 압축풀기

# 아래 작업은 interpret 언어 특성상 terminal에 줄마다 입력하면서
# 코드 하나하나 실행시키며 어떻게 움직이는지 볼 수 있다.
from selenium import webdriver
browser = webdriver.Edge("./msedgedriver.exe")
browser.get("https://naver.com")
# edge browser을 이용해 자동으로 열고, naver로 이동한다.

# 특정 element 접근하기
elem = browser.find_element_by_class_name("link_login")
elem.click()

browser.back()
# brower.forward()
# brower.refresh()
elem = browser.find_elemet_by_id("query")

# query에 값을 입력해 검색하기 위한 module
from selenium.webdriver.common.keys import Keys
elem.send_keys("인공지능")
elem.send_keys(Keys.ENTER)

elem = browser.find_elements_by_tag_name("a")
for e in elem:
    e.get_attribute("href")

browser.get("https://daum.net")
elem = browser.find_element_by_name("q")
elem.send_keys("인공지능")
# elem.send_keys(Keys.ENTER)
browser.find_element_by_xpath("button-XPath").click()

browser.close()  # 현재 보고 있는 창만 닫기
browser.quit()  # 모든 창 닫기

# 네이버 로그인
elem = browser.find_element_by_class_name("link_login")
elem.click()

browser.find_element_by_id("id").send_keys("naver_id")
browser.find_element_by_id("pw").send_keys("password")
browser.find_element_by_id("log.login").click()

# 네이버에 경우, 로그인 실패 이후에 보안을 위해 Web이 변화하면서 불러오는데 시간이 걸린다.
# 이때 web에 다른 요청을 할 경우, 당연하게도 실행되지 않는다.
# 이 때문에 대체로 improt time + time.sleep(3)로 3정도의 시간을 보내게 한다.
browser.find_element_by_id("id").clear()  # 선택된 element에 입력된 값 지우기

print(browser.page_source)

# browser.close()
browser.quit()