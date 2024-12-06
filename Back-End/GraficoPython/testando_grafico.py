# %%
import matplotlib.pyplot as plt
import CoolProp
import numpy as np  
from CoolProp.CoolProp import PropsSI
from CoolProp.Plots import PropertyPlot
import os
import time

def gerar_dados_mollier():
    # Definir os quatro pontos principais do ciclo de refrigeração
    temperatura_1 = 310.15  # Kelvin  
    pressao_1 = 229.87  # kPa
    temperatura_2 = 343.55  # Kelvin  
    pressao_2 = 2025.79  # kPa
    temperatura_3 = 280.55  # Kelvin  
    pressao_3 = 1997.55  # kPa
    temperatura_4 = 284.85  # Kelvin 
    pressao_4 = 254.03  # kPa 

    # Calcular a entalpia em todos os pontos do ciclo
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
    # pressões = [pressao_1, pressao_2, pressao_3, pressao_4]

    return temperaturas, pressões, entalpias

def plotar_diagrama_mollier():
    temperaturas, pressões, entalpias = gerar_dados_mollier()

    plot = PropertyPlot('HEOS::R134a', 'PH', unit_system='KSI', tp_limits='ACHP')
    plot.calc_isolines(CoolProp.iQ)
    plot.calc_isolines(CoolProp.iT, num=30)
    
    #consulta de valores de temperaturas da ISOLINES: IMPORTANTE!!
    # temperaturas = []
    # for isolinha in plot.isolines[CoolProp.iT]:
    #     temperaturas.append(isolinha.value)  # Adiciona a temperatura da isolinha à lista

    #     Imprimir as temperaturas das isolinhas
    # for temp in temperaturas:
    #     print(f'Temperatura da isolinha: {temp:.2f} K')

    plt.plot([entalpias[0], entalpias[1]], [pressões[0], pressões[1]], 'r-')  # Compressao
    plt.plot([entalpias[1], entalpias[2]], [pressões[1], pressões[2]], 'r-')  # Condensação
    plt.plot([entalpias[2], entalpias[4]], [pressões[2], pressões[4]], 'r-')  # Expansão
    plt.plot([entalpias[3], entalpias[4]], [pressões[3], pressões[4]], 'r-')  # Evaporação
    plt.plot([entalpias[3], entalpias[0]], [pressões[3], pressões[0]], 'r-')  # Evaporação

    plt.xlabel('Entalpia (BTU/LB)')  # Nome do eixo X
    plt.ylabel('Pressao (PSIA)')  # Nome do eixo Y
    # plt.title('Diagrama de Mollier para R-134a')  # Título do gráfico

    plt.xlim(125, 600)  # Limites reais do eixo X (pressão em kPa) 

    ticks = [125, 148, 195, 246, 293, 338,  384, 427, 469, 510, 555, 595]  # Ticks logarítmicos em kPa
    labels = ['',  0,  20,  40, 60,  80,  100,  120, 140, 160,  180,   200]

    plt.xticks(ticks, labels)  # Define os ticks e os rótulos

    plt.yscale('log')  # Assegura que o eixo Y está em escala logarítmica
    ticks_y = [28, 38, 48, 90, 140, 300,  440, 580, 760, 1400, 2800, 4000, 5000, 6000]  # Ticks logarítmicos em kPa
    labels_y = [4,  6,  8,  10,  20,  40,   60,  80,  100, 200,  400,  600,  800,   1000]
                
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
    
    # Defina o tamanho da figura
    # manager = plt.get_current_fig_manager()
    # # manager.window.resize(400, 300)  # Redimensiona
    # manager.window.setGeometry(0,560, 400, 300)
    plot.savefig('imagem.png') 
    # plot.show()
    
if __name__ == "__main__":
    plotar_diagrama_mollier()

    

# def listen_to_queue(queue, folder_name, counter):
#     while True:
#         message = queue.get()
#         if message == "save":
#             print('mensagem recebida.')
#             # timestamp = time.strftime('%d-%m-%Y_%H-%M-%S')
            
#             filename = os.path.join(folder_name, f"Gráfico A_{counter.value}.png")

#             time.sleep(0.5)
#             # plotar_diagrama_mollier() 
#             salvar_diagrama_mollier(filename)

#             # plt.savefig(filename, dpi= 300)
           
