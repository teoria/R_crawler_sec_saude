library(rvest)


saveCOSMS <- function(estado){
        url_cosms <- paste("http://www.conasems.org.br/rede-conasems/rede-cosems-busca/?uf=",estado,sep = "")
        page <- read_html(url_cosms)
        path <- paste("./secretaria_saude_municipal/",estado,"/cosms", sep="")
        if(!dir.exists(path) ){
                dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
        }
        write(html_estado, paste(path,"/cosms_",estado,".html",sep = "") )
}

saveCapital<- function(estado){
        url_capital <- "http://www.conasems.org.br/rede-conasems/capital-busca/?uf=pe"
        page <- read_html(url_capital)
        path <- paste("./secretaria_saude_municipal/",estado,"/capital", sep="")
        if(!dir.exists(path) ){
                dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
        }
        write(html_estado, paste(path,"/capital_",estado,".html",sep = "") )
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
                write(html_estado, paste(path,"/",nomes[i],".html",sep = "") )
        }
       
}



url_nome_estados <- "http://www.conasems.org.br/rede-conasems/municipios"
page <- read_html(url_nome_estados)
lista_estado_html <- html_nodes(page, ".lista_de_estados a")
lista_estado <-html_attr(lista_estado_html,"data-estado")

for(i in 1:length(lista_estado)){
        if(!is.na(lista_estado[i])){
                
                estado <- lista_estado[i]
                
                path <- paste("./secretaria_saude_municipal/",estado,sep="")
                if(!dir.exists(path) ){
                        dir.create(path, showWarnings = TRUE, recursive = TRUE, mode = "0777")
                }
                
                saveCOSMS(estado)
                saveCapital(estado)
                saveMunicipios(estado)
                
        }  
}



