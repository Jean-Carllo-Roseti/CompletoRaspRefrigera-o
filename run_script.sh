#!/bin/bash

cd /home/avionics/Refri/CompletoRaspRefrigera-o

# Ativa o ambiente virtual
source /home/avionics/Refri/CompletoRaspRefrigera-o/venv/bin/activate

# Executa o script
python /home/avionics/Refri/CompletoRaspRefrigera-o/main.py

read -p "Pressione Enter para continuar..."