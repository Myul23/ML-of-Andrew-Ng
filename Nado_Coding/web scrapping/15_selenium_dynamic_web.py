# 과연 이걸 실행시킬 것인가.
reply = input("해당 파일은 selenium 활용편입니다. 프로그램을 실행하시겠습니까?\n")
reply = reply.lower()
if reply is "yes" or reply is "well": pass
else: quit()

# 더 자세히 selenium에 대해 알고 싶다면, google, Selenium with Python

# Google Movie
from selenium import webdriver
import requests
from bs4 import BeautifulSoup
import time

# 굳이 web으로의 작동을 볼 필요가 없다면 headless를 사용한다.
# Edge가 Chrome이랑 호환되는 건 알고 있었지만, 그렇다고 EdgeOptions을 안 만들었을 줄이야.
# options = webdriver.ChromeOptions()
# options.headless = True
# options.add_argument("window-size=1920x1080")
# options.add_argument(
#     "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.68"
# )
# browser = webdriver.Edge(options=options)
browser = webdriver.Edge()
browser.maximize_window()

url = "https://play.google.com/store/movies/top"
browser.get(url)

# 강제로 js 실행시키기, 지정한 위치로 스크롤 내리기
# browser.execute_script("window.scrollTo(0, 1080)")

interval = 2
prev_height = browser.execute_script("return document.body.scrollHeight")
while True:
    browser.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    time.sleep(interval)
    curr_height = browser.execute_script("return document.body.scrollHeight")

    if curr_height is prev_height:
        break
    prev_height = curr_height

browser.get_screenshot_as_file("google_movie.jpg")
soup = BeautifulSoup(browser.page_source, "lxml")

# "class": ["ImZGtf mpg5gc", "Vpfmgd"]
# 10개 이후의 영화는 다른 태그로 감싸져 있어서 리스트 형태로 추가된 것입니다.
movies = soup.find_all("div", attrs={"class": "Vpfmgd"})
for movie in movies:
    title = movie.find("div", attrs={"class": "WsMGlc nnK0zc"}).get_text()

    original_price = movie.find("span", attrs={"class": "SUZt4c djCuy"})
    if original_price:
        original_price = original_price.get_text()

    price = movie.find("span", attrs={"class": "VfPnfd ZdBevf i5DZme"})
    if price:
        price = price.get_text()

    link = "https://play.google.com" + movie.find(
        "a", attrs={"class": "JC7lub"})["href"]

browser.quit()