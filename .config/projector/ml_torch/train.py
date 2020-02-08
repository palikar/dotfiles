##!/usr/bin/env python
import os
import json
import sys
import math
import argparse
import random
import signal


from utils import mkdir, Logger
from dataloader import RootDataSet
from models import define_model, get_scheduler, update_learning_rate
from evaluate import Evaluator
from config import config

import numpy as np

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
from torch.utils.data.sampler import SubsetRandomSampler

from torchsummary import summary

if not sys.warnoptions:
    import warnings
    warnings.simplefilter("ignore")


training_started = False
STOP_TRAINING = False

def signal_handler(sig, frame):
    if not training_started:
        sys.exit(0)

    print('Stoping the training...')
    global STOP_TRAINING
    STOP_TRAINING = True


def create_directories():
    mkdir(config['output_dir'])
    mkdir(os.path.join(config['output_dir'], args.model_name))


def test_validation_test_split(dataset, test_train_split=0.8, val_train_split=0.1, shuffle=False):
    dataset_size = len(dataset)
    indices = list(range(dataset_size))
    test_split = int(np.floor(test_train_split * dataset_size))
    if shuffle:
        np.random.shuffle(indices)
    train_indices, test_indices = indices[:test_split], indices[test_split:]
    train_size = len(train_indices)
    validation_split = int(np.floor((1 - val_train_split) * train_size))
    train_indices, val_indices = train_indices[ : validation_split], train_indices[validation_split:]

    return train_indices, val_indices, test_indices


def save_models(net, args, epoch):
    net_model_out_path = "./{0}/{1}/net_{1}_model_epoch_{2}.pth".format(config['output_dir'], args.model_name, epoch)
    torch.save(net, net_model_out_path)


parser = argparse.ArgumentParser(description='The training script of the {{project_name}} pytorch implementation')
parser.add_argument('--data', dest='data_dir', required=True, help='Root directory of the generated data.')
parser.add_argument('--model-path', default=None, action='store', dest='model_path' , help='Optional path to the model\'s weights.')
parser.add_argument('--output-dir', dest='output_dir', default=None, help='The output directory for the model files')
parser.add_argument('--model-name', dest='model_name', default='s_res_8', required=False, help='Name of the current model being trained. res or unet')
parser.add_argument('--model-type', dest='model_type', action='store', default='c', choices=['c', 'vd', 's', 'o'], required=False, help='')
parser.add_argument('--cuda', dest='cuda', action='store_true', default=False, help='Should CUDA be used or not')
parser.add_argument('--threads', dest='threads', type=int, default=4, help='Number of threads for data loader to use')
parser.add_argument('--batch-size', dest='batch_size', type=int, default=4, help='Training batch size.')
parser.add_argument('--test-train-split', dest='test_train_split', type=float, default=0.8, help='The percentage of the data to be used in the training set.')
parser.add_argument('--val-train-split', dest='val_train_split', type=float, default=0.1, help='The percentage of the train data to be used as validation set')
parser.add_argument('--shuffle', dest='shuffle', default=False, action='store_true', help='Should the training and testing data be shufffled.')
parser.add_argument('--seed', dest='seed', type=int, default=123, help='Random seed to use. Default=123')
parser.add_argument('--niter', type=int, dest='niter', default=100, help='Number of iterations at starting learning rate')
parser.add_argument('--epochs', dest='epochs', type=int, default=5, help='Number of epochs for which the model will be trained')
parser.add_argument('--niter_decay', type=int, dest='niter_decay', default=100, help='Number of iterations to linearly decay learning rate to zero')
parser.add_argument('--lr_policy', type=str, default='lambda', help='learning rate policy: lambda|step|plateau|cosine')
parser.add_argument('--print-summeries', dest='print_summeries', default=False, action='store_true', help='Print summeries of the genereated networks')
parser.add_argument('--evaluate', default=False, action='store_true', dest='evaluate' , help='Evaluate the trained model at the end')
parser.add_argument('--no-train', default=False, action='store_true', dest='no_train' , help='Do not train the model with the trianing data')
parser.add_argument('--nfg', type=int, dest='g_nfg', default=-1, help='Number of feature maps in the first layers of ResNet')
parser.add_argument('--layers', type=int, dest='g_layers', default=-1, help='ResNet blocks in the middle of the network')
parser.add_argument('--output_nc', type=int, dest='g_output_nc', default=-1, help='Number of output channels of the genrator network')
parser.add_argument('--input_nc', type=int, dest='g_input_nc', default=-1, help='Number of input channels of the genrator network')

args = parser.parse_args()

if args.g_layers != -1: config['layers'] = args.g_layers
if args.g_nfg != -1: config['nfg'] = args.g_nfg
if args.g_input_nc != -1: config['input_nc'] = args.g_input_nc
if args.g_output_nc != -1: config['output_nc'] = args.g_output_nc
if args.output_dir is not None: config['output_dir'] = args.output_dir

args.model_name = '{}_{}_l{}_ngf{}'.format(args.model_type, args.model_name, config['layers'], config['nfg'])

create_directories()

sys.stdout = Logger(os.path.join(config['output_dir'], 'log.txt'))

print('===> Setting up basic structures ')

if args.cuda and not torch.cuda.is_available():
    raise Exception("No GPU found, please run without --cuda")

