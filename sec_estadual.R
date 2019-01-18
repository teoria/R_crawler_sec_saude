library(rvest)
url <-'http://www.conass.org.br/category/secretaria-de-estado-da-saude'
page<-read_html(url)
estados_html <- html_nodes(page, ".link-estados")

estados<-html_attr(estados_html,"href")
nomes <- html_text(estados_html)

getData_sec_estadual<- function(estados,nomes){
        for(i in 1:length(estados)){
                estado2 <- read_html(estados[i])
                estados_html <- html_nodes(estado2, "main")
                html_estado <- paste("<div>", paste(html_nodes(estados_html, "p") ,collapse = ""),"</div>", sep = "")
                write(html_estado, paste("./secretarias_saude/",nomes[i],".html",sep = "") )
        }    
}

parseData_sec_estadual <- function(estados,nomes){
        for(i in 1:length(estados)){
                path <- paste("./secretarias_saude/",nomes[i],".html",sep = "") 
                data <- read_html(path)
                estados_html <- html_nodes(data, "p")
        }   
}


path <- "./secretarias_saude"
if( !dir.exists(path)){
        dir.create(path, showWarnings = TRUE, recursive = FALSE, mode = "0777")
        getData_sec_estadual(estados,nomes)
}

 
