# IP Rotation

Este é um script em Bash desenvolvido para simplificar operações de varredura, tirando proveito da funcionalidade de rotação de endereços IP através de proxies SOCKS5. Ele se destaca especialmente em cenários que requerem a rotação contínua de endereços IP de forma dinâmica e eficaz.


**Este projeto foi baseado em [TREVORproxy](https://github.com/blacklanternsecurity/TREVORproxy).**

**Recursos Adicionais**:
O script oferece a capacidade de fornecer portas e senhas específicas para cada host, tornando-o altamente flexível e adaptável às necessidades individuais de configuração. Isso permite que você personalize as configurações de conexão para cada servidor SSH de forma conveniente e personalizada.


Requisitos
----------
```
apt install sshpass proxychains
```

Instalação
----------

```
git clone https://github.com/benzetaa/ssh-balancer
cd ssh-balancer
chmod +x main.sh
```

## Usage

Encerra conexões SSH existentes em sua máquina local, garantindo um ambiente limpo para novas conexões.
```bash
./main.sh clean 
```

Para configurar os servidores desejados, siga o formato `user@host:porta:senha`. Se, por outro lado, o login for realizado por meio de uma chave SSH, basta passar `user@host:porta`. 

```bash
unset HISTFILE HISTSIZE SHELL HOME  
export PASS1="senha1"
export PASS2="senha2"

./main.sh user@host1:22:$PASS1 user@host2:1022:$PASS2 user@host3:1022
```



