import os
import argparse
import time
from CoolProp.CoolProp import PropsSI


# ============================================================
# CONFIGURAÇÃO
# ============================================================

REFRIGERANTE = 'HEOS::R134a'

PRESSAO_ATMOSFERICA_PSI = 14.7
CONVERSAO_PSI_KPA = 6.89476


diretorio_atual = os.path.dirname(__file__)

FILE_PRESSAO = os.path.join(
    diretorio_atual,
    '..',
    'dados_pressao.txt'
)

FILE_TEMPERATURA = os.path.join(
    diretorio_atual,
    '..',
    'dados_temperatura.txt'
)

FILE_SA_E_SE = os.path.join(
    diretorio_atual,
    '..',
    'SAeSR.txt'
)

FILE_PRESSAO_MOCK = os.path.join(
    diretorio_atual,
    'dados_pressao_mock.txt'
)

FILE_TEMPERATURA_MOCK = os.path.join(
    diretorio_atual,
    'dados_temperatura_mock.txt'
)

MOCK_DADOS = [
    {
        'temperatura_succao_1_c': 7.2,
        'pressao_succao_psi': 37.2,
        'temperatura_succao_2_c': 10.0,
        'temperatura_liquido_c': 40.5,
        'pressao_alta_psi': 142.2,
    },
    {
        'temperatura_succao_1_c': 7.0,
        'pressao_succao_psi': 25.0,
        'temperatura_succao_2_c': 6.8,
        'temperatura_liquido_c': 33.4,
        'pressao_alta_psi': 142.0,
    },
    {
        'temperatura_succao_1_c': 6.3,
        'pressao_succao_psi': 22.3,
        'temperatura_succao_2_c': 5.2,
        'temperatura_liquido_c': 37.5,
        'pressao_alta_psi': 137.5,
    },
]


# ============================================================
# LEITURA DOS ARQUIVOS
# ============================================================

def ler_array(file_name):

    try:

        with open(file_name, "r") as f:

            data = f.read().strip()

            if not data:
                return []

            return list(map(float, data.split(",")))

    except FileNotFoundError:

        return []

    except Exception:

        return []
    
# ============================================================
# TABELA DE CENÁRIOS
# ============================================================

def gravar_array_mock(file_name, valores):
    """Grava uma leitura simulada no formato dos arquivos dos sensores."""
    with open(file_name, "w", encoding="utf-8") as arquivo:
        arquivo.write(",".join(f"{valor:.2f}" for valor in valores))


def gerar_mock_dados(intervalo_segundos=2, repetir=True):
    """Alterna as leituras da imagem e executa o cálculo real em cada amostra."""
    try:
        while True:
            for numero, amostra in enumerate(MOCK_DADOS, start=1):
                temperaturas = [0.0] * 16
                pressoes = [0.0] * 8

                # Índices iguais aos usados por processar_dados().
                temperaturas[3] = amostra['temperatura_liquido_c']
                temperaturas[6] = amostra['temperatura_succao_1_c']
                temperaturas[12] = amostra['temperatura_succao_2_c']

                # A primeira pressão de sucção da imagem vale para os dois evaporadores.
                pressoes[3] = amostra['pressao_succao_psi']
                pressoes[1] = amostra['pressao_alta_psi']

                gravar_array_mock(FILE_TEMPERATURA_MOCK, temperaturas)
                gravar_array_mock(FILE_PRESSAO_MOCK, pressoes)

                print(f"Mock {numero}/{len(MOCK_DADOS)}: {amostra}")
                processar_dados(mock=True)
                time.sleep(intervalo_segundos)

            if not repetir:
                return
    except KeyboardInterrupt:
        print("Mock interrompido pelo usuário.")


def calcular_cenario(superaquecimento, subresfriamento, evaporador):

    if superaquecimento > 8 and subresfriamento > 8:
        return f"Abrir Valvula de Expansao Evaporador {evaporador}"

    elif superaquecimento < 2 and subresfriamento < 2:
        return f"Fechar Valvula de Expansao Evaporador {evaporador}"

    elif superaquecimento > 8 and subresfriamento < 2:
        return f"Adicionar Fluido Refrigerante Evaporador {evaporador}"

    elif superaquecimento < 2 and subresfriamento < 8:
        return f"Retirar Fluido Refrigerante Evaporador {evaporador}"

    else:
        return "Condicao dentro da faixa de controle"

# ============================================================
# PRESSÃO
# ============================================================

def converter_pressao_psi_para_kpa(valor_psi):

    # PSI manométrico → PSI absoluto
    pressao_psia = valor_psi + PRESSAO_ATMOSFERICA_PSI

    # PSI absoluto → kPa absoluto
    pressao_kpa = pressao_psia * CONVERSAO_PSI_KPA

    return pressao_kpa

# ============================================================
# TEMPERATURA DE SATURAÇÃO - VAPOR
# ============================================================

def obter_temperatura_saturacao_vapor(pressao_kpa):

    temperatura_k = PropsSI(
        'T',
        'P',
        pressao_kpa * 1000,
        'Q',
        1,
        REFRIGERANTE
    )

    return temperatura_k - 273.15


# ============================================================
# TEMPERATURA DE SATURAÇÃO - LÍQUIDO
# ============================================================

def obter_temperatura_saturacao_liquido(pressao_kpa):

    temperatura_k = PropsSI(
        'T',
        'P',
        pressao_kpa * 1000,
        'Q',
        0,
        REFRIGERANTE
    )

    return temperatura_k - 273.15

# ============================================================
# SUPERAQUECIMENTO
# ============================================================

