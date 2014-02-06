class Ball
{
  //taken from http://processing.org/discourse/beta/num_1274893475.html
  // Sphere Variables
  float R = 250;
  int xDetail = 40;
  int yDetail = 30;
  float[] xGrid = new float[xDetail+1];
  float[] yGrid = new float[yDetail+1];
  float[][][] allPoints = new float[xDetail+1][yDetail+1][3];

  // Rotation Variables
  float camDistance = -50;
  float rotationX = 100;
  float rotationY = 170;
  float velocityX = 0;
  float velocityY = 0;


  Ball() {
    setupSphere(R, xDetail, yDetail);
  }

  void setupSphere(float R, int xDetail, int yDetail) {

    // Create a 2D grid of standardized mercator coordinates
    for (int i = 0; i <= xDetail; i++) {
      xGrid[i]= i / (float) xDetail;
    } 
    for (int i = 0; i <= yDetail; i++) {
      yGrid[i]= i / (float) yDetail;
    }

    // Transform the 2D grid into a grid of points on the sphere, using the inverse mercator projection
    for (int i = 0; i <= xDetail; i++) {
      for (int j = 0; j <= yDetail; j++) {
        allPoints[i][j] = mercatorPoint(R, xGrid[i], yGrid[j]);
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////
  float[] mercatorPoint(float R, float x, float y) {

    float[] thisPoint = new float[3];
    float phi = x*2*PI;
    float theta = PI - y*PI;

    thisPoint[0] = R*sin(theta)*cos(phi);
    thisPoint[1] = R*sin(theta)*sin(phi);
    thisPoint[2] = R*cos(theta);

    return thisPoint;
  }
  
  void update(Context context) {
    noStroke();
    pushMatrix();
    fill(300, 0.8);
    translate(0, context.ballHeight, 0);
    scale(0.15);
    drawSphere(ballTexture);
    popMatrix();
  }

  ////////////////////////////////////////////////////////////////////////
  void drawSphere(PImage Map) {
    for (int j = 0; j < yDetail; j++) {
      beginShape(TRIANGLE_STRIP);
      texture(Map);
      for (int i = 0; i <= xDetail; i++) {
        vertex(allPoints[i][j+1][0], allPoints[i][j+1][1], allPoints[i][j+1][2], xGrid[i], yGrid[j+1]);
        vertex(allPoints[i][j][0], allPoints[i][j][1], allPoints[i][j][2], xGrid[i], yGrid[j]);
      }
      endShape(CLOSE);
    }
  }


  //  void update(Context context) {
  //    noStroke();
  //    pushMatrix();
  //    fill(300, 0.8);
  //    translate(0, context.ballHeight, 0);
  //    // TODO: Give it some character
  //    texture
  //      sphere(BALL_WIDTH);
  //    popMatrix();
  //  }
}

