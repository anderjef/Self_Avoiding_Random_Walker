//Jeffrey Andersen

class Spot {
  int xIndex, yIndex, zIndex;
  boolean isVisited;
  ArrayList<Option> possibleOptions = new ArrayList<Option>();

  Spot(int _xIndex, int _yIndex, int _zIndex) {
    xIndex = _xIndex;
    yIndex = _yIndex;
    zIndex = _zIndex;
    isVisited = false;
    this.resetPossibleOptions();
  }

  void resetPossibleOptions() {
    possibleOptions.clear();
    possibleOptions.add(new Option(xIndex, yIndex, zIndex - 1));
    possibleOptions.add(new Option(xIndex, yIndex, zIndex + 1));
    possibleOptions.add(new Option(xIndex, yIndex - 1, zIndex));
    possibleOptions.add(new Option(xIndex, yIndex + 1, zIndex));
    possibleOptions.add(new Option(xIndex - 1, yIndex, zIndex));
    possibleOptions.add(new Option(xIndex + 1, yIndex, zIndex));
  }

  Spot nextSpot() {
    ArrayList<Option> validOptions = new ArrayList<Option>();
    for (Option o : possibleOptions) {
      if (isValidOption(o)) {
        validOptions.add(o);
      }
    }
    if (validOptions.size() > 0) {
      Option chosenOption = validOptions.get(int(random(validOptions.size())));
      chosenOption.isTried = true;
      return grid.get(chosenOption.zIndex * xRows * yRows + chosenOption.yIndex * xRows + chosenOption.xIndex);
    }
    return null;
  }
}
