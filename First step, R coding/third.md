빅데이터 분석의 첫걸음 R코딩
================

  - Author: 장용식, 최진호
  - Book: <https://book.naver.com/bookdb/book_detail.nhn?bid=16324211>
  - coding은 example들을 제외하고는 programming으로 넘겼습니다.

-----

## 7\. 지도 활용하기

> 구글맵은 구글이 개발한 데스크탑 웹매핑 서비스로서, 구글맵 API를 통해 위성 사진, 지도 Street View, Google
> Traffic, 두 지점 간의 최적 경로 등의 다양한 서비스를 제공한다.

  - 이외에도 데이터 시각화 전문회사, Stamen의 Stamen Maps나 네이버, 다음의 지도를 이용할 수도 있다.

> API (Application Programming Interface) 특정 기능 서비스를 위한 인터페이스

  - Google map API는 1년 무료, Google Cloud API: <https://cloud.google.com/>
  - Naver Cloud API: <https://www.ncloud.com>

### 구글맵 출력

  - Google Cloud API가 1년 무료라서 실행은 시키지 않는다.

<!-- end list -->

``` r
## install.packages("ggmap")
library(ggmap)
register_google(key = "AI...")  ## Google Map API
```

``` r
map <- get_googlemap(center = c(126.975684, 37.572752)) # 세종문화회관
ggmap(map)
```

> getcode(enc2utf8(location)): 한글 지역명인 경우 utf8 형식으로 바꿔야 한다. (반환: 경도, 위도)

  - 세종문화회관을 중심으로 지도가 뜬다.

> get\_googlemap(center, maptype = “terrain”, zoom = 10, size = c(X, Y),
> marker)<br />- maptype: “terrain”(default, 지형정보 기반 지도), “satellite”(위성
> 지도), “roadmap”(도로명 표시), “hybrid”(위성과 도로명)<br />- marker: 현재 지점을 나타낼 때
> 나오는 그것.

> ggmap(extent)<br />- extent: “panel”(default, 축 정보 다 포함), “normal”,
> “device”(여백 없음, 축 정보 없음)

#### 단양팔경을 지도 위에

|     지명      | 주소                                    |
| :-----------: | --------------------------------------- |
| 도담삼봉/석문 | 충청북도 단양군 매포읍 삼봉로 644-33    |
| 구담봉/옥순봉 | 충청북도 단양군 단성면 월악로 3827      |
|    사인암     | 충청북도 단양군 대강면 사인암2길 42     |
|    하선암     | 충청북도 단양군 단성면 선암계곡로 1337  |
|    중선암     | 충청북도 단양군 단성면 선암계곡로 868-2 |
|    상선암     | 충청북도 단양군 단성면 선암계곡로 790   |

``` r
library(ggplot2)
register_google(key = "AI...")  ## Google Map API

names <- c("도담삼봉/석문", "구담/옥순봉", "사인암", "하선암", "중선암", "상선암")
addr <- c("충청북도 단양군 매포읍 삼봉로 644-33", "충청북도 단양군 단성면 월악로 3827",
          "충청북도 단양군 대강면 사인암2길 42", "충청북도 단양군 단성면 선암계곡로 1337",
          "충청북도 단양군 단성면 선암계곡로 868-2", "충청북도 단양군 단성면 선암계곡로 790")

gc <- geocode(enc2utf8(addr))
df <- data.frame(name = names, lon = gc$lon, lat = gc$lat)
cen <- c((max(df$lon) + min(df$lon))/2, (max(df$lat) + min(df$lat))/2)

map <- get_googlemap(center = cen, maptype = "roadmap", zoom = 12, marker = gc)
ggmap(map) +
  geom_text(data = df, aes(x = lon, y = lat), size = 5, label = df$name)
```

#### 지진 발생 지역 분포

  - 국내 지진 정보는 기상청 날씨누리 -\> 지진, 화산 -\> 발생기간 입력을 통해 엑셀 파일로 얻을 수 있지만,
    Google Map API를 이유로 실행 안 하고 넘어갑니다.

<!-- end list -->

``` r
## install.packages("openxlsx")
library(ggmap)
library(ggplot2)
library(openxlsx)

register_google(key = "AI...")  ## Google Map API
df <- read.xlsx(file.choose(), sheet = 1, starRow = 4)
```

> file.choose(): 파일 시스템을 열어 직접 파일을 선택한다.

``` r
head(df)
tail(df)
```

