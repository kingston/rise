import java.util.*;

class Animator {
  PriorityQueue<Animation> animations;
  ArrayList<Animation> currentAnimations;

  public Animator() {
    animations = new PriorityQueue<Animation>();
    currentAnimations = new ArrayList<Animation>();
  }

  public void add(Animation animation) {
    animations.add(animation);
  }

  public void update(Context context) {
    // remove any ones with the correct time
    int time = context.time;
    while (!animations.isEmpty () && animations.peek ().startTime <= time) {
      Animation animation = animations.poll();
      animation.beginUpdates(context);
      currentAnimations.add(animation);
    }

    ArrayList<Animation> toRemove = new ArrayList<Animation>();
    for (Animation animation : currentAnimations) {
      if (animation.endTime < time) {
        toRemove.add(animation);
        break;
      }

      animation.update(context);
    }

    currentAnimations.removeAll(toRemove);
  }
}

abstract class Animation implements Comparable<Animation> {
  public int startTime;
  public int endTime;

  public Animation(int startTime, int endTime) {
    this.startTime = startTime;
    this.endTime = endTime;
  }

  @Override
    public int compareTo(Animation animation) {
    return Integer.valueOf(this.startTime).compareTo(Integer.valueOf(animation.startTime));
  }

  public void beginUpdates(Context context) {
  }

  public abstract void update(Context context);
}

