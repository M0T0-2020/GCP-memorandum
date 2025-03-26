import logging

import flask
import functions_framework
from flask.typing import ResponseReturnValue
from google.cloud.logging import Client

logging_client = Client()
logging_client.setup_logging(log_level=logging.DEBUG)


def raise_error_func():
    logging.info("This is a dummy function.")
    print(1/0)

@functions_framework.http
def compute_logger_test(request: flask.Request) -> ResponseReturnValue:
    logging.info("Hello, world!")
    logging.debug("This is a debug message.")
    logging.error("This is an error message.")
    logging.warning("This is a warning message.")
    logging.debug("This is a debug message.")
    raise_error_func()
    return "Hello, world!"
