FILE_NAME = "dados_temperatura.txt"  # Nome do arquivo para leitura

def ler_arquivo_e_transformar_em_array():
    """
    Lê os dados do arquivo e transforma em um array de floats.
    """
    try:
        with open(FILE_NAME, "r") as f:
            data = f.read().strip()
            if data:
                # Converte os dados para uma lista de floats
                array = list(map(float, data.split(",")))
                return array
            else:
                print("O arquivo está vazio.")
                return []
    except FileNotFoundError:
        print(f"Erro: O arquivo '{FILE_NAME}' não foi encontrado.")
        return []
    except Exception as e:
        print(f"Erro ao processar o arquivo: {e}")
        return []

# Continuar seu código anterior...

def atribuir_elementos_a_variaveis(array):
    """
    Atribui os elementos do array a variáveis separadas e retorna um dicionário.
    """
    if len(array) != 16:
        print(f"Atenção: O array contém {len(array)} elementos. Esperado: 8.")
        return {}
    
    # Criando variáveis dinâmicas e atribuindo os valores dos elementos
    variaveis = {
        "temperatura_1": array[0],
        "temperatura_2": array[1],
        "temperatura_3": array[2],
        "temperatura_4": array[3],
        # Caso tenha mais elementos, continue o padrão
        # Se necessário, você pode expandir a lista conforme o seu código.
    }
    return variaveis

def main():
    # Lê o arquivo e transforma os dados em array
    array = ler_arquivo_e_transformar_em_array()
    
    # Exibe o array criado
    print("Array criado a partir do arquivo:")
    print(array)
    
    # Atribui os elementos do array a variáveis
    if array:
        variaveis = atribuir_elementos_a_variaveis(array)
        if variaveis:
            print("\nVariáveis atribuídas com os elementos do array:")
            for nome, valor in variaveis.items():
                print(f"{nome} = {valor}")
            
            # Aqui, você pode acessar as variáveis específicas
            temperatura_1 = variaveis["temperatura_1"]
            temperatura_2 = variaveis["temperatura_2"]
            temperatura_3 = variaveis["temperatura_3"]
            temperatura_4 = variaveis["temperatura_4"]
            # Usar as variáveis conforme necessário
            print("\nVariáveis individuais:")
            print(f"temperatura_1 = {temperatura_1}")
            print(f"temperatura_2 = {temperatura_2}")
            print(f"temperatura_3 = {temperatura_3}")
            print(f"temperatura_4 = {temperatura_4}")

if __name__ == "__main__":
    main()

