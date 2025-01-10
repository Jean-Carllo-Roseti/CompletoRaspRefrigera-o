import java.text.SimpleDateFormat; // Para formatação de data
import java.util.Date; // Para obter a data atual
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;



String mensagem = ""; // Variável para armazenar a mensagem de sucesso
int mensagemTimeout = 0; // Tempo restante para exibir a mensagem

PImage img1, img2, img3, img4;  // Variáveis para armazenar as imagens
long lastUpdateTime = 0; // Tempo da última atualização
int updateInterval = 2100;  // Intervalo para atualizar as imagens (1 segundo)


String[] palavras = {"Air Out", "Air In", "Condenser Fan", "Condenser Assy", "Air In", "P2, P3, P4, P6, P8: SB69-500V", "P1, P7, P5, P9: SB69-100V",
"Evaporator Module", "Evaporator Module", "Compressor Module", "Evaporator Module","Air Out", "In Refr", "Out Refr", "In Refr", "Out Refr", "Air In",
"Air Out", "Temp In", "Temp Out", "Air In", "In", "Out", "Freon Out", "Freon In", "Suction - Gasous Freon", "Pressure - Gaseous Freon", " Pressure - Liquid Freon "};
PVector[] posicoes;

String caminhoImagem1 = "/home/avionics/Desktop/RaspberryResfriacao/assets/images/imagem.png";
String caminhoImagem2 = "/home/avionics/Desktop/RaspberryResfriacao/assets/images/imagem2.png";
String caminhoImagem3 = "/home/avionics/Desktop/RaspberryResfriacao/assets/images/imagem3.png";
String caminhoImagem4 = "/home/avionics/Desktop/RaspberryResfriacao/assets/images/FotoMalha.png";

long lastMockUpdateTime = 0; // Tempo da última atualização dos dados fictícios PARA DADOS MOCADOS, TEST.
int mockUpdateInterval = 2000; // Intervalo para atualizar os dados fictícios (2 segundos)

long lastReadDataTime = 0; // Tempo da última execução da função readDataFromFile PARA DADOS REAIS
int readDataInterval = 2000; // Intervalo para chamar a função (5 segundos, por exemplo)


float[] temperatures = new float[25]; // Array para armazenar temperaturas
float[] pressures = new float[9]; // Array para armazenar pressões

String userInput1 = "";
String userInput2 = "";
String userInput3 = "";
String userInput4 = "";
String userInput5 = "";
String userInput6 = "";
int currentInput = 0; // Para rastrear qual input está ativo

