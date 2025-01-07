from pymodbus.client import ModbusSerialClient
from queue import Queue
import time
import signal
import sys

# Configuração da conexão
PORTA = '/dev/ttyUSB0'
BAUDRATE = 9600
UNIT_ID = 1
ADDRESS = 0
COUNT = 8  

# Fila para armazenar os dados de pressão
pressao_queue = Queue()

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
                print("\nPressão (mV e PSI):")

                for i, valor in enumerate(valores):
                    PSI = valor / 10  # Conversão de mV para PSI
                    print(f"Registro {i+1}: {valor} mV ({PSI:.2f} PSI)")

                    # Adicionando o valor convertido na fila
                    pressao_queue.put(PSI)

                # Garantir que a fila não cresça indefinidamente
                while pressao_queue.qsize() > 100:  # Limite de 100 elementos
                    pressao_queue.get()

            time.sleep(1)
        except Exception as e:
            print(f"\nErro: {e}")
            time.sleep(1)


#criar dois arrays de temp e pressão, 
#seprar os valores recebidos em seus ararys,
#alterar os gráficos.
#-----------------------------------------------------#
#POSSIVEL A SER UTILZADO COM QUANDO TIVER MAIS USBS!!!

#from pymodbus.client import ModbusSerialClient
#import time
#import signal
#import sys

# Configuração das conexões
#PORTAS = ['/dev/ttyUSB0', '/dev/ttyUSB1']
#BAUDRATE = 9600
#UNIT_ID = 1
#ADDRESS = 0

#clientes = []

#def signal_handler(sig, frame):
#    print('\nInterrupção detectada. Fechando conexões...')
#    for cliente in clientes:
#        cliente.close()
#    sys.exit(0)

#signal.signal(signal.SIGINT, signal_handler)

# Conectando a todas as portas
#for porta in PORTAS:
#    cliente = ModbusSerialClient(port=porta, baudrate=BAUDRATE, timeout=2)
#    if cliente.connect():
#        print(f'Conexão estabelecida com sucesso na porta {porta}.')
#        clientes.append(cliente)
#    else:
#        print(f'Falha ao conectar na porta {porta}.')

#if not clientes:
#    print('Nenhuma conexão foi bem-sucedida. Encerrando o programa.')
#    exit()

# Loop de leitura para todas as portas conectadas
#while True:
#    for cliente in clientes:
#        if cliente.is_socket_open():
#            try:
#                count = 8  # Exemplo: ler 8 registros
#                leitura = cliente.read_input_registers(address=ADDRESS, count=count, slave=UNIT_ID)

                #if leitura.isError():
                #    print(f"Erro na leitura dos registros na porta {cliente.port}.")
                #else:
                #    print(f"\nPorta {cliente.port}:")  # Identifica a porta USB
                #    valores = leitura.registers  # Array de valores lidos
                #    print(f"Valores lidos (em mV): {valores}")
                    
                #    for i, valor in enumerate(valores):
                #        mV = valor
                #        PSI = mV / 10  # Conversão de mV para PSI
                #        print(f"Registro {i+1}: {mV} mV ({PSI:.2f} PSI)")
                #time.sleep(1)
            #except Exception as e:
                #print(f"\nErro na porta {cliente.port}: {e}")
                #time.sleep(1)
