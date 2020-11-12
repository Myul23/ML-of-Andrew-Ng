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
write.csv(freq_base, "once_save.csv")
# freq_base[1:10,]


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
# corFreq[1:10, 1:10]


# top20은 시간상 제외

# network 그리기
# https://bookdown.org/yuaye_kt/RTIPS/Texnetword-2.html, https://rfriend.tistory.com/221
# https://briatte.github.io/ggnet/#node-labels
colorList = c(list("1-2월"), c("3월"), c("4월"), c("5월"), c("6월"), c("7월"), c("8월"), c("9월"), c("10월"))
for (i in 2:dim(freq_base)[2]) {
  for (j in 1:dim(freq_base)[1]) {
    if (!is.na(freq_base[j, i])) { colorList[[i - 1]] = c(colorList[[i - 1]], j) }
}}; rm(i); rm(j)

colorC = c("cadetblue1", "aquamarine", "springgreen", "turquoise", "cyan3",
  "aquamarine3", "deepskyblue", "deepskyblue3", "turquoise4")
colorR = rainbow(9)
for (colorL in c(colorC, colorR)) {
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


# 의미없을 것 같은 행과 열 지우기
real_final = corFreq

# 1. 행(or 열) 합이 너무 작으면 제거
sum_value = seq(1, 1.05, 0.0002)
for (min_sum in sum_value) {
removeList = c()
for (i in 1:dim(real_final)[1]) {
  if (sum(real_final[i,]) < min_sum) { removeList = c(removeList, i) }
}; rm(i)

real_final = real_final[, -removeList]
real_final = real_final[-removeList, ]
colorT = colorT[-removeList]
if (dim(real_final)[1] == dim(real_final)[2]) {
  if (dim(real_final)[1] == length(colorT)) { dim(real_final)
}}

# 2. 각각의 빈도 가중치가 너무 작으면 제거 (복잡하지 않도록)
values = seq(0, 0.002, 0.0002)
for (min_value in values) {
real_final[real_final <= min_value] = 0


# 진짜 그리기
netTerms = network(x = real_final, directed = F)
# netTerms # network 구성 확인

# 상위 5%만 색을 달리주는 건데 하지 말까?
netTerms %v% "mode" = ifelse(test = betweenness(netTerms) >= quantile(betweenness(netTerms),
    probs = 0.95, na.rm = T), yes = "Top", no = "Rest")
set.edge.value(netTerms, attrname = "edgeSize", value = real_final * 400)
set.edge.attribute(netTerms, "color", colorT)

for (i in c(2, 3, 5, 10, 15, 20, 25, 30, 50)) {
  ht_name = paste("C:/Users/samsung/Documents/images/htmls/gn", k, ".html", sep = "")
  name = paste("images/network", k, "_size", i, ".jpg", sep = "")
  set.seed(100)
  gn = ggnet2(netTerms, mode = "fruchtermanreingold", size.min = i,
              node.size = degree(netTerms), node.color = "mode",
              palette = c("Top" = "darkturquoise", "Rest" = "azure"),
              edge.size = "edgeSize", edge.color = "color",
              label = T, label.size = 5, label.color = "grey13") +
              theme(plot.title = element_text(hjust = 5, face = "bold")) # +
              #  theme(panel.background = element_rect(fill = "grey15"))
  saveWidget(gn, ht_name, selfcontained = F)
  webshot(ht_name, name, delay = 10)
}; rm(i)
