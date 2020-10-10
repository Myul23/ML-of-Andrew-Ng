# 1. 기사 전체에 대한 링크 따기
# 2. 각 링크마다 제목이랑 본문 내용 따기
# - 데이터양을 생각하면 중간 중간 저장하는 것도 나쁘지 않을 듯

library(httr)
library(rvest)
# library(RCurl)
# library(XML)
library(RmecabKo)
library(wordcloud)
library(wordcloud2)


# base url setting
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


# 고통의 시작
desc = c(); skip = c()
# 총 1,357,818건, 최대 10개씩
for (i in 0:10) {
  start = i*10 + 1
  url = paste(urlPart1, query, urlPart2, date1, urlPart3, date2, urlPart4, start, sep="")
  # Naver는 굳이 header 안 줘도 됐던 것 같다.
  urlMoum = read_html(url)
  
  # li#sp_nws1, (dt, a href)
  middle_point = html_nodes(urlMoum, "div#container") %>% html_nodes("ul.type01") %>%
                html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
  # 지금 모양새가 제목이랑 언론사는 base에서 따는 게 좋을 듯?

  for (j in 1:10) {
    check = 0
    tryCatch({ element_base = read_html(middle_point[j]) },
        error = function(e) { tryCatch({
          check_point = GET(middle_point[j])
          element_base = read_html(check_point)
          }, error = function(e) { tryCatch({
            header = user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70")
            check_point = GET(middle_point[j], header)
            if (check_point$status_code != 200) {
              skip = c(skip, middle_point[j])
              check = 1
            }}, error = function(e) {
              skip = c(skip, middle_point[j])
              check = 1
          })
        })
    })
    if (check == 1) next
    # print(element_base)
    tryCatch({
      description = html_nodes(element_base, "div[id~=wrap]") %>% html_nodes("[id~=container]") %>%
                    html_nodes("[id~=content]") %>% html_nodes("p") %>% html_text()
      if (length(description) == 0) {
        description = html_nodes(element_base, "[class~=article]") %>% html_nodes("p") %>% html_text()
        if (length(description) == 0) {
          description = html_nodes(element_base, "[class~=article]") %>% html_text()
          if (length(description) == 0) {
            skip = c(skip, middle_point[j])
            next
      }}}
      desc = c(desc, description)
    }, error = function(e) { skip = c(skip, middle_point[j]) })
  }
  print(i)
}

# 그냥 하면 접근 불가고 user-agent를 주면 데이터 파일이 이상하다고 하고, 후...
# url = "http://www.phmbc.co.kr/www/news/desk_news?idx=169075&mode=view"
# header = user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70")
# first_result = GET(url, header)
# first_result$status_code == 200

# for(i in 1:N) {
#   url = paste(base_url, i, sep="")
#   r = GET(url)
#   h = read_html(r)
#   comment = html_nodes(h, '.desc_review')
#   comments = html_text(comment)
#   all.comments = c(all.comments, comments)
# }

# 대체로 wrap% -> %container -> %content -> div.{} -> p로 귀결되고 있다, 정말 다행히도.
# 농민신문: div#wrap_bx, div#wrap, div#container, div#content, div.article_bx.clfix, div.article_l, div#_print-content-area.view_wrap, div.detail_txt.txt_zoom1, p(s) - strong으로 요약문 존재
# 스포츠경향: div#wrap, div#container, div#content, article.article_cont_left, section.section_cleft_news, article.wrap_news_body, div.desc_body, div#articleBody.art_body, p.content_text(s)
# 포항MBC: div#wrap, section#container, div.inner, div.cont_wrap.group, div#right, div#content_box, div#content, table.phmbc_view, tbody, tr, td.news_cont, p.vod_cont
# 세계일보: div#wrapNews.targetWrap, div#wps_container, div#mcontent, div#wrqpCont, div#wps_layout1, section#contMain, div#wps_layout1_box2, div#article_txt, article.viewBox, p(s)

# 이제 내일은 skip에 있는 내용에 대해서 error-coding해야지. 짜증나는 포항은 제외하고 예제 5개
# http://www.asiatoday.co.kr/view.php?key=20200315010009126
# div#wrap, div#section, div#section_wrap, div#section_main, div.article_box, dl.article_body, div#font.news_bm, text
# http://koreajoongangdaily.joins.com/news/article/article.aspx?aid=3074957
# div#content-container.container, div#main-second-content, dev.article-left, div#article_data, div#doc, div#article_body.article_body.mg.fs4, text
# http://medicalworldnews.co.kr/news/view.php?idx=1510934686
# div#container, div#contents, div.basicView, div.viewContentWrap, div#viewContent, p, text
# http://www.segye.com/content/html/2020/03/15/20200315508015.html?OutUrl=naver
# div#wrapNews, div#wps_container, div#mcontent, div#wrapCont, div#wps_layout1, section#contMain, div#wps_layout1_box2, div#article_txt, article, p, text
# http://www.greened.kr/news/articleView.html?idxno=242193
# div#user-wrap, section#user-container, div.user-content, section, article, div#article-view-content-div, div#articleBody, p, text


# 본격적으로 워드 클라우드 그리기
nouns = extractNoun(desc)

nouns = unique(nouns)
nouns = unlist(nouns)
nouns = nouns[nchar(nouns) >=2]

# 단어 일차 확인용
# table(nouns)

# 얘도 %>%가 되는 걸로 알고 있지만, 중간중간 확인해야 할 수도 있어서 따로 따로.
nouns = gsub("\n", "", nouns)
nouns = gsub("\r", "", nouns)
nouns = gsub("http*", "", nouns)        # remove graphical characters
nouns = gsub("[[:punct:]]", "", nouns)  # remove Punctuation characters: ! " # % & ' ( ) * + , - . / : ;
# nouns = gsub("[A-Za-z]", "", nouns)   # 영문제거랑 숫자제거는 좀 생각해보자.
# nouns = gsub("\\d+", "", nouns)
nouns = gsub(" ", "", nouns, fixed = TRUE)
nouns = gsub("\n.*", "", nouns)         # 혹시 몰라서 준비함.

wordFreq = table(nouns)
wordFreq = sort(wordFreq, decreasing = T)

# 분석하는 기사 양을 생각하면 택도 없겠지만, 그래도 괜찮지 않을까.
pal = brewer.pal(12, "Paired")
# set.seed(100)                         # 선택 사항 
wordcloud(words = names(wordFreq), freq = wordFreq, scale = c(8, 1.8), colors = pal, min.freq = 5, random.order = F,  random.color = F)
wordcloud2(wordFreq, size = 10, color = "random-light")


# 이대로 이 엄청나게 많은 양의 기사를 분석할 것인가
# - 개인적으로 DB 같은 걸 구성할 게 아니라면 필요 없다고 생각한다. (사실상 시간적으로, 물질적으로 불가능하다고 본다.)
# - 그래서 상위 몇 개의 기사를 사용한다든지, 임의추출을 통한 값으로 샘플링한다든지 하는 작업이 필요할 것으로 보인다.
