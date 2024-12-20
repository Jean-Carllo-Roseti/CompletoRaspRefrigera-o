from pymodbus.client import ModbusSerialClient
import time
import signal
import sys

# Configuração da conexão
PORTA = '/dev/ttyUSB0'
BAUDRATE = 9600
UNIT_ID = 1
ADDRESS = 0

cliente = ModbusSerialClient(port=PORTA, baudrate=BAUDRATE, timeout=2)

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
            # Aqui você pode alterar o count para o número de registros que você deseja ler
            count = 8  # Exemplo: ler 8 registros
            leitura = cliente.read_input_registers(address=ADDRESS, count=count, slave=UNIT_ID)

            if leitura.isError():
                print("Erro na leitura dos registros")
            else:
                # Exibindo todos os registros lidos
                for i, valor in enumerate(leitura.registers):
                    mV = valor
                    PSI = (mV / 1000) * (5 / 5)  # Exemplo de conversão
                    print(f"\nRegistro {i+1}: {mV} mV ({PSI:.2f})")  # Mudando para \n para garantir nova linha

            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)

