import os
import time

from joblib import Parallel, delayed


def process_something(id: int, message: str):
    n = min(id, 10)
    for k in range(n):
        print(f"id{n}: {message} {k}th")
        time.sleep(1)
    return message


def do_job(message: str, number: int):
    results = Parallel(n_jobs=-1)(
        delayed(process_something)(id, message) for id in range(number)
    )
    return list(results)


if __name__ == "__main__":
    message = os.getenv("MESSAGE")
    number = int(os.getenv("NUMBER"))
    messages = do_job(message, number)
