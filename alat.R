
library(tidyverse)
library(jsonlite)
library(kaariLaskuri)

ytunnukset <- org_meta %>% 
    filter(tyyppiluokka=="Osakeyhtiöt",
           tila=="Voimassaoleva",
           vakuutetut_3112>0) %>% 
    .$ytunnus

urls <- paste0("http://avoindata.prh.fi:80/bis/v1/", ytunnukset)


companies <- urls %>% lapply(fromJSON)

codes <- companies %>% 
    sapply(function(x) x$results$businessLines[[1]]$code[1])

tilastokeskusUrl <- "http://www.stat.fi/meta/luokitukset/toimiala/001-2008/luokitusavain_2_teksti.txt"
codeKeys <- read.delim(tilastokeskusUrl,
                       skip = 3,
                       encoding = "latin1",
                       stringsAsFactors = F) %>% 
    select(1, 3, 6) 

alat <- data_frame(koodi.1=codes) %>% 
    left_join(codeKeys)
