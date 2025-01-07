
#from modulo_temp import temperaturas

#temperatura_1 = temperaturas[0]
#temperatura_2 = temperaturas[1]

#print(temperatura_1, temperatura_2) teste de dados em queue

import time
import matplotlib.pyplot as plt
import queue

# Importando a fila de temperaturas (temp_queue)
from modulo_temp import temp_queue

# Função para gerar gráfico A
def gerar_grafico_a():
    temperaturas = []
    while True:
        if not temp_queue.empty():
            temperatura = temp_queue.get()  # Consome o dado da fila
            temperaturas.append(temperatura)

            # Gerando gráfico (para fins ilustrativos)
            plt.plot(temperaturas)
            plt.xlabel('Tempo')
            plt.ylabel('Temperatura')
            plt.title('Temperatura ao longo do tempo')
            plt.pause(1)  # Pausa para a atualização do gráfico

            # Limpar o gráfico a cada novo dado
            plt.clf()

        time.sleep(1)  # Aguarda antes de verificar novamente a fila

# Executando a geração do gráfico
if __name__ == "__main__":
    gerar_grafico_a()
