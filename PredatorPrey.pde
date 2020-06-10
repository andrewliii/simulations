//L203 – line drawing
int HL = 100;
int HL2 = 180;

int amountOfGrass = 900;
int amountOfPrey = 600;
int amountOfPred = 6;
int predHL = 300;
int predRL = 9;

class Organism {
 float x, y, rad;
 boolean isDead;
 float DR;
 boolean inRange;
 
 String name;
 
 String type;
 
 Organism() {
  x = random(0, width);
  y = random(0, height);
  rad = 10;
 }
 
 Organism(float x, float y) {
  this.x = x;
  this.y = y;
 }
 
 void setRad(float rad) {
  this.rad = rad; 
 }
 
 Organism getNearestOrganismInList(ArrayList<Organism> orgs) {
   float mindist = 10000;
   Organism closest = new Organism();
   
   for(Organism o : orgs) {
    if(!o.equals(this) && dist(o.x, o.y, this.x, this.y) < mindist) {
      closest = o;
      mindist = dist(o.x, o.y, this.x, this.y);
    }
   }
   
   return closest;
 }
 
 float getDistanceToNearestOrganismInList(ArrayList<Organism> orgs) {
   float mindist = 10000;
   
   for(Organism o : orgs) {
    if(!o.equals(this) && dist(o.x, o.y, this.x, this.y) < mindist) {
      mindist = dist(o.x, o.y, this.x, this.y);
    }
   }
   
   return mindist;
 }
}

class Animal extends Organism {
 float vel;
 float dir;
 int hunger;
 int heat;
 
 Animal() {
  super();
  this.vel = 1.5;
  this.dir = random(0, 4);
  this.init();
  this.DR = 100;
 }
 
 void init() {
   this.isDead = false;
   this.hunger = 3000;
   this.heat = 0;
 }
 
 void evolve() {
   int rand = (int)random(0, 20000);
   
   switch(rand) {
    case 100:
    vel += random(0, 0.5);
    break;
    case 200:
    vel -= random(0, 0.5);
    if(vel <= 0) vel = -vel;
    break;
    case 300:
    rad += random(0, 3);
    break;
    case 400:
    rad -= random(0, 3);
    if(rad <= 0) rad = -rad;
    break;
    case 500:
    DR += random(0, 5);
    break;
    case 600:
    DR -= random(0, 5);
    if(DR <= 0) DR = -DR;
    break;
   }
 }
 
 void collision(ArrayList<Organism> organ) {
   if(frame%10==0 && inRange && ((this.type == "Prey" && this.getNearestOrganismInList(organ).type == "Prey" && !this.isDead) || (this.type == "Predator" && this.getNearestOrganismInList(organ).type == "Predator" && !this.isDead))) {
    //point towards nearest food
    float ndx = this.getNearestOrganismInList(organ).x-this.x;
    float ndy = this.y-this.getNearestOrganismInList(organ).y;

    this.dir = ((float)Math.atan(ndy/ndx));
   }
   
   if(this.getDistanceToNearestOrganismInList(organ)<=this.rad+this.getNearestOrganismInList(organ).rad && this.getNearestOrganismInList(organ).name!=null) {
     //they're touching
     //println(this.name + " is touching " + this.getNearestOrganismInList(organisms).name);
     
     if(this.type == "Prey" && this.getNearestOrganismInList(organ).type == "Plant" && !this.isDead) {
       Prey l = (Prey)this;
       l.eat((Plant)this.getNearestOrganismInList(organ));
     }
     
     if(this.type == "Predator" && this.getNearestOrganismInList(organ).type == "Prey" && !this.isDead) {
       Predator l = (Predator)this;
       l.eat((Prey)this.getNearestOrganismInList(organ));
     }
     
     if(this.type == "Predator" && this.getNearestOrganismInList(organ).type == "Predator" && !this.isDead && this.heat>=HL2 && ((Predator)(this.getNearestOrganismInList(organ))).heat >=HL2) {
       Predator l = (Predator)this;
       Predator newP = l.mate((Predator)this.getNearestOrganismInList(organ));
       newP.name = "exists";
       newP.x = this.x;
       newP.y = this.y;
       newP.rad = 10;
       organisms.add(newP);
       amountOfPred++;
       this.heat = 0;
       ((Predator)(this.getNearestOrganismInList(organ))).heat = 0;
     }
     
     if(this.type == "Prey" && this.getNearestOrganismInList(organ).type == "Prey" && !this.isDead && this.heat>=HL && ((Prey)(this.getNearestOrganismInList(organ))).heat >=HL) {
       Prey l = (Prey)this;
       Prey newP = l.mate((Prey)this.getNearestOrganismInList(organ));
       newP.name = "exists";
       newP.x = this.x;
       newP.y = this.y;
       amountOfPrey++;
       organisms.add(newP);
       this.heat = 0;
       ((Prey)(this.getNearestOrganismInList(organ))).heat = 0;
     }
   }
   
   if(this.getDistanceToNearestOrganismInList(organ)<=this.DR) {
     //print(this.getDistanceToNearestOrganismInList(organisms));
    //in range
    this.inRange = true;
   } else {
     this.inRange = false;
   }
   
   /*if(frame%10==0 && inRange && ((this.type == "Prey" && this.getNearestOrganismInList(organ).type == "Predator" && !this.isDead))) {
    //point away from nearest enemy
    float ndx = this.getNearestOrganismInList(organ).x-this.x;
    float ndy = this.y-this.getNearestOrganismInList(organ).y;

    this.dir = (((float)Math.atan(ndy/ndx))+2)%4;
   }*/
 }
 
