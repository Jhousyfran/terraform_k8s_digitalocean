# Deploy Kubernetes na Digital Ocean (DNS + TLS)
Este é um repositório de exemplo que usa o terraform para criar um cluster k8s da Digital Ocean, com entradas DNS e certificados TLS.

## Como usar
* É necessário que tenha servidores de nomes apontados para a Digital Ocean.

1. Carregue seu token de acesso
```bash
export DIGITALOCEAN_ACCESS_TOKEN=seu_toke_aqui
```


2. Configure as variaveis
```bash
make init
```
Edite o arquivo terraform.tfvars, setando as variaveis com valores que achar necessario.


3. Verifique se está tudo OK, depois crie sua infra
```bash
make plan
make apply
```

4. Depois de brincar, recolha os brinquedinhos
```bash
make destroy
```
