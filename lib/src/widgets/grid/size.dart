/// A representation of an element's size on a grid. Holds the flex for an item
/// in the grid, along with whether that item will be an Expanded or Flexible
///
/// A size with negative flex indicates that the element will be greedy and use
/// up the entire row of the grid
class TGridSize {
  /// The flex to use - negative values are used as filling the whole row
  final int flex;

  /// Whether the item will use up as much space as allowed by its flex or only
  /// as much width as it needs
  final bool expanded;

  const TGridSize(this.flex) : expanded = false;

  /// Initialize the size with the expanded flag set to true
  const TGridSize.expanded(this.flex) : expanded = true;

  /// Initialize the size with negative flex
  const TGridSize.fill({this.expanded = true}) : flex = -1;

  /// Initialize the size with zero flex
  const TGridSize.zero({this.expanded = false}) : flex = 0;
}
