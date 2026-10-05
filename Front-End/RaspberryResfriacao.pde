import java.text.SimpleDateFormat; // Para formatação de data
import java.util.Date; // Para obter a data atual
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;

import java.io.FileOutputStream;
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

String caminhoImagem1 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/imagem.png";
String caminhoImagem2 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/imagem2.png";
String caminhoImagem4 = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera-o/assets/images/FotoMalha.png";

//String caminhoImagem1 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/imagem.png";
//String caminhoImagem2 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/imagem2.png";
//String caminhoImagem4 = "C:/Users/Avionics/CompletoRaspRefrigera-o/assets/images/FotoMalha.png";

//long lastMockUpdateTime = 0; // Tempo da última atualização dos dados fictícios PARA DADOS MOCADOS, TEST.
//int mockUpdateInterval = 2000; // Intervalo para atualizar os dados fictícios (2 segundos)

long lastReadDataTime = 0; // Tempo da última execução da função readDataFromFile PARA DADOS REAIS
int readDataInterval = 2000; // Intervalo para chamar a função (5 segundos, por exemplo)

float[] temperatures = new float[16]; // Array para armazenar temperaturas
float[] pressures = new float[8]; // Array para armazenar pressões

JanelaTabela janelaTabela = null;

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
  abrirJanelaTabela();
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

class JanelaTabela extends PApplet {

  // ==========================================================
  // ARQUIVO
  // ==========================================================

  String caminhoSAeSR;

  // ==========================================================
  // DADOS
  // ==========================================================

  double superaquecimento_1 = 0;
  double superaquecimento_2 = 0;
  double subresfriamento = 0;

  double temperatura_succao_1 = 0;
  double temperatura_sat_baixa = 0;

  double temperatura_succao_2 = 0;
  double temperatura_sat_baixa_2 = 0;

  double temperatura_sat_alta = 0;
  double temperatura_liquido = 0;

  double pressao_succao = 0;
  double pressao_alta = 0;

  String cenario_1 = "";
  String cenario_2 = "";


  // ==========================================================
  // ATUALIZAÇÃO
  // ==========================================================

  long ultimaAtualizacao = 0;

  int intervaloAtualizacao = 1000;


  // ==========================================================
  // DIMENSÕES
  // ==========================================================

  int larguraJanela = 1000;
  int alturaJanela = 300;


  // ==========================================================
  // CORES
  // ==========================================================

  color AZUL_ESCURO =
    color(23, 54, 93);

  color AZUL_CLARO =
    color(91, 155, 213);

  color AZUL_MUITO_CLARO =
    color(217, 234, 247);

  color BRANCO =
    color(255);

  color PRETO =
    color(0);


  // ==========================================================
  // SETTINGS
  // ==========================================================

  void settings() {

    size(
      larguraJanela,
      alturaJanela
    );
  }


  // ==========================================================
  // SETUP
  // ==========================================================

  void setup() {

    surface.setTitle(
      "Tabela - Refrigeração"
    );

    surface.setResizable(false);

    surface.setLocation(
      50,
      50
    );

    textFont(
      new PFont(
        new java.awt.Font("Arial", java.awt.Font.BOLD, 20),
        true
      )
    );

    caminhoSAeSR = RaspberryResfriacao.this.sketchPath("../SAeSR.txt");

    carregarDados();

    ultimaAtualizacao = millis();
  }


  // ==========================================================
  // DRAW
  // ==========================================================

  void draw() {

    background(255);


    // Atualiza os dados a cada 1 segundo

    if (
      millis() - ultimaAtualizacao
      >= intervaloAtualizacao
    ) {

      ultimaAtualizacao =
        millis();

      carregarDados();
    }


    desenharTabela();
  }


  // ==========================================================
  // LER SAeSR.txt
  // ==========================================================

