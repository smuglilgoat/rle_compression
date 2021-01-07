PImage image, output;
String string = "", hexaValue = "", inter = "";
int w, h;
String[] text;

void setup() {
  size(128,128);
  w = 128;
  h = 128;

  compress("image3.bmp");
  decompress("image.txt");
}

void draw() {
}

void compress(String filename){
    image = loadImage(filename);
    image.loadPixels();  

    for (int i = 0; i < w; ++i) {
        for (int j = 0; j < h; ++j) {
            if (brightness(image.pixels[ i * w + j]) == 0) {
                string = string + "n";
            } else { 
                string = string + "b";
            }
        }
    }


    println("String des pixels: "+ string);
    int cpt = 0, i = 0;
    char clr;

    while (i < string.length()) {
        if (string.charAt(i) == string.charAt(i + 1) && string.charAt(i) == string.charAt(i + 2)) {
            cpt = 3;
            clr = string.charAt(i);
            i = i + 3;
                    
            while (i < string.length() && string.charAt(i) == clr) {
                cpt++;
                i++;
            }

            cpt = cpt + (int) pow(2, 15);
            hexaValue = hexaValue + Integer.toHexString(cpt) + " ";
                
            if (clr == 'n') {
                hexaValue += "00 ";
            } else {
                hexaValue += "FF ";
            }
                    
            cpt = 0;
        } else {
            while((i < string.length() && !(i + 2 < string.length() &&  string.charAt(i) == string.charAt(i + 1) && string.charAt(i) == string.charAt(i + 2)))){
                if (string.charAt(i) == 'n') {
                    inter += "00 ";
                } else {
                    inter += "FF ";
                }

                cpt++;
                i++;
            }
                
            hexaValue = hexaValue + Integer.toHexString(cpt) + " " + inter;
            cpt = 0;
            inter = "";
        }
        
    }
        
    print(hexaValue);
    text = split(hexaValue,' ');
    saveStrings("image.txt", text);
}

void decompress(String filename){
    color pixelColor = 0;
    int i = 0, pixel = 0, iteration;
    String hexaIteration, value;

    text = loadStrings(filename);
    output = createImage(w, h ,RGB);
    output.loadPixels();
    while(i < text.length - 1){
        hexaIteration = text[i];
        iteration =  Integer.parseInt(hexaIteration, 16) - (int) pow(2, 15);
                
        if (iteration > 0) {
                i++;
                value = text[i];
                if( value.equals("FF") ) {
                    pixelColor = color(255, 255, 255);
                }
                if( value.equals("00") ) {
                    pixelColor = color(0, 0, 0);
                }
                while(iteration > 0) {
                    output.pixels[pixel] = pixelColor;  
                    pixel++; 
                    iteration--;
                }
            i++;
        } else {
            iteration =  Integer.parseInt(hexaIteration, 16);
            i++;
            while(i < text.length - 1 && iteration > 0){
                value = text[i];
                if(value.equals("00")) {
                    pixelColor = color(0, 0, 0);
                }
                if(value.equals("FF")) {
                    pixelColor = color(255, 255, 255);
                }
                output.pixels[pixel]= pixelColor;  
                pixel++; 
                iteration--;
                i++;
            }
        }
    }

    updatePixels(); 
    image(output, 0, 0);
    output.save("output.bmp");
}
