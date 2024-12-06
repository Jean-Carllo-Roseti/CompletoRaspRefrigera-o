import asyncio

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
        r"C:\ProgJean\MainFront\GraficoPython\gerar_dados.py",
        r"C:\ProgJean\MainFront\GraficoPython\GraficoA.py",
        r"C:\ProgJean\MainFront\GraficoPython\GraficoB.py",
        r"C:\ProgJean\MainFront\GraficoPython\GraficoC.py"
    ]

    # Cria tarefas para executar os scripts em paralelo
    tasks = [run_script(script) for script in scripts]
    await asyncio.gather(*tasks)  # Executa todas as tarefas simultaneamente

# Ponto de entrada do script
if __name__ == "__main__":
    asyncio.run(main())
