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

String diretorio_atual = sketchPath();
String mensagem = ""; // Variável para armazenar a mensagem de sucesso
int mensagemTimeout = 0; // Tempo restante para exibir a mensagem

//PImage img1, img2, img3, img4;  // Variáveis para armazenar as imagens
PImage img1, img2, img4;
long lastUpdateTime = 0; // Tempo da última atualização
int updateInterval = 2100;  // Intervalo para atualizar as imagens (1 segundo)

// Variáveis para responsividade
float scaleFactorX = 1.0; // Fator de escala horizontal
float scaleFactorY = 1.0; // Fator de escala vertical
float baseWidth = 1920.0;  // Resolução base (largura)
float baseHeight = 1080.0; // Resolução base (altura)
int lastWidth = 0;  // Última largura registrada
int lastHeight = 0; // Última altura registrada


String[] palavras = {"In", "Out", "Module Assy", "Compressor Drive", "REAR CABIN", "P2, P3, P4: SB69-500V", "P1: SB69-100V",
"Evaporator Module", "TAIL", "CONDERNSER ASSY", "Evaporator Module"," Out", "RECEIVER DRYER", "CONDENSER FAN", "MOTOR COMPARTMENT", "Out", "In",
"Out", "In", "Temp Out", "FRONT CABIN", "In", "Out", "Freon Out", "Freon In", "Suction - Gasous Freon", "Pressure - Gaseous Freon", " Pressure - Liquid Freon "};
PVector[] posicoes;

//String caminhoImagem1 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/imagem.png";
//String caminhoImagem2 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/imagem2.png";
//String caminhoImagem4 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/FotoMalha.png";

String caminhoImagem1 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/imagem.png";
String caminhoImagem2 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/imagem2.png";
String caminhoImagem4 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/FotoMalha.png";

long lastMockUpdateTime = 0; // Tempo da última atualização dos dados fictícios PARA DADOS MOCADOS, TEST.
int mockUpdateInterval = 2000; // Intervalo para atualizar os dados fictícios (2 segundos)

long lastReadDataTime = 0; // Tempo da última execução da função readDataFromFile PARA DADOS REAIS
int readDataInterval = 2000; // Intervalo para chamar a função (5 segundos, por exemplo)

float[] temperatures = new float[16]; // Array para armazenar temperaturas
float[] pressures = new float[8]; // Array para armazenar pressões

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
  img4 = loadImage(caminhoImagem4);

  // Calcula os fatores de escala iniciais
  updateScaleFactors();
  
  // Inicializa o array de posições de forma responsiva
  initializePosicoes();
  
  lastUpdateTime = millis(); // Armazena o tempo inicial de execução
  readDataFromFile();
}

