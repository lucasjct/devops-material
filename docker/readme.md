* baixar imagem:  
`docker pull <nome-imagem>`   

* Utilizando tags:
`docker pull <nome_imagem>: tag`
``docker container run <nome_image>:tag`

* Listar todos os container:    
`docker container ls -a`   

* Executar container:   
`docker container run <nome-container>`   

* Executar container para interagir com a linha de comando do próprio container:   
`docker container run -ti <nome-container>`   

* Entrar e executar comandos bash no container:  
`docker container exec -ti <id_container> bash`   

* Executar e nomear containers:  
`docker run -dti <name> <imagem>`    
Exemplo: `docker container run -dti ubuntu-dbserver ubuntu`   

* Copiar um arquivo para um container:   
`docker cp arquivo.ext <name_container>:/<diretorio>`    

 * Copiar varios arquivos (enviar zipado):  
`docker cp <meus_arquivos.zip> <nome_container>:/<destino>`

* Verificar detalhes de configuração do container:  
`docker inspect <nome-container>`

* Verificar imagens:   
`docker images`

* Deletar imagem:  
`docker -rmi <nome_imagem>`  

* Exluir container forçando a parada da execução:    
`docker container rm -f <id_container>`

* Excluir containers:
`docker container prune`

* Pausar container:     
`docker stop <id_container>`


## Exemplo de instalação MySQL:  

* `docker pull mysql`
* `docker container run -e MYSQL_ROOT_PASSWORD=senha123 --name mysql-A -d -p 3306:3306 mysql`
* `docker container exec -ti mysql-A bash`
* `mysql -u root -p --protocol=tcp`
	* CREATE DATABASE exemplo;
	* SHOW DATABASES;
	



## Armazenamento de Dados   

### Tipo Bind (usuário determina qual será o diretório utilizado):

* Montar diretório do container com diretório do host:
exemplo com mysql:
* Identificar diretoório destino do container que será usado para armazenar dado no diretório do host:
`docker inspect mysql-A | grep Destination`

`docker container run -e MYSQL_ROOT_PASSWORD=senha123 --name mysql-exemplo -d -p 3306:3306 --volume=/data/mysql-A:/var/lib/mysql mysql`   

Podemos subir outro container com o mesmo diretório que os dados continuarão   armazenados/mapeados no diretório /data/mysql-A  

### Tipos de Mount

* Bind
	* Vincular um diretório ou arquivo dentro de um container. EX: `docker run -dti --mount type=bind,src=/data/Debian-A,dst=/data debian`.  
	Exemplo 2: docker container run -d -ti --name meu-container --mount type=bind, source="$(pwd)"/target, target=teste-dir nginx

* Namded
	* criamos manualmente com o comando: `docker volume create nome-volume` serã criado no diretório padrão do Dockr /var/lib/docker e poderão ser apenas referenciados pelo nome.  

* DockerFile  
	* Criados pela instrução VOLUME dentro do Dockerfile.  


Criar volume:  
* docker volume create <nome-volume>   

Instrução para tipo volume: 
* `docker run -dti --mount type=volume src=<nome do volime criado no host>,dst=/data --name <nome do container> <imagem> `

EXEMPLO: `docker run -dti --mount type=volume src=backup,dst=/data --name centos-backup centos`  

obs: sempre que estivermos com dúvidas sobre o tipo de mont, podemos executar:
`docker container inspect <nome-container>` 

Exlucir todos os volumes que foram gerados no host:

* `docker volume prune`



### Limitar a quantidade de memoria e cpu do container

`docker container run --name meu-container -d -ti -m 128M -cpu 0.2 imagem`

#### Para atualizar o limite de recurso, posso utiliza por exemplo: `docker container update <nome-container>` -m 126M

Posso estressar o container utilizando o programa stress: `apt update && apt install stress`

### Verificar infos do container
docker container infos <nome-do-container>

### Verficar logs
docker container logs <nome-do-container>  

### Verificar processoss em execução
docker container top <nome-do-container>   

### Redes  

* verificar as redes associadas ao docker:  
`docker network ls`  

* inpencionar as redes:  
`docker network inspect <nome-da-rede>`  

* criar uma rede para isolar a comunicação entre containers:  
`docker network create minha-rede` 
	* Conectar container na rede criada:  
		`docker container run -d -ti --name ubuntu-teste --network minha-rede ubuntu`





