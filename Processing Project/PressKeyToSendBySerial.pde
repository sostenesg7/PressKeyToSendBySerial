/*
  *Developed by: Sóstenes Gomes
  *https://github.com/sostenesg7
  *Software developed in java, using Processing
  *EN - The purpose of this program is send data over Serial port, by pressing any keyboard keys,
  *especially A, W, D, S and directionals like LEFT, RIGHT, UP and DOWN. 
  *The main purpose is to use with Arduino to control anything, depending of developer necessity.
    
  *Software desenvolvido em java, utilizando Processing
  *PT - A finalidade deste programa é enviar dados através da porta Serial, pelo pressionamento das teclas do teclado, 
  *especialmente A, W, D, S e direcionais como ESQUERDA, DIREITA, PARA CIMA e PARA BAIXO. 
  *O objetivo principal é usar com Arduino para controlar qualquer coisa, dependendo da necessidade do desenvolvedor.
 */
 
import controlP5.*;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import processing.core.*;
import processing.serial.*;

    private ControlP5 cp5;
    private List baudRateList;
    private List portList;
    private Serial serialPort;
    private String selectedPortName;
    private Integer selectedBaudRate;
    private CColor btnColor;
    private PImage[] imgsLeft, imgsDown, imgsUp, imgsRight;

    @Override
    public void settings() {
        size(400, 400);
    }

    @Override
    public void setup() {

        baudRateList = Arrays.asList("4800", "9600", "19200", "38400", "57600", "115200");
        btnColor = new CColor();
        PFont font = createFont("Arial", 13);

        selectedBaudRate = 9600;
        cp5 = new ControlP5(this);

        cp5.addScrollableList("baudRate")
                //.setFont(font)
                .setPosition(0, 10)
                .setSize(100, 100)
                .setBarHeight(20)
                .setItemHeight(20)
                .addItems(baudRateList).
                setCaptionLabel("Baud rate").
                setOpen(false);

        cp5.addScrollableList("ports")
                //.setFont(font)
                .setPosition(102, 10)
                .setSize(100, 100)
                .setBarHeight(20)
                .setItemHeight(20).
                //.addItems(portList).
                setCaptionLabel("Porta").
                setOpen(false);

        /* cp5.addButton("update")
                //.setFont(font)
                .setValue(0)
                .setPosition(204, 10)
                .setSize(100, 20).
                setCaptionLabel("Atualizar Portas");*/
        cp5.addButton("open")
                //.setFont(font)
                .setValue(0)
                .setPosition(206, 10)
                .setSize(200, 20).
                setCaptionLabel("Abrir");

        cp5.addTextlabel("lblStatus")
                .setColor(color(0, 0, 0));

        cp5.addTextlabel("lblCredits")
                .setPosition(0, 380)
                .setFont(font)
                .setStringValue("Developed by: Sostenes Gomes [https://github.com/sostenesg7/]")
                .setColor(color(0, 0, 0));
        //.setFont(font);

        PImage[] imgsL = {loadImage("left.png"), loadImage("left1.png"), null};
        imgsLeft = imgsL;
        cp5.addButton("left")
                .setValue(128)
                //.setPosition(0, 180)
                .setPosition(110, 180)
                .setImages(imgsLeft)
                .updateSize();

        PImage[] imgsR = {loadImage("right.png"), loadImage("right1.png"), null};
        imgsRight = imgsR;
        cp5.addButton("right")
                .setValue(128)
                //.setPosition(336, 180)
                .setPosition(210, 180)
                .setImages(imgsRight)
                .updateSize();

        PImage[] imgsU = {loadImage("up.png"), loadImage("up1.png"), null};
        imgsUp = imgsU;
        cp5.addButton("up")
                .setValue(128)
                .setPosition(160, 140)
                //.setPosition(168, 50)
                .setImages(imgsUp)
                .updateSize();

        PImage[] imgsD = {loadImage("down.png"), loadImage("down1.png"), null};
        imgsDown = imgsD;
        cp5.addButton("down")
                .setValue(128)
                .setPosition(160, 220)
                //.setPosition(168,336)
                .setImages(imgsDown)
                .updateSize();

        //Atualiza a lista de portas a cada dois segundos
        ScheduledExecutorService portListUpdater = Executors.newSingleThreadScheduledExecutor();
         portListUpdater.scheduleWithFixedDelay(new Runnable() {
            @Override
            public void run() {
                 update();
            }
        }, 0, 2, TimeUnit.SECONDS);

        try {
            selectedPortName = (String) portList.get(0);
        } catch (Exception ex) {
        }

        updateStatusLabel("Porta padrao (Primeira da lista, caso haja) : " + selectedPortName + ", Baud rate padrao: " + selectedBaudRate);
        btnColor.setBackground(color(255, 0, 0));
        cp5.get(Button.class, "open").setColor(btnColor);
    }

    @Override
    public void draw() {
        background(240);
    }

    void updateStatusLabel(String textStatus) {
        ((Textlabel) cp5.get(Textlabel.class, "lblStatus")).setStringValue(textStatus);
    }

    public void open() {
        try {
            if (serialPort != null && serialPort.active()) {
                println("Porta " + selectedPortName + " ja aberta");
                println("Tentando fechar a PORTA :" + selectedPortName + ", com BAUD RATE de " + selectedBaudRate);
                serialPort.stop();
                serialPort = null;
                println("Porta fechada!");
                btnColor.setBackground(color(255, 0, 0));
                cp5.get(Button.class, "open").setColor(btnColor);
                cp5.get(Button.class, "open").setCaptionLabel("Abrir");
                updateStatusLabel("Porta fechada!");
            } else {
                println("Tentando abrir a PORTA :" + selectedPortName + ", com BAUD RATE de " + selectedBaudRate);
                serialPort = new Serial(this, selectedPortName, selectedBaudRate);
                println("Porta aberta!");
                btnColor.setBackground(color(32, 167, 12));
                cp5.get(Button.class, "open").setColor(btnColor);
                cp5.get(Button.class, "open").setCaptionLabel("Fechar");
                updateStatusLabel("Porta aberta!");
            }
        } catch (Exception ex) {
            //ex.printStackTrace();
        }
    }

    void sendData(String data) {
        try {
            serialPort.write(data);
        } catch (Exception ex) {
            //ex.printStackTrace();
        }
    }

    public void baudRate(int theValue) {
        selectedBaudRate = Integer.parseInt((String) baudRateList.get(theValue));
        println("Baud rate selecionado: " + baudRateList.get(theValue));
    }

    public void ports(int theValue) {
        selectedPortName = (String) portList.get(theValue);
        println("porta selecionada: " + selectedPortName);
    }

    public void update() {
        try {
            portList = Arrays.asList(Serial.list());
            println("Atualizando portas: " + portList);
            cp5.get(ScrollableList.class, "ports").setItems(portList);
        } catch (Exception ex) {
            //println(ex.getMessage());
        }
    }

    public void left() {
        updateStatusLabel("ESQUERDA");
        sendData("LEFT");
    }

    public void right() {
        updateStatusLabel("DIREITA");
        sendData("RIGHT");
    }

    public void up() {
        updateStatusLabel("ACIMA");
        sendData("UP");
    }

    public void down() {
        updateStatusLabel("ABAIXO");
        sendData("DOWN");
    }

    @Override
    public void keyReleased() {
        switch (keyCode) {
            case ('A'):
                ((Button) cp5.get(Button.class, "left")).setImage(imgsLeft[0]);
                break;
            case ('W'):
                ((Button) cp5.get(Button.class, "up")).setImage(imgsUp[0]);
                break;
            case ('D'):
                ((Button) cp5.get(Button.class, "right")).setImage(imgsRight[0]);
                break;
            case ('S'):
                ((Button) cp5.get(Button.class, "down")).setImage(imgsDown[0]);
                break;
            case (LEFT):
                ((Button) cp5.get(Button.class, "left")).setImage(imgsLeft[0]);
                break;
            case (UP):
                ((Button) cp5.get(Button.class, "up")).setImage(imgsUp[0]);
                break;
            case (RIGHT):
                ((Button) cp5.get(Button.class, "right")).setImage(imgsRight[0]);
                break;
            case (DOWN):
                ((Button) cp5.get(Button.class, "down")).setImage(imgsDown[0]);
                break;
        }
    }

    @Override
    public void keyPressed() {
        switch (keyCode) {
            case (LEFT):
                updateStatusLabel("ESQUERDA");
                ((Button) cp5.get(Button.class, "left")).setImage(imgsLeft[1]);
                sendData("LEFT");
                break;
            case (UP):
                updateStatusLabel("ACIMA");
                ((Button) cp5.get(Button.class, "up")).setImage(imgsUp[1]);
                sendData("UP");
                break;
            case (RIGHT):
                updateStatusLabel("DIREITA");
                ((Button) cp5.get(Button.class, "right")).setImage(imgsRight[1]);
                sendData("RIGHT");
                break;
            case (DOWN):
                updateStatusLabel("ABAIXO");
                ((Button) cp5.get(Button.class, "down")).setImage(imgsDown[1]);
                sendData("DOWN");
                break;
            case ENTER:
                updateStatusLabel("ENTER");
                sendData("ENTER");
                break;
            case BEVEL://Space key
                updateStatusLabel("ESPACO");
                sendData("SPACE");
                break;
            case ('A'):
                updateStatusLabel("A");
                ((Button) cp5.get(Button.class, "left")).setImage(imgsLeft[1]);
                sendData("A");
                break;
            case ('W'):
                updateStatusLabel("W");
                ((Button) cp5.get(Button.class, "up")).setImage(imgsUp[1]);
                sendData("W");
                break;
            case ('D'):
                updateStatusLabel("D");
                ((Button) cp5.get(Button.class, "right")).setImage(imgsRight[1]);
                sendData("D");
                break;
            case ('S'):
                updateStatusLabel("S");
                ((Button) cp5.get(Button.class, "down")).setImage(imgsDown[1]);
                sendData("S");
                break;
            default:
                updateStatusLabel(String.valueOf(key));
                sendData(String.valueOf(key));
                break;
        }
    }