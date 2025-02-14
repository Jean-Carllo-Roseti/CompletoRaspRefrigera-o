#!/bin/bash

cd /home/avionics/Refri/CompletoRaspRefrigera

# Ativa o ambiente virtual
source /home/avionics/Refri/CompletoRaspRefrigera/venv/bin/activate

# Executa o script
python /home/avionics/Refri/CompletoRaspRefrigera/main.py &

# Executa o aplicativo Processing (Front-End)
/home/avionics/Refri/CompletoRaspRefrigera/Front-End/linux-aarch64/Front-End &

# Monitora as alterações nos diretórios e sincroniza automaticamente
while inotifywait -e modify,move,create,delete /home/avionics/Refri/CompletoRaspRefrigera/ScrenShots/Registros/; do
    sleep 1
    rsync -avz /home/avionics/Refri/CompletoRaspRefrigera/ScrenShots/Registros/ /home/avionics/Desktop/Registros/
done


read -p "Pressione Enter para continuar..." 