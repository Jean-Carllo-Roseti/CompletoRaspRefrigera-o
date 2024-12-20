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
      new PVector(102, 147),  // Air Out BOX 1
      new PVector(102, 117),  // Air In BOX 1
      new PVector(1005, 87), // Condenser Fan 
      new PVector(710, 95), // Condenser Assy
      new PVector(445, 342), // BOX 2 AIR IN
      new PVector(530, 50), // P2, P3, P4, P6, P8: SB69-500V
      new PVector(530, 70),  // P1, P7, P5, P9: SB69-100V
      new PVector(60, 285),  // Evaporator Box1
      new PVector(1003, 382),  // Evaporator Box3
      new PVector(1195, 290),  // Compressor Module
      new PVector(210, 356),  // Evaporator box2
      new PVector(445, 302),  // Air out Box2
      new PVector(276, 215),  // In Ref Box 2 
      new PVector(302, 135),  // Out Ref Box 1
      
      new PVector(610, 385),  // In Ref Box 4
      
      new PVector(920, 261),  // Out Refr BOX 3
      new PVector(720, 279),  // Air in BOX 3
      new PVector(720, 304),  // Air Out BOX 3
      
      new PVector(820, 245),  // Temp In BOX 4
      new PVector(820, 138),  // Temp Out BOX 4
      new PVector(940, 200),  // Air In BOX 4
      
      new PVector(640, 142),  // In Linha Azul
      new PVector(545, 142),  // OUt Linha Azul
      
      new PVector(1060, 200),  // Freon out Compressor 
      new PVector(1060, 263),  // Frenon In Comrpessor
      
      new PVector(158, 38),  // Suction - verde
      new PVector(158, 58),  //  Roxo
      new PVector(158, 78),  //  AZUL
      
      new PVector(1190, 385),  // Data
      new PVector(1190, 400)  // Hora
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
  image(img1, 0, 420, 350, 300);  // Imagem 1
  image(img2, 340, 420, 350, 300); // Imagem 2
  image(img3, 680, 420, 350, 300); // Imagem 3
  image(img4, 30, 20, 1000, 400);  // Imagem 4 (não atualiza automaticamente, permanece fixa)
   
      //BOX1
    drawSensorCircle("P5", pressures[4], 150, 127);
    drawSensorCircle("P4", pressures[3], 150, 210);
    
    drawSensorCircleTemp("T1", temperatures[0], 150, 165);
    drawSensorCircleTemp("T4", temperatures[2], 65, 130);
    drawSensorCircleTemp("T3", temperatures[3], 65, 160);
    drawSensorCircleTemp("TEO", temperatures[4], 60, 255);
    drawSensorCircleTemp("T2", temperatures[1], 150, 245);
  
    // BOX2
    drawSensorCircle("P6", pressures[5], 285, 372);
    drawSensorCircle("P7", pressures[6], 285, 253);
    
    drawSensorCircleTemp("TEO", temperatures[9], 220, 402);
    drawSensorCircleTemp("T9", temperatures[8], 340, 315);
    drawSensorCircleTemp("T8", temperatures[7], 340, 355);
    drawSensorCircleTemp("T7", temperatures[6], 285, 402);
    drawSensorCircleTemp("T6", temperatures[5], 285, 288);
  
    // BOX3
    drawSensorCircle("P8", pressures[7], 864, 380);
    drawSensorCircle("P9", pressures[8], 864, 294);
    
    drawSensorCircleTemp("T12", temperatures[11], 864, 408);
    drawSensorCircleTemp("T11", temperatures[10], 864, 330); 
    drawSensorCircleTemp("T14", temperatures[13], 550, 315);
    drawSensorCircleTemp("T13", temperatures[12], 550, 290);
    drawSensorCircleTemp("TEO", temperatures[14], 610, 408);
  
    // BOX4
    drawSensorCircle("P3", pressures[2], 680, 205);
    
    drawSensorCircleTemp("T16", temperatures[15], 920, 213);
    drawSensorCircleTemp("T18", temperatures[17], 680, 240);
    drawSensorCircleTemp("T17", temperatures[16], 800, 255);
    drawSensorCircleTemp("T19", temperatures[18], 800, 150);
    drawSensorCircleTemp("TF20", temperatures[19], 1000, 130); //FAN  
    
    // LINHAS E EQUIPAMENTOS
    drawSensorCircle("P2", pressures[1], 1040, 185); // SAIDA MOTOR
    drawSensorCircleTemp("T23", temperatures[22], 1040, 225); //SAIDA MOTOR
    
    drawSensorCircle("P1", pressures[0], 1040, 250); //MOTOR Entrada 
    drawSensorCircleTemp("T22", temperatures[21], 1040, 285); //MOTOR entrada
    drawSensorCircleTemp("TC", temperatures[23], 1220, 260); //TEMP COMPRESSOR
    drawSensorCircleTemp("TM", temperatures[24], 1160, 135); // TEMP MOTOR
    drawSensorCircleTemp("T21", temperatures[20], 570, 125);
    
    drawTextInput(userInput1, 60, 295, "SN"); //BOX1
    drawTextInput(userInput2, 207, 365, "SN"); //BOX2
    drawTextInput(userInput3, 1000, 390, "SN"); //BOX3
    drawTextInput(userInput4, 710, 105, "SN"); //BO4
    drawTextInput(userInput5, 1195, 300, "SN"); //COMPRESSOR
    drawTextInput(userInput6, 995, 95, "SN"); //FAN
    
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
  fill(200); // Cor de fundo do campo de texto
  rect(x, y, 100, 15); // Desenha o retângulo do campo de texto
  fill(0); // Cor do texto (preto)
  textSize(10);
  textAlign(LEFT, CENTER);
  text(label + ": " + inputText, x + 2, y + 7); // Texto de entrada
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

