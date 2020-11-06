library(rvest)
library(tm)
library(RmecabKo)
library(network)
library(RColorBrewer)
# library(sna)
library(GGally)

# base url setting
urlPart1 = "https://search.naver.com/search.naver?&where=news"
query = "&query=코로나"
urlPart2 = "&sm=tab_pge"
sortNum = "&sort=0"
newsType = "&photo=3"
urlPart3 = "&field=0&reporter_article=&pd=3"
date_1 = c("&ds=2020.01.01&de=2020.02.29", "&ds=2020.03.01&de=2020.03.31",
           "&ds=2020.04.01&de=2020.04.30", "&ds=2020.05.01&de=2020.05.31",
           "&ds=2020.06.01&de=2020.06.30", "&ds=2020.07.01&de=2020.07.31",
           "&ds=2020.08.01&de=2020.08.30", "&ds=2020.09.01&de=2020.09.31",
           "&ds=2020.10.01&de=2020.10.30")
urlPart4 = "&docid=&nso=so:r"
date_2 = c(",p:from20200101to20200229", ",p:from20200301to20200331",
           ",p:from20200401to20200430", ",p:from20200501to20200531",
           ",p:from20200601to20200630", ",p:from20200701to20200731",
           ",p:from20200801to20200830", ",p:from20200901to20200931",
           ",p:from20201001to20201030")
urlPart5 = ",a:all&mynews=0&start="
start = 0


# 고통의 시작
top20 = c(); freq_base = data.frame(c()); skip = c()
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
  nouns = gsub("감염자", "확진자", nouns)

  nouns = gsub("네이버", "", nouns)
  # nouns = gsub("무단전재금지", "", nouns)

  final = table(nouns[nchar(nouns) >= 2])
  final = sort(final, decreasing = T)


  # 달별 최소 언급 횟수 5이상
  wordFreq = data.frame(final[final >= 5])
  if (length(top20) == 0) { top20 = wordFreq[1:20,]
  } else { top20 = merge.data.frame(top20, wordFreq[1:20,], by = "Var1", all = T) }


  # 단어별로 상대빈도를 구한 후, 전체 테이블과 합치기
  wordFreq[, 2] = wordFreq[, 2] / sum(wordFreq[, 2])
  if (length(freq_base) == 0) { freq_base = wordFreq
  } else { freq_base = merge.data.frame(freq_base, wordFreq, by = "Var1", all = T) }
  print(c(k, "finish"))
}; rm(k)
# write.csv(freq_base, "once_save.csv")
freq_base[1:10,]


# 빈도 가중치로 (n X n) 행렬 만들기
words = freq_base[, 1]
freq = freq_base[, -c(1)]

# 이후 있을 가중치 행렬을 위해 NA를 0으로 바꾸는 작업
for (i in 1:dim(freq)[2]) {
  freq[i][is.na(freq[i])] = 0
}; rm(i)

corFreq = matrix(0, ncol = dim(freq)[1], nrow = dim(freq)[1])
for (i in 1:dim(freq)[1]) {
  for (j in 1:dim(freq)[1]) {
    if (i == j) { corFreq[i, j] = 1
    } else {
      for (k in 1:dim(freq)[2]) {
        if (freq[i, k] * freq[j, k] != 0) { corFreq[i, j] = freq[i, k] * freq[j, k] }
        # 과연 곱을 가중치로 두는 것이 맞을까?
}}}}; rm(i); rm(j); rm(k)
rownames(corFreq) = words
colnames(corFreq) = words
corFreq[1:10, 1:10]


# sorting 안했음, https://rpubs.com/enlik/wordcloud
# top20 <- head(d, 20)
# top20$word <- reorder(top20$word, top20$freq)

# ggplot(top20, aes(x = word, y = freq, fill = word, label = freq)) +
#   geom_bar(stat="identity", show.legend = FALSE) +
#   coord_flip() +
#   labs(title = "Top 20 Most Used Words in Movie Title", x = "Word", y = "Word Count") +
#   geom_label(aes(fill = word),colour = "white", fontface = "bold", show.legend = FALSE)


