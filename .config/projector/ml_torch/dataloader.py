import os

import numpy as np

import torch
import torch.utils.data as data
import torchvision.transforms as transforms
from torch.utils.data import DataLoader

from utils import load_img
from config import config



class RootDataSet(data.Dataset):

    def __init__(self):
        self.data = np.array([[1.0]]*1000)

        transform_list = []
        self.transform = transforms.Compose(transform_list)

    
    def __getitem__(self, index):
        return self.transform(self.data[index]), self.transform(self.data[index])


    def __len__(self):
        return len(self.data)