void setup() {
  fullScreen();  // Define o tamanho da tela para tela cheia

  // Carregar as imagens inicialmente
  img1 = loadImage(caminhoImagem1);
  img2 = loadImage(caminhoImagem2);
  img3 = loadImage(caminhoImagem3);
  img4 = loadImage(caminhoImagem4);

  lastUpdateTime = millis(); // Armazena o tempo inicial de execução
  readDataFromFile();
  
  
  posicoes = new PVector[]{
      new PVector(width * 0.085, height * 0.19),  // Air Out BOX 1
      new PVector(width * 0.085, height * 0.155),  // Air In BOX 1
      new PVector(width * 0.70, height * 0.12), // Condenser Fan 
      new PVector(width * 0.538, height * 0.12), // Condenser Assy
      new PVector(width * 0.55, height * 0.365), // BOX 2 AIR IN
      new PVector(width * 0.405, height * 0.075), // P2, P3, P4, P6, P8: SB69-500V
      new PVector(width * 0.405, height * 0.096),  // P1, P7, P5, P9: SB69-100V
      new PVector(width * 0.054, height * 0.3745),  // Evaporator Box1
      new PVector(width * 0.756, height * 0.496),  // Evaporator Box3
      new PVector(width * 0.88, height * 0.39),  // Compressor Module
      new PVector(width * 0.142, height * 0.455),  // Evaporator box2
      new PVector(width * 0.55, height * 0.394),  // Air out Box3
      new PVector(width * 0.265, height * 0.28),  // In Ref Box 3 
      new PVector(width * 0.29, height * 0.175),  // Out Ref Box 1
      
      new PVector(width * 0.52, height * 0.5),  // In Ref Box 4
      
      new PVector(width * 0.7, height * 0.34),  // Out Refr BOX 3
      new PVector(width * 0.345, height * 0.435),  // Air in BOX 2
      new PVector(width * 0.345, height * 0.39),  // Air Out BOX 2
      
      new PVector(width * 0.64, height * 0.32),  // Temp In BOX 4
      new PVector(width * 0.64, height * 0.18),  // Temp Out BOX 4
      new PVector(width * 0.71, height * 0.25),  // Air In BOX 4
      
      new PVector(width * 0.48, height * 0.185),  // In Linha Azul
      new PVector(width * 0.405, height * 0.185),  // OUt Linha Azul
      
      new PVector(width * 0.79, height * 0.26),  // Freon out Compressor 
      new PVector(width * 0.79, height * 0.3445),  // Frenon In Comrpessor
      
      new PVector(width * 0.13, height * 0.045),  // Suction - verde
      new PVector(width * 0.13, height * 0.075),  //  Roxo
      new PVector(width * 0.13, height * 0.1),  //  AZUL
      
      new PVector(width * 0.88, height * 0.51),  // Data
      new PVector(width * 0.88, height * 0.525)  // Hora
  };
}

