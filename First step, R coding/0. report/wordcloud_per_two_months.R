# 1. 기사 전체에 대한 링크 따기
# 2. 각 링크마다 제목이랑 본문 내용 따기
# - 데이터양을 생각하면 중간 중간 저장하는 것도 나쁘지 않을 듯

library(httr)
library(rvest)
# library(RCurl)
# library(XML)
library(RmecabKo)
library(wordcloud)

urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=%EC%BD%94%EB%A1%9C%EB%82%98"
urlPart2 = "&sm=tab_pge&sort=2&photo=0&field=0&reporter_article=&pd=3"
# 15일을 이전 사람에게 준 형태
date1 = "&ds=2020.03.16&de=2020.05.15"
urlPart3 = "&docid=&nso=so:da"
date2 = ",p:from20200316to20200515"
urlPart4 = ",a:all&mynews=0&start="
start = 0
# urlPart5 = "1&refresh_start=0"

# 총 1,357,818건, 최대 10개씩
for (start in 1:135782) {
  start = start*10 + 1
  url = paste(urlPart1, query, urlPart2, date1, urlPart3, date2, urlPart4, start, sep="")
  # Naver는 굳이 header 안 줘도 됐던 것 같다.
  base = read_html(url)
  
  # li#sp_nws1, (dt, a href)
  title = html_nodes(base, "div#container") %>% html_nodes("ul.type01") %>%
          html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
  # 지금 모양새가 제목이랑 언론사는 base에서 따는 게 좋을 듯?
}

# 대체로 wrap% -> %container -> %content -> div.{} -> p로 귀결되고 있다, 정말 다행히도.
# 농민신문: div#wrap_bx, div#wrap, div#container, div#content, div.article_bx.clfix, div.article_l, div#_print-content-area.view_wrap, div.detail_txt.txt_zoom1, p(s) - strong으로 요약문 존재
# 스포츠경향: div#wrap, div#container, div#content, article.article_cont_left, section.section_cleft_news, article.wrap_news_body, div.desc_body, div#articleBody.art_body, p.content_text(s)
# 포항MBC: div#wrap, section#container, div.inner, div.cont_wrap.group, div#right, div#content_box, div#content, table.phmbc_view, tbody, tr, td.news_cont, p.vod_cont
# 세계일보: div#wrapNews.targetWrap, div#wps_container, div#mcontent, div#wrqpCont, div#wps_layout1, section#contMain, div#wps_layout1_box2, div#article_txt, article.viewBox, p(s)

url = "http://www.phmbc.co.kr/www/news/desk_news?idx=169075&mode=view"
header = httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70")
first_result = httr::GET(url, header)
first_result$status_code == 200
base = read_html(first_result)
title = html_nodes(base, "div#wrap") %>% html_nodes("#container") %>%
        html_nodes("#content") %>% html_nodes("p") %>% html_text()

for(i in 1:N) {
  url = paste(base_url, i, sep="")
  r=GET(url)
  h=read_html(r)
  comment =html_nodes(h, '.desc_review')
  comments=html_text(comment)
  all.comments = c(all.comments, comments)
}
