import os
import json
import sys
import math
import argparse
import random

import torch
import torch.nn as nn
import numpy as np

from utils import mkdir
from utils import correlation
from utils import merge_and_save
from utils import RedirectStdStreams
from utils import mkdir
from utils import save_img
from utils import UnNormalize
from config import config

try:
    from skimage.metrics import structural_similarity as ssim_metr
except ImportError:
    def ssim_metr(*args, **kargs):
        return 0.3



class Evaluator:

    def __init__(self, args, root_dir, device='cpu'):
        self.args = args
        self.root_dir = root_dir
        self.device = device
