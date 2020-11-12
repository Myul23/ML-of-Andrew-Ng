# 단어 추출
library(rvest)
library(tm)
library(RmecabKo)

# 네트워크 그리기
library(network)
library(RColorBrewer)
library(GGally)
library(sna)

# 이미지 저장?
library(htmlwidgets)
library(webshot)

# base url setting
urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=코로나"
urlPart2 = "&sm=tab_pge"
sortNum = "&sort=1"
newsType = "&photo=3"
urlPart3 = "&field=0&reporter_article=&pd=3"
date_1 = c("&ds=2020.01.01&de=2020.01.31", "&ds=2020.02.01&de=2020.02.29",
           "&ds=2020.03.01&de=2020.03.31", "&ds=2020.04.01&de=2020.04.30",
           "&ds=2020.05.01&de=2020.05.31", "&ds=2020.06.01&de=2020.06.30",
           "&ds=2020.07.01&de=2020.07.31", "&ds=2020.08.01&de=2020.08.30",
           "&ds=2020.09.01&de=2020.09.31", "&ds=2020.10.01&de=2020.10.30")
urlPart4 = "&docid=&nso=so:r"
date_2 = c(",p:from20200101to20200131", ",p:from20200201to20200229",
           ",p:from20200301to20200331", ",p:from20200401to20200430",
           ",p:from20200501to20200531", ",p:from20200601to20200630",
           ",p:from20200701to20200731", ",p:from20200801to20200830",
           ",p:from20200901to20200931", ",p:from20201001to20201030")
urlPart5 = ",a:all&mynews=0&start="
start = 0


# 고통의 시작
skip = c()
for (k in 1:length(date_1)) {
  tit = c(); desc = c()
  for (i in 0:40) {
    # read page (having site links)
    date1 = date_1[k]; date2 = date_2[k]
    start = i*100 + 1
    url = paste(urlPart1, query, urlPart2, sortNum, newsType, urlPart3, date1, urlPart4, date2, urlPart5, start, sep="")
    urlMoum = read_html(url)


    # links
    middle_point = html_nodes(urlMoum, "div#container") %>% html_nodes("div#main_pack") %>%
                   html_nodes("ul.list_news") %>% html_nodes("div.news_area") %>%
                   html_nodes("a.info") %>% html_attr("href")

    for (j in 1:length(middle_point)) {
      tryCatch({ element_base = read_html(middle_point[j]) },
          error = function(e) { skip = c(skip, middle_point[j]) })

      # text
      tryCatch({
        title = html_nodes(element_base, "div#main_content") %>%
                html_nodes("h3#articleTitle") %>% html_text()
        description = html_nodes(element_base, "div#main_content") %>%
                      html_nodes("div#articleBodyContents") %>% html_text()
        tit = c(tit, title)
        desc = c(desc, description)
      }, error = function(e) { skip = c(skip, middle_point[j]) })
    }
    print(c(k, "middle"))
  }; rm(i); rm(j)
  desc = c(tit, desc)


  # 단어 추출
  while (length(desc) %% 10 != 0) { desc = c(desc, "") }
  num = length(desc)/10
  nouns_base = c()
  for (i in 0:10) {
    result = nouns(iconv(desc[(i*num + 1):(i + 1)*num], "utf-8"))
    nouns_base = c(nouns_base, result)
  }; rm(i)


  # 단어 정제 과정
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
  
  nouns = gsub("네이버", "", nouns)
  nouns = gsub("무단", "", nouns)
  nouns = gsub("배포", "", nouns)
  nouns = gsub("전재", "", nouns)
  nouns = gsub("금지", "", nouns)
  nouns = gsub("한국", "", nouns)
  nouns = gsub("뉴스", "", nouns)
  nouns = gsub("기자", "", nouns)

  final = table(nouns[nchar(nouns) >= 2])
  final = sort(final, decreasing = T)

  # 언급 1번 제거
  wordFreq = data.frame(final[final >= 3])
  # 단어별로 상대빈도 구하기
  wordFreq[, 2] = wordFreq[, 2] / sum(wordFreq[, 2])

  # 빈도 가중치로 (n X n) 행렬 만들기
  freq_base = wordFreq
  words = freq_base[, 1]
  freq = freq_base[, -c(1)]

  corFreq = matrix(0, ncol = length(freq), nrow = length(freq))
  for (i in 1:length(freq)) {
    for (j in 1:length(freq)) {
      if (i == j) { corFreq[i, j] = 1
      } else { corFreq[i, j] = freq[i] * freq[j] * 100 }
      # 과연 곱을 가중치로 두는 것이 맞을까?
  }}; rm(i); rm(j)
  rownames(corFreq) = words
  colnames(corFreq) = words

  # network 그리기
  # https://bookdown.org/yuaye_kt/RTIPS/Texnetword-2.html, https://rfriend.tistory.com/221
  # https://briatte.github.io/ggnet/#node-labels

  # 의미없을 것 같은 행과 열 지우기
  real_final = corFreq
    
  # 1. 행(or 열) 합이 너무 작으면 제거
  sum_value = seq(1, 1.05, 0.0002)
  for (min_sum in sum_value) {
    removeList = c()
    for (i in 1:dim(real_final)[1]) {
      if (sum(real_final[i,]) < min_sum) { removeList = c(removeList, i) }
    }; rm(i)

    if (!is.null(removeList)) {
      real_final = real_final[, -removeList]
      real_final = real_final[-removeList, ]
    }
    if (dim(real_final)[1] != dim(real_final)[2]) { error("stop!!!") }

    # 2. 각각의 빈도 가중치가 너무 작으면 제거 (복잡하지 않도록)
    values = seq(0.005, 0.009, 0.001)
    for (min_value in values) {
      real_final[real_final <= min_value] = 0

      # 진짜 그리기
      netTerms = network(x = real_final, directed = F)
      # 상위 5%만 색을 달리주는 건데 하지 말까?
      netTerms %v% "mode" = ifelse(betweenness(netTerms) >= quantile(betweenness(netTerms),
                                   probs = 0.95, na.rm = T), yes = "Top", no = "Rest")
      set.edge.value(netTerms, attrname = "edgeSize", value = real_final * 40)

      for (i in c(3, 5, 10, 15, 20)) {
        tryCatch({
          name = paste("images/network_", k,
                       "_min.sum", min_sum, "_min.value", min_value,
                       "_size.min", i, ".jpg", sep = "")
          jpeg(name, width = 600, height = 600)
          set.seed(100)
          gn = ggnet2(netTerms, mode = "fruchtermanreingold", size.min = i,
                      node.size = degree(netTerms)/5, node.color = "mode",
                      palette = c("Top" = "darkturquoise", "Rest" = "azure"),
                      edge.size = "edgeSize", edge.color = "grey60",
                      label = T, label.size = 10, label.color = "black") +
                      theme(plot.title = element_text(hjust = 5, face = "bold")) # +
                      # theme(panel.background = element_rect(fill = "grey15"))
          print(gn)
          dev.off()
        }, error = function(e) { skip = c(skip, name) })
      }; rm(i)
    }
  }
  print(c(k, "finish"))
}; rm(min_value); rm(min_sum); rm(k)
