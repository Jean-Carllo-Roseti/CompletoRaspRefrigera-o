import time
from modulo_pressao import obter_valores
from pressao_central import pressao_array

while True:
    valores = obter_valores()
    lista = pressao_array  # Acesso direto à variável pressao_array
    print(f'Valores obtidos: {valores}')  # Exibe o array completo
    print(f'Posição1: {lista[0]}')  # Exibe a posição 1 (índice 0)
    time.sleep(1)
