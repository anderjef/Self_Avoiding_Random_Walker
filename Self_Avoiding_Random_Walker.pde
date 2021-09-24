//Jeffrey Andersen

import peasy.*;

int xSpacing = 100, ySpacing = 100, zSpacing = 100;
int stepsPerFrame = 10000;
int initialRedValue = 50 % 256, initialGreenValue = 50 % 256, initialBlueValue = 50 % 256, initialAlphaValue = 255 % 256;
int dRedValue = 5, dGreenValue = 10, dBlueValue = 15, dAlphaValue = 0;
boolean drawOrbs = true;

int depth = 600;
Spot s; //walker's location
int xRows, yRows, zRows;
int xOffset = 0, yOffset = 0, zOffset;
ArrayList<Spot> grid = new ArrayList<Spot>();
ArrayList<Spot> path = new ArrayList<Spot>();
int frameNum = 0;
PeasyCam camera;

boolean isValidOption(Option o) {
  if (o.xIndex < 0 || o.xIndex >= xRows || o.yIndex < 0 || o.yIndex >= yRows || o.zIndex < 0 || o.zIndex >= zRows) {
    return false;
  }
  return !grid.get(o.zIndex * xRows * yRows + o.yIndex * xRows + o.xIndex).isVisited && !o.isTried;
}

int distanceSquaredBetweenSpots(Spot s1, Spot s2) {
  return (s1.xIndex - s2.xIndex) * (s1.xIndex - s2.xIndex) + (s1.yIndex - s2.yIndex) * (s1.yIndex - s2.yIndex) + (s1.zIndex - s2.zIndex) * (s1.zIndex - s2.zIndex);
}

void setup() {
  size(600, 600, P3D);
  xRows = width / xSpacing;
  if (width % xSpacing != 0) {
    xOffset = round((width - (width / xSpacing) * xSpacing) / 2); //integer truncation is as desired
  }
  yRows = height / ySpacing;
  if (height % ySpacing != 0) {
    yOffset = round((height - (height / ySpacing) * ySpacing) / 2); //integer truncation is as desired
  }
  zRows = depth / zSpacing;
  if (depth % zSpacing != 0) {
    zOffset = round((depth - (depth / zSpacing) * zSpacing) / 2); //integer truncation is as desired
  }
  for (int z = 0; z < zRows; z++) {
    for (int y = 0; y < yRows; y++) {
      for (int x = 0; x < xRows; x++) {
        grid.add(new Spot(x, y, z));
      }
    }
  }
  s = grid.get(int(random(zRows)) * xRows * yRows + int(random(yRows)) * xRows + int(random(xRows))); //start in an arbitrary/random location
  s.isVisited = true;
  path.add(s);
  stroke(initialRedValue, initialGreenValue, initialBlueValue, initialAlphaValue);
  strokeWeight(min(xSpacing, ySpacing, zSpacing) * 0.5);
  noFill();
  camera = new PeasyCam(this, depth + depth / 2); //PeasyCam notably moves the origin to the center of the window
}