#             # plt.savefig(filename, dpi=300, format='png', transparent=False, bbox_inches='tight')
#             print('arquivo salvo.')
#             counter.value += 1
#         else:
#             print('não houve mensagem.')

# def salvar_diagrama_mollier(nome_arquivo='Gráfico 1.png'):
#     plt.gcf().savefig(nome_arquivo, dpi=300, bbox_inches='tight')
#     print(f"Gráfico salvo como {nome_arquivo}")

# # def salvar_diagrama_mollier(nome_arquivo='Gráfico 1.png'):
# #     plt.gcf().canvas.draw_idle()  # Força renderização
# #     plt.pause(0.1)  # Aguarda renderização
# #     plt.tight_layout()  # Ajusta layout
# #     plt.savefig(nome_arquivo, dpi=300, bbox_inches='tight')
# #     print(f"Gráfico salvo como {nome_arquivo}")

#OBSERVAR AQUI!!
# # %%
# import matplotlib.animation as animation
# import matplotlib.pyplot as plt
# import CoolProp
# import numpy as np  
# from CoolProp.CoolProp import PropsSI
# from CoolProp.Plots import PropertyPlot
# from PIL import Image
# import os
# import time

# def gerar_dados_mollier(conjunto_dados=1):
#     # Definir os quatro pontos principais do ciclo de refrigeração
#     dados = {
#         1: {
#             'temperatura_1': 310.15,
#             'pressao_1': 229.87,
#             'temperatura_2': 343.55,
#             'pressao_2': 2025.79,
#             'temperatura_3': 280.55,
#             'pressao_3': 1997.55,
#             'temperatura_4': 284.85,
#             'pressao_4': 254.03
#         },
#         2: {
#             'temperatura_1': 320.15,
#             'pressao_1': 239.87,
#             'temperatura_2': 353.55,
#             'pressao_2': 2125.79,
#             'temperatura_3': 290.55,
#             'pressao_3': 2097.55,
#             'temperatura_4': 294.85,
#             'pressao_4': 274.03
#         }
#     }

#     # Acessar as variáveis através do dicionário
#     temperatura_1 = dados[conjunto_dados]['temperatura_1']
#     pressao_1 = dados[conjunto_dados]['pressao_1']
#     temperatura_2 = dados[conjunto_dados]['temperatura_2']
#     pressao_2 = dados[conjunto_dados]['pressao_2']
#     temperatura_3 = dados[conjunto_dados]['temperatura_3']
#     pressao_3 = dados[conjunto_dados]['pressao_3']
#     temperatura_4 = dados[conjunto_dados]['temperatura_4']
#     pressao_4 = dados[conjunto_dados]['pressao_4']

#     # Calcular a entalpia em todos os pontos do ciclo
#     entalpias = [
#         PropsSI('H', 'T', temperatura_1, 'P', pressao_1 * 1000, 'HEOS::R134a') / 1000,  # Ponto 1
#         PropsSI('H', 'T', temperatura_2, 'P', pressao_2 * 1000, 'HEOS::R134a') / 1000,  # Ponto 2
#         PropsSI('H', 'T', temperatura_3, 'P', pressao_3 * 1000, 'HEOS::R134a') / 1000,  # Ponto 3
#         PropsSI('H', 'T', temperatura_4, 'P', pressao_4 * 1000, 'HEOS::R134a') / 1000   # Ponto 4
#     ]

#     entalpia_5 = entalpias[2]  # Entalpia do Ponto 3
#     pressao_5 = pressao_4  # Pressao do Ponto 1
#     entalpias.append(entalpia_5)  # Adiciona entalpia do Ponto 5
#     pressoes = [pressao_1, pressao_2, pressao_3, pressao_4, pressao_5] 
#     temperaturas = [temperatura_1, temperatura_2, temperatura_3, temperatura_4]
#     # pressoes = [pressao_1, pressao_2, pressao_3, pressao_4]

#     return temperaturas, pressoes, entalpias

# def plotar_diagrama_mollier():
#     background_image = Image.open('C:\\ProgJean\\SistemaResfri\\Refrigeração\\processing\\data\\paraTeste.png')
#     background_image = background_image.resize((1800, 800))  # Ajuste para o tamanho desejado

#     # Cria a figura e os eixos
#     fig, ax = plt.subplots(figsize=(background_image.width / 100, background_image.height / 100))
    
