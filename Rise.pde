import ddf.minim.*;

AudioPlayer player;
Minim minim; //audio context

Background back = new Background();
Context context = new Context();
Ball ball = new Ball();
Animator animator = new Animator();

PImage ballTexture;

boolean DEBUG = false;
final float NOISE_FALLOFF = 0.5f;

final int BALL_WIDTH = 30;
final int TRANSITION_TIME = 30;

PFont font;

// taken from http://www.openprocessing.org/sketch/21319
PImage glowImage;

boolean FULL_SCREEN = true;

boolean sketchFullScreen() {
  return FULL_SCREEN;
}

void setup() {
  // basic setup
  if (FULL_SCREEN) {
    size(displayWidth, displayHeight, P3D);
  } else {
    size(800, 600, P3D);
  }
  frameRate(30);

  background(0);

  // color
  colorMode(HSB, 360, 100, 100, 1);

  // objects
  setupBackground();
  setupAnimations();

  // load images
  strokeWeight(1);
  noiseDetail(1, NOISE_FALLOFF);
  glowImage = loadImage("light.png");
  ballTexture = loadImage("light2.png");
  textureMode(NORMAL);
  smooth();

  if (DEBUG) {
    font = createFont("Arial Bold", 48);
  }

  minim = new Minim(this);
  player = minim.loadFile("3055.mp3");
}

void setupBackground()
{
  back.addKeyframe(-2500, color(210, 100, 0));
  back.addKeyframe(-100, color(210, 100, 30));
  back.addKeyframe(0, color(210, 100, 40));
  back.addKeyframe(1200, color(210, 100, 50));
  back.addKeyframe(9000, color(210, 50, 80));
  back.addKeyframe(16700, color(60, 15, 100));
}

