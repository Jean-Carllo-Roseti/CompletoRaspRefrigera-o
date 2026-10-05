#!/bin/bash

# cd /home/avionics/Refri/CompletoRaspRefrigera
cd /home/avionics/Refri/ENAER/CompletoRaspRefrigera-o

# Ativa o ambiente virtual
# source /home/avionics/Refri/CompletoRaspRefrigera/venv/bin/activate
source /home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/venv/bin/activate

# Executa o script
# python /home/avionics/Refri/CompletoRaspRefrigera/main.py &
python /home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/main.py &

# Executa o aplicativo Processing (Front-End)
# /home/avionics/Refri/CompletoRaspRefrigera/Front-End/linux-aarch64/Front-End &
/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/Front-End/linux-aarch64/Front-End &

# Monitora as alterações nos diretórios e sincroniza automaticamente
# while inotifywait -e modify,move,create,delete /home/avionics/Refri/CompletoRaspRefrigera/ScrenShots/Registros/; do
#     sleep 1
#     rsync -avz /home/avionics/Refri/CompletoRaspRefrigera/ScrenShots/Registros/ /home/avionics/Desktop/Registros/
# done
# Monitora as alterações nos diretórios e sincroniza automaticamente
while inotifywait -e modify,move,create,delete /home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/ScrenShots/Registros/; do
    sleep 1
    rsync -avz /home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/ScrenShots/Registros/ /home/avionics/Desktop/RegistrosENAER/
done


read -p "Pressione Enter para continuar..." 