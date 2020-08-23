#!/bin/bash

# Autor: Michael Christian
# Versao: 1.0
# GitHub: mchristian279

# Variaveis Externas do Jenkins
#${ImagemBase}
#${Tag}

# Variaveis de Ambiente Globais
GitRepo="ProjetoGit"
GitRepoDir=`echo "$GitRepo" | cut -d '/' -f 5 | cut -d '.' -f 1`
UserRegistry="USUARIOREGISTRY"
PassRegistry="SENHA"
UrlRegistry="URLREGISTRY:18444"

# Login Registry - Loga na Registry privada para Pull e Push de Imagens Base
Login_Registry () {
    echo "Logando Registry" ;
    docker login -u "$UserRegistry" -p "$PassRegistry" "$UrlRegistry" 
}

# Build Imagem Docker - Recebe como parâmetro as variáveis ${ImagemBase} e ${Tag} do Jenkins
Build_Imagem () {
    echo "Realizando Build da Imagem..." ;
    docker build -t "$UrlRegistry"/"${ImagemBase}":"${Tag}" "$GitRepoDir"/
}

# Push Imagem Docker - Envia a Imagem Gerada para a Registry Privada
Push_Imagem () {
    echo "Versionando Imagem na Registry..." ;
    docker push "$UrlRegistry"/"${ImagemBase}":"${Tag}"  
}

# Executa a Função Login_Registry
Login_Registry ; 

# Executa a Função Build_Imagem
Build_Imagem

# Valida a execução da chamada da Função Build_Imagem
if [[ $? == 0 ]]; then
    Push_Imagem ;
    sleep 2;
    echo "Push "${ImagemBase}":"${Tag}" Realizado com Sucesso! "
else
    echo "Não foi possível realizar o Build da "${ImagemBase}":"${Tag}" " ;
exit
fi
