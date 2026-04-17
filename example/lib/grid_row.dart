import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';

class _GridExample extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const _GridExample({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SelectableText(title, style: Theme.of(context).textTheme.titleLarge),
        ...rows.separateWith(const Divider()),
      ].separateWith(const SizedBox(height: 20)),
    );
  }
}

class TGridRowShowcase extends StatelessWidget with TGridBreakpointAware {
  const TGridRowShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    String currentBreakpoint = getBreakpoint(context).name;
    return TCommonScaffold(
      title: 'TGridRow showcase',
      footer: (
        height: 30,
        widget: Center(
          child: SelectableText(
            'Current size: $currentBreakpoint',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      children: <Widget>[
        // The GridRow will automatically assign all children a flex of 1,
        // forcing them to automatically resize as needed based on the number
        // of children
        _GridExample(
          title: 'Automatic TGridRow with already expanded widgets',
          rows: <TGridRow>[
            TGridRow(
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(text: '1/3', usesMaxWidth: true),
                ),
                TGridItem(
                  child: TButton.elevated(text: '2/3', usesMaxWidth: true),
                ),
                TGridItem(
                  child: TButton.elevated(text: '3/3', usesMaxWidth: true),
                ),
              ],
            ),
            TGridRow(
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(text: '1/2', usesMaxWidth: true),
                ),
                TGridItem(
                  child: TButton.elevated(text: '2/2', usesMaxWidth: true),
                ),
              ],
            ),
          ],
        ),

        // If the widgets do not have infinite width, they will only take up
        // as much space as needed, unless specified to expand
        _GridExample(
          title: "Automatic TGridRow with widgets that aren't expanded",
          rows: <TGridRow>[
            TGridRow(
              children: <TGridItem>[
                TGridItem(child: TButton.elevated(text: '1/2')),
                TGridItem(child: TButton.elevated(text: '2/2')),
              ],
            ),
            TGridRow(
              children: <TGridItem>[
                TGridItem.fixedSize(
                  size: const TGridSize.expanded(1),
                  child: TButton.elevated(text: '1/2'),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize.expanded(1),
                  child: TButton.elevated(text: '2/2'),
                ),
              ],
            ),
          ],
        ),

        // You can specify how many flexes will fit in each grid size, allowing
        // the row to auto-adjust based on the screen width. Note here that
        // specified sizes propagate DOWN - specifying MD will copy its value
        // down to SM and XS, unless they are specified as well
        _GridExample(
          title: 'Automatic TGridRow with specific breakpoints',
          rows: <TGridRow>[
            TGridRow(
              xsFlexLimit: 1,
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(
                    text: '1/2 (xs limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
                TGridItem(
                  child: TButton.elevated(
                    text: '2/2 (xs limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
              ],
            ),
            TGridRow(
              mdFlexLimit: 1,
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(
                    text: '1/2 (md limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
                TGridItem(
                  child: TButton.elevated(
                    text: '2/2 (md limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
              ],
            ),
            TGridRow(
              xxlFlexLimit: 1,
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(
                    text: '1/2 (xxl limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
                TGridItem(
                  child: TButton.elevated(
                    text: '2/2 (xxl limit 1)',
                    usesMaxWidth: true,
                  ),
                ),
              ],
            ),
            TGridRow(
              smFlexLimit: 1,
              lgFlexLimit: 2,
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(
                    text: '1/3 (sm 1, lg 2)',
                    usesMaxWidth: true,
                  ),
                ),
                TGridItem(
                  child: TButton.elevated(
                    text: '2/3 (sm 1, lg 2)',
                    usesMaxWidth: true,
                  ),
                ),
                TGridItem(
                  child: TButton.elevated(
                    text: '3/3 (sm 1, lg 2)',
                    usesMaxWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),

        // You can manually specify how many flexes each item takes, to have
        // full control over how they are sized relative to each other. Special
        // values can also be assigned: zero means the item will not take up
        // space, and negative values will force that item to take up the whole
        // row
        //
        // You can also specify these values per breakpoint size, to have
        // complete control over the item structure at all screen sizes
        //
        // Note that unlike the row flex limit, item flex sizes propagate UP,
        // so specifying MD will copy its value up to LG, XL and beyond, leaving
        // SM and XS with default values
        //
        // The exception to that are negative flexes, which also propagate DOWN
        _GridExample(
          title: 'Automatic TGridRow with customized flex',
          rows: <TGridRow>[
            TGridRow(
              xsFlexLimit: 1, // This is useless in this example
              smFlexLimit: 2,
              lgFlexLimit: 3,
              children: <TGridItem>[
                TGridItem.fixedSize(
                  size: const TGridSize(2),
                  child: TButton.elevated(text: '2', usesMaxWidth: true),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize(1),
                  child: TButton.elevated(text: '1', usesMaxWidth: true),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize(2),
                  child: TButton.elevated(text: '2', usesMaxWidth: true),
                ),
              ],
            ),
            TGridRow(
              // Can specify this to center non-expanded elements
              mainAxisAlignment: MainAxisAlignment.center,
              xsFlexLimit: 1,
              children: <TGridItem>[
                TGridItem(
                  child: TButton.elevated(text: '1', usesMaxWidth: true),
                ),
                TGridItem(
                  child: TButton.elevated(text: '1', usesMaxWidth: true),
                ),
                TGridItem(
                  xs: const TGridSize(1),
                  sm: const TGridSize.zero(),
                  child: TButton.elevated(text: '0 (xs 1)'),
                ),
              ],
            ),
            TGridRow(
              smFlexLimit: 1,
              children: <TGridItem>[
                TGridItem.fixedSize(
                  size: const TGridSize(2),
                  child: TButton.elevated(text: '2', usesMaxWidth: true),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize(1),
                  child: TButton.elevated(text: '1', usesMaxWidth: true),
                ),
                TGridItem(
                  xxl: const TGridSize.fill(), // Will propagate down
                  child: TButton.elevated(text: '-1', usesMaxWidth: true),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize(1),
                  child: TButton.elevated(text: '1', usesMaxWidth: true),
                ),
                TGridItem.fixedSize(
                  size: const TGridSize(2),
                  child: TButton.elevated(text: '2', usesMaxWidth: true),
                ),
              ],
            ),
          ],
        ),

        // A uniform grid interface is also provided, to automatically wrap
        // all children with a flex of 1, spreading them out uniformly among
        // the rows based on the limit. Because they all have flex 1, this
        // ensures they will all have the same width, even if the final row has
        // fewer elements than the limit size
        _GridExample(
          title: 'TGridRow uniformGrid',
          rows: <TGridRow>[
            TGridRow.uniformGrid(
              xsFlexLimit: 1,
              smFlexLimit: 2,
              mdFlexLimit: 3,
              lgFlexLimit: 4,
              xlFlexLimit: 5,
              xxlFlexLimit: 6,
              xxxlFlexLimit: 7,
              fhdFlexLimit: 8,
              qhdFlexLimit: 9,
              uhdFlexLimit: 10,
              children: List<Widget>.generate(
                23,
                (_) =>
                    TButton.elevated(text: '<Same width>', usesMaxWidth: true),
              ),
            ),
          ],
        ),

        // A bootstrap-like interface is also provided, to substitute flex
        // behavior with the hardcoded 12 width. In this mode, the default
        // behavior is to assign 12 to every item, unles otherwise specified
        _GridExample(
          title: 'TGridRow with bootstrap-like behavior',
          rows: <TGridRow>[
            TGridRow.bootstrap(
              children: <TGridItem>[
                TGridItem.bootstrap(
                  xs: const TGridSize(4),
                  child: TButton.elevated(text: 'xs-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  xs: const TGridSize(4),
                  child: TButton.elevated(text: 'xs-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  xs: const TGridSize(4),
                  child: TButton.elevated(text: 'xs-4', usesMaxWidth: true),
                ),
              ],
            ),
            TGridRow.bootstrap(
              children: <TGridItem>[
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
              ],
            ),
            TGridRow.bootstrap(
              children: <TGridItem>[
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  md: const TGridSize(2),
                  child: TButton.elevated(text: 'md-2', usesMaxWidth: true),
                ),
                // It will automatically overflow and space things accordingly
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
                TGridItem.bootstrap(
                  md: const TGridSize(4),
                  child: TButton.elevated(text: 'md-4', usesMaxWidth: true),
                ),
              ],
            ),
          ],
        ),

        // Sometimes you need to make sure the children behave in a specific
        // way grouped in columns - a convenience TGridColumn class is
        // provided to reduce the boilerplate of wrapping them in a Column as
        // the child of a TGridItem
        _GridExample(
          title: 'TGridRow + TGridColumn',
          rows: <TGridRow>[
            TGridRow.bootstrap(
              // Might want to set this to start, default is center
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <TGridColumn>[
                TGridColumn.bootstrap(
                  md: const TGridSize(4),
                  children: <Widget>[
                    TButton.elevated(text: 'md-4 (1)', usesMaxWidth: true),
                    const SelectableText('Some text'),
                  ].separateWith(const SizedBox(height: 5)),
                ),
                TGridColumn.bootstrap(
                  md: const TGridSize(4),
                  children: <Widget>[
                    TButton.elevated(text: 'md-4 (2)', usesMaxWidth: true),
                    TButton.elevated(text: 'md-4 (2)', usesMaxWidth: true),
                  ].separateWith(const SizedBox(height: 20)),
                ),
                TGridColumn.bootstrap(
                  md: const TGridSize(4),
                  children: <Widget>[
                    TButton.elevated(text: 'md-4 (3)', usesMaxWidth: true),
                  ],
                ),
              ],
            ),
          ],
        ),
      ].separateWith(const Divider()),
    );
  }
}
