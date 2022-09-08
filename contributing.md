# Contributing

😍 Thank you for contributing to **`Dart Runner Bot`**! 😍

## Philosophy

I aim to make Dart Runner Bot as fast, robust, secure and reliable as possible, while also allowing for extensive customization.

If you spot anywhere that I could trim some expense and improve performance, or add new functionality, I will gladly accept new issues or PRs! 😄

## Linting

Dart Runner Bot source files are linted with [lints](https://pub.dev/packages/lints). I recommend you to add this dependency in your pubspec.yaml & use it at all times.

```yaml
dev_dependencies:
  lints: ^[latest version] # for e.g. ^2.0.0
```

## Formatting

World's Best Dad source files are formatted with Dart's Default Code Formatter, see [Formatting Documentation](https://dart.dev/guides/language/formatting) for more info.

## Git/GitHub workflow

This is my preferred process for opening a PR on GitHub:

1. Fork this repository
2. Create a branch off of `master` for your work: `git checkout -b my-feature-branch`
3. Make some changes, committing them along the way
4. When your changes are ready for review, push your branch: `git push origin my-feature-branch`
5. Create a pull request from your branch to `Dart-Runner-Bot/master`
6. No need to assign the pull request to me, I'll review it when I can
7. When the changes have been reviewed and approved, I will squash and merge for you
