# Dino Refactor

## Project Description
Dino Refactor is a Ruby project designed to demonstrate object-oriented programming principles through a dinosaur-themed application. The project focuses on refactoring existing code to improve readability, maintainability, and test coverage.

## Features
- Object-oriented design with classes representing dinosaurs and their behaviors.
- Comprehensive test suite using RSpec.
- Code coverage analysis with SimpleCov.

## Running Tests

This project uses [RSpec](https://rspec.info/) for testing. To run the test suite:

1. Make sure you have Bundler installed:
   ```
   gem install bundler
   ```

2.	Install project dependencies:
    ```
    bundle install
    ```

3.	Run the test suite with:
    ```
    bundle exec rspec
    ```

You can add --format documentation for more readable output:
```
bundle exec rspec --format documentation
```

The tests are located in the spec/ directory. Running them will also generate a coverage report if [SimpleCo](https://github.com/simplecov-ruby/simplecov) is enabled.

## Code Coverage with SimpleCov
This project uses SimpleCov to measure test coverage. To generate a coverage report, run the tests normally. After the test suite completes, open the `coverage/index.html` file in your browser to view detailed coverage statistics.
