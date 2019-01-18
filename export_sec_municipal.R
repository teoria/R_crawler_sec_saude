library(rvest)
library(stringr)
library(dplyr)
lista_estados <- list.files("./secretaria_saude_municipal/")

 


salvaMunicipios <- function(estado,municipios){
        df <- data.frame(cargo=character(),nome=character(),email=character(),estado=character(),municipio=character())
        for(i in 1:length(municipios)){
                path <- paste("./secretaria_saude_municipal/",estado,"/municipios/",municipios[i],sep = "")
                htmlBruto <- read_html(path)
                htmlBody <- html_nodes(htmlBruto, "body")
                nomes <-str_extract_all(  paste(htmlBody) , '(de:<\\/strong>([ A-z])+)' )
                emails <-str_extract_all(  paste(htmlBody) ,'(Email:<\\/strong>[\\sA-z@.,]+)')
                
                nomes <- str_trim(str_replace_all(unlist(nomes), '<\\/strong>|Email:|Nome:|de:' , ''))
                emails <- str_trim(str_replace_all(unlist(emails), '<\\/strong>|Email:|Nome:| ' , ''))
                
                municipio <- str_replace_all( municipios[i] , "\\.html|» ","" )
                cargo <- "Secretário de Saúde"
                df <- df%>%add_row(cargo=cargo,nome=nomes,email=emails,estado=estado,municipio=municipio)
                
        }
        df
}

salvaCosms <- function(estado,cosms){
        path <- paste("./secretaria_saude_municipal/",estado,"/cosms/",cosms,sep = "")
        htmlBruto <- read_html(path)
        htmlBody <- html_nodes(htmlBruto, "body")
        
        html_paragrafos <- (html_nodes(htmlBody, "p") )
        cargo <- html_text(html_nodes(htmlBody, "h5 strong") )
        nomes <-str_extract_all(  paste(htmlBody) ,"(Nome:<\\/strong>[ A-z@.]+)" )
        emails <-str_extract_all(  paste(htmlBody) ,"(Email:<\\/strong>[ A-z@.]+)" )
          
       nomes<- str_trim(str_replace_all(unlist(nomes), '<\\/strong>|Email:|Nome:' , ''))
       emails<- str_trim(str_replace_all(unlist(emails), '<\\/strong>|Email:|Nome:' , ''))
       
       df <- data.frame(cargo=character(),nome=character(),email=character(),estado=character())
       for (i in 1:length(cargo)) {
               df<-df%>%add_row(
                       cargo=cargo[i],
                       nome=nomes[i],
                       email=emails[i],
                       estado=estado )
               
       }
        df
}


df_cosms <- data.frame(cargo=character(),nome=character(),email=character(),estado=character())
df_municipios <- data.frame(cargo=character(),nome=character(),email=character(),estado=character(),municipio=character())


for(i in 1:length(lista_estados)){
        path <- paste("./secretaria_saude_municipal/",lista_estados[i],sep = "")
        
        
        municipios <- list.files( paste("./secretaria_saude_municipal/",lista_estados[i],"/municipios",sep = "") )
        cosms <- list.files( paste("./secretaria_saude_municipal/",lista_estados[i],"/cosms",sep = "") )
        
        
        
        cosms_estado <- salvaCosms(lista_estados[i],cosms)
        print(
                paste(lista_estados[i]," - ",dim(cosms_estado))
                )
        df_cosms <- df_cosms%>%
                        bind_rows(cosms_estado)
        
        municipios_estado <- salvaMunicipios(lista_estados[i],municipios)
        df_municipios <- df_municipios%>%
                bind_rows(municipios_estado)
        
        
         
         
}





write.csv(df_cosms ,"relatorio/df_cosms.csv"  )
write.csv(df_municipios ,"relatorio/df_municipios.csv"  )
 