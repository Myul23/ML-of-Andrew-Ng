library(RCurl)
# library(KoNLP)
library(RmecabKo)
library(RColorBrewer)
library(wordcloud2)


# base url setting
urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=%EC%BD%94%EB%A1%9C%EB%82%98"
urlPart2 = "&sm=tab_pge"
sortNum = "&sort=0"
newsType = "&photo=3"
urlPart3 = "&field=0&reporter_article=&pd=3"
date1 = "&ds=2020.03.01&de=2020.03.31"
urlPart4 = "&docid=&nso=so:r"
date2 = ",p:from20200301to20200331"
urlPart5 = ",a:all&mynews=0&start="
start = 0


# 고통의 시작
tit = c();  desc = c(); skip = c()
# 3월: 27,580, 4월: 24,779, 5월: 21,343
for (i in 0:275) {
  start = i*100 + 1
  url = paste(urlPart1, query, urlPart2, sortNum, newsType, urlPart3, date1, urlPart4, date2, urlPart5, start, sep="")
  urlMoum = read_html(url)
  
  # li#sp_nws1, (dt, a href)
  middle_point = html_nodes(urlMoum, "div#container") %>% html_nodes("ul.type01") %>%
                 html_nodes("dt") %>% html_nodes("a") %>% html_attr("href")
  
  for (j in 1:10) {
    tryCatch({ element_base = read_html(middle_point[j]) },
        error = function(e) { skip = c(skip, middle_point[j]) })
    tryCatch({
      title = html_nodes(element_base, "div#main_content") %>% html_nodes("h3#articleTitle") %>% html_text()
      description = html_nodes(element_base, "div#main_content") %>% html_nodes("div#articleBodyContents") %>% html_text()
      tit = c(tit, title)
      desc = c(desc, description)
    }, error = function(e) { skip = c(skip, middle_point[j]) })
  }
  print(start)
}; rm(i); rm(j)

# 본격적으로 워드 클라우드 그리기
print(length(desc))
# nouns_base = extractNoun(desc)
nouns_base = nouns(iconv(desc, "utf-8"))

# extractNoun와 nouns의 인자 제한 범위를 훌쩍 넘겨 버려서 그걸 고쳐보고자 한 것들.
# for (i in 1:6) { desc = c(desc, "") }
# num = length(desc)/46
# nouns_base = c()
# for (i in 0:45) {
#   result = nouns(iconv(desc[(i*num + 1):(i + 1)*num], "utf-8"))
#   nouns_base = c(nouns_base, result)
# }

nouns_base = unique(nouns_base)
nouns_base = unlist(nouns_base)
nouns_base = nouns_base[nchar(nouns_base) >= 2]


ele_nouns = gsub("\n", "", nouns_base) %>% gsub("\r", "") %>% gsub("http*", "") %>%
            gsub("[[:punct:]]", "") %>% gsub("[A-Za-z]", "") %>% gsub("\\d+", "") %>%
            gsub(" ", "", fixed = TRUE)

# about COVID-19
nouns = gsub("^신종.*", "", ele_nouns) %>% gsub("^코로나.*", "") %>%
        gsub("^바이러스.*", "") %>% gsub("^감염증.*", "") %>%
        gsub("확진자.*", "확진자") %>% gsub("감염자", "확진자")


final = nouns[nchar(nouns) >= 2]
wordFreq = table(final)
wordFreq = sort(wordFreq, decreasing = T)
# frequency = wordFreq[wordFreq >= 50]
set.seed(100)
wordcloud2(wordFreq, size = 1, color = "random-light")
