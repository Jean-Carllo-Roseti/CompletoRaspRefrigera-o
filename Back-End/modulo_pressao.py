#import serial
#import time

## Configuração da porta serial
#ser = serial.Serial(
#    port='/dev/ttyUSB0', 
#    baudrate=115200,        
#    bytesize=serial.EIGHTBITS,
#    parity=serial.PARITY_NONE,
#    stopbits=serial.STOPBITS_ONE,
#    timeout=1             
#)

## Imprime o nome da porta serial
#print(ser.name)

#try:
#    if not ser.isOpen():
#        ser.open()  # Tenta abrir a porta, se ainda não estiver aberta
#        print("Porta serial aberta com sucesso.")
#    
#    while True:
#        if ser.in_waiting > 0:  # Verifica se há dados disponíveis na porta
#            data = ser.readline()  # Lê uma linha de dados
#           print(f"Dados recebidos: {data.decode('utf-8').strip()}")
#       else:
#            print("Nenhum dado recebido.")
#            
#        time.sleep(1)

#except KeyboardInterrupt:
#    print("Programa encerrado.")
#finally:
#    if ser.isOpen():
#        ser.close()  # Fecha a porta serial quando o programa terminar


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
conexão = cliente.connect()

if conexão:
    print('Conexão estabelecida com sucesso.')
else:
    print('Falha ao conectar.')
    exit()

while True:
    if not cliente.connect():
        print("Not connected, trying to connect!")
        time.sleep(5)
        continue
    try:
        leitura = cliente.read_input_registers(address=ADDRESS, count=1, slave=UNIT_ID)
        if leitura.isError():
            print("Erro na leitura dos registros")
        else:
            for i, valor in enumerate(leitura.registers):
                mV = valor
                PSI = (mV / 1000) * (5 / 5)
                print(f"\rRegistro {i+1}: {mV} mV ({PSI:.2f})\033[K", end='')
        time.sleep(1)
    except Exception as e:
        print(f"\nErro: {e}")
        time.sleep(1)
