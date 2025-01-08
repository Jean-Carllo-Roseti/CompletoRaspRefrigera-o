from pymodbus.client import ModbusSerialClient
import time
import signal
import sys

pressao_array = []
FILE_NAME = "dados_pressao.txt"  # Nome do arquivo para salvar os dados

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

def escrever_em_arquivo(valores):
    """
    Escreve os valores de pressão em um arquivo .txt.
    :param valores: Lista de valores de pressão.
    """
    with open(FILE_NAME, "w") as f:
        f.write(",".join(map(str, valores)))  # Salva os valores separados por vírgulas

# Configuração da conexão
PORTA = '/dev/ttyUSB0'
BAUDRATE = 9600
UNIT_ID = 1
ADDRESS = 0
COUNT = 8  # Número de registros a serem lidos

# Criando cliente Modbus
cliente = ModbusSerialClient(port=PORTA, baudrate=BAUDRATE, timeout=2)

# Tratamento de interrupção (Ctrl+C)
def signal_handler(sig, frame):
    print('\nInterrupção detectada. Fechando conexão...')
    cliente.close()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

# Conexão ao dispositivo
if cliente.connect():
    print('Conexão estabelecida com sucesso.')
else:
    print('Falha ao conectar.')
    exit()

# Loop principal para leitura contínua
while True:
    if cliente.is_socket_open():
        try:
            # Leitura dos registros Modbus
            leitura = cliente.read_input_registers(address=ADDRESS, count=COUNT, slave=UNIT_ID)

            if leitura.isError():
                print("Erro na leitura dos registros")
            else:
                valores = leitura.registers  # Array de valores lidos
                PSI_valores = [valor / 10 for valor in valores]  # Conversão de mV para PSI

                # Atualizando o array centralizador
                limpar_array()  # Limpa os valores antigos
                adicionar_valores(PSI_valores)  # Adiciona os novos valores

                # Escrevendo no arquivo .txt
                escrever_em_arquivo(PSI_valores)

                # Imprimindo os valores atualizados
                print("\nPressão (mV e PSI):")
                for i, valor in enumerate(valores):
                    print(f"Registro {i+1}: {valor} mV ({PSI_valores[i]:.2f} PSI)")

                # Exibindo os valores armazenados no array centralizador
                print("Valores no array centralizador:", obter_valores())

            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)
