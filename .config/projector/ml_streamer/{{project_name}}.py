#!/usr/bin/env python
import os
import numpy as np
import pandas as pd

from ai_streaming.model_streaming.ml_stremer import MLStreamer
from ai_streaming.model_streaming.decorators import with_model_builder
from ai_streaming.model_streaming.decorators import with_model_loader
import ai_streaming.model_streaming.utils as ut

class TestModel(MLStreamer):


    def __init__(self):
         MLStreamer.__init__(self, "{{project_name}}")
        

    def arg_setup(self, argumentar):
        argumentar.add_custom_files(['custom'])

    def file_loader_setup(self, loader, config):
        loader['custom'] = lambda x: pd.read_csv(x)
        
    def model_setup(self, config):
        print('Building model!')
        return None

    
    def model_load(self, files):
        print("Not supported!")
        exit(1)
        


    def load_data(self, config, files):
        print("Loading data!")
	return None

        
            
    def pipeline(self, config, model):
        print('Runnung inner pipeline')
        return dict()

    
    def train_model(self, config, data, model, pipeline):
        
        print('Fitting the tree')
                        
    
    def eval_model(self, config, data, model, pipeline):
	print('Evaluating the model')	
        
        

        
    def save_model(self, config, model, output):       
        pass
        
        


def main():
    TestModel().run()

if __name__ == '__main__':
    main()