void draw() {
  background(0);
  translate(-width / 2, -height / 2, -depth / 2);
  translate(xSpacing * 0.5 + xOffset, ySpacing * 0.5 + yOffset, zSpacing * 0.5 + zOffset);
  if (drawOrbs) { //draw initial orb
    Spot spot = path.get(0);
    stroke(initialRedValue, initialGreenValue, initialBlueValue, initialAlphaValue);
    translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
    sphere(min(xSpacing, ySpacing, zSpacing) / 8);
    translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
  }
  for (int spotIndex = 1; spotIndex < path.size() - 1; spotIndex++) { //draw intermediary orbs
    if (drawOrbs && distanceSquaredBetweenSpots(path.get(spotIndex - 1), path.get(spotIndex + 1)) != 4) {
      Spot spot = path.get(spotIndex);
      stroke((initialRedValue + dRedValue * spotIndex) % 256, (initialGreenValue + dGreenValue * spotIndex) % 256, (initialBlueValue + dBlueValue * spotIndex) % 256, (initialAlphaValue + dAlphaValue * spotIndex) % 256);
      translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
      sphere(min(xSpacing, ySpacing, zSpacing) / 8);
      translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
    }
  }
  if (drawOrbs && path.size() > 1) { //draw final orb
    Spot spot = path.get(0);
    stroke(initialRedValue, initialGreenValue, initialBlueValue, initialAlphaValue);
    translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
    sphere(min(xSpacing, ySpacing, zSpacing) / 8);
    translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
  }
  beginShape();
  int redValueOffset = 0, greenValueOffset = 0, blueValueOffset = 0, alphaValueOffset = 0;
  for (Spot spot : path) {
    vertex(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
    stroke((initialRedValue + redValueOffset) % 256, (initialGreenValue + greenValueOffset) % 256, (initialBlueValue + blueValueOffset) % 256, (initialAlphaValue + alphaValueOffset) % 256);
    redValueOffset += dRedValue;
    greenValueOffset += dGreenValue;
    blueValueOffset += dBlueValue;
    alphaValueOffset += dAlphaValue;
  }
  endShape();
  for (int i = 0; i < stepsPerFrame; i++) {
    if (path.size() == xRows * yRows * zRows) {
      println("Random walk is complete!");
      println("Took", frameNum * stepsPerFrame + i, " steps.");
      background(0);
      if (drawOrbs) { //draw initial orb
        Spot spot = path.get(0);
        stroke(initialRedValue, initialGreenValue, initialBlueValue, initialAlphaValue);
        translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
        sphere(min(xSpacing, ySpacing, zSpacing) / 8);
        translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
      }
      for (int spotIndex = 1; spotIndex < path.size() - 1; spotIndex++) { //draw intermediary orbs
        if (drawOrbs && distanceSquaredBetweenSpots(path.get(spotIndex - 1), path.get(spotIndex + 1)) != 4) {
          Spot spot = path.get(spotIndex);
          stroke((initialRedValue + dRedValue * spotIndex) % 256, (initialGreenValue + dGreenValue * spotIndex) % 256, (initialBlueValue + dBlueValue * spotIndex) % 256, (initialAlphaValue + dAlphaValue * spotIndex) % 256);
          translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
          sphere(min(xSpacing, ySpacing, zSpacing) / 8);
          translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
        }
      }
      if (drawOrbs && path.size() > 1) { //draw final orb
        Spot spot = path.get(0);
        stroke(initialRedValue, initialGreenValue, initialBlueValue, initialAlphaValue);
        translate(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
        sphere(min(xSpacing, ySpacing, zSpacing) / 8);
        translate(-spot.xIndex * xSpacing, -spot.yIndex * ySpacing, -spot.zIndex * zSpacing);
      }
      beginShape();
      redValueOffset = 0;
      greenValueOffset = 0;
      blueValueOffset = 0;
      alphaValueOffset = 0;
      for (Spot spot : path) {
        vertex(spot.xIndex * xSpacing, spot.yIndex * ySpacing, spot.zIndex * zSpacing);
        stroke((initialRedValue + redValueOffset) % 256, (initialGreenValue + greenValueOffset) % 256, (initialBlueValue + blueValueOffset) % 256, (initialAlphaValue + alphaValueOffset) % 256);
        redValueOffset += dRedValue;
        greenValueOffset += dGreenValue;
        blueValueOffset += dBlueValue;
        alphaValueOffset += dAlphaValue;
      }
      endShape();
      noLoop();
      return;
    }
    s = s.nextSpot();
    if (s == null) {
      s = path.get(path.size() - 1);
      s.resetPossibleOptions();
      s.isVisited = false;
      path.remove(s);
      s = path.get(path.size() - 1);
    } else {
      s.isVisited = true;
      path.add(s);
    }
  }
  frameNum++;
}