void draw() {
  background(255);  // Limpa a tela com fundo branco

  // Verifica se passou o tempo do intervalo para atualizar as imagens
  if (millis() - lastUpdateTime > updateInterval) {
    lastUpdateTime = millis(); // Atualiza o tempo de última atualização

    // Atualiza as imagens caso o arquivo tenha sido modificado
    img1 = loadImage(caminhoImagem1); 
    img2 = loadImage(caminhoImagem2);
    img3 = loadImage(caminhoImagem3);
  }

  // Desenha as imagens
  image(img1, 0, 420, width * 0.33, height * 0.38);  // Imagem 1
  image(img2, 340, 420, width * 0.33, height * 0.38); // Imagem 2
  image(img3, 680, 420, width * 0.33, height * 0.38); // Imagem 3
  image(img4, 30, 20, width * 0.97, height * 0.52);  // Imagem 4 (não atualiza automaticamente, permanece fixa)
   
      //BOX1
    drawSensorCircle("P5", pressures[4], width * 0.147, height * 0.17);
    drawSensorCircle("P4", pressures[3], width * 0.147, height * 0.267);
    
    drawSensorCircleTemp("T1", temperatures[0], width * 0.147, height * 0.22);
    drawSensorCircleTemp("T4", temperatures[2], width * 0.064, height * 0.17);
    drawSensorCircleTemp("T3", temperatures[3], width * 0.064, height * 0.21);
    drawSensorCircleTemp("TEO", temperatures[4], width * 0.061, height * 0.34);
    drawSensorCircleTemp("T2", temperatures[1], width * 0.147, height * 0.32);
  
    // BOX2
    drawSensorCircle("P6", pressures[5], width * 0.279, height * 0.485);
    drawSensorCircle("P7", pressures[6], width * 0.277, height * 0.33);
    
    drawSensorCircleTemp("TEO", temperatures[9], width * 0.20, height * 0.52);
    drawSensorCircleTemp("T9", temperatures[8], width * 0.325, height * 0.41);
    drawSensorCircleTemp("T8", temperatures[7], width * 0.325, height * 0.45);
    drawSensorCircleTemp("T7", temperatures[6], width * 0.279, height * 0.52);
    drawSensorCircleTemp("T6", temperatures[5], width * 0.277, height * 0.375);
  
    // BOX3
    drawSensorCircle("P8", pressures[7], width * 0.66, height * 0.46);
    drawSensorCircle("P9", pressures[8], width * 0.66, height * 0.38);
    
    drawSensorCircleTemp("T12", temperatures[11], width * 0.66, height * 0.50);
    drawSensorCircleTemp("T11", temperatures[10], width * 0.66, height * 0.42); 
    drawSensorCircleTemp("T14", temperatures[13], width * 0.53, height * 0.41);
    drawSensorCircleTemp("T13", temperatures[12], width * 0.53, height * 0.38);
    drawSensorCircleTemp("TEO", temperatures[14], width * 0.62, height * 0.525);
  
    // BOX4
    drawSensorCircle("P3", pressures[2], width * 0.505, height * 0.267);
    
    drawSensorCircleTemp("T16", temperatures[15], width * 0.690, height * 0.267);
    drawSensorCircleTemp("T18", temperatures[17], width * 0.505, height * 0.305);
    drawSensorCircleTemp("T17", temperatures[16], width * 0.625, height * 0.337);
    drawSensorCircleTemp("T19", temperatures[18], width * 0.625, height * 0.195);
    drawSensorCircleTemp("TF20", temperatures[19], width * 0.76, height * 0.18); //FAN  
    
    // LINHAS E EQUIPAMENTOS
    drawSensorCircle("P2", pressures[1], width * 0.78, height * 0.24); // SAIDA MOTOR
    drawSensorCircleTemp("T23", temperatures[22], width * 0.78, height * 0.29); //SAIDA MOTOR
    
    drawSensorCircle("P1", pressures[0], width * 0.78, height * 0.32); //MOTOR Entrada 
    drawSensorCircleTemp("T22", temperatures[21], width * 0.78, height * 0.373); //MOTOR entrada
    drawSensorCircleTemp("TC", temperatures[23], width * 0.90, height * 0.355); //TEMP COMPRESSOR
    drawSensorCircleTemp("TM", temperatures[24], width * 0.92, height * 0.19); // TEMP MOTOR
    drawSensorCircleTemp("T21", temperatures[20], width * 0.43, height * 0.17);
    
    drawTextInput(userInput1, width * 0.052, height * 0.39, "SN"); //BOX1
    drawTextInput(userInput2, width * 0.14, height * 0.47, "SN"); //BOX2
    drawTextInput(userInput3, width * 0.753, height * 0.511, "SN"); //BOX3
    drawTextInput(userInput4, width * 0.538, height * 0.132, "SN"); //BO4 CONDENSER ASSY
    drawTextInput(userInput5, width * 0.88, height * 0.4, "SN"); //COMPRESSOR
    drawTextInput(userInput6, width * 0.7, height * 0.132, "SN"); //FAN
    
  /*
   if (millis() - lastMockUpdateTime > mockUpdateInterval) {
    generateMockData();
    lastMockUpdateTime = millis(); // Atualiza o tempo de última atualização
  }
  */
  
  if (millis() - lastReadDataTime > readDataInterval) {
    readDataFromFile(); // Chama a função para ler os dados do arquivo
    lastReadDataTime = millis(); // Atualiza o tempo de última execução
  }
  
  if (mensagemTimeout > 0) {
    pushStyle(); // Salva o estilo atual
    fill(0, 255, 0);
    textSize(20);
    textAlign(RIGHT, TOP);
    text(mensagem, width - 10, 10);
    popStyle(); // Restaura o estilo anterior
    mensagemTimeout--;
}
  
  drawPalavras();
  drawSaveButton();
  
}

void drawTextInput(String inputText, float x, float y, String label) {
  float inputWidth = width * 0.1;  // Largura do campo de texto (exemplo proporcional)
  float inputHeight = height * 0.02; // Altura do campo de texto (exemplo proporcional)

  fill(200); // Cor de fundo do campo de texto
  rect(x, y, inputWidth, inputHeight); // Desenha o retângulo do campo de texto

  fill(0); // Cor do texto (preto)
  textSize(10);
  textAlign(LEFT, CENTER);
  text(label + ": " + inputText, x + 5, y + inputHeight / 2); // Texto de entrada, centralizado verticalmente
}


