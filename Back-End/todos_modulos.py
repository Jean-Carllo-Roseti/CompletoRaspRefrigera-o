from pymodbus.client import ModbusSerialClient
import time
import signal
import sys
import threading

CAMINHO_BASE = "/home/avionics/Desktop/RaspberryResfriacao/Back-End/"


# Configurações dos dispositivos e arquivos
CONFIGURACOES = {
    "pressao": {
        "unit_id": 1,
        "address": 0,
        "count": 8,
        "factor": 10,  # Fator de escala da pressão
        "file_name": f"{CAMINHO_BASE}dados_pressao.txt",  # Caminho absoluto,
        "tipo": "Pressão",
            "formula": lambda valores: [ 
                (((((valor / 3) - 500) / (4500 - 500)) * 100) ) if i in [0, 3, 7] else
                (((((valor / 3) - 500) / (4500 - 500)) * 100) + 25.01) if i == 5 else
                (((((valor / 3) - 500) / (4500 - 500)) * 500) )
                for i, valor in enumerate(valores)
]

    },
    "temperatura": {
        "unit_id": 2,
        "address": 32,
        "count": 16,
        "file_name":  f"{CAMINHO_BASE}dados_temperatura.txt",
        "tipo": "Temperatura",
        "formula": lambda valores: [(valor / 10) - 0.15 for valor in valores]
    },
    "temperatura2": {
        "unit_id": 3,
        "address": 32,
        "count": 16,
        "file_name":  f"{CAMINHO_BASE}dados_temperatura2.txt",
        "tipo": "Temperatura",
        "formula": lambda valores: [(valor / 10) - 0.15 for valor in valores]
    }
}

# Porta serial compartilhada
PORTA = '/dev/ttyUSB0'
BAUDRATE = 9600
TIMEOUT = 1  # Tempo de espera para resposta

# Lock para sincronizar o acesso à porta serial
serial_lock = threading.Lock()


# Funções auxiliares
def escrever_em_arquivo(nome_arquivo, valores):
    """Escreve os valores em um arquivo .txt, separados por vírgulas."""
    try:
        with open(nome_arquivo, "w") as f:
            f.write(",".join(f"{valor:.2f}" for valor in valores))
    except IOError as e:
        print(f"Erro ao escrever no arquivo {nome_arquivo}: {e}")


def monitorar_dispositivo(client, config):
    """Função para monitorar um dispositivo específico."""
    while True:
        with serial_lock:
            if client.is_socket_open():
                try:
                    # Verificar tipo de leitura: pressão usa input registers e temperatura usa holding registers
                    if config["tipo"] == "Pressão":
                        leitura = client.read_input_registers(
                            address=config["address"],
                            count=config["count"],
                            slave=config["unit_id"]
                        )
                    else:
                        leitura = client.read_holding_registers(
                            address=config["address"],
                            count=config["count"],
                            slave=config["unit_id"]
                        )

                    if leitura.isError():
                        print(f"Erro na leitura dos registros do dispositivo {config['tipo']}.")
                    else:
                        # Conversão dos valores
                        valores = leitura.registers
                        valores_convertidos = config["formula"](valores)

                        # Escrevendo os valores no arquivo associado
                        escrever_em_arquivo(config["file_name"], valores_convertidos)

                        # Exibindo os valores no console
                        print(f"\n{config['tipo']} (Registros e Valores Convertidos):")
                        for i, valor in enumerate(valores):
                            print(f"Registro {i + 1}: {valor} (Convertido: {valores_convertidos[i]:.2f})")

                except Exception as e:
                    print(f"Erro no dispositivo {config['tipo']}: {e}")

        # Intervalo entre leituras
        time.sleep(1)



# Tratamento de interrupção (Ctrl+C)
def signal_handler(sig, frame):
    print('\nInterrupção detectada. Fechando conexão...')
    client.close()
    sys.exit(0)


signal.signal(signal.SIGINT, signal_handler)

# Criando o cliente Modbus
client = ModbusSerialClient(
    port=PORTA,
    baudrate=BAUDRATE,
    timeout=TIMEOUT,
    parity='N',
    stopbits=1,
    bytesize=8
)


# Conexão ao dispositivo
if client.connect():
    print("Conexão estabelecida com sucesso com a porta serial.")
else:
    print("Falha ao conectar à porta serial.")
    sys.exit()

# Criando e iniciando threads para cada dispositivo
threads = []
for key, config in CONFIGURACOES.items():
    thread = threading.Thread(target=monitorar_dispositivo, args=(client, config), daemon=True)
    thread.start()
    threads.append(thread)
    print(f"Iniciada thread de monitoramento para {config['tipo']}.")

# Mantendo o programa ativo
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    signal_handler(None, None)
