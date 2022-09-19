__version__ = '1.0.0'
from .client import *
from .funcs import *

import logging

logger = logging.getLogger(__name__)
logger.addHandler(logging.NullHandler())
