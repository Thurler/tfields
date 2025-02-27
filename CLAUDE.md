# tfields - Thurler Flutter Fields and Widgets

## Commands
- Build: `flutter build`
- Run app: `flutter run`
- Format code: `dartformat .` (custom formatter, not standard `dart format`)
- Lint: `flutter analyze`
- Run tests: `flutter test`
- Run single test: `flutter test example/test/widget_test.dart`

## Code Style
- **Imports**: Always use package imports (`always_use_package_imports: true`)
- **Formatting**: 80 character line limit, use single quotes
- **Types**: Always specify types (`always_specify_types: true`)
- **Variables**: Local variables should NOT be marked as final (`unnecessary_final`)
- **Naming**: Use camelCase for variables, PascalCase for classes
- **Error handling**: Handle exceptions with try/catch, validate form inputs
- **Forms**: Use TForm pattern for form fields, always call validate() on value changes
- **Comments**: Use /// for documentation comments
- **Trailing commas**: Required for multi-line parameters (`require_trailing_commas: true`)
- **Classes**: Put required named parameters first