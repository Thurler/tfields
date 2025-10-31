/// A representation of an element's size on a grid. Holds the flex for an item
/// in the grid, along with whether that item will be an Expanded or Flexible
///
/// A size with negative flex indicates that the element will be greedy and use
/// up the entire row of the grid
class TGridSize {
  final int flex;
  final bool expanded;

  const TGridSize(this.flex) : expanded = false;

  const TGridSize.expanded(this.flex) : expanded = true;

  const TGridSize.fill({this.expanded = true}) : flex = -1;

  const TGridSize.zero({this.expanded = false}) : flex = 0;
}
