library(rvest)
library(stringr)
lista_estados <- list.files("./secretarias_saude/")

nomes <- list()
dados <- list()
for(i in 1:length(lista_estados)){
        path <- paste("./secretarias_saude/",lista_estados[i],sep = "")
        estado2 <- read_html(path)
        estados_html <- html_nodes(estado2, "body")
        
        html_estado <- (html_nodes(estados_html, "p") )
          
        
        lista_find <- grepl("[é formado|<p><strong>]",html_estado)
        for(j in 1:length(lista_find )){
                if(lista_find[j]){
                        paragrafo_nome <- (html_text(html_estado[j+1]))
                        nomes[[i]]<-paragrafo_nome
                        break;
                }
        }
        
        paragrafo_email <- paste(html_estado[
                                grepl(".@",html_estado)
                        ])
        
        email <-str_extract_all(paragrafo_email,":\\b[\\w\\.-]+@[\\w\\.-]+\\.\\w{2,4}\\b")        
       
        
       dados[[i]] <-  
                str_replace_all( 
                paste( 
                        lista_estados[i],
                        "#", paste(email,collapse = ",",sep = "") ,
                        sep = ""
                         ) 
                                ,
                                'c\\(|\\.html|:|\"|\\)|\\,character\\(0'  ,
                                ''
                                
                              
                        ) 
         
}

write(unlist(dados) ,"sec_estaduais_temp.csv"  )

library(readr)
sec_estaduais <- read_delim("sec_estaduais_temp.csv", 
                            "#",
                            escape_double = FALSE, 
                            col_names = FALSE, 
                            trim_ws = TRUE)
 

nomes <- c(
        "Rui Emanuel Rodrigues Arruda",
        "Carlos Christian Reis Teixeira",
        "Gastão Valente Calandrini de Azevêdo",
        "Francisco Deodato Guimarães",
        "Fábio Vilas Boas",
        "Henrique Jorge Javi de Sousa",
        "Humberto Fonseca",
        "Ricardo de Oliveira",
        "Leonardo Vilela",
        "Carlos Eduardo de Oliveira Lula",
        "Carlos Alberto Moraes Coimbra",
        "Luiz Antonio Vitório Soares",
        "Luiz Sávio de Souza Cruz",
        "Antonio Carlos Figueiredo Nard",
        "Cláudia Luciana de Sousa Mascena Veras",
        "Vitor Manuel Jesus Mateus",
        "José Iran Costa Júnior",
        "Florentino Neto",
        "Sérgio D’Abreu Gama",
        "Sidney Domingos Ferreira de Souza e Santos",
        "Francisco Antônio Zancan Paz",
        "Luis Eduardo Maiorquin",
        "Antonio Leocádio Vasconcelos Filho",
        "Acélio Casagrande",
        "Valberto de Oliveira Lima",
        "Marco Antônio Zargo",
        "Renato Jayme da Silva"
)

sec_estaduais$nome <- nomes
names(sec_estaduais) <- c("Estado","Email","Nome")

write.csv(sec_estaduais,"./relatorio/sec_estaduais.csv" ,row.names = FALSE )


