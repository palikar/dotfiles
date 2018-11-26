#!/bin/bash


if ! [ -d build_debug ]; then
    mkdir build_debug
fi


cd build_debug
cmake ..
cmake --build ./ -- -j4
cd ..
./build_debug/bin/{{main_file}} "$@"
