import os
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
    'SAeSE.txt'
)


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
# PRESSÃO
# ============================================================

def converter_pressao_psi_para_kpa(valor_psi):

    # PSI manométrico → PSI absoluto
    pressao_psia = valor_psi + PRESSAO_ATMOSFERICA_PSI

    # PSI absoluto → kPa absoluto
    pressao_kpa = pressao_psia * CONVERSAO_PSI_KPA

    return pressao_kpa


# ============================================================
# TEMPERATURA DE SATURAÇÃO
# ============================================================

def obter_temperatura_saturacao(pressao_kpa):

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
    pressao_alta_psi
):

    with open(FILE_SA_E_SE, "w") as f:

        f.write(f"{superaquecimento_1:.2f}\n")
        f.write(f"{superaquecimento_2:.2f}\n")
        f.write(f"{subresfriamento:.2f}\n")

        f.write(f"{temperatura_succao_1_c:.2f}\n")
        f.write(f"{temperatura_sat_baixa:.2f}\n")
        f.write(f"{temperatura_succao_2_c:.2f}\n")
        f.write(f"{temperatura_sat_baixa:.2f}\n")
        f.write(f"{temperatura_sat_alta:.2f}\n")
        f.write(f"{temperatura_liquido_c:.2f}\n")

        f.write(f"{pressao_succao_psi:.2f}\n")
        f.write(f"{pressao_alta_psi:.2f}\n")

# ============================================================
# PROCESSAMENTO
# ============================================================

def processar_dados():

    # --------------------------------------------------------
    # CARREGAR ARRAYS
    # --------------------------------------------------------

    array_pressao = ler_array(FILE_PRESSAO)
    array_temperatura = ler_array(FILE_TEMPERATURA)

    if len(array_pressao) <= 4:
        return

    if len(array_temperatura) <= 4:
        return


    # --------------------------------------------------------
    # TEMPERATURAS MEDIDAS
    # --------------------------------------------------------

    temperatura_succao_1_c = array_temperatura[6]
    temperatura_succao_2_c = array_temperatura[12]

    temperatura_liquido_c = array_temperatura[4]


    # --------------------------------------------------------
    # PRESSÕES
    # --------------------------------------------------------

    pressao_succao_psi = array_pressao[3]
    pressao_alta_psi = array_pressao[4]


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

    temperatura_sat_baixa = obter_temperatura_saturacao(
        pressao_succao_kpa
    )

    temperatura_sat_alta = obter_temperatura_saturacao(
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
    temperatura_liquido_c
)


# ============================================================
# EXECUÇÃO
# ============================================================

if __name__ == "__main__":
    processar_dados()