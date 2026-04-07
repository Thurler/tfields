import 'package:flutter/material.dart';
import 'package:tfields/widgets.dart';

// Sample data model for product inventory
class Product {
  final String sku;
  final String name;
  final String category;
  final double price;
  final int stock;
  final DateTime lastRestocked;

  Color get stockStatusColor => stock > 50
    ? Colors.green
    : stock > 20
      ? Colors.orange
      : Colors.red;

  String get stockStatusText => stock > 50
    ? 'In stock'
    : stock > 20
      ? 'Low'
      : 'Critical';

  const Product({
    required this.sku,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.lastRestocked,
  });
}

// Sample dataset for the responsive tables
// Extended with more products for searchable table demonstration
final List<Product> _sampleProducts = <Product>[
  Product(
    sku: 'LAP-001',
    name: 'Laptop Pro 15',
    category: 'Electronics',
    price: 1299.99,
    stock: 23,
    lastRestocked: DateTime(2025, 10, 15),
  ),
  Product(
    sku: 'MOU-042',
    name: 'Wireless Mouse',
    category: 'Accessories',
    price: 29.99,
    stock: 156,
    lastRestocked: DateTime(2025, 10, 20),
  ),
  Product(
    sku: 'KEY-018',
    name: 'Mechanical Keyboard',
    category: 'Accessories',
    price: 89.99,
    stock: 67,
    lastRestocked: DateTime(2025, 10, 18),
  ),
  Product(
    sku: 'MON-025',
    name: '4K Monitor 27"',
    category: 'Electronics',
    price: 449.99,
    stock: 12,
    lastRestocked: DateTime(2025, 10, 12),
  ),
  Product(
    sku: 'HED-033',
    name: 'Headphones with Noise Cancelling',
    category: 'Audio',
    price: 249.99,
    stock: 34,
    lastRestocked: DateTime(2025, 10, 22),
  ),
  Product(
    sku: 'CAM-007',
    name: 'Webcam HD 1080p',
    category: 'Electronics',
    price: 79.99,
    stock: 45,
    lastRestocked: DateTime(2025, 10, 19),
  ),
  Product(
    sku: 'MIC-012',
    name: 'USB Condenser Microphone',
    category: 'Audio',
    price: 129.99,
    stock: 28,
    lastRestocked: DateTime(2025, 10, 16),
  ),
  Product(
    sku: 'SPK-055',
    name: 'Bluetooth Speakers',
    category: 'Audio',
    price: 89.99,
    stock: 72,
    lastRestocked: DateTime(2025, 10, 21),
  ),
  Product(
    sku: 'TAB-003',
    name: 'Tablet 10"',
    category: 'Electronics',
    price: 399.99,
    stock: 18,
    lastRestocked: DateTime(2025, 10, 14),
  ),
  Product(
    sku: 'CHR-088',
    name: 'Fast USB-C Charger',
    category: 'Accessories',
    price: 24.99,
    stock: 203,
    lastRestocked: DateTime(2025, 10, 23),
  ),
  Product(
    sku: 'CAB-099',
    name: 'HDMI Cable 2m',
    category: 'Accessories',
    price: 14.99,
    stock: 187,
    lastRestocked: DateTime(2025, 10, 17),
  ),
  Product(
    sku: 'DSK-044',
    name: 'Support for Notebooks',
    category: 'Accessories',
    price: 39.99,
    stock: 54,
    lastRestocked: DateTime(2025, 10, 13),
  ),
];

// ============================================================================
// EXAMPLE 1: Using the threshold-based column specification
// ============================================================================
//
// This approach specifies columns with a minimum GridBreakpoint threshold.
// Each column will be visible when the screen size is AT OR ABOVE the
// specified breakpoint. This is useful when you want to progressively reveal
// more information as screen size increases.
//
// IMPORTANT: The column enum is forced to implement ResponsiveColumn, which
// benefits from Dart's compile-time checking in switch statements - you'll
// get warnings if you don't handle all cases!

// Column enum for the threshold-based table
// Must implement ResponsiveColumn mixin to be used with TResponsiveTable
enum ThresholdTableColumn with TResponsiveColumn {
  sku,
  name,
  category,
  price,
  stock,
  lastRestocked;

  @override
  Widget build(BuildContext context) {
    // Using a switch ensures compile-time checking - if we add a new enum
    // value and forget to handle it here, Dart will warn us!
    return switch (this) {
      ThresholdTableColumn.sku => const Text('SKU'),
      ThresholdTableColumn.name => const Text('Product Name'),
      ThresholdTableColumn.category => const Text('Category'),
      ThresholdTableColumn.price => const Text('Price'),
      ThresholdTableColumn.stock => const Text('Stock'),
      ThresholdTableColumn.lastRestocked => const Text('Last Restock'),
    };
  }
}

