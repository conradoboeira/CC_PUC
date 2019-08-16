#!/bin/bash
g++ -c -std=c++11 src/Cache_direta.cpp
g++ -c -std=c++11 src/Cache_conjunto_assoc.cpp
g++ -c -std=c++11 -I $PWD/headers src/App.cpp
g++ -std=c++11 -o Memoria_Cache App.o Cache_conjunto_assoc.o Cache_direta.o
