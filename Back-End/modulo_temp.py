from pymodbus.client import ModbusSerialClient
import time
import signal
import sys

# Configuração do dispositivo e Modbus
PORTA = '/dev/ttyUSB0'  # Porta serial
BAUDRATE = 9600         # Taxa de comunicação
UNIT_ID = 1             # Slave ID
ADDRESS = 32            # Endereço ajustado para base 0
QUANTITY = 16           # Quantidade de registros
FACTOR = 10             # Fator de escala

temperaturas = []

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
                # Exibindo os registros lidos
                valores = leitura.registers  # Array de valores lidos
                print("\nTemperaturas lidas:")

                temperaturas = [temp / FACTOR for temp in valores]
                
                 # Exibindo cada valor de temperatura em uma linha
                for temp in temperaturas:
                    print(temp / FACTOR)


            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)