``` r
df[, 5] <- gsub(" N", "", df[, 5])
df[, 6] <- gsub(" E", "", df[, 6])
df2 <- data.frame(lon = df[, 6], lat = df[, 5], mag = df[, 3])
str(df2)
```

어째 숫자가 string으로 읽혔는지 다 factor가 됐더라고

``` r
df2[, 1] = as.numeric(as.character(df2[, 1]))
df2[, 2] = as.numeric(as.character(df2[, 2]))
df2[, 3] = as.numeric(as.character(df2[, 3]))
str(df2)
```

``` r
## attach(df2)
cen <- c((max(df2$lon) + min(df2$lon))/2, (max(df2$lat) + min(df2$lat))/2)
```

``` r
map <- get_googlemap(center = cen, zoom = 6)
ggmap(map) +
  geom_point(data = df2, aes(x = lon, y = lat), color = "red", size = df2$mag, alpha = 0.5)
```

### 연습용 project

(한국환경공단) 미세먼지 or 초미세먼지 분포

``` r
## install.packages("openxlsx")
library(ggmap)
library(ggplot2)
library(openxlsx)

register_google(key = "AI...")  ## Google Map API
df <- read.xlsx(file.choose(), sheet = 1)
```

``` r
df2 <- data.frame(lon = df[, 6], lat = df[, 5], mag = df[, 3])
cen <- c((max(df2$lon) + min(df2$lon))/2, (max(df2$lat) + min(df2$lat))/2)
```

``` r
map <- get_googlemap(center = cen, zoom = 6)
ggmap(map) +
  geom_point(data = df2, aes(x = lon, y = lat), color = c("lightblue", "orange"),
             size = c(df2$PM10, df2$PM25), alpha = 0.5)
```

  - 흠 이렇게 하면 한 그림으로 나오겠지?

-----

## 8\. Web scraping

|          용어 정리          | description                                                              |
| :-------------------------: | ------------------------------------------------------------------------ |
|   웹크롤링 (Web crawling)   | 주로 포털 등에서 자동으로 웹 사이트의 링크 정보를 수집하여 저장하는 기술 |
| 웹 스크래핑 (Web scraping)  | 웹 사이트로부터 웹문서를 다운로드 받아 필요한 정보를 추출하는 기술       |
| 텍스트 마이닝 (Text mining) | 비정형 텍스트 데이터에서 정보를 찾아내는 기술                            |

  - DOM (Document Object Model)은 트리 구조로 이루어져 있으며, 어떤 데이터를 스크래핑할 건지 확실하게
    정해야 한다. 그렇지 않으면 엄청난 양의 필요없는 데이터가 딸려올 수 있어 전처리 과정에서 곤욕을 치를 수 있다.

<!-- end list -->

``` r
## install.packages("rvest")
library(rvest)
```

#### 1\. 웹문서 전체 인식

``` r
url <- "https://www.data.go.kr/tcs/dss/selectDataSetList.do"
html <- read_html(url)
html
```

    ## {html_document}
    ## <html lang="ko">
    ## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
    ## [2] <body>\r\n\t\t<div class="skip">\r\n\t\t\t<a href="#gnb" tabindex="0">주 메 ...

#### 2\. 웹문서에서 가져오고자 하는 데이터 추출

  - \[@id="apiDataList"\]/div\[2\]/ul/li\[2\]/dl/dt/a/span\[2\]

<!-- end list -->

``` r
title <- html_nodes(html, "#apiDataList") %>%
         html_nodes("ul") %>% html_nodes("a") %>%
         html_nodes("span.title") %>% html_text()
title
```

    ## [1] "\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t농촌진흥청_스마트팜 우수농가 공개용 데이터\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t"
    ## [2] "\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t한국지역난방공사 열판매량 정보\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t"            
    ## [3] "\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t대전광역시도시철도공사 열차시각표\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t"         
    ## [4] "\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t국민연금공단_국민연금 가입 사업장 내역\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t"    
    ## [5] "\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\t\t예금보험공사 발간도서 목록\r\n\t\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t"

