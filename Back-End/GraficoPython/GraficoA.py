# %%
import matplotlib.pyplot as plt
import CoolProp
import numpy as np  
from CoolProp.CoolProp import PropsSI
from CoolProp.Plots import PropertyPlot
import os
import time

#ordem dos valores da cablagem
#01,02/03,04/ = TEMP MOTOR
#A11/A12/ = PRESSAO MOTOR 

#05,06/07,08/ = TEMP EVAPORADORA
#A13/A14 = PRESSAO EVAPORADORA

# Arquivos para leitura
FILE_PRESSAO = "/home/avionics/Desktop/RaspberryResfriacao/Back-End/dados_pressao.txt"
FILE_TEMPERATURA = "/home/avionics/Desktop/RaspberryResfriacao/Back-End/dados_temperatura.txt"  

def ler_arquivo_e_transformar_em_array(file_name):
    """
    Lê os dados do arquivo e transforma em um array de floats.
    """
    try:
        with open(file_name, "r") as f:
            data = f.read().strip()
            if data:
                # Converte os dados para uma lista de floats
                array = list(map(float, data.split(",")))
                return array
            else:
                print(f"O arquivo '{file_name}' está vazio.")
                return []
    except FileNotFoundError:
        print(f"Erro: O arquivo '{file_name}' não foi encontrado.")
        return []
    except Exception as e:
        print(f"Erro ao processar o arquivo '{file_name}': {e}")
        return []

def atribuir_elementos_a_variaveis_pressao(array):
    """
    Atribui os elementos do array de pressão a variáveis separadas, convertendo de PSI para kPa.
    """
    # Aplicar a conversão de PSI para kPa
    array_convertido = [valor * 6.89476 for valor in array]

    if len(array) != 8:
        print(f"Atenção: O array de pressão contém {len(array)} elementos. Esperado: 8.")
        return {}

    # Atribuir valores a variáveis
    variaveis_pressao = {
        #"pressao_1": array_convertido[0],
        #"pressao_2": array_convertido[1],
        #"pressao_3": array_convertido[2],
        #"pressao_4": array_convertido[3],
        "pressao_1": 229.87,
        "pressao_2": 2025.79,
        "pressao_3": 1997.55,
        "pressao_4": 254.03
    }

    return variaveis_pressao

def atribuir_elementos_a_variaveis_temperatura(array):
    """
    Atribui os elementos do array de temperatura a variáveis separadas.
    """
    array_convertido = [valor + 273.15 for valor in array]  # Alteração aqui


    if len(array) != 16:
        print(f"Atenção: O array de temperatura contém {len(array)} elementos. Esperado: 16.")
        return {}

    variaveis_temperatura = {
        "temperatura_1": 310.15,  # Kelvin  
        "temperatura_2": 343.55,  # Kelvin  
        "temperatura_3": 280.55,  # Kelvin  
        "temperatura_4": 284.85  # Kelvin 
        #"temperatura_1": array_convertido[0],
        #"temperatura_2": array_convertido[1],
        #"temperatura_3": array_convertido[2],
        #"temperatura_4": array_convertido[3]
    }
    return variaveis_temperatura


def gerar_dados_mollier(pressao_1, pressao_2, pressao_3, pressao_4, temperatura_1, temperatura_2, temperatura_3, temperatura_4):
    # Calcular a entalpia em todos os pontos do ciclo usando as pressões recebidas como parâmetros
    entalpias = [
        PropsSI('H', 'T', temperatura_1, 'P', pressao_1 * 1000, 'HEOS::R134a') / 1000,  # Ponto 1
        PropsSI('H', 'T', temperatura_2, 'P', pressao_2 * 1000, 'HEOS::R134a') / 1000,  # Ponto 2
        PropsSI('H', 'T', temperatura_3, 'P', pressao_3 * 1000, 'HEOS::R134a') / 1000,  # Ponto 3
        PropsSI('H', 'T', temperatura_4, 'P', pressao_4 * 1000, 'HEOS::R134a') / 1000   # Ponto 4
    ]

    entalpia_5 = entalpias[2]  # Entalpia do Ponto 3
    pressao_5 = pressao_4  # Pressao do Ponto 1
    entalpias.append(entalpia_5)  # Adiciona entalpia do Ponto 5
    pressões = [pressao_1, pressao_2, pressao_3, pressao_4, pressao_5] 
    temperaturas = [temperatura_1, temperatura_2, temperatura_3, temperatura_4]

    return temperaturas, pressões, entalpias