  void carregarDados() {

    String[] dados =
      loadStrings(caminhoSAeSR);


    // Arquivo ainda não disponível
    if (
      dados == null ||
      dados.length < 13
    ) {

      return;
    }


    try {

      // ------------------------------------------------------
      // VALORES
      // ------------------------------------------------------

      superaquecimento_1 =
        Double.parseDouble(
          dados[0].trim()
        );

      superaquecimento_2 =
        Double.parseDouble(
          dados[1].trim()
        );

      subresfriamento =
        Double.parseDouble(
          dados[2].trim()
        );


      temperatura_succao_1 =
        Double.parseDouble(
          dados[3].trim()
        );

      temperatura_sat_baixa =
        Double.parseDouble(
          dados[4].trim()
        );


      temperatura_succao_2 =
        Double.parseDouble(
          dados[5].trim()
        );

      temperatura_sat_baixa_2 =
        Double.parseDouble(
          dados[6].trim()
        );


      temperatura_sat_alta =
        Double.parseDouble(
          dados[7].trim()
        );

      temperatura_liquido =
        Double.parseDouble(
          dados[8].trim()
        );


      pressao_succao =
        Double.parseDouble(
          dados[9].trim()
        );

      pressao_alta =
        Double.parseDouble(
          dados[10].trim()
        );


      // ------------------------------------------------------
      // CENÁRIOS
      // ------------------------------------------------------

      cenario_1 =
        dados[11].trim();

      cenario_2 =
        dados[12].trim();


    } catch (Exception e) {

      println(
        "Erro ao atualizar tabela: "
        + e.getMessage()
      );
    }
  }


  // ==========================================================
  // DESENHAR TABELA
  // ==========================================================

  void desenharTabela() {

    float margem = 25;

    float larguraTotal =
      width - (margem * 2);

    float espaco = 12;

    float larguraTabela =
      (larguraTotal - (espaco * 2)) / 3.0;

    float x1 = margem;

    float x2 =
      x1 + larguraTabela + espaco;

    float x3 =
      x2 + larguraTabela + espaco;


    float yTitulo = 10;

    float alturaTitulo = 34;

    float yTabela =
      yTitulo + alturaTitulo;


    // ========================================================
    // TÍTULO
    // ========================================================

    fill(AZUL_ESCURO);

    stroke(PRETO);

    rect(
      margem,
      yTitulo,
      larguraTotal,
      alturaTitulo
    );


    fill(BRANCO);

    textAlign(
      CENTER,
      CENTER
    );

    textSize(24);

    text(
      "Ficha de Cálculo de Super Aquecimento / Super Resfriamento",
      margem + larguraTotal / 2,
      yTitulo + alturaTitulo / 2
    );


    // ========================================================
    // TABELAS
    // ========================================================

    desenharEvaporador(
      x1,
      yTabela,
      larguraTabela,
      "Evaporador 1",
      "T7",
      temperatura_succao_1,
      "P4",
      pressao_succao,
      temperatura_sat_baixa,
      superaquecimento_1,
      "CN",
      cenario_1
    );


    desenharEvaporador(
      x2,
      yTabela,
      larguraTabela,
      "Evaporador 2",
      "T13",
      temperatura_succao_2,
      "P4",
      pressao_succao,
      temperatura_sat_baixa_2,
      superaquecimento_2,
      "CN",
      cenario_2
    );


    desenharCondensador(
      x3,
      yTabela,
      larguraTabela
    );
  }


  // ==========================================================
  // EVAPORADOR
  // ==========================================================

