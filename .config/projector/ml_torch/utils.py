#!/usr/bin/env python
import os
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont




VERDANA_FONT = ImageFont.truetype("verdana.ttf", 16)

class RedirectStdStreams(object):
    def __init__(self, stdout=None, stderr=None):
        self._stdout = stdout or sys.stdout
        self._stderr = stderr or sys.stderr

    def __enter__(self):
        self.old_stdout, self.old_stderr = sys.stdout, sys.stderr
        self.old_stdout.flush(); self.old_stderr.flush()
        sys.stdout, sys.stderr = self._stdout, self._stderr

    def __exit__(self, exc_type, exc_value, traceback):
        self._stdout.flush(); self._stderr.flush()
        sys.stdout = self.old_stdout
        sys.stderr = self.old_stderr


class Logger(object):
    def __init__(self, log_file):
        self.terminal = sys.stdout
        self.log = open(log_file, "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def flush(self):
        self.terminal.flush()
        self.log.flush()


class UnNormalize(object):

    def __init__(self, mean, std):
        self.mean = mean
        self.std = std

    def __call__(self, tensor):
        for t, m, s in zip(tensor, self.mean, self.std):
            t.mul_(s).add_(m)
        return tensor


def is_image_file(filename):
    return any(filename.endswith(extension) for extension in [".png", ".jpg", ".jpeg"])


def load_img(filepath, size=(1024, 256)):
    img = Image.open(filepath).convert("L")
    img = img.resize(size, Image.BICUBIC)

    arr = np.expand_dims(np.array(img), 2)
    
    return arr


def save_img(image_tensor, filename):
    image_numpy = image_tensor.float().numpy()
    image_numpy = (np.transpose(image_numpy, (1, 2, 0)) + 1) / 2.0 * 255.0
    image_numpy = image_numpy.clip(0, 255)
    image_numpy = image_numpy.astype(np.uint8)
    image_numpy = np.squeeze(image_numpy)
    image_pil = Image.fromarray(image_numpy)
    image_pil.save(filename)
    print("Image saved as {}".format(filename))


def mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)

        
def mkdirs(paths):
    if isinstance(paths, list) and not isinstance(paths, str):
        for path in paths:
            mkdir(path)
    else:
        mkdir(paths)


def correlation(img1, img2):
    c = np.corrcoef(img1.flat, img2.flat)[0,1]
    return c


def merge_and_save(img1, img2, text1, text2, dest, mode='L'):
    image_1 = Image.fromarray(np.uint8(np.squeeze(img1)))
    image_2 = Image.fromarray(np.uint8(np.squeeze(img2)))

    width_1, height_1 = image_1.size
    width_2, height_2 = image_2.size

    new_im = Image.new('RGB', (max(width_1, width_2), height_1 + height_2))
    new_im.paste(image_1, (0, 0))
    new_im.paste(image_2, (0, height_1))

    draw = ImageDraw.Draw(new_im) 
    draw.line((0,height_1,width_1,height_2), fill=0, width=2)
    draw.text((10,10), text1, (0,0,0), font=VERDANA_FONT)
    draw.text((10,10 + height_1), text2, (0,0,0), font=VERDANA_FONT)
    
    new_im.save(dest)


def save_img(img, text, dest, mode='L'):
    image = Image.fromarray(np.uint8(np.squeeze(img))).convert('L')

    width, height = image.size

    draw = ImageDraw.Draw(image) 
    draw.text((10,10), text, (0), font=VERDANA_FONT)

    image.save(dest)


    
    