void generateMockData() {
  for (int i = 0; i < temperatures.length; i++) {
    temperatures[i] = random(15, 30); // Gera temperaturas aleatórias entre 15 e 30
  }
  for (int i = 0; i < pressures.length; i++) {
    pressures[i] = random(20, 180); // Gera pressões aleatórias entre 95000 e 105000 Pa
  }
}

void drawPalavras() {
  fill(0); // Cor do texto
  textSize(12); // Tamanho da fonte
  
  // Desenha cada palavra na posição correspondente
  for (int i = 0; i < palavras.length; i++) {
    text(palavras[i], posicoes[i].x, posicoes[i].y);
  }
  
    String dataAtual = getCurrentDate();
    String horaAtual = getCurrentTime();
  
    // Desenha a data ao lado do campo "Data:"
  text(dataAtual, posicoes[28].x + 40, posicoes[28].y); // Ajuste a posição conforme necessário

  // Desenha a hora ao lado do campo "Hora:"
  text(horaAtual, posicoes[29].x + 40, posicoes[29].y); // Ajuste a posição conforme necessário
}

// Função para obter a data atual
String getCurrentDate() {
  SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
  Date date = new Date();
  return dateFormat.format(date);
}

// Função para obter a hora atual
String getCurrentTime() {
  SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
  Date time = new Date();
  return timeFormat.format(time);
}

void drawSensorCircle(String label, float sensorValue, float x, float y) {
  fill(0); // Cor do círculo
  ellipse(x, y, 20, 20); // Desenha o círculo

  fill(255); // Cor do texto (branco)
  textSize(12);
  textAlign(CENTER, CENTER);
  text(label, x, y); // Desenha a letra maiúscula no centro do círculo

  // Desenha o valor ao lado do círculo
  fill(0); // Cor do texto (preto)
  textSize(12);
  textAlign(LEFT, CENTER);
  text(nf(sensorValue, 0, 2) + " PSI", x + 20, y); // Desenha o valor ao lado
}

void drawSensorCircleTemp(String label, float sensorValue, float x, float y) {
  fill(0); // Cor do círculo
  ellipse(x, y, 20, 20); // Desenha o círculo

  fill(255); // Cor do texto (branco)
  textSize(12);
  textAlign(CENTER, CENTER);
  text(label, x, y); // Desenha a letra maiúscula no centro do círculo

  // Desenha o valor ao lado do círculo
  fill(0); // Cor do texto (preto)
  textSize(12);
  textAlign(LEFT, CENTER);
  text(nf(sensorValue, 0, 2) + " °C", x + 20, y); // Desenha o valor ao lado
}

void drawSaveButton() {
  fill(0, 200, 0); // Cor do botão (verde)
  rect(width * 0.86, height * 0.505, width * 0.05, height * 0.025); // Nova posição do botão em (900, 50)
  fill(255); // Cor do texto (branco)
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Save", width * 0.885, height * 0.515); // Texto centralizado no botão
}

