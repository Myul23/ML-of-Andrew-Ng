library(RCurl)
library(XML)
library(RmecabKo)

searchUrl = "https://openapi.naver.com/v1/search/news.xml"
Client_id = "meUW9o4dR901QC46CxBi"
Client_Secret = "bIjrLxseMd"

query = URLencode(iconv("코로나", "euc-kr", "UTF-8"))
url = paste(searchUrl, "?query=", query, "&desplay=20", sep="")

doc = getURL(url, httpheader = c("Content-Type" = "application/xml",
             "X-Naver-Client-id" = Client_id, "X-Naver-Client-Secret" = Client_Secret))
