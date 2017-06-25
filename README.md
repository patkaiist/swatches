# Swatches

[(点击这里阅读中文版本)](https://github.com/keyilan/swatches/blob/master/README_zh.md)

Swatches is a colour palette utility for getting variations.

To use Swatches, type or paste a hexadecimal colour code into the text entry, with or without a hash mark. You'll then be given two columns of colours. The left column offers changes in luminence only, while the right column gives difference in brightness.

## Features

* One-click copying from any of the colour swatches
* Quickly switch between RGB and hexadecimal colour values
* Remembers your preference for hex or rgb between uses
* Remembers the last colour you checked when reloading the app
* Toggle relative luminance adjustment
* Toggle visibility of labels

## Screenshots

![screenshot](/data/screenshot.png?raw=true)

## Installation

First, make sure you've instlled the elementary OS SDK

````
sudo apt install elementary-sdk
````

Clone the repository

````
git clone https://github.com/keyilan/swatches
cd swatches
````

Build and install

````
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
sudo make install
````

## To do
* User control over how many steps to show
