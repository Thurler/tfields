import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/icons.dart';
import 'package:tfields/widgets/input_decoration.dart';
import 'package:tfields/widgets/table/responsive.dart';

/// A mixin for ResponsiveTables that adds pagination concepts to the class. It
/// will not keep track of the state of pagination, considering the Table itself
/// is a StatelessWidget
mixin TPaginatedTable<T, C extends TResponsiveColumn>
    on TResponsiveTable<T, C> {
  /// The current page the table is displaying
  int get currentPage;

  /// How many rows are being displayed per page
  int get pageSize;

  /// The total page count, if available
  int? get pageCount;

  /// The page sizes available to be chosen by the user - a null list or a list
  /// that doesn't contain the current page size means the dropdown will not be
  /// rendered
  List<int>? get availablePageSizes;

  /// The callback to be called when the user selects a new pagination size -
  /// leaving this null means the pagination dropdown will not be rendered
  void Function(int?)? get pageSizeChangeCallback;

  /// A callback to trigger when the user requests a new page
  void Function(int newPage)? get pageChangeRequest;

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      children: <Widget>[
        // The table itself
        super.build(context),
        // Pagination controls are always rendered below the table itself
        TPaginationControl(
          currentPage: currentPage,
          pageSize: pageSize,
          availablePageSizes: availablePageSizes,
          pageSizeChangeCallback: pageSizeChangeCallback,
          pageChangeRequest: pageChangeRequest,
          pageCount: pageCount,
        ),
      ].separateWith(const SizedBox(height: 20)),
    );
    return expanded ? column : IntrinsicWidth(child: column);
  }
}

/// The pagination controls for a TPaginatedTable
class TPaginationControl extends StatelessWidget {
  /// The current page the table is displaying
  final int currentPage;

  /// How many rows are being displayed per page
  final int pageSize;

  /// The total page count, if available
  final int? pageCount;

  /// The page sizes available to be chosen by the user - a null list or a list
  /// that doesn't contain the current page size means the dropdown will not be
  /// rendered
  final List<int>? availablePageSizes;

  /// The callback to be called when the user selects a new pagination size -
  /// leaving this null means the pagination dropdown will not be rendered
  final void Function(int? newSize)? pageSizeChangeCallback;

  /// A callback to trigger when the user requests a new page
  final void Function(int newPage)? pageChangeRequest;

  const TPaginationControl({
    required this.currentPage,
    required this.pageSize,
    required this.pageChangeRequest,
    this.pageSizeChangeCallback,
    this.availablePageSizes,
    this.pageCount,
    super.key,
  });

  /// Show the current page as a "X of Y" text
  String get pageText =>
      pageCount == null ? '$currentPage' : '$currentPage of $pageCount';

  @override
  Widget build(BuildContext context) {
    bool showPageSizeControl = availablePageSizes != null &&
        pageSizeChangeCallback != null &&
        availablePageSizes!.contains(pageSize);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showPageSizeControl) ...<Widget>[
          IntrinsicWidth(
            child: TFormDropdown<int>(
              hintText: '',
              enabled: true,
              title: '# items',
              sortLogic: TDropdownSortLogic.object,
              initialValue: pageSize,
              options: availablePageSizes!,
              onValueChanged: pageSizeChangeCallback,
              toDropdownText: (int value) => value.toString(),
            ),
          ),
          // Pad out page size control from other pagination controls
          const Expanded(child: SizedBox(width: double.infinity)),
        ],
        TButton.iconOnly(
          icon: const TIcon(icon: Icons.first_page),
          text: 'First page',
          // No reason to go to the first page when you're already there
          onPressed: currentPage > 1 && pageChangeRequest != null
            ? () => pageChangeRequest!(1)
            : null,
        ),
        TButton.iconOnly(
          icon: const TIcon(icon: Icons.chevron_left),
          text: 'Previous page',
          // There's no previous page if you're in the first page
          onPressed: currentPage > 1 && pageChangeRequest != null
            ? () => pageChangeRequest!(currentPage - 1)
            : null,
        ),
        IntrinsicWidth(
          child: InputDecorator(
            decoration: const TInputDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SelectableText(pageText),
            ),
          ),
        ),
        TButton.iconOnly(
          icon: const TIcon(icon: Icons.chevron_right),
          text: 'Next page',
          // There's no next page if you're in the last page
          onPressed: (pageCount == null || currentPage != pageCount) &&
              pageChangeRequest != null
            ? () => pageChangeRequest!(currentPage + 1)
            : null,
        ),
        // There's no way to jump to last page if we don't know the count
        if (pageCount != null)
          TButton.iconOnly(
            icon: const TIcon(icon: Icons.last_page),
            text: 'Last page',
            // No reason to go to the last page when you're already there
            onPressed: pageChangeRequest != null && currentPage != pageCount
              ? () => pageChangeRequest!(pageCount!)
              : null,
          ),
      ].separateWith(const SizedBox(width: 5)),
    );
  }
}