random_seed = args.seed
np.random.seed(random_seed)
torch.manual_seed(random_seed)
random.seed(random_seed)

if args.cuda:
    torch.cuda.manual_seed(random_seed)

device = torch.device("cuda:0" if args.cuda else "cpu")
# if torch.cuda.device_count() > 1:
#     device = torch.device("cuda")

if not args.no_train: signal.signal(signal.SIGINT, signal_handler)

model_type = args.model_type
test_train_split = args.test_train_split
val_train_split = args.val_train_split
batch_size = args.batch_size
shuffle_dataset = args.shuffle
num_epochs = args.epochs
threads = args.threads
model_name = args.model_name


print('--Model name:', args.model_name)
print('--model type:', model_type)
print('--test-train split:', test_train_split)
print('--val-train split:', val_train_split)
print('--batch size:', batch_size)
print('--shuffle dataset:', shuffle_dataset)
print('--num epochs:', num_epochs)
print('--learning rate policiy:', args.lr_policy)
print('--random seed:', random_seed)
print('--worker threads:', threads)
print('--cuda:', args.cuda)
print('--device:', device)
print('--gen. input channels:', config['input_nc'])
print('--gen. output channels:', config['output_nc'])
print('--desc. input channels:', config['input_nc'])


print('===> Loading datasets')

dataset = RootDataSet()

train_indices, val_indices, test_indices = test_validation_test_split(dataset, shuffle=shuffle_dataset,
                                                                      test_train_split=args.test_train_split,
                                                                      val_train_split=args.val_train_split)

train_sampler = SubsetRandomSampler(train_indices)
val_sampler = SubsetRandomSampler(val_indices)
test_sampler = SubsetRandomSampler(test_indices)

train_loader = DataLoader(dataset, batch_size=batch_size, sampler=train_sampler, shuffle=False, num_workers=threads)
val_loader = DataLoader(dataset, batch_size=batch_size, sampler=val_sampler, shuffle=False, num_workers=threads)
test_loader = DataLoader(dataset, batch_size=batch_size, sampler=test_sampler, shuffle=False, num_workers=threads)

print('--training samples count:', len(train_indices))
print('--validation samples count:', len(val_indices))
print('--test samples count:', len(test_indices))

print('===> Loading model')


net = define_model(config['input_nc'], config['output_nc'], config['nfg'], n_blocks=config['layers'], gpu_id=device, args=args).float()

# if torch.cuda.device_count() > 1:
#   print("--using", torch.cuda.device_count(), "GPUs")
#   net = nn.DataParallel(net)
# net.to(device)
# net_g.to(device)


optimizer = optim.Adam(net.parameters(), lr=config['adam_lr'], betas=(config['adam_b1'], config['adam_b2']))
net_scheduler = get_scheduler(optimizer, args)

criterionL1 = nn.L1Loss().to(device)
criterionMSE = nn.MSELoss().to(device)

if args.print_summeries:
    print('===> Generator network:')
    summary(net, (config['input_nc'], 1, 1))


train_loader_len = len(train_loader)
losses_path = os.path.join(config['output_dir'], 'losses.txt')
val_losses_path = os.path.join(config['output_dir'], 'val_losses_test.txt')

if not args.no_train:
    print('===> Starting the training loop')

training_started = True

for epoch in range(num_epochs if not args.no_train else 0):
    epoch_loss = 0
    
    iteration = 1
    for batch in train_loader:

        net.train()
        optimizer.zero_grad()
        
        x, label = batch[0].to(device).float(), batch[1].to(device).float()
        pred = net(x)
        loss = criterionL1(label, pred)
        optimizer.step()

        print("> Epoch[{}]({}/{}): Loss: {:.5f}".format(epoch, iteration, train_loader_len, loss.item()))
        iteration += 1
        
        if STOP_TRAINING:
            print('> Saving the model now...')
            save_models(net, args, epoch)
            print('> Model saved.')
            sys.exit(0)

    
    update_learning_rate(net_scheduler, optimizer)
    epoch_loss /= train_loader_len

    with open(losses_path, 'a') as losses_hand:
        losses_hand.write('epoch: {}, net:{:.5f}\n'.format(epoch, epoch_loss))

    if epoch % 10  == 0:
        save_models(net, args, epoch)
        print("> Checkpoint saved to {}".format(os.path.join("checkpoints", args.model_name)))

    if epoch % 5  == 0:
        avg_psnr = 0
        avg_mse = 0
        with torch.no_grad():
            for batch in val_loader:

                x, label = batch[0].to(device).float(), batch[1].to(device).float()
                pred = net(x)

                mse = criterionMSE(pred, label)
                psnr = 10 * math.log10(1 / mse.item())
                avg_mse += mse
            avg_mse /= len(val_loader)

            print("> Val Avg. MSE: {:.5} ".format(avg_mse))
            with open(val_losses_path, 'a') as losses_hand:
                losses_hand.write('epoch:{}, mse:{:.5f}\n'.format(epoch, avg_mse))




save_models(net, args, num_epochs)
print("> Checkpoint saved to {}".format(os.path.join("checkpoints", args.model_name)))
training_started = False


evaluator = Evaluator(args, config['output_dir'], device=device)
if args.evaluate:
    print('===> Evaluating model')
    net.eval()
    with torch.no_grad():
        pass
