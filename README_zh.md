# 色板

色板（Swatches）是选颜色工具。输入十六进制或 RGB（红绿蓝）的颜色代码，彩色样片返回许多浓淡。

## 功能

* 一键复制
* 快速 RGB / 十六进制的切换
* APP每次会记得您设定
* 重装的时，还有以前输入的颜色代码
* 切换打算亮度的方式
* 切换标签的可见性
* 包括中文本地化（简体和繁體）

## 截图

![截图](/data/screenshot.png?raw=true)

## 安装

1. 下载 elementary OS 的软件开发套件：

````
sudo apt install elementary-sdk
````

2. 把 git 项目拷贝下来：

````
git clone https://github.com/keyilan/swatches
cd swatches
````

3. 编译和安装软件:

````
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
sudo make install
````
