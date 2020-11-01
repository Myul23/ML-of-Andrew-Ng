library(rvest)
library(RmecabKo)
library(RColorBrewer)
library(wordcloud2)


# base url setting
urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=코로나"
urlPart2 = "&sm=tab_pge"
sortNum = "&sort=0"
newsType = "&photo=3"
urlPart3 = "&field=0&reporter_article=&pd=3"
date1 = "&ds=2020.02.01&de=2020.02.29"
# &ds=2020.03.01&de=2020.03.15
# &ds=2020.03.16&de=2020.03.31
# &ds=2020.04.01&de=2020.04.15
# &ds=2020.04.16&de=2020.04.30
# &ds=2020.05.01&de=2020.05.15
# &ds=2020.05.16&de=2020.05.31
urlPart4 = "&docid=&nso=so:r"
date2 = ",p:from20200201to20200229"
# ,p:from20200301to20200315
# ,p:from20200316to20200331
# ,p:from20200401to20200415
# ,p:from20200416to20200430
# ,p:from20200501to20200515
# ,p:from20200516to20200531
urlPart5 = ",a:all&mynews=0&start="
start = 0


# 고통의 시작
tit = c(); desc = c(); skip = c()
# 3월: 27,580, 4월: 24,779, 5월: 21,343이었지만, 모두 4000개만
for (i in 0:40) {
  start = i*100 + 1
  url = paste(urlPart1, query, urlPart2, sortNum, newsType, urlPart3, date1, urlPart4, date2, urlPart5, start, sep="")
  urlMoum = read_html(url)
  
  # /html/body/div[3]/div[2]/div/div[1]/section[1]/div/div[3]/ul/li[1]/div[1]/div/div[1]/div/a[2]
  middle_point = html_nodes(urlMoum, "div#container") %>% html_nodes("div#main_pack") %>%
                 html_nodes("ul.list_news") %>% html_nodes("div.news_area") %>% html_nodes("a.info") %>%
                 html_attr("href")
  
  for (j in 1:length(middle_point)) {
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

desc = c(tit, desc)
print(length(desc))


# 본격적으로 워드 클라우드 그리기
for (i in 1:6) { desc = c(desc, "") }
num = length(desc)/10

nouns_base = c()
for (i in 0:10) {
  result = nouns(iconv(desc[(i*num + 1):(i + 1)*num], "utf-8"))
  nouns_base = c(nouns_base, result)
}
# nouns_base = nouns(iconv(desc, "utf-8"))

nouns_base = unique(nouns_base)
nouns_base = unlist(nouns_base)
nouns_base = nouns_base[nchar(nouns_base) >= 2]


ele_nouns = gsub("[[:cntrl:]]", "", nouns_base)
ele_nouns = gsub("http*", "", ele_nouns)
ele_nouns = gsub("[[:punct:]]", "", ele_nouns)
ele_nouns = gsub("[A-Za-z]", "", ele_nouns)
ele_nouns = gsub("\\d+", "", ele_nouns)
ele_nouns = gsub(" ", "", fixed = TRUE, ele_nouns)

# about COVID-19
nouns = gsub("신종", "", ele_nouns)
nouns = gsub("코로나", "", nouns)
nouns = gsub("바이러스", "", nouns)
nouns = gsub("감염증", "", nouns)
nouns = gsub("확진자.*", "확진자", nouns)
nouns = gsub("감염자", "확진자", nouns)


final = nouns[nchar(nouns) >= 2]
wordFreq = table(final)
wordFreq = sort(wordFreq, decreasing = T)
# frequency = wordFreq[wordFreq >= 50]
set.seed(100)
wordcloud2(wordFreq, size = 1, color = "random-light")
