# Structured Logging Documentation

This module provides structured logging capabilities that allow you to output either human-readable 
logs or JSON-formatted structured logs. These features are especially useful for debugging in 
development and for generating easily parseable logs in production environments.

## Overview

The logging setup supports two main modes:

1. **Human-readable logs**: Provides logs in a colored, properly formatted output for local development.
2. **Structured logs**: Outputs logs as JSON objects, with each log record represented as a single line. This mode is ideal for production environments where logs need to be processed by log aggregation systems.

### Key Functions

- `add_logging_args()`: Adds logging configuration options to an `argparse.ArgumentParser` instance, making it easy to configure logging via command-line arguments.
- `setup()`: Directly configures logging by specifying the logging level and format (structured or human-readable).
- `set_context()`: Assigns a custom context to be logged with each message in structured logging mode.
- `log_multipart()`: Logs large messages by splitting them into chunks and compressing the data.

---

## Usage

### Basic Setup with `setup()`

To initialize logging in your application, call the `setup()` function. You can specify whether to enable structured logging or use the default human-readable format.

```python
from my_logging_module import setup

# Initialize logging
setup(level="INFO", structured=False)  # Human-readable format

# Enable structured logging for production
setup(level="INFO", structured=True)
```

#### Parameters for `setup()`

- `level`: The logging level (e.g., "DEBUG", "INFO", "WARNING", "ERROR"). This can be a string or an integer.
- `structured`: A boolean that controls whether structured logging is enabled. Set to `True` for JSON logs.
- `allow_trailing_dot`: Prevents log messages from having a trailing dot unless explicitly allowed.
- `level_from_msg`: An optional function to dynamically change the logging level based on the content of the message.
- `ensure_utf8_streams`: Ensures that `stdout` and `stderr` use UTF-8 encoding.

### Adding Logging Arguments with `add_logging_args()`

You can easily integrate logging configuration options into your command-line interface using `add_logging_args()`. This function automatically adds command-line flags for setting the logging level and format.

#### Command-Line Flags

- `--log-level`: Set the logging verbosity (e.g., "DEBUG", "INFO", "WARNING").
- `--log-structured`: Enable structured logging (outputs logs in JSON format).

#### Environment Variables

You can also set the logging level and format using environment variables:

- `LOG_LEVEL`: Set the logging level.
- `LOG_STRUCTURED`: Enable structured logging.

```bash
LOG_LEVEL=DEBUG LOG_STRUCTURED=1 python my_app.py
```

### Structured Logging in Production

To enable structured logging (JSON logs), you can either set the `--log-structured` flag when running your application or configure it programmatically using `setup()`:

```bash
python my_app.py --log-level DEBUG --log-structured
```

In structured logging mode, each log entry is a JSON object with the following fields:

- `level`: The log level (e.g., "info", "error").
- `msg`: The log message.
- `source`: The file and line number where the log occurred.
- `time`: The timestamp of the log event.
- `thread`: The thread ID in a shortened format.
- `name`: The logger name.

Example structured log output:

```json
{
  "level": "info",
  "msg": "Application started",
  "source": "app.py:42",
  "time": "2023-09-23T14:22:35.000+00:00",
  "thread": "f47c",
  "name": "my_app"
}
```

### Custom Context with `set_context()`

In structured logging mode, you can attach additional context to each log message by calling `set_context()`. This context is logged alongside the usual fields, allowing you to track custom metadata.

```python
from my_logging_module import set_context

# Set custom context
set_context({"user_id": "12345", "transaction_id": "abcde"})

# The custom context will now appear in each structured log message
```

### Handling Large Log Messages with `log_multipart()`

When logging large messages (e.g., serialized data or files), the `log_multipart()` function compresses and splits the message into smaller chunks to prevent issues with log size limits.

```python
from my_logging_module import log_multipart

# Log a large message
log_multipart(logging.getLogger(), b"Large data to be logged")
```

This function will automatically split the message and log each chunk, ensuring the entire message is captured.

---

## Customizing the Logging Format

### Human-Readable Logs

By default, when not using structured logging, logs are output in a colored format, with color-coding based on the log level:

- **DEBUG**: Gray
- **INFO**: Cyan
- **WARNING**: Yellow
- **ERROR/CRITICAL**: Red

You can further customize the format by modifying the `AwesomeFormatter` class, which is used for formatting logs in human-readable mode. It also shortens thread IDs for easier readability.

### Enforcing Logging Standards

To enforce standards in your logging messages, such as preventing trailing dots in log messages, the module provides the `check_trailing_dot()` decorator. This can be applied to logging functions to raise an error if a message ends with a dot:

```python
from my_logging_module import check_trailing_dot

@check_trailing_dot
def log_message(record):
    # Your custom logging logic
    pass
```

---

## Best Practices

- Use **human-readable logs** in development for easier debugging.
- Switch to **structured logging** in production to enable easier parsing and aggregation by log management tools.
- **Set custom contexts** to include additional metadata in your logs, such as user IDs or request IDs, to improve traceability in production.
- **Use multipart logging** to handle large log messages that might otherwise exceed log size limits.

---

## Example

Here's a full example of how to use structured logging with command-line configuration:

```python
import argparse
import logging
from flogging import add_logging_args, set_context, setup

# Initialize logging
setup(level="INFO", structured=False)  # Human-readable format
# Create argument parser
parser = argparse.ArgumentParser(description="My Application")
add_logging_args(parser)

# Parse arguments and setup logging
args = parser.parse_args()

# Set additional context for structured logging
set_context({"request_id": "123abc"})

# Start logging messages
logger = logging.getLogger("my_app")
logger.info("Application started")
```

