from pymodbus.client import ModbusSerialClient
import time
import signal
import sys


temp_array = []
FILE_NAME = "dados_temperatura.txt"  # Nome do arquivo para salvar os dados

def adicionar_valores(valores):
    """
    Adiciona uma lista de valores ao array de pressão.
    :param valores: Lista contendo os valores de pressão a serem adicionados.
    """
    if len(valores) != 16:
        raise ValueError("A lista de valores deve conter exatamente 8 elementos.")
    temp_array.extend(valores)

def obter_valores():
    """
    Retorna os valores atuais do array de pressão.
    """
    return temp_array

def limpar_array():
    """
    Limpa todos os valores do array de pressão.
    """
    temp_array.clear()

def escrever_em_arquivo(valores):
    """
    Escreve os valores de pressão em um arquivo .txt.
    :param valores: Lista de valores de pressão.
    """
    with open(FILE_NAME, "w") as f:
        f.write(",".join(map(str, valores)))  # Salva os valores separados por vírgulas


# Configuração do dispositivo e Modbus
PORTA = '/dev/ttyUSB0'  # Porta serial
BAUDRATE = 9600         # Taxa de comunicação
UNIT_ID = 3             # Slave ID
ADDRESS = 32            # Endereço ajustado para base 0
QUANTITY = 16           # Quantidade de registros




# Criando o cliente Modbus
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

while True:
    if cliente.is_socket_open():
        try:
            # Lendo os registros
            leitura = cliente.read_holding_registers(address=ADDRESS, count=QUANTITY, slave=UNIT_ID)

            if leitura.isError():
                print("Erro na leitura dos registros.")
            else:
                valores = leitura.registers  # Array de valores lidos
                temp_valores = [((0.0876 * valor - 5743.33) + 2.5) if (len(str(valor)) == 5 and valor != 64536) else ((valor / 10) - 0.15)
        for valor in valores]

                # Atualizando o array centralizador
                limpar_array()  # Limpa os valores antigos
                adicionar_valores(temp_valores)  # Adiciona os novos valores

                 # Escrevendo no arquivo .txt
                escrever_em_arquivo(temp_valores)
                

                # Imprimindo os valores atualizados
                print("\nPressão (mV e Celsius):")
                for i, valor in enumerate(valores):
                    print(f"Registro {i+1}: {valor} mV ({temp_valores[i]:.2f} Celsius)")

                # Exibindo os valores armazenados no array centralizador
                #print("Valores no array centralizador:", obter_valores())
                   

            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)