class ThresholdBasedTable
    extends TResponsiveTable<Product, ThresholdTableColumn> {
  ThresholdBasedTable({super.key}) :
    super(
      rows: _sampleProducts,
      // Map each column to its minimum visibility breakpoint
      // - SKU and Name: Always visible (xs = extra small screens)
      // - Category: Visible on small screens and above
      // - Price: Visible on medium screens and above
      // - Stock: Visible on large screens and above
      // - Last Restocked: Only visible on extra large screens
      columns: const <ThresholdTableColumn, TGridBreakpoint>{
        ThresholdTableColumn.sku: TGridBreakpoint.xs,
        ThresholdTableColumn.name: TGridBreakpoint.xs,
        ThresholdTableColumn.category: TGridBreakpoint.sm,
        ThresholdTableColumn.price: TGridBreakpoint.md,
        ThresholdTableColumn.stock: TGridBreakpoint.lg,
        ThresholdTableColumn.lastRestocked: TGridBreakpoint.xl,
      },
      noRowsText: 'No product available',
    );

  @override
  Widget buildCell(
    Product row,
    ThresholdTableColumn col,
    BuildContext context,
  ) {
    // Again, using switch for compile-time safety!
    return switch (col) {
      ThresholdTableColumn.sku => Text(row.sku),
      ThresholdTableColumn.name => Text(row.name),
      ThresholdTableColumn.category => Text(row.category),
      ThresholdTableColumn.price => Text('\$${row.price.toStringAsFixed(2)}'),
      ThresholdTableColumn.stock => Text(row.stock.toString()),
      ThresholdTableColumn.lastRestocked => Text(
          '${row.lastRestocked.year}-'
          '${row.lastRestocked.month.toString().padLeft(2, '0')}-'
          '${row.lastRestocked.day.toString().padLeft(2, '0')}',
        ),
    };
  }
}

// ============================================================================
// EXAMPLE 2: Using the per-breakpoint column specification
// ============================================================================
//
// This approach explicitly specifies which columns appear at each breakpoint.
// This is useful when you want different column combinations at different
// screen sizes, or when smaller screens should show summary columns instead
// of hiding columns.
//
// Columns at larger breakpoints automatically inherit from smaller ones unless
// explicitly overridden, allowing you to progressively add columns as screen
// size increases.

// Column enum for the per-breakpoint table
enum BreakpointTableColumn with TResponsiveColumn {
  name,
  category,
  price,
  stock,
  stockStatus, // A special summary column for small screens
  actions;

  @override
  Widget build(BuildContext context) {
    return switch (this) {
      BreakpointTableColumn.name => const Text('Product'),
      BreakpointTableColumn.category => const Text('Category'),
      BreakpointTableColumn.price => const Text('Price'),
      BreakpointTableColumn.stock => const Text('Stock'),
      BreakpointTableColumn.stockStatus => const Text('Status'),
      BreakpointTableColumn.actions => const Text('Actions'),
    };
  }
}

class BreakpointBasedTable
    extends TResponsiveTable<Product, BreakpointTableColumn> {
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  static const List<BreakpointTableColumn> xsColumns = <BreakpointTableColumn>[
    BreakpointTableColumn.name,
    BreakpointTableColumn.stockStatus,
  ];

  static const List<BreakpointTableColumn> mdColumns = <BreakpointTableColumn>[
    BreakpointTableColumn.name,
    BreakpointTableColumn.price,
    BreakpointTableColumn.stockStatus,
  ];

  static const List<BreakpointTableColumn> lgColumns = <BreakpointTableColumn>[
    BreakpointTableColumn.name,
    BreakpointTableColumn.category,
    BreakpointTableColumn.price,
    BreakpointTableColumn.stock,
  ];

  BreakpointBasedTable({
    this.onEditPressed,
    this.onDeletePressed,
    super.key,
  }) : super.perBreakpoint(
    rows: _sampleProducts,
    // Explicitly specify columns for each breakpoint:
    // - xs/sm: Just name and a summary status column
    // - md: Add price (status column still visible)
    // - lg: Replace status with separate stock and category columns
    // - xl/xxl/beyond: All columns visible
    xsColumns: xsColumns,
    mdColumns: mdColumns,
    lgColumns: lgColumns,
    // The suffixColumn always appears on the right with minimal width
    // Perfect for action buttons!
    suffixColumn: BreakpointTableColumn.actions,
    noRowsText: 'No product available',
  );

  // This is static only so we can reuse it in subsequent examples
  static Widget gBuildCell(
    Product row,
    BreakpointTableColumn col,
    BuildContext context,
  ) {
    return switch (col) {
      BreakpointTableColumn.name => Text(row.name),
      BreakpointTableColumn.category => Text(row.category),
      BreakpointTableColumn.price => Text('\$${row.price.toStringAsFixed(2)}'),
      BreakpointTableColumn.stock => Text(row.stock.toString()),
      // The stockStatus column provides a summary for smaller screens
      BreakpointTableColumn.stockStatus => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.circle, size: 8, color: row.stockStatusColor),
            const SizedBox(width: 4),
            Text(
              row.stockStatusText,
              style: TextStyle(color: row.stockStatusColor),
            ),
          ],
        ),
      BreakpointTableColumn.actions => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TButton.iconOnly.edit(
              forceDefaultIconColor: true,
              onPressed: () {},
            ),
            TButton.iconOnly.delete(onPressed: () {}),
          ],
        ),
    };
  }

  @override
  Widget buildCell(
    Product row,
    BreakpointTableColumn col,
    BuildContext context,
  ) {
    return gBuildCell(row, col, context);
  }
}

