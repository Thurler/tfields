import 'package:flutter/material.dart';
import 'package:tfields/src/extensions/comparable.dart';
import 'package:tfields/src/mixins/grid_breakpoint_aware.dart';
import 'package:tfields/src/widgets/grid/breakpoint.dart';
import 'package:tfields/src/widgets/icon_text.dart';

/// The mixin that binds a ResponsiveTable's Column's functionalities
mixin TResponsiveColumn on Enum {
  /// Function to build the column header widget
  Widget build(BuildContext context);
}

/// A DataTable that acts responsive by removing columns below a specific
/// TGridBreakpoint threshold. The conversion between the templated data of type
/// T and what shows in each cell for a Column is achieved through the
/// TResponsiveColumn class enum being routed to an abstract `buildCell`
/// function
abstract class TResponsiveTable<T, Col extends TResponsiveColumn>
    extends StatelessWidget with TGridBreakpointAware {
  /// The data that will be rendered, in its original data type
  final List<T> rows;

  /// The columns that will be displayed, alongside the TGridBreakpoint
  /// threshold for displaying each column
  final Map<Col, TGridBreakpoint>? columns;

  /// The inverse of the "columns" property, specifying which columns show at
  /// each grid breakpoint. This can be useful for tables that want to display
  /// specific summary columns at smaller breakpoints
  final Map<TGridBreakpoint, List<Col>>? columnsPerBreakpoint;

  /// A column that will anchor itself to the right and always be rendered with
  /// only the necessary width
  final Col? suffixColumn;

  /// The text to display when rows is an empty list
  final String noRowsText;

  /// Whether the table will have infinite width or not
  final bool expanded;

  /// The function that receives the data and column that are being rendered in
  /// a cell, and returns the Widget that will be displayed
  Widget buildCell(T row, Col col, BuildContext context);

  const TResponsiveTable({
    required this.rows,
    required Map<Col, TGridBreakpoint> this.columns,
    required this.noRowsText,
    this.expanded = true,
    this.suffixColumn,
    super.key,
  }) : columnsPerBreakpoint = null;

  /// A different way to specify the columns available per breakpoint. Bigger
  /// sizes will copy the available columns from the smaller sizes
  TResponsiveTable.perBreakpoint({
    required this.rows,
    required List<Col> xsColumns,
    required this.noRowsText,
    List<Col>? smColumns,
    List<Col>? mdColumns,
    List<Col>? lgColumns,
    List<Col>? xlColumns,
    List<Col>? xxlColumns,
    this.expanded = true,
    this.suffixColumn,
    super.key,
  }) :
    columns = null,
    columnsPerBreakpoint = <TGridBreakpoint, List<Col>>{
      TGridBreakpoint.xs: xsColumns,
      TGridBreakpoint.sm: smColumns ?? xsColumns,
      TGridBreakpoint.md: mdColumns ?? smColumns ?? xsColumns,
      TGridBreakpoint.lg: lgColumns ?? mdColumns ?? smColumns ?? xsColumns,
      TGridBreakpoint.xl:
          xlColumns ?? lgColumns ?? mdColumns ?? smColumns ?? xsColumns,
      TGridBreakpoint.xxl: xxlColumns ?? xlColumns ?? lgColumns ?? mdColumns ??
          smColumns ?? xsColumns,
    };

  @override
  Widget build(BuildContext context) {
    // If no rows, just render the no rows text
    if (rows.isEmpty) {
      return TIconText.error(noRowsText);
    }
    // Make sure only the columns for the current breakpoint are rendered
    TGridBreakpoint currentGrid = getBreakpoint(context);
    Iterable<Col> displayedColumns = columns != null
      ? columns!.keys.where((Col col) => columns![col]! <= currentGrid)
      : columnsPerBreakpoint![currentGrid]!;
    return SizedBox(
      width: expanded ? double.infinity : null,
      child: DataTable(
        dataRowMaxHeight: double.infinity,
        columnSpacing: 24,
        horizontalMargin: 16,
        columns: <DataColumn>[
          ...displayedColumns.map(
            (Col col) => DataColumn(
              label: col.build(context),
              columnWidth: const FlexColumnWidth(),
            ),
          ),
          if (suffixColumn != null)
            DataColumn(
              label: suffixColumn!.build(context),
              columnWidth: const IntrinsicColumnWidth(),
            ),
        ],
        rows: rows.map(
          (T row) => DataRow(
            cells: <DataCell>[
              ...displayedColumns.map(
                (Col col) => DataCell(buildCell(row, col, context)),
              ),
              if (suffixColumn != null)
                DataCell(buildCell(row, suffixColumn!, context)),
            ],
          ),
        ).toList(),
      ),
    );
  }
}
