# 나도코딩, web-scrapping을 위한 발걸음

# Requests
import requests
from bs4 import BeautifulSoup
import re
import csv

# header에 대한 정보가 없어 열리지 않는 페이지를 위해 header도 같이 넘긴다.
# google, User Agent String, Whit is my User Agent?
headers = {
    "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.68"
}

for i in range(1, 6):
    url = f"https://nadocoding.tistory.com.공부하자고_추가한_것들_page={i}"

    # res = requests.get(url)
    res = requests.get(url, headers=headers)
    # print("응답코드:", res.status_code)
    # 200: 정상적으로 받아와졌다.
    # 403: 접근 권한이 없다. etc.

    # 이런 식으로도 할 수 있고.
    # if res.status_code is requests.codes.ok:
    #     print("정상입니다.")
    # else:
    #     print("문제가 생겼습니다, [에러코드 ", res.status_code, "]", sep="")

    # 함수로 반환된 코드의 유효성 검사를 할 수도 있다.
    res.raise_for_status()
    # print("웹 스크래핑을 진행합니다.")

    # 일단 내부 맛보기
    # print(len(res.text))
    # print(res.text)
    # 당연하게도 다 오기 때문에 내용이 많습니다.
    # with open("mygoogle.html", "w", encoding="utf8") as f:
    #     f.write(res.text)

    # Parsing
    soup = BeautifulSoup(res.text, "lxml")
    # print(soup.title)
    # print(soup.title.get_text())
    # 배웠듯이 해당 element에서 가장 처음 값을 반한합니다.
    # print(soup.a)
    # print(soup.a.attrs)
    # print(soup.a["href"])  # 특정 속성 값 가져오기

    # print(soup.find("a", attrs={"class": "Nbtn_upload"}))
    # print(soup.find(attrs={"class": "Nbtn_upload"}))  # class지만, id 같이 하나뿐이라 가능.
    # print(soup.find("li", attrs={"class": "rank01"}))

    # rank1 = soup.find("li", attrs={"class": "rank01"})
    # nextElementSibling으로 안해서 그런 거.
    # rank2 = rank1.next_sibling.next_sibling
    # rank3 = rank2.next_sibling.next_sibling
    # rank3.previous_sibling.previous_sibling  # = rank2
    # print(rank1.parent)
    # print(rank1.child)

    # rank1.find_next_sibling("li")  # 형제 중에서 li-tag(element) 찾기
    # rank1.find_next_siblings("li")  # 리스트로 가져오기

    # 타 만화 사이트
    cartoons = soup.find_all("td", attrs={"class": "title"})
    # for cartoon in cartoons:
    #     print(cartoon.get_text())

    # 만화 제목과 링크 가져오기
    # for cartoon in cartoons:
    #     title = cartoon.get_text()
    #     link = "https://comic.naver.com" + cartoon.a["href"]

    # 평점 가져오기
    cartoons = soup.find_all("div", attrs={"class": "rating_type"})
    sum = 0
    for cartoon in cartoons:
        rate = cartoon.find("strong").get_text()
        sum += float(rate)
    print("total", sum, "mean", sum / len(cartoons))

    # 정규식
    # p = re.complie("ca.e")
    # . : 하나의 문제 대체
    # ^ : 문자열의 시작   ("^de")
    # $ : 문자열의 끝     ("se$")

    # def print_match(m):
    #     if m:
    #         print(m.group())  # 일치하는 문자열을 반환하므로, 매치되지 않으면 에러를 발생시킨다.
    #         print(m.string)  # 입력한 문자열 반환
    #         print(m.start())  # 매치된 문자열의 시작 index
    #         print(m.end())  # 매치된 문자열의 마지막 index
    #         print(m.span())  # 매치된 문자열의 시작과 끝 index
    #     else:
    #         print("메칭되지 않았습니다.")

    # m = p.match("careless")  # 주어진 문자열이 처음부터 일치하는지 확인.
    # print_match(m)

    # m = p.search("good care")  # 주어진 문자열 중에 일치하는 게 있는지 확인.
    # print_match(m)

    # mylist = p.find_all("careless")  # 매치되는 모든 것을 반환 (리스트)

    # 타 쇼핑 사이트
    items = soup.find_all("li", attrs={"class": re.compile("^search-product")})
    # print(items[0].find("div", attrs={"class": "name"}).get_text())
    for item in items:
        # 광고 상품 제외
        ad_badge = item.find("span", attrs={"class": "ad-badge-text"})
        if ad_badge: continue

        name = item.find("div", attrs={"class": "name"}).get_text()
        # 애플 상품 제외
        if "Apple" in name: continue
        price = item.find("strong", atrrs={"class": "price-value"}).get_text()

        rate = item.find("em", atrrs={"class": "rating"})
        if rate: rate = rate.get_text()
        else: continue
        rate_cnt = item.find("span", atrrs={"class": "rating-totla-count"})
        if rate_cnt:
            rate_cnt = rate_cnt.get_text()
            rate_cnt = rate_cnt[1:-1]
        else:
            continue

        # 평점 4.5 이상, 리뷰수 70개 이상
        if float(rate) >= 4.5 and int(rate_cnt) >= 70:
            print(name, price, rate, rate_cnt)

# rank5까지의 영화 이미지 가져와 저장하기
images = soup.find_all("img", attrs={"class": "thub_img"})
for idx, image in enumerate(images):
    if idx >= 5: break

    image_url = image["src"]
    if image_url.startswitch("//"):
        image_url = "https:" + image_url

    image_res = requests.get(image_url)
    image_res.raise_for_status()

    with open("movie{}.jpg".format(idx + 1), "wb") as f:
        f.write(image_res.content)

# csv로 가공하기

filename = "file_name"
f = open(filename, "w", encoding="utf8", newline="")
# csv 파일로 변환시켰을 때 한글이 깨진다면 utf-8-sig을 이용할 것.
writer = csv.writer(f)

title = "만약에 열 이름들을 긴 string으로 받아왔다면".split(" ")
writer.writerow(title)  # 리스트 형태일 것.
# 타이틀을 먼저 파일로 집어넣는 것일 뿐이다.

for page in range(1, 5):
    res = requests.get(url + str(page))
    res.raise_for_status()
    soup = BeautifulSoup(res.text, "lxml")

    data_rows = soup.find("table", attrs={
        "class": "type_2"
    }).find("tbody").find_all("tr")
    for row in data_rows:
        columns = row.find_all("td")
        if len(columns) <= 1: continue
        data = [column.get_text().strip() for column in columns]
        writer.writerow(data)