// ============================================================================
// EXAMPLE 3: Using the PaginatedTable mixin
// ============================================================================
//
// The PaginatedTable mixin adds pagination controls to any
// TResponsiveTable. In this STATELESS example, we're hardcoding the
// pagination state for demonstration purposes only.
//
// IMPORTANT: In a real-world scenario, these values (currentPage, pageSize,
// rows data, etc.) would typically be passed in as constructor arguments from
// a STATEFUL parent widget that manages pagination state and fetches data
// based on page changes.

class PaginatedProductTable
    extends TResponsiveTable<Product, BreakpointTableColumn>
    with TPaginatedTable<Product, BreakpointTableColumn> {
  // IMPORTANT: In a real stateful implementation, these would be passed as
  // constructor arguments that change when the user interacts with pagination
  // controls. The parent StatefulWidget would manage the state and re-render
  // this table with updated values.

  // Hardcoded for demo: would normally come from constructor
  @override
  final int currentPage = 2;

  // Hardcoded for demo: would normally come from constructor
  @override
  final int pageSize = 3;

  // Hardcoded for demo: would normally be calculated from total row count
  // (e.g., (totalRows / pageSize).ceil())
  @override
  final int? pageCount = 5;

  // Hardcoded for demo: would normally come from constructor
  @override
  final List<int>? availablePageSizes = const <int>[3, 5, 10, 20];

  // Hardcoded for demo: would normally trigger parent widget's setState
  @override
  final void Function(int?)? pageSizeChangeCallback = null;

  // Hardcoded for demo: would normally trigger parent widget's setState
  // to update currentPage and fetch new data
  @override
  final void Function(int)? pageChangeRequest = null;

  PaginatedProductTable({super.key}) :
    super.perBreakpoint(
      // In a real implementation, this would be a slice of the full dataset
      // based on currentPage and pageSize, e.g.:
      // rows.skip((currentPage - 1) * pageSize).take(pageSize).toList()
      rows: _sampleProducts.skip(3).take(3).toList(), // Simulating page 2
      xsColumns: BreakpointBasedTable.xsColumns,
      mdColumns: BreakpointBasedTable.mdColumns,
      lgColumns: BreakpointBasedTable.lgColumns,
      suffixColumn: BreakpointTableColumn.actions,
      noRowsText: 'No product available',
    );

  @override
  Widget buildCell(
    Product row,
    BreakpointTableColumn col,
    BuildContext context,
  ) {
    return BreakpointBasedTable.gBuildCell(row, col, context);
  }
}

// ============================================================================
// Main view that demonstrates all table approaches
// ============================================================================

class TableExampleView extends StatelessWidget with TGridBreakpointAware {
  const TableExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    String currentBreakpoint = getBreakpoint(context).name;

    return TCommonScaffold(
      title: 'Table showcase',
      // Show current breakpoint
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
        // Example 1: Threshold-based columns
        SelectableText(
          'TResponsiveTable (columns x threshold)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ThresholdBasedTable(),

        // Example 2: Per-breakpoint columns with suffix
        SelectableText(
          'TResponsiveTable (threshold x columns)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        BreakpointBasedTable(onEditPressed: () {}, onDeletePressed: () {}),

        // Example 3: Paginated table
        SelectableText(
          'PaginatedTable (with hardcoded pagination)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        PaginatedProductTable(),
      ],
    );
  }
}
