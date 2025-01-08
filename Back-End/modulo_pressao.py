from pymodbus.client import ModbusSerialClient
from pressao_central import adicionar_valores, limpar_array, obter_valores
import time
import signal
import sys

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

                # Atualizando o array centralizado
                limpar_array()  # Limpa os valores antigos
                adicionar_valores(PSI_valores)  # Adiciona os novos valores

                # Imprimindo os valores atualizados
                print("\nPressão (mV e PSI):")
                for i, valor in enumerate(valores):
                    print(f"Registro {i+1}: {valor} mV ({PSI_valores[i]:.2f} PSI)")

                

            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)