void draw() {
  background(255);  // Limpa a tela com fundo branco
  
  // Verifica se a resolução mudou e recalcula os scale factors
  if (width != lastWidth || height != lastHeight) {
    updateScaleFactors();
    initializePosicoes(); // Recalcula as posições com a nova resolução
  }

  // Verifica se passou o tempo do intervalo para atualizar as imagens
  if (millis() - lastUpdateTime > updateInterval) {
    lastUpdateTime = millis(); // Atualiza o tempo de última atualização

    // Atualiza as imagens caso o arquivo tenha sido modificado
    img1 = loadImage(caminhoImagem1); 
    img2 = loadImage(caminhoImagem2);
  }

  // Desenha as imagens centralizadas
  float img1Width = width * 0.4;
  float img1Height = height * 0.45;
  float img1X = width * 0.05;
  float img1Y = height * 0.55;
  
  float img2Width = width * 0.4;
  float img2Height = height * 0.45;
  float img2X = width * 0.5;
  float img2Y = height * 0.55;
    
  float img4Width = width * 0.97;
  float img4Height = height * 0.52;
  float img4X = width * 0.03;
  float img4Y = height * 0.03;

  // Desenha as imagens
  if (img1 != null) image(img1, img1X, img1Y, img1Width, img1Height);
  if (img2 != null) image(img2, img2X, img2Y, img2Width, img2Height);
  if (img4 != null) image(img4, img4X, img4Y, img4Width, img4Height);
   
      //BOX1
    drawSensorCircleTemp("T1",temperatures[0], width * 0.85, height * 0.315); 
    drawSensorCircleTemp("T2", temperatures[1], width * 0.88, height * 0.049);
    drawSensorCircleTemp("T3", temperatures[2], width * 0.78, height * 0.27);
    drawSensorCircleTemp("T4", temperatures[3], width * 0.625, height * 0.183); 
    drawSensorCircleTemp("T5", temperatures[4], width * 0.455, height * 0.15);
    drawSensorCircleTemp("T6", temperatures[5], width * 0.3, height * 0.15);
    drawSensorCircleTemp("T7", temperatures[6], width * 0.3, height * 0.08);
    drawSensorCircleTemp("T8", temperatures[7], width * 0.21, height * 0.045); 
    drawSensorCircleTemp("T9", temperatures[8], width * 0.1, height * 0.07);
    drawSensorCircleTemp("T10", temperatures[9], width * 0.070, height * 0.255);
    drawSensorCircleTemp("T11", temperatures[10], width * 0.1, height * 0.3);
    drawSensorCircleTemp("T12", temperatures[11], width * 0.2, height * 0.28);
    drawSensorCircleTemp("T13", temperatures[12], width * 0.3, height * 0.31);
    drawSensorCircleTemp("T14", temperatures[13], width * 0.3, height * 0.38); 
    drawSensorCircleTemp("T15", temperatures[14], width * 0.070, height * 0.467); 
    drawSensorCircleTemp("T16", temperatures[15], width * 0.625, height * 0.315);
    
    // LINHAS E EQUIPAMENTOS
    drawSensorCircle("P1", pressures[0],  width * 0.85, height * 0.373); //MOTOR Entrada 
    drawSensorCircle("P2", pressures[1], width * 0.625, height * 0.24); // SAIDA COMPRESSOR
    drawSensorCircle("P3", pressures[2], width * 0.3, height * 0.205);  
    drawSensorCircle("P4", pressures[3], width * 0.625, height * 0.368); 
  
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

// Função para atualizar os fatores de escala quando a resolução muda
void updateScaleFactors() {
  scaleFactorX = width / baseWidth;
  scaleFactorY = height / baseHeight;
  lastWidth = width;
  lastHeight = height;
}

// Função para inicializar as posições de forma responsiva
void initializePosicoes() {
  posicoes = new PVector[]{
      new PVector(width * 0.25, height * 0.159),  //  In  BOX 1
      new PVector(width * 0.22, height * 0.097),  //  Out BOX 1
      
      new PVector(width * 0.66, height * 0.52), // Module ASSY
      new PVector(width * 0.65, height * 0.5), //  Compressor Drive
      
      new PVector(width * 0.235, height * 0.47), // REAR CABIN
      new PVector(width * 0.3, height * 0.52), // P2, P3, P4: SB69-500V
      new PVector(width * 0.3, height * 0.54),  // P1: SB69-100V
      new PVector(width * 0.123, height * 0.22),  // Evaporator Box1
      new PVector(width * 0.44, height * 0.06),  // TAIL Box3
      new PVector(width * 0.77, height * 0.085),  // Compressor Module
      new PVector(width * 0.125, height * 0.45),  // Evaporator box2
      new PVector(width * 0.724, height * 0.225),  // Air out Box3
      new PVector(width * 0.495, height * 0.29),  // RECEIVER DRYER
      new PVector(width * 0.642, height * 0.085),  // Out Ref Box 1
      
      new PVector(width * 0.44, height * 0.52),  // MOTOR COMPARTMENT
      
      new PVector(width * 0.79, height * 0.326),  // Out Refr BOX 3
      new PVector(width * 0.7, height * 0.326),  //  in  
      new PVector(width * 0.218, height * 0.325),  // Air Out BOX 2 
      
      new PVector(width * 0.255, height * 0.39),  // Temp In BOX 4
      new PVector(width * 1.64, height * 0.18),  // Temp Out BOX 4
      new PVector(width * 0.23, height * 0.255),  // FRONT CABIN
      
      new PVector(width * 0.58, height * 0.19),  // In Linha Azul
      new PVector(width * 0.48, height * 0.19),  // OUt Linha Azul
      
      new PVector(width * 1.79, height * 0.26),  // Freon out Compressor >>>
      new PVector(width * 1.79, height * 0.3445),  // Frenon In Comrpessor>>>
      
      new PVector( width * 0.1405, height * 0.508),  // Suction - verde
      new PVector( width * 0.1405, height * 0.524),  //  Roxo
      new PVector( width * 0.138, height * 0.542),  //  AZUL
      
      new PVector(width * 0.882, height * 0.51),  // Data
      new PVector(width * 0.883, height * 0.525)  // Hora
  };
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
  ellipse(x, y, 30, 30); // Desenha o círculo

  fill(255); // Cor do texto (branco)
  textSize(18);
  textAlign(CENTER, CENTER);
  text(label, x, y); // Desenha a letra maiúscula no centro do círculo

  // Desenha o valor ao lado do círculo
  fill(0); // Cor do texto (preto)
  textSize(18);
  textAlign(LEFT, CENTER);
  text(nf(sensorValue, 0, 2) + " PSI", x + 20, y); // Desenha o valor ao lado
}

void drawSensorCircleTemp(String label, float sensorValue, float x, float y) {
  fill(0); // Cor do círculo
  ellipse(x, y, 30, 30); // Desenha o círculo

  fill(255); // Cor do texto (branco)
  textSize(18);
  textAlign(CENTER, CENTER);
  text(label, x, y); // Desenha a letra maiúscula no centro do círculo

  // Desenha o valor ao lado do círculo
  fill(0); // Cor do texto (preto)
  textSize(18);
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
  

  // Verifica se o clique foi dentro do botão "Save"
  if (mouseX > saveX && mouseX < saveX + saveWidth &&
      mouseY > saveY && mouseY < saveY + saveHeight) {
    saveWithTimestamp(); // Chama a função de salvar
  }
}


//bom, alterar apenas para tirar a foto da malha
void saveWithTimestamp() {
  // Gera o timestamp para criar uma pasta única
  String timestamp = new SimpleDateFormat("yyyy_MM_dd_HH-mm-ss").format(new Date());
  String folderPath = "/home/avionics/Refri/CompletoRaspRefrigera/ScrenShots/Registros/" + timestamp;
  new File(folderPath).mkdir(); // Cria a pasta com o timestamp

  // Salvando cada imagem com sua legenda
  salvarImagemComLegenda(img1, userInput1, folderPath + "/imagem1.png");
  salvarImagemComLegenda(img2, userInput2, folderPath + "/imagem2.png");
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
  String filePathP = "/home/avionics/Refri/CompletoRaspRefrigera/Back-End/dados_pressao.txt";
  String filePathT = "/home/avionics/Refri/CompletoRaspRefrigera/Back-End/dados_temperatura.txt";


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

    readerP.close();
    readerT.close();
    
  } catch (IOException e) {
    println("Erro ao ler o arquivo: " + e.getMessage());
  }
}