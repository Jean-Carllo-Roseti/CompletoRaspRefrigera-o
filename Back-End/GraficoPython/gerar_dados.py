import random
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

#Dados mocados
def gerar_dados_sensores():
    # with open(caminho_arquivo, "w") as file:
        # Gera 24 temperaturas aleatórias (entre 15°C e 30°C)
        temperaturas = [round(random.uniform(15.0, 30.0), 2) for _ in range(26)]
        # Gera 5 pressões aleatórias (entre 0 e 10 bar)
        pressoes = [round(random.uniform(0.0, 120.0), 2) for _ in range(9)]

        return temperaturas, pressoes

@app.route('/dados-sensores', methods=['GET'])
def get_dados_sensores():
    temperaturas, pressoes = gerar_dados_sensores()
    print("Temperaturas:", temperaturas)
    print("Pressões:", pressoes)

    return jsonify({'temperaturas': temperaturas, 'pressoes': pressoes})
    
@app.after_request
def add_headers(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    return response

if __name__ == '__main__':
    app.run(port=5000)
