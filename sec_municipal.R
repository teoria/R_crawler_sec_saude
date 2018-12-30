library(rvest)


saveCOSMS <- function(estado){
        url_cosms <- paste("http://www.conasems.org.br/rede-conasems/rede-cosems-busca/?uf=",estado,sep = "")
        page <- read_html(url_cosms)
        data <- html_nodes(page ,"body")
        path <- paste("./secretaria_saude_municipal/",estado,"/cosms", sep="")
        if(!dir.exists(path) ){
                dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
        }
        pathFile <- paste(path,"/cosms_",estado,".html",sep = "")
        html_estado <- paste(  paste(data ,collapse = ""), sep = "")
        write(html_estado, pathFile)
}

saveCapital <- function(estado){
        url_capital <- paste("http://www.conasems.org.br/rede-conasems/capital-busca/?uf=",estado,sep="")
        page <- read_html(url_capital)
        path <- paste("./secretaria_saude_municipal/",estado,"/capital", sep="")
        if(!dir.exists(path) ){
                dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
        }
         
        pathFile <- paste(path,"/capital_",estado,".html",sep = "")
        html_estado <- paste(  paste(page ,collapse = ""), sep = "")
        write(html_estado, pathFile)
}

saveMunicipios<- function(estado){
        
        url_municipal <- paste("http://www.conasems.org.br/rede-conasems/municipios-busca/?uf=",estado,sep="")
        
        page <- read_html(url_municipal)
        cod_municipios_html <- html_nodes(page, ".cod_munici")
        nomes <- html_text(cod_municipios_html)
        codigos <- html_attr(cod_municipios_html,"data-municipio")
        
        
        for(i in 1:length(codigos)){
                url_municipal_codigo <- paste("http://www.conasems.org.br/rede-conasems/municipio-busca/?codigo_municipio=",codigos[i],sep="")
                page <- read_html(url_municipal_codigo)
                
                path <- paste("./secretaria_saude_municipal/",estado,"/municipios", sep="")
                if(!dir.exists(path) ){
                        dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
                } 
                pathFile <- paste(path,"/",nomes[i],".html",sep = "")
                html_estado <- paste(  paste(page ,collapse = ""), sep = "")
                write(html_estado, pathFile)
        }
       
}



url_nome_estados <- "http://www.conasems.org.br/rede-conasems/municipios"
page <- read_html(url_nome_estados)
lista_estado_html <- html_nodes(page, ".lista_de_estados a")
lista_estado <-html_attr(lista_estado_html,"data-estado")

for(k in 1:length(lista_estado)){
        
        estado <- lista_estado[k]
        if(!is.na(estado)){
                
                
                path <- paste("./secretaria_saude_municipal/",estado,sep="")
                if(!dir.exists(path) ){
                        dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
                }
                
                saveCOSMS(estado)
                saveCapital(estado)
                saveMunicipios(estado)
                
        }  
}