# network로 그리기
# https://bookdown.org/yuaye_kt/RTIPS/Texnetword-2.html, https://rfriend.tistory.com/221
# https://briatte.github.io/ggnet/#node-labels
colorList = c(list("1-2월"), c("3월"), c("4월"), c("5월"), c("6월"), c("7월"), c("8월"), c("9월"), c("10월"))
for (i in 2:dim(freq_base)[2]) {
  for (j in 1:dim(freq_base)[1]) {
    if (!is.na(freq_base[j, i])) { colorList[[i - 1]] = c(colorList[[i - 1]], j) }
}}; rm(i); rm(j)

colorL = c("cadetblue1", "aquamarine", "springgreen", "turquoise", "cyan3", "aquamarine3", "deepskyblue", "deepskyblue3", "turquoise4")
# colorL = c("firebrick2", "thistle1", "coral2", "khaki", "seagreen3", "darkgreen", "royalblue1", "purple2", "grey33")
# 왜 edge마다 색상 주는 게 다중 그룹 데이터는 안 되냐.
# 중복에 경우, 먼저 언급된 월에 더 가중치를 준 듯한 모양새. (물론 가중치를 줬다기보단 그냥 그 값을 줘버린 거지만.)
colorT = matrix(nrow = dim(corFreq)[1])
for (i in 1:length(colorT)) {
  for (j in 1:length(colorList)) {
    if (any(i == colorList[[j]])) {
      colorT[i] = colorL[j]
      break
}}}; rm(i); rm(j)
colorT = colorT[, 1]

# colorT = matrix(nrow = dim(corFreq)[1], ncol = dim(corFreq)[2])
# for (i in 1:length(colorList)) {
#   for (j in 2:length(colorList[[i]])) {
#     for (k in 2:length(colorList[[i]])) {
#       # colorT[j - 1, k - 1] = colorL[i]
# }}}; rm(i); rm(j); rm(k)
# colorT[1:10, 50:55]

# NA to white
# for (i in 1:dim(colorT)[2]) {
#   colorT[i,][is.na(colorT[i,])] = "grey15"
# }; rm(i)


# 의미없을 것 같은 행과 열 지우기
real_final = corFreq

# 1. 각각의 빈도 가중치가 너무 작으면 제거
real_final[real_final <= 0.0015] = 0 # 너무 복잡하지 않도록 조정합니다.

# 2. 행(or 열) 합이 너무 작으면 제거
# removeList = c()
# for (i in 1:dim(real_final)[1]) {
#   if (sum(real_final[i,]) < 1.02) { removeList = c(removeList, i) }
# }; rm(i)
# real_final = real_final[, -removeList]
# real_final = real_final[-removeList, ]

# colorT = colorT[-removeList]
if (dim(real_final)[1] == dim(real_final)[2]) {
  if (dim(real_final)[1] == length(colorT)) { dim(real_final)
}}

# colorT = colorT[, -removeList]
# colorT = colorT[-removeList, ]
# if (dim(real_final)[1] == dim(real_final)[2]) {
#   if (dim(colorT)[1] == dim(colorT)[2]) {
#     if (dim(real_final)[1] == dim(colorT)[1]) { dim(real_final) }
# }}

# 진짜 그리기
netTerms = network(x = real_final, directed = F)
# netTerms
# plot(netTerms, vertex.cex = 1) # 중간 확인
netTerms %v% "mode" = ifelse(test = betweenness(netTerms) >= quantile(betweenness(netTerms), probs = 0.95, na.rm = T), yes = "Top", no = "Rest")
set.edge.value(netTerms, attrname = "edgeSize", value = real_final * 400)
set.edge.attribute(netTerms, "color", colorT)

# for문으로 깔끔하게 뽑고 싶었지만, 왜 인지 실패.
set.seed(100)
ggnet2(netTerms, mode = "fruchtermanreingold", size.min = 20,
       node.size = degree(netTerms), node.color = "mode", palette = c("Top" = "darkturquoise", "Rest" = "azure"),
       edge.size = "edgeSize", edge.color = "color",
       label = T, label.size = 5, label.color = "grey13") +
       theme(plot.title = element_text(hjust = 5, face = "bold")) # +
      #  theme(panel.background = element_rect(fill = "grey15"))
