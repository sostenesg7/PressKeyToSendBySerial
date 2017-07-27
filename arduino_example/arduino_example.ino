/*
  *Developed by: Sóstenes Gomes
  *https://github.com/sostenesg7
*/

void setup() {
  Serial.begin(9600);
}

void loop() {

   if(Serial.available() > 0){
      String readData = Serial.readString();
      
      if(readData == "UP"){//ACIMA
        
      }else if(readData == "DOWN"){//ABAIXO

      }else if(readData == "LEFT"){//ESQUERDA

      }else if(readData == "RIGHT"){//DIREITA

      }else if(readData == "A"){//DEMAIS TECLAS ABAIXO
        
      }else if(readData == "W"){
        
      }else if(readData == "D"){
        
      }else if(readData == "S"){
        
      }else if(readData == "+"){
        
      }else if(readData == "-"){
        
      }
      /*..
      continua...
      ...*/
  }
}