  void desenharEvaporador(
    float x,
    float y,
    float largura,
    String titulo,
    String nomeT,
    double valorT,
    String nomeP,
    double valorP,
    double tempSat,
    double SA,
    String nomeCN,
    String cenario
  ) {

    float larguraColuna1 =
      largura * 0.30;

    float larguraColuna2 =
      largura - larguraColuna1;


    float alturaCabecalho = 30;

    float alturaLinha = 30;
    float alturaLinhaCenario = 80;


    // --------------------------------------------------------
    // CABEÇALHO
    // --------------------------------------------------------

    fill(AZUL_ESCURO);

    stroke(PRETO);

    rect(
      x,
      y,
      largura,
      alturaCabecalho
    );


    fill(BRANCO);

    textSize(20);

    textAlign(
      CENTER,
      CENTER
    );

    text(
      titulo,
      x + largura / 2,
      y + alturaCabecalho / 2
    );


    // --------------------------------------------------------
    // T7 / T13
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho,
      larguraColuna1,
      alturaLinha,
      nomeT
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho,
      larguraColuna2,
      alturaLinha,
      nf((float)valorT, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // P4
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha,
      larguraColuna1,
      alturaLinha,
      nomeP
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha,
      larguraColuna2,
      alturaLinha,
      nf((float)valorP, 0, 2) + " PSI"
    );


    // --------------------------------------------------------
    // TEMPSAT
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 2,
      larguraColuna1,
      alturaLinha,
      "TempSat"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 2,
      larguraColuna2,
      alturaLinha,
      nf((float)tempSat, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // SA
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 3,
      larguraColuna1,
      alturaLinha,
      "SA"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 3,
      larguraColuna2,
      alturaLinha,
      nf((float)SA, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // CN
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 4,
      larguraColuna1,
      alturaLinhaCenario,
      nomeCN
    );

    desenharCelulaCenario(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 4,
      larguraColuna2,
      alturaLinhaCenario,
      cenario
    );
  }


  // ==========================================================
  // CONDENSADOR
  // SEM CN
  // ==========================================================

  void desenharCondensador(
    float x,
    float y,
    float largura
  ) {

    float larguraColuna1 =
      largura * 0.30;

    float larguraColuna2 =
      largura - larguraColuna1;


    float alturaCabecalho = 30;

    float alturaLinha = 30;
    float alturaLinhaCenario = 80;


    // --------------------------------------------------------
    // CABEÇALHO
    // --------------------------------------------------------

    fill(AZUL_ESCURO);

    stroke(PRETO);

    rect(
      x,
      y,
      largura,
      alturaCabecalho
    );


    fill(BRANCO);

    textSize(20);

    textAlign(
      CENTER,
      CENTER
    );

    text(
      "Condensador",
      x + largura / 2,
      y + alturaCabecalho / 2
    );


    // --------------------------------------------------------
    // T4
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho,
      larguraColuna1,
      alturaLinha,
      "T4"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho,
      larguraColuna2,
      alturaLinha,
      nf((float)temperatura_liquido, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // P2
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha,
      larguraColuna1,
      alturaLinha,
      "P2"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha,
      larguraColuna2,
      alturaLinha,
      nf((float)pressao_alta, 0, 2) + " PSI"
    );


    // --------------------------------------------------------
    // TEMPSAT
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 2,
      larguraColuna1,
      alturaLinha,
      "TempSat"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 2,
      larguraColuna2,
      alturaLinha,
      nf((float)temperatura_sat_alta, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // SR
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 3,
      larguraColuna1,
      alturaLinha,
      "SR"
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 3,
      larguraColuna2,
      alturaLinha,
      nf((float)subresfriamento, 0, 2) + " °C"
    );


    // --------------------------------------------------------
    // LINHA 7 VAZIA
    // --------------------------------------------------------

    desenharCelulaIdentificacao(
      x,
      y + alturaCabecalho + alturaLinha * 4,
      larguraColuna1,
      alturaLinhaCenario,
      ""
    );

    desenharCelulaValor(
      x + larguraColuna1,
      y + alturaCabecalho + alturaLinha * 4,
      larguraColuna2,
      alturaLinhaCenario,
      ""
    );
  }


  // ==========================================================
  // CÉLULA DE IDENTIFICAÇÃO
  // ==========================================================

  void desenharCelulaIdentificacao(
    float x,
    float y,
    float largura,
    float altura,
    String texto
  ) {

    fill(AZUL_MUITO_CLARO);

    stroke(PRETO);

    rect(
      x,
      y,
      largura,
      altura
    );


    fill(PRETO);

    textSize(20);

    textAlign(
      CENTER,
      CENTER
    );

    text(
      texto,
      x + largura / 2,
      y + altura / 2
    );
  }


  // ==========================================================
  // CÉLULA DE VALOR
  // ==========================================================

  void desenharCelulaValor(
    float x,
    float y,
    float largura,
    float altura,
    String texto
  ) {

    fill(AZUL_CLARO);

    stroke(PRETO);

    rect(
      x,
      y,
      largura,
      altura
    );


    fill(PRETO);

    textSize(20);

    textAlign(
      CENTER,
      CENTER
    );

    text(
      texto,
      x + largura / 2,
      y + altura / 2
    );
  }


  // ==========================================================
  // CÉLULA DO CENÁRIO
  // ==========================================================

  void desenharCelulaCenario(
    float x,
    float y,
    float largura,
    float altura,
    String texto
  ) {

    fill(AZUL_CLARO);

    stroke(PRETO);

    rect(
      x,
      y,
      largura,
      altura
    );


    fill(PRETO);

    textSize(20);

    textAlign(
      CENTER,
      CENTER
    );


    // Quebra o cenário em várias linhas
    String[] linhas =
      dividirTexto(texto, largura - 12);


    float alturaTexto =
      textAscent() + textDescent();


    float alturaTotal =
      linhas.length * alturaTexto;


    float inicioY =
      y + (altura - alturaTotal) / 2
      + alturaTexto / 2;


    for (int i = 0; i < linhas.length; i++) {

      text(
        linhas[i],
        x + largura / 2,
        inicioY + i * alturaTexto
      );
    }
  }

  // ==========================================================
  // QUEBRAR TEXTO
  // ==========================================================

  String[] dividirTexto(
    String texto,
    float larguraMaxima
  ) {

    if (
      texto == null ||
      texto.length() == 0
    ) {

      return new String[]{""};
    }


    String[] palavras =
      split(texto, ' ');


    String atual = "";

    ArrayList<String> linhas =
      new ArrayList<String>();


    for (String palavra : palavras) {

      String teste =
        atual.length() == 0
        ? palavra
        : atual + " " + palavra;


      if (
        atual.length() > 0 &&
        textWidth(teste) > larguraMaxima
      ) {

        if (atual.length() > 0) {

          linhas.add(atual);
        }

        atual = palavra;

      } else {

        atual = teste;
      }
    }


    if (atual.length() > 0) {

      linhas.add(atual);
    }


    return linhas.toArray(
      new String[linhas.size()]
    );
  }


  // ==========================================================
  // FECHAMENTO DA JANELA
  // ==========================================================

  public void dispose() {

    janelaTabela = null;

    super.dispose();
  }
}

void abrirJanelaTabela() {

  // Evita abrir várias janelas iguais
  if (janelaTabela != null) {
    return;
  }

  janelaTabela = new JanelaTabela();

  String[] argumentos = {
    "JanelaTabela"
  };

  PApplet.runSketch(
    argumentos,
    janelaTabela
  );
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



void gerarExcel(String folderPath) {

  // ==========================================================
  // CAMINHO DO SAeSR.txt
  // ==========================================================

  String caminhoSAeSR = sketchPath("../SAeSR.txt");

  // ==========================================================
  // LER O SAeSR.txt
  // ==========================================================

  String[] dados = loadStrings(caminhoSAeSR);

  if (dados == null || dados.length < 13) {

    println(
      "Erro: SAeSR.txt não possui os 13 valores esperados."
    );

    return;
  }

  // ==========================================================
  // DADOS DO ARQUIVO
  //
  // 0  = superaquecimento_1
  // 1  = superaquecimento_2
  // 2  = subresfriamento
  // 3  = temperatura_succao_1
  // 4  = temperatura_sat_baixa
  // 5  = temperatura_succao_2
  // 6  = temperatura_sat_baixa
  // 7  = temperatura_sat_alta
  // 8  = temperatura_liquido
  // 9  = pressao_succao
  // 10 = pressao_alta
  // 11 = cenario_1
  // 12 = cenario_2
  // ==========================================================

  double superaquecimento_1 =
    Double.parseDouble(dados[0].trim());

  double superaquecimento_2 =
    Double.parseDouble(dados[1].trim());

  double subresfriamento =
    Double.parseDouble(dados[2].trim());

  double temperatura_succao_1 =
    Double.parseDouble(dados[3].trim());

  double temperatura_sat_baixa =
    Double.parseDouble(dados[4].trim());

  double temperatura_succao_2 =
    Double.parseDouble(dados[5].trim());

  double temperatura_sat_baixa_2 =
    Double.parseDouble(dados[6].trim());

  double temperatura_sat_alta =
    Double.parseDouble(dados[7].trim());

  double temperatura_liquido =
    Double.parseDouble(dados[8].trim());

  double pressao_succao =
    Double.parseDouble(dados[9].trim());

  double pressao_alta =
    Double.parseDouble(dados[10].trim());

  String cenario_1 =
    dados[11].trim();

  String cenario_2 =
    dados[12].trim();


  // ==========================================================
  // CRIAR WORKBOOK
  // ==========================================================

  Workbook workbook =
    new XSSFWorkbook();

  org.apache.poi.ss.usermodel.Sheet sheet =
    workbook.createSheet("Refrigeração");


  // ==========================================================
  // CORES
  // ==========================================================

  // Azul mais escuro
  String AZUL_ESCURO = "17365D";

  // Azul intermediário
  String AZUL_CLARO = "5B9BD5";

  // Azul mais claro de todos
  String AZUL_MUITO_CLARO = "D9EAF7";


  // ==========================================================
  // FONTES
  // ==========================================================

  Font fonteBranca =
    workbook.createFont();

  fonteBranca.setFontName("Arial");
  fonteBranca.setFontHeightInPoints((short)10);
  fonteBranca.setBold(true);
  fonteBranca.setColor(
    IndexedColors.WHITE.getIndex()
  );


  Font fonteTitulo =
    workbook.createFont();

  fonteTitulo.setFontName("Arial");
  fonteTitulo.setFontHeightInPoints((short)14);
  fonteTitulo.setBold(true);
  fonteTitulo.setColor(
    IndexedColors.WHITE.getIndex()
  );


  Font fontePreta =
    workbook.createFont();

  fontePreta.setFontName("Arial");
  fontePreta.setFontHeightInPoints((short)10);
  fontePreta.setColor(
    IndexedColors.BLACK.getIndex()
  );


  // ==========================================================
  // ESTILO BASE COM BORDA
  // ==========================================================

  CellStyle estiloTitulo =
    workbook.createCellStyle();

  estiloTitulo.setFont(fonteTitulo);

  estiloTitulo.setFillForegroundColor(
    criarCorHex(AZUL_ESCURO)
  );

  estiloTitulo.setFillPattern(
    FillPatternType.SOLID_FOREGROUND
  );

  estiloTitulo.setAlignment(
    HorizontalAlignment.CENTER
  );

  estiloTitulo.setVerticalAlignment(
    VerticalAlignment.CENTER
  );

  aplicarBorda(estiloTitulo);


  // ==========================================================
  // CABEÇALHOS DAS TABELAS
  // ==========================================================

  CellStyle estiloCabecalho =
    workbook.createCellStyle();

  estiloCabecalho.setFont(fonteBranca);

  estiloCabecalho.setFillForegroundColor(
    criarCorHex(AZUL_ESCURO)
  );

  estiloCabecalho.setFillPattern(
    FillPatternType.SOLID_FOREGROUND
  );

  estiloCabecalho.setAlignment(
    HorizontalAlignment.CENTER
  );

  estiloCabecalho.setVerticalAlignment(
    VerticalAlignment.CENTER
  );

  aplicarBorda(estiloCabecalho);


  // ==========================================================
  // COLUNAS A / C / E
  // AZUL MAIS CLARO DE TODOS
  // TEXTO PRETO
  // ==========================================================

  CellStyle estiloIdentificacao =
    workbook.createCellStyle();

  estiloIdentificacao.setFont(fontePreta);

  estiloIdentificacao.setFillForegroundColor(
    criarCorHex(AZUL_MUITO_CLARO)
  );

  estiloIdentificacao.setFillPattern(
    FillPatternType.SOLID_FOREGROUND
  );

  estiloIdentificacao.setAlignment(
    HorizontalAlignment.CENTER
  );

  estiloIdentificacao.setVerticalAlignment(
    VerticalAlignment.CENTER
  );

  aplicarBorda(estiloIdentificacao);


  // ==========================================================
  // COLUNAS B / D / F
  // AZUL CLARO
  // TEXTO PRETO
  // ==========================================================

  CellStyle estiloValor =
    workbook.createCellStyle();

  estiloValor.setFont(fontePreta);

  estiloValor.setFillForegroundColor(
    criarCorHex(AZUL_CLARO)
  );

  estiloValor.setFillPattern(
    FillPatternType.SOLID_FOREGROUND
  );

  estiloValor.setAlignment(
    HorizontalAlignment.CENTER
  );

  estiloValor.setVerticalAlignment(
    VerticalAlignment.CENTER
  );

  estiloValor.setDataFormat(
    workbook.createDataFormat().getFormat("0.00")
  );

  aplicarBorda(estiloValor);


  // ==========================================================
  // CÉLULA DOS CENÁRIOS
  // ==========================================================

  CellStyle estiloCenario =
    workbook.createCellStyle();

  estiloCenario.setFont(fontePreta);

  estiloCenario.setFillForegroundColor(
    criarCorHex(AZUL_CLARO)
  );

  estiloCenario.setFillPattern(
    FillPatternType.SOLID_FOREGROUND
  );

  estiloCenario.setAlignment(
    HorizontalAlignment.LEFT
  );

  estiloCenario.setVerticalAlignment(
    VerticalAlignment.CENTER
  );

  estiloCenario.setWrapText(true);

  aplicarBorda(estiloCenario);


  // ==========================================================
  // LINHA 1
  // A1:F1
  // ==========================================================

  Row linha1 =
    sheet.createRow(0);

  for (int i = 0; i < 6; i++) {

    Cell celula =
      linha1.createCell(i);

    celula.setCellStyle(estiloTitulo);
  }

  linha1.getCell(0).setCellValue(
    "Ficha de Cálculo de Super Aquecimento / Super Resfriamento"
  );

  sheet.addMergedRegion(
    new CellRangeAddress(
      0,
      0,
      0,
      5
    )
  );

  linha1.setHeightInPoints(
    cmParaPontos(0.9)
  );


  // ==========================================================
  // CABEÇALHO EVAPORADOR 1
  // A2:B2
  // ==========================================================

  criarCabecalhoTabela(
    sheet,
    1,
    0,
    1,
    "Evaporador 1",
    estiloCabecalho
  );


  // ==========================================================
  // CABEÇALHO EVAPORADOR 2
  // C2:D2
  // ==========================================================

  criarCabecalhoTabela(
    sheet,
    1,
    2,
    3,
    "Evaporador 2",
    estiloCabecalho
  );


  // ==========================================================
  // CABEÇALHO CONDENSADOR
  // E2:F2
  // ==========================================================

  criarCabecalhoTabela(
    sheet,
    1,
    4,
    5,
    "Condensador",
    estiloCabecalho
  );


  // ==========================================================
  // EVAPORADOR 1
  // ==========================================================

  criarLinhaTabela(
    sheet,
    2,
    0,
    "T7",
    temperatura_succao_1,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    3,
    0,
    "P4",
    pressao_succao,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    4,
    0,
    "TempSat",
    temperatura_sat_baixa,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    5,
    0,
    "SA",
    superaquecimento_1,
    estiloIdentificacao,
    estiloValor
  );


  // ==========================================================
  // CN EVAPORADOR 1
  // A7:B7
  // ==========================================================

  Row linha7 =
    sheet.createRow(6);

  Cell celulaA7 =
    linha7.createCell(0);

  celulaA7.setCellValue("CN");
  celulaA7.setCellStyle(estiloIdentificacao);


  Cell celulaB7 =
    linha7.createCell(1);

  celulaB7.setCellValue(cenario_1);
  celulaB7.setCellStyle(estiloCenario);


  // ==========================================================
  // EVAPORADOR 2
  // ==========================================================

  criarLinhaTabela(
    sheet,
    2,
    2,
    "T13",
    temperatura_succao_2,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    3,
    2,
    "P4",
    pressao_succao,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    4,
    2,
    "TempSat",
    temperatura_sat_baixa_2,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    5,
    2,
    "SA",
    superaquecimento_2,
    estiloIdentificacao,
    estiloValor
  );


  // ==========================================================
  // CN EVAPORADOR 2
  // C7:D7
  // ==========================================================

  Cell celulaC7 =
    linha7.createCell(2);

  celulaC7.setCellValue("CN");
  celulaC7.setCellStyle(estiloIdentificacao);


  Cell celulaD7 =
    linha7.createCell(3);

  celulaD7.setCellValue(cenario_2);
  celulaD7.setCellStyle(estiloCenario);


  // ==========================================================
  // CONDENSADOR
  // E:F
  //
  // SEM CN
  // ==========================================================

  criarLinhaTabela(
    sheet,
    2,
    4,
    "T4",
    temperatura_liquido,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    3,
    4,
    "P2",
    pressao_alta,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    4,
    4,
    "TempSat",
    temperatura_sat_alta,
    estiloIdentificacao,
    estiloValor
  );

  criarLinhaTabela(
    sheet,
    5,
    4,
    "SR",
    subresfriamento,
    estiloIdentificacao,
    estiloValor
  );


  // ==========================================================
  // ALTURA DAS LINHAS
  // ==========================================================

  for (int i = 2; i <= 5; i++) {

    Row linha =
      sheet.getRow(i);

    if (linha != null) {

      linha.setHeightInPoints(
        cmParaPontos(0.5)
      );
    }
  }


  // Linha 7 = 1 cm

  linha7.setHeightInPoints(
    cmParaPontos(1.0)
  );


  // ==========================================================
  // LARGURA DAS COLUNAS
  // ==========================================================

  // A = 1,65 cm
  // B = 4,45 cm
  // C = 1,65 cm
  // D = 4,45 cm
  // E = 1,65 cm
  // F = 4,45 cm

  sheet.setColumnWidth(
    0,
    larguraColunaExcel(1.65)
  );

  sheet.setColumnWidth(
    1,
    larguraColunaExcel(4.45)
  );

  sheet.setColumnWidth(
    2,
    larguraColunaExcel(1.65)
  );

  sheet.setColumnWidth(
    3,
    larguraColunaExcel(4.45)
  );

  sheet.setColumnWidth(
    4,
    larguraColunaExcel(1.65)
  );

  sheet.setColumnWidth(
    5,
    larguraColunaExcel(4.45)
  );


  // ==========================================================
  // SALVAR NA MESMA PASTA DO REGISTRO
  // ==========================================================

  String caminhoExcel =
    folderPath + "/RelatorioRefrigeracao.xlsx";


  try {

    FileOutputStream arquivo =
      new FileOutputStream(caminhoExcel);

    workbook.write(arquivo);

    arquivo.close();
    workbook.close();

    println(
      "Excel salvo em: " + caminhoExcel
    );

  } catch (IOException e) {

    println(
      "Erro ao salvar Excel: " + e.getMessage()
    );
  }
}


// ==========================================================
// CRIAR LINHA DA TABELA
// ==========================================================

void criarLinhaTabela(
  org.apache.poi.ss.usermodel.Sheet sheet,
  int linha,
  int colunaInicial,
  String nome,
  double valor,
  CellStyle estiloNome,
  CellStyle estiloValor
) {

  // Obtém a linha existente
  Row row = sheet.getRow(linha);

  // Caso a linha ainda não exista, cria
  if (row == null) {
    row = sheet.createRow(linha);
  }


  // ========================================================
  // COLUNA DE IDENTIFICAÇÃO
  // A / C / E
  // ========================================================

  Cell celulaNome =
    row.createCell(colunaInicial);

  celulaNome.setCellValue(nome);
  celulaNome.setCellStyle(estiloNome);


  // ========================================================
  // COLUNA DO VALOR
  // B / D / F
  // ========================================================

  Cell celulaValor =
    row.createCell(colunaInicial + 1);

  celulaValor.setCellValue(valor);
  celulaValor.setCellStyle(estiloValor);
}


// ==========================================================
// CRIAR CABEÇALHO
// ==========================================================

void criarCabecalhoTabela(
  org.apache.poi.ss.usermodel.Sheet sheet,
  int linha,
  int colunaInicial,
  int colunaFinal,
  String texto,
  CellStyle estilo
) {

  Row row =
    sheet.getRow(linha);

  if (row == null) {

    row =
      sheet.createRow(linha);
  }


  for (
    int coluna = colunaInicial;
    coluna <= colunaFinal;
    coluna++
  ) {

    Cell celula =
      row.createCell(coluna);

    celula.setCellStyle(estilo);
  }


  row.getCell(
    colunaInicial
  ).setCellValue(texto);


  sheet.addMergedRegion(
    new CellRangeAddress(
      linha,
      linha,
      colunaInicial,
      colunaFinal
    )
  );


  row.setHeightInPoints(
    cmParaPontos(0.6)
  );
}



// ==========================================================
// BORDA
// ==========================================================

void aplicarBorda(CellStyle estilo) {

  estilo.setBorderTop(
    BorderStyle.THIN
  );

  estilo.setBorderBottom(
    BorderStyle.THIN
  );

  estilo.setBorderLeft(
    BorderStyle.THIN
  );

  estilo.setBorderRight(
    BorderStyle.THIN
  );

  estilo.setTopBorderColor(
    IndexedColors.BLACK.getIndex()
  );

  estilo.setBottomBorderColor(
    IndexedColors.BLACK.getIndex()
  );

  estilo.setLeftBorderColor(
    IndexedColors.BLACK.getIndex()
  );

  estilo.setRightBorderColor(
    IndexedColors.BLACK.getIndex()
  );
}



// ==========================================================
// COR HEXADECIMAL
// ==========================================================

XSSFColor criarCorHex(String hex) {

  return new XSSFColor(
    java.awt.Color.decode("#" + hex),
    null
  );
}



// ==========================================================
// CENTÍMETROS → PONTOS
// ==========================================================

float cmParaPontos(float cm) {

  return cm * 28.3464567;
}



// ==========================================================
// CENTÍMETROS → LARGURA EXCEL
// ==========================================================

int larguraColunaExcel(float cm) {

  return round(
    cm * 5.6 * 256
  );
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
  String timestamp =
    new SimpleDateFormat("yyyy_MM_dd_HH-mm-ss").format(new Date());

  Path pastaTeste = Paths.get(
    System.getProperty("user.home"),
    "Desktop",
    "Teste_Save_" + timestamp
  );

  try {
    Files.createDirectories(pastaTeste);
  } catch (IOException e) {
    println("Erro ao criar pasta de teste: " + e.getMessage());
    mensagem = "Erro ao criar a pasta de teste.";
    mensagemTimeout = 100;
    return;
  }

  String folderPath = pastaTeste.toString();

  // ----------------------------------------------------------
  // Salvando imagens
  // ----------------------------------------------------------

  salvarImagemComLegenda(
    img1,
    userInput1,
    Paths.get(folderPath, "imagem1.png").toString()
  );

  salvarImagemComLegenda(
    img2,
    userInput2,
    Paths.get(folderPath, "imagem2.png").toString()
  );

  save(Paths.get(folderPath, "Malha.png").toString());

  if (janelaTabela != null) {
    janelaTabela.saveFrame(
      Paths.get(folderPath, "Tabela.png").toString()
    );
  }


  // ----------------------------------------------------------
  // Gerar Excel
  // ----------------------------------------------------------

  gerarExcel(folderPath);

  // ----------------------------------------------------------
  // Mensagem
  // ----------------------------------------------------------

  println(
    "Imagens e Excel salvos em: " + folderPath
  );

  mensagem = "Imagens e Excel gerados com sucesso.";

  mensagemTimeout = 50;
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
  //String filePathP = "/home/avionics/Refri/CompletoRaspRefrigera/Back-End/dados_pressao.txt";
  //String filePathT = "/home/avionics/Refri/CompletoRaspRefrigera/Back-End/dados_temperatura.txt";

  String filePathT = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera/Back-End/dados_pressao.txt";
  String filePathT = "/home/avionics/Refri/ENAER/CompletoRaspRefrigera/Back-End/dados_temperatura.txt";


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
