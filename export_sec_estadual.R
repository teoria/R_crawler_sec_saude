library(rvest)
library(stringr)
lista_estados <- list.files("./secretarias_saude/")


for(i in 1:length(lista_estados)){
        path <- paste("./secretarias_saude/",lista_estados[i],sep = "")
        estado2 <- read_html(path)
        estados_html <- html_nodes(estado2, "body")
        
        html_estado <- (html_nodes(estados_html, "p") )
          
        
        lista_find <- grepl("<p><strong>Secret",html_estado)
        for(j in 1:length(lista_find )){
                if(lista_find[j]){
                        paragrafo_nome <- (html_text(html_estado[j+1]))
                        break;
                }
        }
        
        paragrafo_email <- paste(html_estado[
                
                grepl(".@",html_estado)
                ])
        
        email <-str_extract_all(paragrafo_email,"\\b[\\w\\.-]+@[\\w\\.-]+\\.\\w{2,4}\\b")        
        
        print( paste( paragrafo_nome," - ", email) )
}