// Função para detectar a interação do mouse
void mousePressed() {
  // Calcula as dimensões do botão "Save" dinamicamente
  float saveX = width * 0.86;         // Coordenada X inicial do botão
  float saveY = height * 0.505;       // Coordenada Y inicial do botão
  float saveWidth = width * 0.05;     // Largura do botão
  float saveHeight = height * 0.025;  // Altura do botão
  
  // Coordenadas e tamanhos dos campos de entrada
  float inputWidth = width * 0.1;    // Largura do campo de texto
  float inputHeight = height * 0.02; // Altura do campo de texto

  float inputX1 = width * 0.052;     // Coordenada X do campo 1
  float inputY1 = height * 0.39;     // Coordenada Y do campo 1

  float inputX2 = width * 0.14;      // Coordenada X do campo 2
  float inputY2 = height * 0.47;     // Coordenada Y do campo 2

  float inputX3 = width * 0.753;     // Coordenada X do campo 3
  float inputY3 = height * 0.511;    // Coordenada Y do campo 3

  float inputX4 = width * 0.538;     // Coordenada X do campo 4
  float inputY4 = height * 0.132;    // Coordenada Y do campo 4

  float inputX5 = width * 0.88;      // Coordenada X do campo 5
  float inputY5 = height * 0.4;      // Coordenada Y do campo 5

  float inputX6 = width * 0.7;       // Coordenada X do campo 6
  float inputY6 = height * 0.132;    // Coordenada Y do campo 6

  // Verifica se o clique foi dentro do botão "Save"
  if (mouseX > saveX && mouseX < saveX + saveWidth &&
      mouseY > saveY && mouseY < saveY + saveHeight) {
    saveWithTimestamp(); // Chama a função de salvar
  }

  // Detecta qual campo de entrada foi clicado
  if (mouseX > inputX1 && mouseX < inputX1 + inputWidth &&
      mouseY > inputY1 && mouseY < inputY1 + inputHeight) {
    currentInput = 0; // Campo userInput1
  } else if (mouseX > inputX2 && mouseX < inputX2 + inputWidth &&
             mouseY > inputY2 && mouseY < inputY2 + inputHeight) {
    currentInput = 1; // Campo userInput2
  } else if (mouseX > inputX3 && mouseX < inputX3 + inputWidth &&
             mouseY > inputY3 && mouseY < inputY3 + inputHeight) {
    currentInput = 2; // Campo userInput3
  } else if (mouseX > inputX4 && mouseX < inputX4 + inputWidth &&
             mouseY > inputY4 && mouseY < inputY4 + inputHeight) {
    currentInput = 3; // Campo userInput4
  } else if (mouseX > inputX5 && mouseX < inputX5 + inputWidth &&
             mouseY > inputY5 && mouseY < inputY5 + inputHeight) {
    currentInput = 4; // Campo userInput5
  } else if (mouseX > inputX6 && mouseX < inputX6 + inputWidth &&
             mouseY > inputY6 && mouseY < inputY6 + inputHeight) {
    currentInput = 5; // Campo userInput6
  }
}


void keyPressed() {
  // Remoção de caracteres com BACKSPACE
  if (key == BACKSPACE) {
    if (currentInput == 0 && userInput1.length() > 0) {
      userInput1 = userInput1.substring(0, userInput1.length() - 1);
    } else if (currentInput == 1 && userInput2.length() > 0) {
      userInput2 = userInput2.substring(0, userInput2.length() - 1);
    } else if (currentInput == 2 && userInput3.length() > 0) {
      userInput3 = userInput3.substring(0, userInput3.length() - 1);
    } else if (currentInput == 3 && userInput4.length() > 0) {
      userInput4 = userInput4.substring(0, userInput4.length() - 1);
    } else if (currentInput == 4 && userInput5.length() > 0) {
      userInput5 = userInput5.substring(0, userInput5.length() - 1);
    } else if (currentInput == 5 && userInput6.length() > 0) {
      userInput6 = userInput6.substring(0, userInput6.length() - 1);
    } 
  }
  // Adiciona caracteres quando não é BACKSPACE, ENTER ou TAB
  else if (key != ENTER && key != TAB) {
    if (currentInput == 0 && userInput1.length() < 15) {
      userInput1 += key;
    } else if (currentInput == 1 && userInput2.length() < 15) {
      userInput2 += key;
    } else if (currentInput == 2 && userInput3.length() < 15) {
      userInput3 += key;
    } else if (currentInput == 3 && userInput4.length() < 15) {
      userInput4 += key;
    } else if (currentInput == 4 && userInput3.length() < 15) {
      userInput5 += key;
    } else if (currentInput == 5 && userInput4.length() < 15) {
      userInput6 += key;
    }
  }
}

