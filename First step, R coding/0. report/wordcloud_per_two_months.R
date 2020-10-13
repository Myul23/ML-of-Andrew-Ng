# 이대로 이 엄청나게 많은 양의 기사를 분석할 것인가
# - 개인적으로 DB 같은 걸 구성할 게 아니라면 필요 없다고 생각한다. (사실상 시간적으로, 물질적으로 불가능하다고 본다.)
# - 그래서 상위 몇 개의 기사를 사용한다든지, 임의추출을 통한 값으로 샘플링한다든지 하는 작업이 필요할 것으로 보인다.


# 1. 기사 전체에 대한 링크 따기
# 2. 각 링크마다 제목이랑 본문 내용 따기
# - 데이터양을 생각하면 중간 중간 저장하는 것도 나쁘지 않을 듯

library(httr)
library(rvest)
# library(RCurl)
# library(XML)
library(KoNLP)
library(RmecabKo)
library(RColorBrewer)
# library(wordcloud)
library(wordcloud2)


# base url setting
urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=%EC%BD%94%EB%A1%9C%EB%82%98"
urlPart2 = "&sm=tab_pge"
# 0번은 관련도순, 1번은 최신순, 2번은 오래된순
sortNum = "&sort=0"
urlPart3 = "&photo=0&field=0&reporter_article=&pd=3"
# 15일을 이전 사람에게 준 형태
date1 = "&ds=2020.03.16&de=2020.05.15"
urlPart4 = "&docid=&nso=so:da"
date2 = ",p:from20200316to20200515"
urlPart5 = ",a:all&mynews=0&start="
start = 0
# urlPart6 = "&refresh_start=0"


# 고통의 시작
desc = c(); skip = c()
# 총 1,357,818건, 최대 10개씩
for (i in 0:1000) {
  start = i*10 + 1
  url = paste(urlPart1, query, urlPart2, sortNum, urlPart3, date1, urlPart4, date2, urlPart5, start, sep="")
  # Naver는 굳이 header 안 줘도 됐던 것 같다.
  urlMoum = read_html(url)
  
  # li#sp_nws1, (dt, a href)
  middle_point = html_nodes(urlMoum, "div#container") %>% html_nodes("ul.type01") %>%
    html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
  # 지금 모양새가 제목이랑 언론사는 base에서 따는 게 좋을 듯?
  
  # 영자 site는 없애버릴까.
  for (j in 1:10) {
    check = 0
    # 그냥 하면 접근 불가고 user-agent를 주면 데이터 파일이 이상하다고 하고, 후...
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
        html_nodes("[id~=content]") %>% html_text()
      if (length(description) == 0) {
        description = html_nodes(element_base, "article") %>% html_text()
        if (length(description) == 0) {
          description = html_nodes(element_base, "[id~=article") %>% html_text()
          if (length(description) == 0) {
            description = html_nodes(element_base, "[class~=article]") %>% html_text()
            if (length(description) == 0) {
              description = html_nodes(element_base, "div#main_content") %>% html_nodes("div#articleBodyContents") %>% html_text()
              if (length(description) == 0) {
                skip = c(skip, middle_point[j])
                next
              }}}}}
      desc = c(desc, description)
    }, error = function(e) { skip = c(skip, middle_point[j]) })
  }
  print(start)
}

# 대체로 wrap% -> %container -> %content -> div.{} -> p로 귀결되고 있다, 정말 다행히도.
# 농민신문: div#wrap_bx, div#wrap, div#container, div#content, div.article_bx.clfix, div.article_l, div#_print-content-area.view_wrap, div, p(s) - strong으로 요약문 존재
# 스포츠경향: div#wrap, div#container, div#content, article.article_cont_left, section, article, div, div#articleBody, p.content_text(s)
# 포항MBC: div#wrap, section#container, div.inner, div.cont_wrap.group, div#right, div#content_box, div#content, table.phmbc_view, tbody, tr, td.news_cont, p.vod_cont
# 세계일보: div#wrapNews.targetWrap, div#wps_container, div#mcontent, div, section#contMain, div#article_txt, article, p(s)
# 아시아투데이: div#wrap, div#section, div#section_wrap, div#section_main, div.article_box, dl.article_body, div#font.news_bm, text
# 중앙데일리(영자): div#content-container.container, div#main-second-content, dev.article-left, div#article_data, div#doc, div#article_body.article_body.mg.fs4, text
# Medical World News: div#container, div#contents, div, div.viewContentWrap, div#viewContent, p, text
# 세계일보: div#wrapNews, div#wps_container, div#mcontent, div#wrapCont, div#wps_layout1, section#contMain, div#wps_layout1_box2, div#article_txt, article, p, text
# 녹색경제신문: div#user-wrap, section#user-container, div.user-content, section, article, div#article-view-content-div, div#articleBody, p, text
# 네이버뉴스: div#wrap, table.container, div#main_content.content, div#articleBody., div#articleBodyContents, text
# 조선일보: div#fusion-app, div.article, section, article, section, p, text
# MBC: div#wrap, div#container, div#content, section, article, div, text
# newis: div#wrap, div#container, div#content, div#article, div#textBody, text
# JTBC: div, div#jtbcBody, form, div#article, div#articlebody, div, text
# 파이넨셜뉴스: div#root, div.contents, div#article_content, text


