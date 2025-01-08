# Script centralizador do array de pressão

# Array para armazenar os valores de pressão
pressao_array = []

def adicionar_valores(valores):
    """
    Adiciona uma lista de valores ao array de pressão.
    :param valores: Lista contendo os valores de pressão a serem adicionados.
    """
    if len(valores) != 8:
        raise ValueError("A lista de valores deve conter exatamente 8 elementos.")
    pressao_array.extend(valores)

def obter_valores():
    """
    Retorna os valores atuais do array de pressão.
    """
    return pressao_array

def limpar_array():
    """
    Limpa todos os valores do array de pressão.
    """
    pressao_array.clear()

def tamanho_array():
    """
    Retorna o tamanho atual do array de pressão.
    """
    return len(pressao_array)