 void tick(ArrayList<Organism> organ) {
  collision(organ); 
   
   if(hunger > 0) {
     heat+=1;
     hunger-=2;
     if(rad-15>=15) rad-=15;
   }
   
   if(hunger <= 0) {
    
    if(this.type=="Predator" && !this.isDead) {
     amountOfPred--; 
     organisms.remove(this);
    } else if (this.type=="Prey" && !this.isDead) {
     amountOfPrey--;
     organisms.remove(this);
    }
    
    return;
   }
  //move
  
  float mag = vel*1.5;
  float fac = map(dir, 0, 4, 0, 6.28);
  
  //line(x, y, x+mag*cos(fac)*10, y+mag*sin(fac)*10);
  
  this.x+=mag*cos(fac);
  this.y+=mag*sin(fac);
  
  if(x<0) x=width;
  if(y<0) y=height;
  if(x>width) x=0;
  if(y>height) y=0;
  
  this.dir += random(-0.05, 0.05);
  
  //evolve();
 }
}

class Predator extends Animal {
 Predator() {
  super();
  this.type = "Predator";
  this.hunger = predHL+80;
 }
 
 Predator(float[] traits) {
  super();
  this.vel = traits[0];
  this.rad = traits[1];
  this.type = "Predator";
  this.hunger = predHL;
 }
 
 void eat(Prey food) {
   food.isDead = true;
   food.x = -1000;
   food.y = -1000;
   this.hunger += food.rad*predRL;
   if(hunger>=predHL+100) hunger = predHL+100;
   this.rad += 0.1;
   organisms.remove(food);
   amountOfPrey--;
 }
 
 Predator mate(Predator friend) {
   float[] T = {(this.vel + friend.vel)/2, (this.rad + friend.rad)/2};
   return new Predator(T);
 }
}

class Prey extends Animal {
 Prey() {
  super();
  this.type = "Prey";
  this.hunger = 600;
 }
 
 Prey(float[] traits) {
  super();
  this.vel = traits[0];
  this.rad = traits[1];
  this.type = "Prey";
  this.hunger = 600;
 }
 
 void eat(Plant food) {
   food.isDead = true;
   food.x = -1000;
   food.y = -1000;
   this.hunger += 300;
   if(hunger>=800) hunger = 800;
   //this.rad += 3;
   organisms.remove(food);
   amountOfGrass--;
 }
 
 Prey mate(Prey friend) {
   float[] T = {(this.vel + friend.vel)/2, (this.rad + friend.rad)/2};
   return new Prey(T);
 }
}

class Plant extends Organism {
 Plant() {
   super();
   this.type = "Plant";
   this.DR = 0;
 }
}

ArrayList<Organism> organisms = new ArrayList<Organism>();
int frame = 0;

void setup() {
 size(600,600);
 frameRate(120);
 for(int i = 0; i < amountOfPrey; i ++) {
  Prey p = new Prey();
  p.name = "Y" + i;
  organisms.add(p);
 }
 
 for(int i = 0; i < amountOfPred; i ++) {
  Predator p = new Predator();
  p.name = "R" + i;
  p.rad = 10;
  organisms.add(p);
 }
 
 for(int i = 0; i < amountOfGrass; i ++) {
  Plant p = new Plant();
  p.name = "P" + i;
  organisms.add(p);
 }
}
int totalFrame = 0;

void getMoreGrass() {
 for(int i = 0; i < 6; i ++) {
   Plant p = new Plant();
   p.name = "PN" + i;
   organisms.add(p);
  amountOfGrass++;
 }
}

int countPrey() {
 int ct = 0;
 for(Organism o : organisms) {
  if(o.type == "Prey") ct++; 
 }
 
 return ct;
}

int countPred() {
  int ct = 0;
 for(Organism o : organisms) {
  if(o.type == "Predator") ct++; 
 }
 
 return ct;
}

void printData() {
 println(totalFrame/30 + "\t" + countPrey() + "\t" + countPred() + "\t" + amountOfGrass); //time prey pred grass
}

void draw() {
 background(255);
 frame++;
 totalFrame++;
 if(frame%10==0 && amountOfGrass <= 200) {
 getMoreGrass(); 
 }
 frame%=30;
 
 if(totalFrame % 30 == 0) {
  printData(); 
 }
 
 for(int i = 0; i < organisms.size(); i ++) {
   Organism o = organisms.get(i);

   switch(o.type) {
     case "Predator":
     fill(180, 0, 0);
     break;
     case "Prey":
     fill(220, 180, 0);
     break;
     case "Plant":
     fill(0, 180, 0, 45);
     break;
     default:
     fill(255);
     break;
   }
   
   ellipse(o.x, o.y, o.rad, o.rad);
   
   //fill(255, 192, 137, 20);
   //ellipse(o.x, o.y, o.rad+o.DR, o.rad+o.DR);
   
   if(o.type=="Predator" || o.type=="Prey") {
    Animal a = (Animal)o;
    a.tick(organisms);
    //fill(0);
    //text(a.hunger + " – " + a.heat, a.x+10, a.y+10);
   } else {
     //fill(0);
     //text(o.name + " – " + o.inRange + " – " + o.getNearestOrganismInList(organisms).name, o.x+10, o.y+10);
   }
   
   noStroke();
   fill(190, 190, 190, 240);
   rect(0, 0, width, 50);

   fill(180, 0, 0);
   ellipse(25, 25, 10, 10);
   fill(0);
   text("x" + countPred(), 30, 25);
   
   fill(220, 180, 0);
   ellipse(125, 25, 10, 10);
   fill(0);
   text("x" + countPrey(), 130, 25);
   
   fill(0, 180, 0, 45);
   ellipse(225, 25, 10, 10);
   fill(0);
   text("x" + amountOfGrass, 230, 25);
 }
}
