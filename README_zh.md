# Swatches

色板（Swatches）是选颜色工具。输入十六进制或 RGB（红绿蓝）的颜色代码，彩色样片返回许多浓淡。

## Features

* One-click copying from any of the colour swatches
* Quickly switch between RGB and hexadecimal colour values
* Remembers your preference for hex or rgb between uses
* Remembers the last colour you checked when reloading the app
* Toggle relative luminance adjustment
* Toggle visibility of labels
* 包括中文本地化（简体和繁體）

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
