# Swatches

Swatches is a colour palette utility for getting variations.

To use Swatches, type or paste a hexadecimal colour code into the text entry, with or without a hash mark. You'll then be given two columns of colours. The left column offers changes in luminence only, while the right column gives difference in brightness.

To copy any of the colours to your clipboard, simply click on the desired shade.

## Screenshot

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
