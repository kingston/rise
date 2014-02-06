//class FallingBallAnimation extends Animation {
//  int startHeight;
//  int targetHeight;
//
//  float startVelocity;
//  float acceleration;
//
//  public FallingBallAnimation(int startTime, int endTime, int targetHeight) {
//    super(startTime, endTime); // keep on rendering for 5 seconds after key time
//    this.targetHeight = targetHeight;
//  }
//
//  public void beginUpdates(Context context) {
//    // compute estimated end velocity
//    startHeight = context.ballHeight;
//    startVelocity = context.ballVelocity;
//    
//    int distance = targetHeight - startHeight;
//    float time = endTime - startTime;
//    acceleration = 2 * (distance - startVelocity * time) / time / time;
//  }
//
//  public void update(Context context) {
//    float time = context.time - startTime;
//    float distance = startVelocity * time + 0.5 * acceleration * time * time;
//    context.ballHeight = startHeight + (int) distance;
//    context.ballVelocity = startVelocity + time * acceleration;
//    //TODO: Hack - put somewhere better
//    //TODO: have camera follow ball as if force is acting on it
//    context.cameraHeight = context.ballHeight + 200;
//    // re-position camera
//    //camera(0, 300, 0, 0, context.ballHeight, 0, 0.0, 0.0, -1.0);
//    camera(0, context.cameraHeight, -400, 0, context.ballHeight, 0, 0.0, 0.0, -1.0);
//  }
//}

class FallingBallAnimation extends Animation {
  int startHeight;
  int targetHeight;

  float startVelocity;
  float targetVelocity;
  float alpha = 0.3;

  public FallingBallAnimation(int startTime, int endTime, int targetHeight) {
    super(startTime, endTime); // keep on rendering for 5 seconds after key time
    this.targetHeight = targetHeight;
  }

  public void beginUpdates(Context context) {
    // compute estimated end velocity
    startHeight = context.ballHeight;
    startVelocity = context.ballVelocity;
    
    int distance = targetHeight - startHeight;
    float time = endTime - startTime;
    targetVelocity = (2 * distance - startVelocity * alpha * time) / (2 * time - alpha * time);
  }

  public void update(Context context) {
    float time = context.time - startTime;
    float distance;
    float velocity;
    
    float firstDuration = alpha * (endTime - startTime);
    if (time < firstDuration) {
      distance = (startVelocity + targetVelocity) / 2.0 * time;
      velocity = lerp(startVelocity, targetVelocity, time / firstDuration);
    } else {
      distance = (startVelocity + targetVelocity) / 2.0 * firstDuration + targetVelocity * (time - firstDuration);
      velocity = targetVelocity;
    }
    context.ballHeight = startHeight + (int) distance;
    context.ballVelocity = velocity;
    //TODO: Hack - put somewhere better
    //TODO: have camera follow ball as if force is acting on it
    context.cameraHeight = context.ballHeight + 200;
    // re-position camera
    //camera(0, 300, 0, 0, context.ballHeight, 0, 0.0, 0.0, -1.0);
    camera(0, context.cameraHeight, -400, 0, context.ballHeight, 0, 0.0, 0.0, -1.0);
  }
}