void setupAnimations()
{
  // set up allllll the animations
  /*
	    0: start (height 1000)
   	  400: 1st touch (height 0)
   	  890: 2nd touch (height -1000)
   	 1386: 3rd touch (height -2000)
   	 1868: 4th touch (softer) (height -3000)
   	 2233: 5th touch (background sounds) (height -4000)
   	 2723: final touch (height -5000)
   	 #3278: quieted down#
   	 3660: begin ramp up and fade (height -5000)
   	 4660: second ramp up and rise (height -5000)
   	 5466: third ramp up and continue to rise (height -4000)
   	 6210: fourth rise up (height -3000)
   	 6902: flat-ish (height -2000)
   	 7354: flat-ish (height -1000)
   	 7561: hit through the roof (with snares) (height 0)
   	 8188: post reach (height 2000)
   	 8778: playful hit (height 4000)
   	 9300: lead up to climax (height 6000)
   	 9883: climax (height 9000)
   	10424: 2nd hit (height 10000)
   	10966: 3rd hit
   	11513: 4th snarish hit - finishing up
   	12011: final hit and slows down
   	12530: light hit (weird transition)
   	13126: final hit
   	13719: final bling
   	14200: done
   	*/

  // first 4 seconds are silence

  // on the way down
  animator.add(new HexagonalGridFrame(0, 400, 0));
  animator.add(new HexagonalGridFrame(400, 890, -500));
  animator.add(new HexagonalGridFrame(890, 1386, -1000));
  animator.add(new HexagonalGridFrame(1386, 1868, -1500));
  animator.add(new HexagonalGridFrame(1868, 2233, -2000));
  animator.add(new HexagonalGridFrame(2233, 2723, -2500));
  // now on the way up
  animator.add(new AutonomousGlowStream(3660, 4200, -2500, -2300));
  animator.add(new HexagonalGridFrame(4660, 5466, -2000));
  GlowStream one = new GlowStream(4660, 7561);
  GlowStream two = new GlowStream(4660, 7561);
  two.startAngle = PI;
  animator.add(one);
  animator.add(two);
  animator.add(new GlowStream(4660, 7561));
  animator.add(new HexagonalGridFrame(4360, 6210, -1500));
  animator.add(new HexagonalGridFrame(6210, 6902, -1000));
  animator.add(new HexagonalGridFrame(6902, 7354, -500));
  animator.add(new HexagonalGridFrame(7354, 7561, 0));
  // up on the surface!
  one = new GlowStream(7761, 10424);
  one.streamHeight = 250;
  one.streamEndHeight = 600;
  one.streamCircleHeight = 200;
  one.streamRadius = 75;
  one.value = 70;
  two = new GlowStream(7761, 10424);
  two.streamHeight = 250;
  two.streamEndHeight = 600;
  two.streamCircleHeight = 200;
  two.streamRadius = 75;
  two.startAngle = TWO_PI / 3;
  two.value =70;
  GlowStream three = new GlowStream(7761, 10424);
  three.streamHeight = 250;
  three.streamEndHeight = 600;
  three.streamCircleHeight = 200;
  three.streamRadius = 75;
  three.startAngle = 2.0 * TWO_PI / 3;
  three.value = 70;
  animator.add(one);
  animator.add(two);
  animator.add(three);
  animator.add(new HexagonalGridFrame(7561, 8188, 1000));
  animator.add(new HexagonalGridFrame(8188, 8778, 2000));
  animator.add(new HexagonalGridFrame(8778, 9300, 4000));
  animator.add(new HexagonalGridFrame(9300, 9883, 6500));
  animator.add(new HexagonalGridFrame(9883, 10424, 9500));
  // up on top
  
  one = new GlowStream(10966, 13426);
  one.streamHeight = 400;
  one.streamEndHeight = 150;
  one.streamCircleHeight = 100;
  one.streamRadius = 60;
  one.value = 40;
  two = new GlowStream(10966, 13426);
  two.streamHeight = 250;
  two.streamEndHeight = 600;
  two.streamCircleHeight = 200;
  two.streamRadius = 125;
  two.startAngle = TWO_PI / 3;
  two.value =70;
  three = new GlowStream(10966, 13726);
  three.streamHeight = 400;
  three.streamEndHeight = 100;
  three.streamCircleHeight = 200;
  three.streamRadius = 75;
  three.startAngle = 2.0 * TWO_PI / 3;
  three.value = 80;
  animator.add(one);
  
  animator.add(new HexagonalGridFrame(10424, 10966, 12000));
  animator.add(new HexagonalGridFrame(10966, 11513, 13500));
  animator.add(new HexagonalGridFrame(11513, 12011, 14800));
  animator.add(new HexagonalGridFrame(12011, 13126, 15800));
  animator.add(new HexagonalGridFrame(13126, 13719, 16500));
}

boolean firstDraw = true;
int startTime = 0;

// NOTE: We are operating in centisecond time
void draw() {
  if (firstDraw) {
    firstDraw = false;
    // force start for debug purposes
    int forceStart = 0;//7561*10;
    startTime = millis() / 10 - forceStart / 10;
    player.play();
    if (forceStart != 0) {
      player.cue(forceStart);
      context.ballHeight = 0;
    }
  }
  // set up context time
  context.time = millis() / 10 - startTime;
  
  back.update(context);
  // update background and ball
  //TODO: Hardcoded hack
  int time = context.time;
  if (time < 2723) {
    tint(360,1);
  } else if (time < 3578) {
    tint(360, 1- (time - 2723.0) / (3578.0-2723.0));
  } else if (time < 7561) {
    // do nothing
  } else if (time > 13719) {
    tint(360, max(0,1- (time - 13719.0) / 300.0));
  } else {
    tint(360,1);
  }
  ball.update(context);

  animator.update(context);


  // show FPS
  if (DEBUG) {
    textFont(font, 36);
    // white float frameRate
    fill(255);
    text(frameRate, 20, 20);
  }
  //
  //  println("Time: " + context.time);
  //  println("Ball Height: " + context.ballHeight);
  //  println("Ball Velocity: " + context.ballVelocity);
  //  println("Camera Height: " + context.cameraHeight);
}

