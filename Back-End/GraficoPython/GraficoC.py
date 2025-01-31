# %%
import matplotlib.pyplot as plt
import CoolProp
import numpy as np  
from CoolProp.CoolProp import PropsSI
from CoolProp.Plots import PropertyPlot
import os
import time
import gc  # Para Garbage Collector

def gerar_dados_mollier(conjunto_dados=5):
    dados = {
        5: {
            'temperatura_1': 310.15,
            'pressao_1': 229.87,
            'temperatura_2': 343.55,
            'pressao_2': 2025.79,
            'temperatura_3': 280.55,
            'pressao_3': 1997.55,
            'temperatura_4': 284.85,
            'pressao_4': 254.03
        },
        6: {
            'temperatura_1': 210.15,
            'pressao_1': 190.87,
            'temperatura_2': 353.55,
            'pressao_2': 1600.79,
            'temperatura_3': 290.55,
            'pressao_3': 1700.55,
            'temperatura_4': 294.85,
            'pressao_4': 150.03
        }
    }

    temperatura_1 = dados[conjunto_dados]['temperatura_1']
    pressao_1 = dados[conjunto_dados]['pressao_1']
    temperatura_2 = dados[conjunto_dados]['temperatura_2']
    pressao_2 = dados[conjunto_dados]['pressao_2']
    temperatura_3 = dados[conjunto_dados]['temperatura_3']
    pressao_3 = dados[conjunto_dados]['pressao_3']
    temperatura_4 = dados[conjunto_dados]['temperatura_4']
    pressao_4 = dados[conjunto_dados]['pressao_4']

    # Calcular a entalpia em todos os pontos do ciclo
    entalpias = [
        PropsSI('H', 'T', temperatura_1, 'P', pressao_1 * 1000, 'HEOS::R134a') / 1000,
        PropsSI('H', 'T', temperatura_2, 'P', pressao_2 * 1000, 'HEOS::R134a') / 1000,
        PropsSI('H', 'T', temperatura_3, 'P', pressao_3 * 1000, 'HEOS::R134a') / 1000,
        PropsSI('H', 'T', temperatura_4, 'P', pressao_4 * 1000, 'HEOS::R134a') / 1000
    ]

    entalpia_5 = entalpias[2]
    pressao_5 = pressao_4
    entalpias.append(entalpia_5)
    pressões = [pressao_1, pressao_2, pressao_3, pressao_4, pressao_5]
    temperaturas = [temperatura_1, temperatura_2, temperatura_3, temperatura_4]

    return temperaturas, pressões, entalpias

def plotar_diagrama_mollier(conjunto_dados=5):
    temperaturas, pressões, entalpias = gerar_dados_mollier(conjunto_dados)

    plot = PropertyPlot('HEOS::R134a', 'PH', unit_system='KSI', tp_limits='ACHP')
    plot.calc_isolines(CoolProp.iQ)
    plot.calc_isolines(CoolProp.iT, num=30)

    plt.plot([entalpias[0], entalpias[1]], [pressões[0], pressões[1]], 'r-')  # Compressao
    plt.plot([entalpias[1], entalpias[2]], [pressões[1], pressões[2]], 'r-')  # Condensação
    plt.plot([entalpias[2], entalpias[4]], [pressões[2], pressões[4]], 'r-')  # Expansão
    plt.plot([entalpias[3], entalpias[4]], [pressões[3], pressões[4]], 'r-')  # Evaporação
    plt.plot([entalpias[3], entalpias[0]], [pressões[3], pressões[0]], 'r-')  # Evaporação

    plt.xlabel('Entalpia (BTU/LB)')
    plt.ylabel('Pressao (PSIA)')
    plt.title('Diagrama 3')

    plt.xlim(125, 600)
    ticks = [125, 148, 195, 246, 293, 338,  384, 427, 469, 510, 555, 595]
    labels = ['',  0,  20,  40, 60,  80,  100,  120, 140, 160,  180,   200]
    plt.xticks(ticks, labels)

    plt.yscale('log')
    ticks_y = [28, 38, 48, 90, 140, 300,  440, 580, 760, 1400, 2800, 4000, 5000, 6000]
    labels_y = [4,  6,  8,  10,  20,  40,   60,  80,  100, 200,  400,  600,  800,   1000]
    plt.yticks(ticks_y, labels_y)

    plt.text(240, 28, '-51 °C = -60 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(250, 46, '-41 °C = -43 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(260, 74, '-32 °C = -25 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(270, 118, '-22 °C = -8 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(280, 180, '-12 °C = 9 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(290, 250, '-3 °C = 27 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(300, 370, '7 °C = 44 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(310, 500, '16 °C = 62 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(320, 715, '26 °C = 79 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(330, 945, '36 °C = 97 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(340, 1200,'45 °C = 114 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(350, 1500,'55 °C = 131 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(360, 1885,'65 °C = 149 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(370, 2300,'75 °C = 167 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(380, 2850,'84 °C = 184 °F', fontsize=8, ha='center', va='bottom', color='blue')
    plt.text(390, 3500,'94 °C = 202 °F', fontsize=8, ha='center', va='bottom', color='blue')


    plt.grid(True)
    caminho_imagem = r'/home/avionics/Desktop/RaspberryResfriacao/assets/images/imagem3.png'
    plot.savefig(caminho_imagem)
    plt.close('all')  # Libera os recursos de plotagem

    # Forçar coleta de lixo
    gc.collect()

if __name__ == "__main__":
    conjuntos_de_dados = [5, 6]
    while True:
        for conjunto_dados in conjuntos_de_dados:
            plotar_diagrama_mollier(conjunto_dados)
            time.sleep(1)  # Aguarda antes de alternar
