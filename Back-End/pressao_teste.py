import time
import signal
import sys

FILE_NAME = "dados_pressao.txt"  # Nome do arquivo para leitura

def signal_handler(sig, frame):
    print('\nEncerrando o consumidor...')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def ler_dados():
    """
    Lê os dados do arquivo .txt e exibe no console.
    """
    try:
        with open(FILE_NAME, "r") as f:
            data = f.read().strip()
            if data:
                valores = list(map(float, data.split(",")))  # Converte para lista de floats
                print(f"Dados lidos do arquivo: {valores}")
            else:
                print("O arquivo está vazio.")
    except FileNotFoundError:
        print("Arquivo não encontrado. Aguardando dados...")
    except Exception as e:
        print(f"Erro ao ler o arquivo: {e}")

if __name__ == "__main__":
    print("Consumidor iniciado. Pressione Ctrl+C para sair.")
    while True:
        ler_dados()
        time.sleep(1)  # Intervalo de leitura
