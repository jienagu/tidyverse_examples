
### What is the max page of COS


### 20 posts per page, loop to investigate the max page
pages=c(1400:1500)
for (i in pages) {
  cos_base <- 'https://d.cosx.org/all?page=%s'
  COS_link2 <- read_html(sprintf(cos_base, i) )
  url_vector=COS_link2 %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  last_link=url_vector[length(url_vector)]
  
  last_number<-as.numeric(gsub("[https://d.cosx.org/all?page=]", "",last_link) )
  
  if(last_number<=i-1){
    print(i)
    break
  }
}
## Totally COS has 1422 pages, 28430 (20*1421+10) posts, COS was created in 2006, and the first post was created in "2006-05-20T21:32:35+00:00"
## This is the first post: https://d.cosx.org/d/5-5 


### Now, create a function to fetch info from every page
### Alert: since COS has 1422 pages, it might takes a while to run...
cos_per_page=function(x){
  library(rvest)
  library(jsonlite)
  library(stringr)
  cos_base <- 'https://d.cosx.org/all?page=%s'
  url  <- sprintf(cos_base, x) 
  r <- read_html(url) %>% 
    html_nodes('body') %>% 
    html_text() %>% 
    toString()
  
  x <- str_match_all(r,'flarum\\.core\\.app\\.load\\((.*)\\);')  
  json <- jsonlite::fromJSON(x[[1]][,2])
  
  df_per_page=data.frame(link_id=json$apiDocument$data$id, Comment_count=json$apiDocument$data$attributes$commentCount,
                         Participant_count=json$apiDocument$data$attributes$participantCount, 
                         create_at=json$apiDocument$data$attributes$createdAt,
                         last_post_at=json$apiDocument$data$attributes$lastPostedAt  )
  return(df_per_page)
}
### Be careful, it takes a long while to run...
output_cos=map(c(1:1422), ~ cos_per_page(.x))
## Combine the output
everything_cos=do.call("rbind", output_cos)

everything_cos[1:10,]
everything_cos$URL=paste0("https://d.cosx.org/d/",everything_cos$link_id)
everything_cos$create_Date=as.Date(everything_cos$create_at)
everything_cos$last_post_Date=as.Date(everything_cos$last_post_at)
everything_cos$active_days=as.numeric(everything_cos$last_post_Date-everything_cos$create_Date)

everything_cos2=everything_cos[,c(2,3,6,7,8,9)]

everything_cos2[1:2,]

### sort by Comment/replies count

everything_cos2_replies=everything_cos2%>% 
  arrange(desc(Comment_count))

everything_cos2_replies[1:10,]
### By participants
everything_cos2_participants=everything_cos2%>% 
  arrange(desc(Participant_count))

everything_cos2_participants[1:10,]
### By active days
everything_cos2_active_days=everything_cos2%>% 
  arrange(desc(active_days))

everything_cos2_active_days[1:10,]