``` r
desc <- html_nodes(html, "#contents") %>%
        html_nodes("#apiDataList") %>%
        html_nodes(".result-list") %>%
        html_nodes(".ellipsis") %>% html_text()
desc
```

    ## [1] "농촌진흥청 스마트팜 우수농가에 대한 공개용 데이터셋을 (온실환경, 작물생육, 생산량)을 제공합니다. "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    ## [2] "지역난방공사 전사 열판매 정보 "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    ## [3] "역별 열차운행 시각표를 보여주는 서비스 "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    ## [4] "(국민연금가입수급정보) 법정동단위 지역별, 국민연금 가입 사업장 정보<br/>* 단, 개인사업장 및 2인 이하 법인 사업장 정보 미제공<br/><br/>*사업장 컬럼별 상세설명<br/>○ 자료생성년월 → 자격마감일(사유발생일이 속하는 달의 다음달 15일)까지 신고분 반영<br/>○ 가입자 수 → 가입자수 (고지인원 수 포함)<br/>○ 당월고지금액 → 국민연금법 시행령 제5조에 의거 기준소득월액 상한액 적용으로 실제소득과 고지금액은 상이할 수 있음<br/>■ 상한액 2019.7.~2020.6. 4,860,000원(2019.7.1.기준)<br/>■ 상한액 2020.7.~2021.6. 5,030,000원(2020.7.1.기준)<br/>○ 신규취득자수 → 납부재개 포함 : ※ 전달 고지대상자와 비교하므로 실제 취득자와 상이할 수 있음 (초일취득 (고지)초일이 아닌경우 (당월 미고지되며 다음달 취득자수에 반영)<br/>○ 상실가입자수 → 납부예외 포함 : ※ 전달 고지대상자와 비교하므로 실제 퇴사자와 상이할 수 있음 (초일이 아닌 상실자는 다음달 상실자수에 반영)<br/>※ 국민연금법 제6조, 8조, 동법 시행령 제18조에 의거 60세 도달하거나 퇴직연금수급자, 조기노령연금 수급권을 취득한 자는 가입대상에서 제외되며, 18세미만, 기초수급자는 본인희망에 의해 제외될 수 있음<br/> "
    ## [5] "(부보금융회사 종합정보)<br/>예금보험공사가 발간한 도서 목록 및 해당 도서의 서명과 저자 등의 관련정보 "

#### 3\. 전처리: 제어 문자(escape ch,  ) 없애기 (데이터 정제)

``` r
title <- gsub("\r\n\t", "", title) %>%
         gsub(pattern = "\t", replacement = "") %>%
         gsub(pattern = '_', replacement = ' ')
## title <- trimws(title, "both")
title
```

    ## [1] "농촌진흥청 스마트팜 우수농가 공개용 데이터"
    ## [2] "한국지역난방공사 열판매량 정보"            
    ## [3] "대전광역시도시철도공사 열차시각표"         
    ## [4] "국민연금공단 국민연금 가입 사업장 내역"    
    ## [5] "예금보험공사 발간도서 목록"

``` r
## desc <- gsub("\r\n", "", desc)
desc <- trimws(desc, "both")
desc
```

    ## [1] "농촌진흥청 스마트팜 우수농가에 대한 공개용 데이터셋을 (온실환경, 작물생육, 생산량)을 제공합니다."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    ## [2] "지역난방공사 전사 열판매 정보"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    ## [3] "역별 열차운행 시각표를 보여주는 서비스"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    ## [4] "(국민연금가입수급정보) 법정동단위 지역별, 국민연금 가입 사업장 정보<br/>* 단, 개인사업장 및 2인 이하 법인 사업장 정보 미제공<br/><br/>*사업장 컬럼별 상세설명<br/>○ 자료생성년월 → 자격마감일(사유발생일이 속하는 달의 다음달 15일)까지 신고분 반영<br/>○ 가입자 수 → 가입자수 (고지인원 수 포함)<br/>○ 당월고지금액 → 국민연금법 시행령 제5조에 의거 기준소득월액 상한액 적용으로 실제소득과 고지금액은 상이할 수 있음<br/>■ 상한액 2019.7.~2020.6. 4,860,000원(2019.7.1.기준)<br/>■ 상한액 2020.7.~2021.6. 5,030,000원(2020.7.1.기준)<br/>○ 신규취득자수 → 납부재개 포함 : ※ 전달 고지대상자와 비교하므로 실제 취득자와 상이할 수 있음 (초일취득 (고지)초일이 아닌경우 (당월 미고지되며 다음달 취득자수에 반영)<br/>○ 상실가입자수 → 납부예외 포함 : ※ 전달 고지대상자와 비교하므로 실제 퇴사자와 상이할 수 있음 (초일이 아닌 상실자는 다음달 상실자수에 반영)<br/>※ 국민연금법 제6조, 8조, 동법 시행령 제18조에 의거 60세 도달하거나 퇴직연금수급자, 조기노령연금 수급권을 취득한 자는 가입대상에서 제외되며, 18세미만, 기초수급자는 본인희망에 의해 제외될 수 있음<br/>"
    ## [5] "(부보금융회사 종합정보)<br/>예금보험공사가 발간한 도서 목록 및 해당 도서의 서명과 저자 등의 관련정보"