def calcular_superaquecimento(
    temperatura_real,
    temperatura_saturacao
):

    return temperatura_real - temperatura_saturacao

# ============================================================
# SUBRESFRIAMENTO
# ============================================================

def calcular_subresfriamento(
    temperatura_saturacao,
    temperatura_real
):

    return temperatura_saturacao - temperatura_real

# ============================================================
# EXPORTAR RESULTADOS
# ============================================================

def exportar_resultados(
    superaquecimento_1,
    superaquecimento_2,
    subresfriamento,
    temperatura_succao_1_c,
    temperatura_sat_baixa,
    temperatura_succao_2_c,
    temperatura_sat_alta,
    temperatura_liquido_c,
    pressao_succao_psi,
    pressao_alta_psi,
    cenario_1,
    cenario_2
):

    with open(FILE_SA_E_SE, "w") as f:

        # Resultados dos cálculos
        f.write(f"{superaquecimento_1:.2f}\n")
        f.write(f"{superaquecimento_2:.2f}\n")
        f.write(f"{subresfriamento:.2f}\n")

        # Temperaturas
        f.write(f"{temperatura_succao_1_c:.2f}\n")
        f.write(f"{temperatura_sat_baixa:.2f}\n")
        f.write(f"{temperatura_succao_2_c:.2f}\n")
        f.write(f"{temperatura_sat_baixa:.2f}\n")
        f.write(f"{temperatura_sat_alta:.2f}\n")
        f.write(f"{temperatura_liquido_c:.2f}\n")

        # Pressões
        f.write(f"{pressao_succao_psi:.2f}\n")
        f.write(f"{pressao_alta_psi:.2f}\n")

        # Cenários
        f.write(f"{cenario_1}\n")
        f.write(f"{cenario_2}\n")

# ============================================================
# PROCESSAMENTO
# ============================================================

def processar_dados(mock=False):

    # --------------------------------------------------------
    # CARREGAR ARRAYS
    # --------------------------------------------------------

    arquivo_pressao = FILE_PRESSAO_MOCK if mock else FILE_PRESSAO
    arquivo_temperatura = FILE_TEMPERATURA_MOCK if mock else FILE_TEMPERATURA

    array_pressao = ler_array(arquivo_pressao)
    array_temperatura = ler_array(arquivo_temperatura)

    if len(array_pressao) <= 3:
        return

    if len(array_temperatura) <= 12:
        return

    # --------------------------------------------------------
    # TEMPERATURAS MEDIDAS
    # --------------------------------------------------------

    temperatura_succao_1_c = array_temperatura[6]
    temperatura_succao_2_c = array_temperatura[12]

    temperatura_liquido_c = array_temperatura[3]

    # --------------------------------------------------------
    # PRESSÕES
    # --------------------------------------------------------

    pressao_succao_psi = array_pressao[3]
    pressao_alta_psi = array_pressao[1]


    # --------------------------------------------------------
    # CONVERSÃO DAS PRESSÕES
    # --------------------------------------------------------

    pressao_succao_kpa = converter_pressao_psi_para_kpa(
        pressao_succao_psi
    )

    pressao_alta_kpa = converter_pressao_psi_para_kpa(
        pressao_alta_psi
    )

    # --------------------------------------------------------
    # TEMPERATURAS DE SATURAÇÃO - COOLPROP
    # --------------------------------------------------------

    temperatura_sat_baixa = obter_temperatura_saturacao_vapor(
        pressao_succao_kpa
    )

    temperatura_sat_alta = obter_temperatura_saturacao_liquido(
        pressao_alta_kpa
    )

    # --------------------------------------------------------
    # SUPERAQUECIMENTO 1
    # --------------------------------------------------------

    superaquecimento_1 = calcular_superaquecimento(
        temperatura_succao_1_c,
        temperatura_sat_baixa
    )

    # --------------------------------------------------------
    # SUPERAQUECIMENTO 2
    # --------------------------------------------------------

    superaquecimento_2 = calcular_superaquecimento(
        temperatura_succao_2_c,
        temperatura_sat_baixa
    )

    # --------------------------------------------------------
    # SUBRESFRIAMENTO
    # --------------------------------------------------------

    subresfriamento = calcular_subresfriamento(
        temperatura_sat_alta,
        temperatura_liquido_c
    )

    # --------------------------------------------------------
    # CENÁRIO
    # --------------------------------------------------------

    cenario_1 = calcular_cenario(
        superaquecimento_1,
        subresfriamento,
        1
    )

    cenario_2 = calcular_cenario(
        superaquecimento_2,
        subresfriamento,
        2
    ) 

    # --------------------------------------------------------
    # EXPORTAR
    # --------------------------------------------------------

    exportar_resultados(
    superaquecimento_1,
    superaquecimento_2,
    subresfriamento,
    temperatura_succao_1_c,
    temperatura_sat_baixa,
    temperatura_succao_2_c,
    temperatura_sat_alta,
    temperatura_liquido_c,
    pressao_succao_psi,
    pressao_alta_psi,
    cenario_1,
    cenario_2
)

# ============================================================
# EXECUÇÃO
# ============================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--mock",
        action="store_true",
        help="Simula continuamente as três leituras da imagem."
    )
    parser.add_argument(
        "--uma-volta",
        action="store_true",
        help="Executa cada amostra mock uma vez e encerra."
    )
    argumentos = parser.parse_args()

    if argumentos.mock:
        gerar_mock_dados(repetir=not argumentos.uma_volta)
    else:
        processar_dados()
