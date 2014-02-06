class GlowStream extends Animation {
  final float TRANSITION_TIME_PROPORTION = 0.2;
  public float glowDistance = 15;
  public int glowSize = 25;
  int transitionTime;
  
  public float streamHeight;
  public float streamRadius;
  public float streamCircleHeight;
  public float startAngle;
  public int startHue;
  public int endHue;
  public int saturation;
  public int value;
  
  public float streamEndHeight = -1;
  
  public int startHeight;
  
  public GlowStream(int startTime, int endTime) {
    super(startTime, endTime);
    transitionTime = (int) ((endTime - startTime) * TRANSITION_TIME_PROPORTION);
    this.streamHeight = 200;
    this.streamRadius = 50;
    this.streamCircleHeight = 150;
    this.startAngle = 0;
    this.startHue = (int) random(360);
    this.endHue = (int) random(360);
    this.saturation = 80;
    this.value = 80;
  }
  
  public void beginUpdates(Context context) {
    startHeight = context.ballHeight;
  }
  
  protected float getCenteredHeight(Context context) {
    return context.ballHeight;
  }
  
  public void update(Context context) {
    int time = context.time;
    float centeredHeight = getCenteredHeight(context);
    
    float intensity;
    if (time - startTime < transitionTime) {
      intensity = lerp(0, 1, (time-startTime)/(float)transitionTime);
    } else if (endTime - time < transitionTime) {
      intensity = lerp(0, 1, (endTime-time)/(float)transitionTime);
    } else {
      intensity = 1.0;
    }
    
    // compute height
    
    float actualHeight;
    
    if (streamEndHeight != -1) {
      actualHeight = lerp(streamHeight, streamEndHeight, (time-startTime)/(float)(endTime-time));
    } else {
      actualHeight = streamHeight;
    }
    
    int glows = (int) (actualHeight / glowDistance);
    float startY = centeredHeight - actualHeight / 2.0;
    for (int i = 0; i < glows; i++) {
      float y = startY + i * glowDistance;
      float offset = i / (float) glows - 0.5;
      
      // compute hue
      float hue = lerp(startHue, endHue, (time - startTime) / (float) (endTime - startTime));
      hue += offset * 30;
      hue = (hue + 360) % 360;
      
      // compute angle and x/z
      float angle = (startAngle + ((y - startHeight) / streamCircleHeight) * TWO_PI) % TWO_PI;
      float x = streamRadius * sin(angle);
      float z = streamRadius * cos(angle);
      
      // compute intensity
      float finalIntensity = intensity * (1-abs(offset));
      if (y < -2500) finalIntensity = 0.0; // floor
      drawGlow(new PVector(x,y,z), color(hue,saturation,value), finalIntensity, glowSize);
    }
  }
  
  private void drawGlow(PVector coord, int glowColor, float alpha, int size) {
    pushMatrix();
    translate(coord.x - 25, coord.y - 25, coord.z);
    tint(glowColor, alpha);
    scale(size / 51.0);
    image(glowImage, 0, 0);
    popMatrix();
  }
}

class AutonomousGlowStream extends GlowStream {
  int startHeight;
  int endHeight;
  
  public AutonomousGlowStream(int startTime, int endTime, int startHeight, int endHeight) {
    super(startTime, endTime);
    this.startHeight = startHeight;
    this.endHeight = endHeight;
    this.transitionTime = (int) ((endTime - startTime) * 0.35);
  }
  
  @Override
  protected float getCenteredHeight(Context context) {
    int time = context.time;
    return lerp(startHeight, endHeight, (time - startTime) / (float) (endTime - startTime));
  }
}