``` r
api <- data.frame(title, desc)
api
```

    ##                                        title
    ## 1 농촌진흥청 스마트팜 우수농가 공개용 데이터
    ## 2             한국지역난방공사 열판매량 정보
    ## 3          대전광역시도시철도공사 열차시각표
    ## 4     국민연금공단 국민연금 가입 사업장 내역
    ## 5                 예금보험공사 발간도서 목록
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         desc
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           농촌진흥청 스마트팜 우수농가에 대한 공개용 데이터셋을 (온실환경, 작물생육, 생산량)을 제공합니다.
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              지역난방공사 전사 열판매 정보
    ## 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     역별 열차운행 시각표를 보여주는 서비스
    ## 4 (국민연금가입수급정보) 법정동단위 지역별, 국민연금 가입 사업장 정보<br/>* 단, 개인사업장 및 2인 이하 법인 사업장 정보 미제공<br/><br/>*사업장 컬럼별 상세설명<br/>○ 자료생성년월 → 자격마감일(사유발생일이 속하는 달의 다음달 15일)까지 신고분 반영<br/>○ 가입자 수 → 가입자수 (고지인원 수 포함)<br/>○ 당월고지금액 → 국민연금법 시행령 제5조에 의거 기준소득월액 상한액 적용으로 실제소득과 고지금액은 상이할 수 있음<br/>■ 상한액 2019.7.~2020.6. 4,860,000원(2019.7.1.기준)<br/>■ 상한액 2020.7.~2021.6. 5,030,000원(2020.7.1.기준)<br/>○ 신규취득자수 → 납부재개 포함 : ※ 전달 고지대상자와 비교하므로 실제 취득자와 상이할 수 있음 (초일취득 (고지)초일이 아닌경우 (당월 미고지되며 다음달 취득자수에 반영)<br/>○ 상실가입자수 → 납부예외 포함 : ※ 전달 고지대상자와 비교하므로 실제 퇴사자와 상이할 수 있음 (초일이 아닌 상실자는 다음달 상실자수에 반영)<br/>※ 국민연금법 제6조, 8조, 동법 시행령 제18조에 의거 60세 도달하거나 퇴직연금수급자, 조기노령연금 수급권을 취득한 자는 가입대상에서 제외되며, 18세미만, 기초수급자는 본인희망에 의해 제외될 수 있음<br/>
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       (부보금융회사 종합정보)<br/>예금보험공사가 발간한 도서 목록 및 해당 도서의 서명과 저자 등의 관련정보

#### 4\. 10페이지를 웹스크래핑

  - 4.20을 기준으로 페이지를 새롭게 구성하여 (xsl를 이용한 것으로 보인다) page에 대한 parsing이 상당히
    어려워졌다. xsl parsing을 구조체만 알아내면 쉽게 할 수 있는데 지금으로썬 뭐인지 모르겠다.
  - 만약에 xsl로 만든 게 맞고 js에 반응해 다음으로 움직이는데 이게 js로 배열화시켜놓은 거라면, js가 관여하는
    (for-each 안에) 데이터 태그 이름을 알아내거나 (for-each) 위치를 저장해서 계속 부르면 다른 값을 주지
    않을까?
  - 일단 ul을 기준으로 계속 호출해봤는데 같은 값밖에 가져오지 않는다.

<!-- end list -->

``` r
url.api <- "https://www.data.go.kr/tcs/dss/selectDataSetList.do"
## base url은 일단 위와 같은 곳으로 적었다.
titles <- NULL; descs <- NULL

for (page in 1:10) {
  url <- paste(url.api, page, sep = "")
  html <- read_html(url.api)

  title <- html_nodes(html, "#apiDataList") %>%
           html_nodes("ul") %>% html_nodes("a") %>%
           html_nodes("span.title") %>% html_text()
  desc <- html_nodes(html, "#contents") %>%
          html_nodes("#apiDataList") %>%
          html_nodes(".result-list") %>%
          html_nodes(".ellipsis") %>% html_text()

  title <- gsub("\r\n\t", "", title) %>%
         gsub(pattern = "\t", replacement = "") %>%
         gsub(pattern = '_', replacement = ' ')
  desc <- trimws(desc, "both")

  titles <- c(titles, title)
  descs <- c(descs, desc)
}

titles
```

