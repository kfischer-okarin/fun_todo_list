# Fun Todo List

## How To

### Automatically run unit tests on change
- Ruby needs to be installed
- Install the Gemfile with `bundle install`
- Run guard with `guard`

### Run Integration Tests

```sh
flutter drive --driver=./test_driver/integration_test.dart ./integration_test/*_test.dart -d <DEVICE_ID>
```

Can also be definded as a test task in VS Code:

```json
{
  "label": "Integration Tests",
  "type": "shell",
  "command": "flutter drive --driver=./test_driver/integration_test.dart ./integration_test/*_test.dart -d <DEVICE_ID>",
  "group": "test"
}
```
