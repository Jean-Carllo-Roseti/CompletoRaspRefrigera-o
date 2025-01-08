FILE_NAME = "dados_pressao.txt"  # Nome do arquivo para leitura

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
    if len(array) != 8:
        print(f"Atenção: O array contém {len(array)} elementos. Esperado: 8.")
        return {}
    
    # Criando variáveis dinâmicas e atribuindo os valores dos elementos
    variaveis = {
        "pressao_1": array[0],
        "pressao_2": array[1],
        "pressao_3": array[2],
        "pressao_4": array[3],
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
            pressao_1 = variaveis["pressao_1"]
            pressao_2 = variaveis["pressao_2"]
            pressao_3 = variaveis["pressao_3"]
            pressao_4 = variaveis["pressao_4"]
            # Usar as variáveis conforme necessário
            print("\nVariáveis individuais:")
            print(f"pressao_1 = {pressao_1}")
            print(f"pressao_2 = {pressao_2}")
            print(f"pressao_3 = {pressao_3}")
            print(f"pressao_4 = {pressao_4}")

if __name__ == "__main__":
    main()

