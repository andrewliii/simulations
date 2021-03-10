/* Set these values for different diseases
b = 1/average days infectious
c = contacts per infectious person
a = b*c
n = total pop */
public class Dot {
  int t;
  float S;
  float I;
  float R;
  
  Dot(int t, float S, float I, float R) {
     this.t=t;
     this.S=S;
     this.I=I;
     this.R=R;
  }
  
  String string() {
    return this.t + "\t" + this.S + "\t" + this.I + "\t" + this.R;
  }
  
  String stringRounded() {
    return this.t + "\t" + Math.round(this.S) + "\t" + Math.round(this.I) + "\t" + Math.round(this.R);
  }
}

float b = 1.0/3.0;
float c = 1.4;
float a = b*c;
int t = 0;
int limit = 1000;
float timestep = 0.1;

float S = 1000;
float I = 1;
float R = 0;
final float n = S+I+R;
Dot[] dots;

// Sets up drawing environment
void setup() {
  size(1000,1000);
  frameRate(100);
  dots = calculate();
  drawTime();
}

Dot[] calculate() {
  Dot[] list = new Dot[limit];
  
  for(int i = 0; i < limit; i ++) {
    //println(i);
    float dS = (-1*a*S*I/n)*timestep;
    float dI = ((a*S*I/n)-(b*I))*timestep;
    float dR = b*I*timestep;  
    
    Dot q = new Dot(i, S, I, R);
    list[i] = q;
      
    S += dS;
    I += dI;
    R += dR;
  }
  
  return list;
}

int frame = 0;
void drawTime() {
  fill(0);
  for(int q = 0; q < limit; q += 100) text((int)q*timestep, q, height-30);
}

void draw() {
  if(frame<limit) {
   //println(frame + "\t" + dots[frame]);
   noStroke();
   fill(255, 0, 0);
   ellipse(frame*width/limit, height-0.9*map(dots[frame].S, 0, n, 0, height)-50, 4, 4);
   //rect(frame*width/limit, height-0.9*map(dots[frame].S, 0, n, 0, height)-100, width/limit, 0.8*map(dots[frame].S, 0, n, 0, height));
   fill(0, 0, 255);
   ellipse(frame*width/limit, height-0.9*map(dots[frame].R, 0, n, 0, height)-50, 4, 4);
   //rect(frame*width/limit, height-0.9*map(dots[frame].R, 0, n, 0, height)-100, width/limit, 0.8*map(dots[frame].R, 0, n, 0, height));
   fill(0, 255, 0);
   ellipse(frame*width/limit, height-0.9*map(dots[frame].I, 0, n, 0, height)-50, 4, 4);
   //rect(frame*width/limit, height-0.9*map(dots[frame].I, 0, n, 0, height)-100, width/limit, 0.8*map(dots[frame].I, 0, n, 0, height));
   frame++;
  }
  
  if(mouseX <= frame) {
    String S = (dots[mouseX].stringRounded());
    fill(0);
    rect(10, 970, 300, 30);
    fill(255);
    text(S, 30, 990);
  }
}
