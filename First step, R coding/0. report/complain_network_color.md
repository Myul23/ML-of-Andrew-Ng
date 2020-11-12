top20도 뽑아놓고 안 함.

- sorting 안했음, <https://rpubs.com/enlik/wordcloud>

```
top20 <- head(d, 20)
top20$word <- reorder(top20$word, top20$freq)

ggplot(top20, aes(x = word, y = freq, fill = word, label = freq)) +
  geom_bar(stat="identity", show.legend = FALSE) +
  coord_flip() +
  labs(title = "Top 20 Most Used Words in Movie Title", x = "Word", y = "Word Count") +
  geom_label(aes(fill = word),colour = "white", fontface = "bold", show.legend = FALSE)
```


try_word_network에서 color로 설정된 행렬이 먹지 않아 주석처리 되어버린 n X n 행렬 만들기

```
colorL = c("firebrick2", "thistle1", "coral2", "khaki", "seagreen3", "darkgreen", "royalblue1", "purple2", "grey33")
```

```
colorT = matrix(nrow = dim(corFreq)[1], ncol = dim(corFreq)[2])
for (i in 1:length(colorList)) {
  for (j in 2:length(colorList[[i]])) {
    for (k in 2:length(colorList[[i]])) {
      colorT[j - 1, k - 1] = colorL[i]
}}}; rm(i); rm(j); rm(k)
colorT[1:10, 50:55]

# NA to white
for (i in 1:dim(colorT)[2]) {
  colorT[i,][is.na(colorT[i,])] = "grey15"
}; rm(i)
```

의미없는 행, 열 지우기

```
colorT = colorT[, -removeList]
colorT = colorT[-removeList, ]
if (dim(real_final)[1] == dim(real_final)[2]) {
  if (dim(colorT)[1] == dim(colorT)[2]) {
    if (dim(real_final)[1] == dim(colorT)[1]) { dim(real_final) }
}}
```
