import asyncio
import os

#caminhi para o diretório onde o script main.py esta localizado.
#base_path = os.path.dirname(os.path.realpath(__file__))

# Função para rodar um script Python em um subprocesso assíncrono
async def run_script(script_path):
    while True:
        print(f"Executando {script_path}...")
        process = await asyncio.create_subprocess_exec(
            "python", script_path,  # Comando para executar o script
            stdout=asyncio.subprocess.PIPE,  # Captura a saída padrão
            stderr=asyncio.subprocess.PIPE   # Captura erros
        )
        stdout, stderr = await process.communicate()

        if stdout:
            print(f"[{script_path}] OUTPUT:\n{stdout.decode()}")
        if stderr:
            print(f"[{script_path}] ERROR:\n{stderr.decode()}")

        # Aguarda um tempo antes de reiniciar o loop (opcional)
        await asyncio.sleep(2)

# Função principal para gerenciar todos os scripts
async def main():
    # Caminhos absolutos para os scripts
    scripts = [
        r"/home/avionics/Refri/CompletoRaspRefrigera-o/Back-End/GraficoPython/gerar_dados.py",
        r"/home/avionics/Refri/CompletoRaspRefrigera-o/Back-End/GraficoPython/GraficoA.py",
        r"/home/avionics/Refri/CompletoRaspRefrigera-o/Back-End/GraficoPython/GraficoB.py",
        r"/home/avionics/Refri/CompletoRaspRefrigera-o/Back-End/GraficoPython/GraficoC.py"
    ]

    # Cria tarefas para executar os scripts em paralelo
    tasks = [run_script(script) for script in scripts]
    await asyncio.gather(*tasks)  # Executa todas as tarefas simultaneamente

# Ponto de entrada do script
if __name__ == "__main__":
    asyncio.run(main())


#import asyncio
#import queue

# Fila para dados de temperatura e pressão
#temp_queue = queue.Queue()
#pressao_queue = queue.Queue()

# Função para rodar um script Python em um subprocesso assíncrono
# async def run_script(script_path, args=None):
#    while True:
#        print(f"Executando {script_path}...")
#        process = await asyncio.create_subprocess_exec(
#            "python", script_path, *args,  # Comando para executar o script
#            stdout=asyncio.subprocess.PIPE,  # Captura a saída padrão
#            stderr=asyncio.subprocess.PIPE   # Captura erros
#        )
#        stdout, stderr = await process.communicate()

#        if stdout:
#            print(f"[{script_path}] OUTPUT:\n{stdout.decode()}")
#        if stderr:
#            print(f"[{script_path}] ERROR:\n{stderr.decode()}")

        # Aguarda um tempo antes de reiniciar o loop (opcional)
#        await asyncio.sleep(2)

# Função principal para gerenciar todos os scripts
#async def main():
    # Caminhos para os scripts
 #   scripts_grupo_1 = [
 #       "/home/avionics/Desktop/RaspberryResfriacao/Back-End/GraficoPython/gerar_dados_temp.py",
 #       "/home/avionics/Desktop/RaspberryResfriacao/Back-End/GraficoPython/gerar_dados_pressao.py"
 #   ]
    
  #  scripts_grupo_2 = [
  #      "/home/avionics/Desktop/RaspberryResfriacao/Back-End/GraficoPython/GraficoA.py",
  #      "/home/avionics/Desktop/RaspberryResfriacao/Back-End/GraficoPython/GraficoB.py",
  #      "/home/avionics/Desktop/RaspberryResfriacao/Back-End/GraficoPython/GraficoC.py"
  #  ]
    
    # Grupo 1: Coletando dados de temperatura e pressão
 #   tasks_grupo_1 = [
 #       run_script(scripts_grupo_1[0]),  # Rodando script de dados de temperatura
 #       run_script(scripts_grupo_1[1])   # Rodando script de dados de pressão
 #   ]
    
    # Grupo 2: Gerando gráficos A, B, C
 #   tasks_grupo_2 = [
 #       run_script(scripts_grupo_2[0]),  # Rodando gráfico A
 #       run_script(scripts_grupo_2[1]),  # Rodando gráfico B
 #       run_script(scripts_grupo_2[2])   # Rodando gráfico C
 #   ]
    
    # Executa os dois grupos de tarefas simultaneamente
 #   await asyncio.gather(*tasks_grupo_1, *tasks_grupo_2)

# Ponto de entrada do script
#if __name__ == "__main__":
#    asyncio.run(main())