``` r
api <- data.frame(title = titles, desc = descs)
head(api)
```

### 연습용 project

  - **아니 어떻게 XPath를 따와서 만든 건데, 안 될 수가 있지?**
  - 유튜브 “알라딘 OST” 페이지 가져오기
  - URL DOM 이해하기 및 parsing 객체 확인
  - 페이지 내 영상 제목만 가져와 구성하기

<!-- end list -->

``` r
library(rvest)
url = "https://www.youtube.com/results?search_query=%EC%95%8C%EB%9D%BC%EB%94%98+OST"
html = read_html(url)
```

  - \[@id="video-title"\]/yt-formatted-string
  - document.querySelector(“\#video-title \> yt-formatted-string”)

<!-- end list -->

``` r
title = html_nodes(html, "#video-title") %>%
        html_nodes("yt-formatted-string") %>%
        html_text()
title
```

-----

## 9\. 공공데이터 활용

  - OPEN API를 받아야 해서 실행시키지 않았다.

<!-- end list -->

``` r
library(XML)
library(ggplot2)
```

``` r
api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
api_key   <- "DE..."        ## 공공 데이터 포털에서 승인 받은 키
numOfRows <- 10
pageNo    <- 1
itemCode  <- "PM10"         ## 아이템 코드: 미세먼지
dataGubun <- "HOUR"         ## (한) 시간 단위 미세먼지 데이터
searchCondition <- "MONTH"  ## 요청 데이터 기간: 한달
```

  - 당연히 api에 할당한 주소 또한 달라졌을 것이다.

<!-- end list -->

``` r
url <- paste(api, "?serviceKey=", api_key, "&numOfRows=", numOfRows, "&pageNo=", pageNo,
            "&itemCode=", itemCode, "&dataGubun=", dataGubun, "&searchCondition=", searchCondition)
```

``` r
xmlFile <- xmlParse(url)
xmlRoot(xmlFile)
```

  - 혹시나 해서 html 읽기를 xmlParse 및 xmlRoot( )로 해봤는데 안 먹는다.

<!-- end list -->

``` r
df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df
```

  - XSL file parsing 때의 file system을 기반으로 한 주소를 사용한다.
  - 전체에서 모든 items element 내 item을 (list 형태로) 불러온다.

<!-- end list -->

``` r
ggplot(data = df, aes(x = dataTime, y = seoul)) +
  geom_bar(stat = "identity", fill = "green")
```

> df 내 dataTime, seoul을 축으로 설정하고 y 데이터에 맞춰 초록색의 막대를 그린다.

#### 초록색으로 통일

``` r
ggplot(data = df, aes(x = dataTime, y = seoul)) +
  geom_bar(stat = "identity", fill = "green") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "시간대별 서울지역의 미세먼지 농도 변화", x = "측정일시", y = "농도")
```

#### rainbow( )을 이용한 여러 색으로 칠하기

``` r
ggplot(data = df, aes(x = dataTime, y = seoul, fill = dataTime)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "시간대별 서울지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10))
```

#### 쓸모없는 범례를 지우자

``` r
ggplot(data = df, aes(x = dataTime, y = seoul, fill = dataTime)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90), legend.position = "none") +
  labs(title = "시간대별 서울지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10))
```

#### 가로로 출력해보자

``` r
ggplot(data = df, aes(x = dataTime, y = seoul, fill = dataTime)) +
  geom_bar(stat = "identity") +
  theme(legend.position = "none") +
  labs(title = "시간대별 서울지역의 미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10)) +
  coord_flip()
```

### 지도: 지역별 미세먼지 농도 비교

``` r
library(XML)
library(ggmap)
```

#### 1\. 데이터 불러오기

``` r
api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
api_key   <- "DE..."        ## 공공 데이터 포털에서 승인 받은 키
numOfRows <- 10
pageNo    <- 1
itemCode  <- "PM10"         ## 아이템 코드: 미세먼지
dataGubun <- "HOUR"         ## (한) 시간 단위 미세먼지 데이터
searchCondition <- "MONTH"  ## 요청 데이터 기간: 한달

url <- paste(api, "?serviceKey=", api_key, "&numOfRows=", numOfRows, "&pageNo=", pageNo,
            "&itemCode=", itemCode, "&dataGubun=", dataGubun, "&searchCondition=", searchCondition)

xmlFile <- xmlParse(url)
xmlRoot(xmlFile)

df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df
```

  - 이전에 서울 내 미세먼지 데이터를 가져올 때와 완전히 동일하다.

<!-- end list -->

``` r
pm <- df[1, 4:20]
```

#### 2\. 구글 지도 가져오기

``` r
register_google(key = "AI...")  ## Google Map API

cities <- c("서울시", "부산시", "대구시", "인천시", "광주시", "대전시", "울산시", "경기도", "강원도",
            "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주시", "세종시")
## 일부 이름이 주소 인식이 안 되어 지역명을 모두 한글로 변경
gc <- geocode(enc2utf8(cities)) ## 지역별 좌표(경도, 위도)
gc
```

``` r
df2 <- data.frame(지역명 = cities, 미세먼지 = t(pm), 경도 = gc$lon, 위도 = gc$lat, stringsAsFactors = F)
## names(df2)[2] <- "미세먼지"
df2
```

``` r
str(df2)
```

``` r
df2[, 2] <- as.numeric(df2[, 2])
```

#### 3\. 지도에 그려보자

``` r
cen <- as.numeric(geocode(enc2utf8("전라북도")))
map <- get_googlemap(center = cen, zoom = 7)

ggmap(map) +
  geom_point(data = df2, aes(x = 경도, y = 위도), color = rainbow(length(df2$미세먼지)),
             size = df2$미세먼지 * 0.3, alpha = 0.5)
```

> geom\_point(aes: 원의 위치, alpha: 투명도)

### 연습용 project

1.  특정 지역(서울)의 시간대별 미세먼지 농도의 변화

<!-- end list -->

  - 서울 지역의 초미세먼지 데이터 불러오기
  - 막대 그래프 그리기

<!-- end list -->

``` r
api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
api_key   <- "DE..."  ## 공공 데이터 포털에서 승인 받은 키
numOfRows <- 10
pageNo    <- 1
itemCode  <- "PM25"   ## 아이템 코드: 초미세먼지
dataGubun <- "HOUR"
searchCondition <- "MONTH"
```

``` r
url <- paste(api, "?serviceKey=", api_key, "&numOfRows=", numOfRows, "&pageNo=", pageNo,
            "&itemCode=", itemCode, "&dataGubun=", dataGubun, "&searchCondition=", searchCondition)
```

``` r
xmlFile <- xmlParse(url)
xmlRoot(xmlFile)
df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df
```

``` r
ggplot(data = df, aes(x = dataTime, y = seoul, fill = dataTime)) +
  geom_bar(stat = "identity") +
  theme(legend.position = "none") +
  labs(title = "시간대별 서울지역의 초미세먼지 농도 변화", x = "측정일시", y = "농도") +
  scale_fill_manual(values = rainbow(10))
```

2.  특정 시간대의 지역별 초미세먼지 농도 비교

<!-- end list -->

``` r
api <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst"
api_key   <- "DE..."  ## 공공 데이터 포털에서 승인 받은 키
numOfRows <- 10
pageNo    <- 1
itemCode  <- "PM25"   ## 아이템 코드: 초미세먼지
dataGubun <- "HOUR"
searchCondition <- "MONTH"

url <- paste(api, "?serviceKey=", api_key, "&numOfRows=", numOfRows, "&pageNo=", pageNo,
            "&itemCode=", itemCode, "&dataGubun=", dataGubun, "&searchCondition=", searchCondition)

xmlFile <- xmlParse(url)
xmlRoot(xmlFile)

df <- xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
pm <- df[1, 4:20]
```

``` r
register_google(key = "AI...")  ## 구글 지도 API

cities <- c("서울시", "부산시", "대구시", "인천시", "광주시", "대전시", "울산시", "경기도", "강원도",
            "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주시", "세종시")
## 일부 이름이 주소 인식이 안 되어 지역명을 모두 한글로 변경
gc <- geocode(enc2utf8(cities)) ## 지역별 좌표 검색(경도, 위도)
gc
```

``` r
df2 <- data.frame(지역명 = cities, 초미세먼지 = t(pm), 경도 = gc$lon, 위도 = gc$lat,
                  stringsAsFactors = F)
## names(df2)[2] <- "초미세먼지"
df2
str(df2)
```

``` r
df2[, 2] <- as.numeric(df2[, 2])
```

``` r
cen <- as.numeric(geocode(enc2utf8("전라북도")))
map <- get_googlemap(center = cen, zoom = 7)

ggmap(map) +
  geom_point(data = df2, aes(x = 경도, y = 위도), color = rainbow(length(df2$초미세먼지)),
             size = df2$초미세먼지 * 0.3, alpha = 0.5)
```
