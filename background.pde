class Background {
  ArrayList<BackgroundKeyframe> frames;

  public Background() {
    frames = new ArrayList<BackgroundKeyframe>();
  }

  // has to be added in the right order (lowest highest)
  public void addKeyframe(int height, int keyColor) {
    BackgroundKeyframe frame = new BackgroundKeyframe();
    frame.keyColor = keyColor;
    frame.height = height;
    frames.add(frame);
  }

  public void update(Context context) {
    // based off height figure out background
    float height = context.cameraHeight;
    BackgroundKeyframe lastFrame = null;
    for (BackgroundKeyframe frame : frames) {
      if (height < frame.height) {
        if (lastFrame == null) {
          throw new RuntimeException("Background Error: Height below lowest frame");
        }
        float portion = (height - lastFrame.height) / (frame.height - lastFrame.height);
        int newColor = lerpColor(lastFrame.keyColor, frame.keyColor, portion);
        background(newColor);
        return;
      }
      lastFrame = frame;
    }
    throw new RuntimeException("Background Error: Height above highest frame");
  }

  class BackgroundKeyframe {
    public int keyColor;
    public int height;
  }
}

