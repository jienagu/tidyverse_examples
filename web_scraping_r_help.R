


#Loading the rvest package
library('rvest')
library(purrr)
library(tidyverse)
## Create year month list
current_month=as.Date(cut(Sys.Date(), "month"))
date_seq=seq(from=as.Date("1997-04-01"),to=current_month , by="1 month")
trans_month=format(as.Date(date_seq), "%Y-%B")

### Make a function to fetch the summarized data frame for every month
unnecessary=c("thread.html#start",
              "author.html#start",
              "date.html#start",
              "https://stat.ethz.ch/mailman/listinfo/r-help")

scraplinks_JM <- function(x){
  #Specifying the url for desired website to be scraped
  url_base <- 'https://stat.ethz.ch/pipermail/r-help/%s/subject.html'
  
  test_web=read_html(sprintf(url_base, x) )
  # Extract the URLs
  url_ <- test_web %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  # Extract the link text
  link_ <- test_web %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  test_df=data.frame(link = link_, url = url_)
  test_df2=test_df[which(!is.na(test_df$url)),]
  test_df3=test_df2[which(! test_df2$url %in% unnecessary),]
  test_df3$link=gsub("[\r\n]", " ", test_df3$link)
  test_df3$url=paste0("https://stat.ethz.ch/pipermail/r-help/", x,"/",test_df3$url)
  test_df4=test_df3 %>% 
    group_by(link) %>%
    dplyr::mutate(
      Link_url = dplyr::first(url)
    ) %>% group_by(link,Link_url ) %>% 
    summarize(
      count=n()
    ) 
  test_df4=data.frame(test_df4)
  return(test_df4)
}


### Purrr to every month
output=map(trans_month, ~ scraplinks_JM(.x))
## Combine the output
everything=do.call("rbind", output)
## sort by count
everything2=everything%>% 
  arrange(desc(count))
everything2[1:10,]

