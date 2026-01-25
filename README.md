# rubocop-spec_structure

[![CI](https://github.com/mensfeld/rubocop-spec_structure/actions/workflows/ci.yml/badge.svg)](https://github.com/mensfeld/rubocop-spec_structure/actions/workflows/ci.yml)

RuboCop plugin to enforce spec file structure conventions. Ensures that source files have corresponding spec files and vice versa.

## Installation

Add to your `Gemfile`:

```ruby
gem 'rubocop-spec_structure'
```

## Usage

Add to your `.rubocop.yml`:

```yaml
plugins:
  - rubocop-spec_structure
```

## Cops

### SpecStructure/SpecFileExists

Checks that source files in configured directories have corresponding spec files.

For a file `lib/foo/bar.rb`, expects `spec/lib/foo/bar_spec.rb` to exist.

**Configuration:**

```yaml
SpecStructure/SpecFileExists:
  Enabled: true
  SourceDirectories:
    - lib
    - app
  SpecDirectory: spec
  Exclude: []
```

### SpecStructure/SourceFileExists

Checks that spec files have corresponding source files (detects orphan specs).

For a file `spec/lib/foo/bar_spec.rb`, expects `lib/foo/bar.rb` to exist.

**Configuration:**

```yaml
SpecStructure/SourceFileExists:
  Enabled: true
  SourceDirectories:
    - lib
    - app
  SpecDirectory: spec
  Exclude: []
```

## Example Configuration

```yaml
plugins:
  - rubocop-spec_structure

# Exclude files that intentionally don't have specs
SpecStructure/SpecFileExists:
  Exclude:
    - lib/my_gem/version.rb
    - lib/my_gem/railtie.rb

# Exclude support files and integration specs
SpecStructure/SourceFileExists:
  Exclude:
    - spec/support/**/*
    - spec/integrations/**/*
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt) for details.
