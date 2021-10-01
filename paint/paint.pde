/*
 Credits:
   Trailing cursor animation inspired by https://processing.org/examples/storinginput.html
 */

int COLORS_SIZE = 30;
int NUM_HUES = 11;
int COLORS_X = 750;
int[] hues = new int[NUM_HUES];
int[] colors_y = new int[NUM_HUES];

int NUM_TAILS = 30;
int[] xs = new int[NUM_TAILS];
int[] ys = new int[NUM_TAILS];

int mouse_size = 25;
int mouse_hue = 0;

PImage img;

void setup() {
  size(800, 600);
  img = loadImage("panda.png");
  background(img);
  img.loadPixels();
}

void draw() {
  colorMode(HSB, 360, 100, 100);
  update_pixels(); 
  for (int i = 0; i < NUM_HUES; i++) {
    hues[i] = i*30;
    colors_y[i] = i*50+50;
    fill(hues[i], 50, 100);
    circle(COLORS_X, colors_y[i], COLORS_SIZE);
  }
  show_trail();
  update_mouse_color();
}

void update_pixels() {
  loadPixels();
  for (int w = 0; w < width; w++) {
    for (int h = 0; h < height; h++) {
      if (w > width - 100) {
        pixels[w+h*width] = color(0,0,100);
        continue;
      }
      float distX = mouseX - w;
      float distY = mouseY - h;
      float og_hue = hue(pixels[w+h*width]);
      float og_sat = saturation(pixels[w+h*width]);
      float og_bright = brightness(img.pixels[w + h*width]);
      color c = color(og_hue, og_sat, og_bright);
      if (og_bright > 50 && sqrt(pow(distX, 2) + pow(distY, 2)) <= mouse_size/2) {
        c = color(mouse_hue, 50, og_bright);
      }
      pixels[w+h*width] = c;
    }
  }
  
  updatePixels();
}

void show_trail() {
  noStroke();
  int curr = frameCount % NUM_TAILS;
  xs[curr] = mouseX;
  ys[curr] = mouseY;
  if (mouseX < 700) { 
    for (int i = 0; i < NUM_TAILS-min(0.2 * mouse_size, 25); i++) {
      int idx = (curr + NUM_TAILS - i) % NUM_TAILS;
      fill(mouse_hue, 50, 100);
      if (xs[idx] < 700) {
        circle(xs[idx], ys[idx], mouse_size-i);
      }
    }
  }
}

void update_mouse_color() {
  for (int i = 0; i < NUM_HUES; i++) {
    int distX = mouseX - COLORS_X;
    int distY = mouseY - colors_y[i];
    if (sqrt(pow(distX, 2) + pow(distY, 2)) <= COLORS_SIZE/2) {
      mouse_hue = hues[i];
    }
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w') {
    mouse_size += 5;
  } else if (key == 'S' || key == 's') {
    mouse_size -= 5;
  } else if (key == 'C' || key == 'c') {
    clear_drawing();
  }
}

void clear_drawing() {
  loadPixels();
  for (int w = 0; w < width; w++) {
    for (int h = 0; h < height; h++) {
      if (w > width - 100) {
        pixels[w+h*width] = color(0,0,100);
        continue;
      }
      pixels[w+h*width] = img.pixels[w+h*width];
    }
  }
  
  updatePixels();
}