//bom, alterar apenas para tirar a foto da malha
void saveWithTimestamp() {
  // Gera o timestamp para criar uma pasta única
  String timestamp = new SimpleDateFormat("yyyy_MM_dd_HH-mm-ss").format(new Date());
  String folderPath = "/home/avionics/Desktop/RaspberryResfriacao/ScrenShots/Registros/" + timestamp;
  new File(folderPath).mkdir(); // Cria a pasta com o timestamp

  // Salvando cada imagem com sua legenda
  salvarImagemComLegenda(img1, userInput1, folderPath + "/imagem1.png");
  salvarImagemComLegenda(img2, userInput2, folderPath + "/imagem2.png");
  salvarImagemComLegenda(img3, userInput3, folderPath + "/imagem3.png");
  save(folderPath + "/Malha.png");

  println("Imagens salvas com legendas em: " + folderPath);
  mensagem = "Imagens geradas com sucesso.";
  mensagemTimeout = 50; // Número de frames que a mensagem será exibida (ajuste conforme necessário)
}

void salvarImagemComLegenda(PImage img, String legenda, String caminhoSaida) {
  // Adiciona o prefixo "SN: " à legenda
  String legendaComPrefixo = "SN: " + legenda;

  // Cria um novo canvas com a imagem e espaço extra para a legenda
  PGraphics canvas = createGraphics(img.width, img.height + 30); // 30px para a legenda
  canvas.beginDraw();

  // Desenha a imagem no canvas
  canvas.image(img, 0, 0); 

  // Adiciona o fundo opaco para a legenda
  canvas.fill(0); // Define a cor preta para o fundo
  canvas.noStroke(); // Remove as bordas do retângulo
  canvas.rect(0, img.height, img.width, 30); // Desenha um retângulo preto na área da legenda

  // Adiciona a legenda por cima do fundo
  canvas.fill(255); // Cor do texto (branco)
  canvas.textSize(16);
  canvas.textAlign(CENTER, CENTER);
  canvas.text(legendaComPrefixo, img.width / 2, img.height + 15); // Legenda centralizada abaixo da imagem

  canvas.endDraw();

  // Salva a imagem com a legenda
  canvas.save(caminhoSaida);
}

void readDataFromFile() {
  String filePathP = "/home/avionics/Desktop/RaspberryResfriacao/Back-End/dados_pressao.txt";
  String filePathT = "/home/avionics/Desktop/RaspberryResfriacao/Back-End/dados_temperatura.txt";

  try {
    // Cria BufferedReader para ambos os arquivos
    BufferedReader readerP = new BufferedReader(new FileReader(filePathP));
    BufferedReader readerT = new BufferedReader(new FileReader(filePathT));

    String line;

    // Lê todas as linhas de pressão
    while ((line = readerP.readLine()) != null) {
      String[] values = line.split(","); // Divide a linha em valores
      for (int i = 0; i < values.length && i < pressures.length; i++) {
        try {
          pressures[i] = Float.parseFloat(values[i].trim()); // Converte para float
          println("Pressão lida: " + pressures[i]); // Verifica o valor lido
        } catch (NumberFormatException e) {
          println("Erro ao converter a pressão na posição " + i + ": " + values[i]);
        }
      }
    }

    // Lê todas as linhas de temperatura
    while ((line = readerT.readLine()) != null) {
      String[] values = line.split(","); // Divide a linha em valores
      for (int j = 0; j < values.length && j < temperatures.length; j++) {
        try {
          temperatures[j] = Float.parseFloat(values[j].trim()); // Converte para float
          println("Temperatura lida: " + temperatures[j]); // Verifica o valor lido
        } catch (NumberFormatException e) {
          println("Erro ao converter a temperatura na posição " + j + ": " + values[j]);
        }
      }
    }
    // Fecha os leitores
    readerP.close();
    readerT.close();
    
  } catch (IOException e) {
    println("Erro ao ler o arquivo: " + e.getMessage());
  }
}