def plotar_diagrama_mollier():
    array_pressao = ler_arquivo_e_transformar_em_array(FILE_PRESSAO)
    array_temperatura = ler_arquivo_e_transformar_em_array(FILE_TEMPERATURA)

    variaveis_pressao = atribuir_elementos_a_variaveis_pressao(array_pressao)
    variaveis_temperatura = atribuir_elementos_a_variaveis_temperatura(array_temperatura)


    # Passa os valores de pressão extraídos para a função gerar_dados_mollier
    if variaveis_pressao and variaveis_temperatura:
        temperaturas, pressões, entalpias = gerar_dados_mollier(
            variaveis_pressao["pressao_1"], 
            variaveis_pressao["pressao_2"], 
            variaveis_pressao["pressao_3"], 
            variaveis_pressao["pressao_4"],
            variaveis_temperatura["temperatura_1"],  # Passando a temperatura_1
            variaveis_temperatura["temperatura_2"],  # Passando a temperatura_2
            variaveis_temperatura["temperatura_3"],  # Passando a temperatura_3
            variaveis_temperatura["temperatura_4"]   # Passando a temperatura_4
        )

        plot = PropertyPlot('HEOS::R134a', 'PH', unit_system='KSI', tp_limits='ACHP')
        plot.calc_isolines(CoolProp.iQ)
        plot.calc_isolines(CoolProp.iT, num=30)

        plt.plot([entalpias[0], entalpias[1]], [pressões[0], pressões[1]], 'r-')  # Compressão
        plt.plot([entalpias[1], entalpias[2]], [pressões[1], pressões[2]], 'r-')  # Condensação
        plt.plot([entalpias[2], entalpias[4]], [pressões[2], pressões[4]], 'r-')  # Expansão
        plt.plot([entalpias[3], entalpias[4]], [pressões[3], pressões[4]], 'r-')  # Evaporação
        plt.plot([entalpias[3], entalpias[0]], [pressões[3], pressões[0]], 'r-')  # Evaporação

        plt.xlabel('Entalpia (BTU/LB)')  # Nome do eixo X
        plt.ylabel('Pressao (PSIA)')  # Nome do eixo Y

        plt.xlim(125, 600)  # Limites reais do eixo X (pressão em kPa)

        ticks = [125, 148, 195, 246, 293, 338, 384, 427, 469, 510, 555, 595]  # Ticks logarítmicos em kPa
        labels = ['', 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200]

        plt.xticks(ticks, labels)  # Define os ticks e os rótulos

        plt.yscale('log')  # Assegura que o eixo Y está em escala logarítmica
        ticks_y = [28, 38, 48, 90, 140, 300, 440, 580, 760, 1400, 2800, 4000, 5000, 6000]  # Ticks logarítmicos em kPa
        labels_y = [4, 6, 8, 10, 20, 40, 60, 80, 100, 200, 400, 600, 800, 1000]

        plt.yticks(ticks_y, labels_y)  # Define os ticks e os rótulos do eixo Y

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
        plt.legend()
        #plot.show()

        plot.savefig(os.path.join('assets', 'imagem.png')) 

        caminho_imagem = r'/home/avionics/Desktop/RaspberryResfriacao/assets/images/imagem.png'

        plot.savefig(caminho_imagem) 
        plt.close('all')  # Libera os recursos de plotagem

        # Forçar coleta de lixo
        


if __name__ == "__main__":
    plotar_diagrama_mollier()


    
    
