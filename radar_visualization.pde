import processing.serial.*;

Serial myPort;

float angle = 0;
float distance = 0;

void setup() {
  size(1000, 700);
  
  // CHANGE COM3 if your Arduino uses another port
  myPort = new Serial(this, "COM8", 9600);
  myPort.bufferUntil('\n');
  
  background(0);
}

void draw() {
  background(0);

  translate(width/2, height-60);

  // Radar circles
  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();

  ellipse(0, 0, 500, 500);
  ellipse(0, 0, 375, 375);
  ellipse(0, 0, 250, 250);
  ellipse(0, 0, 125, 125);

  // Radar lines
  line(-250, 0, 250, 0);
  line(0, 0, -216, -125);
  line(0, 0, 216, -125);

  // Sweep line
  float x = 250 * cos(radians(angle));
  float y = -250 * sin(radians(angle));

  stroke(0, 255, 0);
  line(0, 0, x, y);

  // Detected object
  if (distance > 0 && distance < 100) {
    float r = map(distance, 0, 100, 0, 250);

    float dotX = r * cos(radians(angle));
    float dotY = -r * sin(radians(angle));

    fill(255, 0, 0);
    noStroke();
    ellipse(dotX, dotY, 14, 14);
  }

  // Text
  resetMatrix();

  fill(0, 255, 0);
  textSize(22);
  text("MINI RADAR", 30, 40);
  text("Angle: " + int(angle) + "°", 30, 70);
  text("Distance: " + int(distance) + " cm", 30, 100);
}

void serialEvent(Serial p) {
  String data = p.readStringUntil('\n');

  if (data != null) {
    data = trim(data);

    String[] values = split(data, ',');

    if (values.length == 2) {
      angle = float(values[0]);
      distance = float(values[1]);
    }
  }
}