# 본격적으로 워드 클라우드 그리기
# nouns_base = extractNoun(desc)
# nouns_base = nouns(iconv(desc, "utf-8"))

# extractNoun와 nouns의 인자 제한 범위를 훌쩍 넘겨 버려서 그걸 고쳐보고자 한 것들.
# print(length(desc))
num = length(desc)
# 와.. 내가 살다살다 input buffer를 초과할 줄이야. 그 부담 줄여주려 만든 것.
for (i in 1:8) { desc = c(desc, "") }
nouns_base = c()
for (i in 0:500) {
  result = nouns(iconv(desc[(i*num + 1):(i + 1)*num], "utf-8"))
  nouns_base = c(nouns_base, result)
}

nouns_base = unique(nouns_base)
nouns_base = unlist(nouns_base)
nouns_base = nouns_base[nchar(nouns_base) >= 2]


# 얘도 %>%가 되는 걸로 알고 있지만, 중간중간 확인해야 할 수도 있어서 따로 따로.
# 뭐지 갑자기 일을 잘하는데, ~도 없어졌어.
# first_nouns = gsub("n차", "~차", nouns_base)
# first_nouns = gsub("[1-9]차", "~차", first_nouns)

ele_nouns = gsub("\n", "", nouns_base)
ele_nouns = gsub("\r", "", ele_nouns)
# ele_nouns = gsub("[[:cntrl:]]", "", ele_nouns)  # \n, \r과 같은 제어문자 제거
ele_nouns = gsub("http*", "", ele_nouns)          # remove graphical characters
ele_nouns = gsub("[[:punct:]]", "", ele_nouns)    # remove Punctuation characters: ! " # % & ' ( ) * + , - . / : ;
ele_nouns = gsub("[A-Za-z]", "", ele_nouns)       # 영어는 딱히 뭐가 유의미하게 안 남아서 패스
ele_nouns = gsub("\\d+", "", ele_nouns)           # 지우고 싶은 마음 만땅인데, 이게 그날 문제가 있었음을 지적할 수 있는 사안이지만, 지워. 이상해.
ele_nouns = gsub(" ", "", ele_nouns, fixed = TRUE)
# ele_nouns = gsub("\n.*", "", ele_nouns)         # 혹시 몰라서 준비.

# about COVID-19
nouns = gsub("^신종.*", "", ele_nouns)
nouns = gsub("^코로나.*", "", nouns)
nouns = gsub("^바이러스.*", "", nouns)
nouns = gsub("^감염증.*", "", nouns)
nouns = gsub("확진자.*", "확진자", nouns)
nouns = gsub("감염자", "확진자", nouns)

# # 특이사항들을 합치거나 없애봅시다.
# nouns = gsub("이태", "이태원", nouns)
# nouns = gsub("서울연합뉴스", "", nouns)
# nouns = gsub("하게", "", nouns)                 # 방역수칙에 대한 이야기로 보인다.
# nouns = gsub("하기", "", nouns)
# nouns = gsub("영상$", "", nouns)                # 동영상 정보가 남았더라고. 근데 양을 늘리면 필요없을 것 같다.


final = nouns[nchar(nouns) >= 2]                  # 왜 그렇게 되었는지 정말 모르겠지만, 공백 처리한 게 있어서 한 글자로 남은 것도 있더라구요.
wordFreq = table(final)
wordFreq = sort(wordFreq, decreasing = T)


# pal = brewer.pal(12, "Paired")
# set.seed(100)
# wordcloud(words = names(wordFreq), freq = wordFreq, scale = c(8, 1.8), colors = pal, min.freq = 5, random.order = F,  random.color = F)

# frequency = wordFreq[wordFreq >= 50]
set.seed(100)
wordcloud2(wordFreq, size = 0.5, color = "random-light")
