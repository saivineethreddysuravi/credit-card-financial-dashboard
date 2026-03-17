import logging
import time

def setup_telemetry(module_name):
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    return logging.getLogger(module_name)

def log_transaction_latency(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        duration = time.time() - start_time
        logging.info(f"Transaction monitoring: {func.__name__} executed in {duration:.4f}s")
        return result
    return wrapper