#     #consulta de valores de temperaturas da ISOLINES: IMPORTANTE!!
#     # temperaturas = []
#     # for isolinha in plot.isolines[CoolProp.iT]:
#     #     temperaturas.append(isolinha.value)  # Adiciona a temperatura da isolinha à lista

#     #     Imprimir as temperaturas das isolinhas
#     # for temp in temperaturas:
#     #     print(f'Temperatura da isolinha: {temp:.2f} K')


#     plt.xlabel('Entalpia (BTU/LB)')  # Nome do eixo X
#     plt.ylabel('Pressao (PSIA)')  # Nome do eixo Y
#     # plt.title('Diagrama de Mollier para R-134a')  # Título do gráfico
#     conjunto_dados = 1
#     temperaturas, pressões, entalpias = gerar_dados_mollier()

#     linha1, = ax.plot([entalpias[0], entalpias[1]], [pressões[0], pressões[1]], 'r-')
#     linha2, = ax.plot([entalpias[1], entalpias[2]], [pressões[1], pressões[2]], 'r-')
#     linha3, = ax.plot([entalpias[2], entalpias[4]], [pressões[2], pressões[4]], 'r-')
#     linha4, = ax.plot([entalpias[3], entalpias[4]], [pressões[3], pressões[4]], 'r-')
#     linha5, = ax.plot([entalpias[3], entalpias[0]], [pressões[3], pressões[0]], 'r-')

#     plt.xlim(125, 600)  # Limites reais do eixo X (pressão em kPa) 
#     ticks = [125, 148, 195, 246, 293, 338,  384, 427, 469, 510, 555, 595]  # Ticks logarítmicos em kPa
#     labels = ['',  0,  20,  40, 60,  80,  100,  120, 140, 160,  180,   200]
#     plt.xticks(ticks, labels)  # Define os ticks e os rótulos

#     plt.yscale('log')  # Assegura que o eixo Y está em escala logarítmica
#     ticks_y = [28, 38, 48, 90, 140, 300,  440, 580, 760, 1400, 2800, 4000, 5000, 6000]  # Ticks logarítmicos em kPa
#     labels_y = [4,  6,  8,  10, 20,  40,   60,  80,  100, 200,  400,  600,  800, 1000]          
#     plt.yticks(ticks_y, labels_y)  # Define os ticks e os rótulos do eixo Y

#     plt.text(240, 28, '-51 °C = -60 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(250, 46, '-41 °C = -43 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(260, 74, '-32 °C = -25 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(270, 118, '-22 °C = -8 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(280, 180, '-12 °C = 9 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(290, 250, '-3 °C = 27 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(300, 370, '7 °C = 44 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(310, 500, '16 °C = 62 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(320, 715, '26 °C = 79 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(330, 945, '36 °C = 97 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(340, 1200,'45 °C = 114 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(350, 1500,'55 °C = 131 °F °C', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(360, 1885,'65 °C = 149 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(370, 2300,'75 °C = 167 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(380, 2850,'84 °C = 184 °F', fontsize=8, ha='center', va='bottom', color='blue')
#     plt.text(390, 3500,'94 °C = 202 °F', fontsize=8, ha='center', va='bottom', color='blue')

#     plt.grid(True)
#     plt.legend()
    
#     def atualizar(frame):

#         nonlocal conjunto_dados
#         conjunto_dados = (conjunto_dados % 2) + 1  # Alterna entre conjunto_dados 1 e 2
#         temperaturas, pressões, entalpias = gerar_dados_mollier(conjunto_dados)

#         linha1.set_data([entalpias[0], entalpias[1]], [pressões[0], pressões[1]])
#         linha2.set_data([entalpias[1], entalpias[2]], [pressões[1], pressões[2]])
#         linha3.set_data([entalpias[2], entalpias[4]], [pressões[2], pressões[4]])
#         linha4.set_data([entalpias[3], entalpias[4]], [pressões[3], pressões[4]])
#         linha5.set_data([entalpias[3], entalpias[0]], [pressões[3], pressões[0]])

#         return linha1, linha2, linha3, linha4, linha5

#     ani = animation.FuncAnimation(fig, atualizar, frames=range(100), interval=1000)  # 3 segundos

#     plt.show()
    
# if __name__ == "__main__":
#     plotar_diagrama_mollier()

    