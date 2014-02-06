abstract class AnimationFrame extends Animation {
  public int keyTime;
  Animator animator;

  public AnimationFrame(int startTime, int keyTime) {
    super(startTime, keyTime + 5000); // keep on rendering for 5 seconds after key time
    this.keyTime = keyTime;
    animator = new Animator();
  }

  // animation frames need to:
  // + update ball
  // + do whatever renderings
  // + update camera
}

class HexagonalGridFrame extends AnimationFrame {
  final float HEX_SIZE = 35;
  final float HEX_DEPTHX = 14;
  final float HEX_DEPTHY = 30;
  int targetHeight;
  
  float brightness = 0.0;
  boolean hasShown = false;

  public HexagonalGridFrame(int startTime, int keyTime, int targetHeight) {
    super(startTime, keyTime);
    this.targetHeight = targetHeight;
  }

  // thanks to http://www.redblobgames.com/grids/hexagons/
  private void drawHexagon(float centerX, float centerY, float fader) {
    float hue;
    float saturation;
    // compute hue based off targetHeight
    if (targetHeight <= 0) {
      saturation = 0;
      hue = 242;
    } else {
      hue = lerp(70, 20, targetHeight / 16500.0);
      saturation = lerp(30, 70, targetHeight / 16500.0);
    }
    float distance = exp(-dist(0,0,centerX,centerY)/100);
    float longDistance = exp(-dist(0,0,centerX,centerY)/200) * fader;
    stroke(hue, saturation, 100, brightness * 0.9 * distance + 0.1 * longDistance);
    fill(hue, saturation, 100,  brightness * 0.95 * distance + 0.05 * longDistance);
    beginShape(TRIANGLE_FAN);
    vertex(centerX, targetHeight, centerY);
    for (int i = 0; i < 7; i++) {
      float angle = 2.0 * PI / 6.0 * i;
      float x_i = centerX + HEX_SIZE * cos(angle);
      float y_i = centerY + HEX_SIZE * sin(angle);
      vertex(x_i, targetHeight, y_i);
    }
    endShape();
  }
  
  public void beginUpdates(Context context) {
    boolean isGoingDown = context.ballVelocity <= 0;
    if (isGoingDown) {
      animator.add(new FallingBallAnimation(startTime, keyTime, targetHeight + BALL_WIDTH ));
      //animator.add(new FallingBallAnimation(keyTime - TRANSITION_TIME, keyTime, targetHeight));
    } else {
      animator.add(new FallingBallAnimation(startTime, keyTime, targetHeight - BALL_WIDTH ));
      //animator.add(new FallingBallAnimation(keyTime - TRANSITION_TIME, keyTime, targetHeight));
    }
  }

  public void update(Context context) {
    animator.update(context);
    if (!hasShown && context.time > keyTime) {
      hasShown = true;
      brightness = 1.0;
    }
    stroke(0);
    noFill();
    beginShape(TRIANGLE);
//    vertex(0,0,0);
//    vertex(0,0,-100);
//    vertex(-100,0,-100);
    endShape(CLOSE);

    // draw grid (approximated as a simple grid)
    float hexWidth = HEX_SIZE * 2.0;
    float hexHeight = sqrt(3)/2.0 * hexWidth;
  
    float xDistance = 3.0/2.0 * hexWidth;
    float yDistance = hexHeight / 2.0;
    
    float startY = - yDistance * HEX_DEPTHY / 2.0 + yDistance / 2.0;
    float startX = - xDistance * HEX_DEPTHX / 2.0 + xDistance / 2.0;
    
    float fader = (context.time - keyTime > 0) ? exp(-(context.time-keyTime) / 400.0): 1;
    
    for (int y = 0; y < HEX_DEPTHY; y++) {
      float yOffset = startY + yDistance * y;
      float xOffset = startX + 3.0/4.0 * hexWidth * (y % 2);
      for (int x = 0; x < HEX_DEPTHX; x++) {
        drawHexagon(xOffset + x * xDistance, yOffset, fader);
      }
    }
    brightness *= 0.9;
  }
}

