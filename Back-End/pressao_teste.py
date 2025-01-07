from modulo_pressao import pressao_queue
import time

while True:
    if not pressao_queue.empty():
        valor = pressao_queue.get()
        print(f"Valor de pressão consumido: {valor} PSI")
    else:
        print("Aguardando novos valores...")
    time.sleep(0.5)