void drawSensorCircle(String label, float sensorValue, int x, int y) {
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

void drawSensorCircleTemp(String label, float sensorValue, int x, int y) {
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
  rect(1115, 375, 100, 30); // Nova posição do botão em (900, 50)
  fill(255); // Cor do texto (branco)
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Save", 1164, 390); // Texto centralizado no botão
}

// Função para detectar a interação do mouse
void mousePressed() {
  // Verifica se o botão de salvar foi clicado na nova posição
  if (mouseX > 1115 && mouseX < 1215 && mouseY > 375 && mouseY < 405) {
    saveWithTimestamp(); // Chama a função de salvar
  } 
    // Detecta qual campo de entrada foi clicado
    if (mouseX > 60 && mouseX < 160 && mouseY > 295 && mouseY < 315) {
      currentInput = 0; // Campo userInput1
    } else if (mouseX > 190 && mouseX < 307 && mouseY > 340 && mouseY < 390) {
      currentInput = 1; // Campo userInput2
    } else if (mouseX > 1000 && mouseX < 1100 && mouseY > 390 && mouseY < 405) {
      currentInput = 2; // Campo userInput3
    } else if (mouseX > 710 && mouseX < 810 && mouseY > 105 && mouseY < 120) {
      currentInput = 3; // 
    } else if (mouseX > 1195 && mouseX < 1295 && mouseY > 300 && mouseY < 315) {
      currentInput = 4; // 
    }  else if (mouseX > 995 && mouseX < 1095 && mouseY > 95 && mouseY < 110) {
      currentInput = 5; // 
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

// Função para salvar uma imagem com uma legenda
void salvarImagemComLegenda(PImage img, String legenda, String caminhoSaida) {
  // Adiciona o prefixo "SN: " à legenda
  String legendaComPrefixo = "SN: " + legenda;

  // Cria um novo canvas com a imagem e espaço extra para a legenda
  PGraphics canvas = createGraphics(img.width, img.height + 30); // 30px para a legenda
  canvas.beginDraw();
  canvas.image(img, 0, 0); // Desenha a imagem no canvas

  // Adiciona a legenda
  canvas.fill(255); // Cor do texto (preto)
  canvas.textSize(16);
  canvas.textAlign(CENTER, CENTER);
  canvas.text(legendaComPrefixo, img.width / 2, img.height + 15); // Legenda centralizada abaixo da imagem
  canvas.endDraw();

  // Salva a imagem com a legenda
  canvas.save(caminhoSaida);
}



void readDataFromFile() {
  String filePath = "/home/avionics/Desktop/RaspberryResfriacao/valores_sensores.txt";

  try {
    BufferedReader reader = new BufferedReader(new FileReader(filePath));
    String line;

    // Lê as temperaturas
    line = reader.readLine(); // Lê a primeira linha
    if (line != null) {
      String[] values = line.split(","); // Divide a linha em valores
      for (int j = 0; j < values.length && j < temperatures.length; j++) {
        try {
          temperatures[j] = Float.parseFloat(values[j].trim()); // Converte para float
          println("Temperatura lida: " + temperatures[j]); // Verifica o valor lido
        } catch (NumberFormatException e) {
          println("Erro ao converter a temperatura na posição " + j + ": " + values[j]);
        }
      }
    } else {
      println("Nenhuma linha de temperatura encontrada.");
    }

    // Lê as pressões
    line = reader.readLine(); // Lê a próxima linha
    if (line != null) {
      String[] values = line.split(","); // Divide a linha em valores
      for (int i = 0; i < values.length && i < pressures.length; i++) {
        try {
          pressures[i] = Float.parseFloat(values[i].trim()); // Converte para float
          println("Pressão lida: " + pressures[i]); // Verifica o valor lido
        } catch (NumberFormatException e) {
          println("Erro ao converter a pressão na posição " + i + ": " + values[i]);
        }
      }
    } else {
      println("Nenhuma linha de pressão encontrada.");
    }

    reader.close();
  } catch (IOException e) {
    println("Erro ao ler o arquivo: " + e.getMessage());
  }
}
