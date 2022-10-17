def obter_nome():
    name = input("Nome: ")
    return name

def emitir_msg():
    nome = obter_nome()
    print("olá ", nome)

emitir_msg()