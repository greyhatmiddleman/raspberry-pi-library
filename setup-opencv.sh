#!/bin/bash

# source for this script: https://www.pyimagesearch.com/2019/09/16/install-opencv-4-on-raspberry-pi-4-and-raspbian-buster/

GETPKG="sudo apt install -y"

up-packages () {
sudo apt update
sudo apt upgrade -y

$GETPKG build-essential cmake pkg-config
}


image_io_packages () {
	$GETPKG libjpeg-dev libtiff5-dev libjasper-dev libpng-dev
	$GETPKG libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
	$GETPKG libxvidcore-dev libx264-dev
}

display_packages () {
	$GETPKG libfontconfig1-dev libcairo2-dev
	$GETPKG libgdk-pixbuf2.0-dev libpango1.0-dev
	$GETPKG libgtk2.0-dev libgtk-3-dev
}


matrix_packages () {
	$GETPKG libatlas-base-dev gfortran
}

hdf5_qtgui () {
	$GETPKG libhdf5-dev libhdf5-serial-dev libhdf5-103
	$GETPKG libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5
}

python_headers () {
	$GETPKG python3-dev
}

python_modules () {
	sudo pip3 install virtualenv virtualenvwrapper

cat << 'EOF'>> ~/.bashrc
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
EOF

	source ~/.bashrc
	cd ~
	mkvirtualenv cv -p python3

	pip3 install picamera[array]
}

simple_opencv () {
	pip3 install opencv-contrib-python==4.1.0.25
}

increase_dphys_swap () {
	sudo sed -i 's/^CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile stop
	sudo /etc/init.d/dphys-swapfile start
}

prep_compile_opencv () {
	cd ~
	wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.1.zip
	wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.1.zip
	unzip opencv.zip
	unzip opencv_contrib.zip
	mv opencv-4.1.1 opencv
	mv opencv_contrib-4.1.1 opencv_contrib
}

dep_opencv () {
workon cv
pip install numpy
}

config_opencv () {
# notes:
# if using with pi zero, delete lines with NEON and VFPV

cd ~/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D CMAKE_SHARED_LINKER_FLAGS=-latomic \
    -D BUILD_EXAMPLES=OFF ..
}

compile_opencv () {
	make -j4
	sudo make install
	sudo ldconfig
}

restore_dphys_swap () {
	sudo sed -i 's/^CONF_SWAPSIZE=2048/CONF_SWAPSIZE=100/' /etc/dphys-swapfile
	sudo /etc/init.d/dphys-swapfile stop
	sudo /etc/init.d/dphys-swapfile start
}

symlink_opencv () {
cd /usr/local/lib/python3.7/site-packages/cv2/python-3.7
sudo mv cv2.cpython-37m-arm-linux-gnueabihf.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.7/site-packages/
ln -s /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.so cv2.so
}

unit_test () {
cd ~
workon cv
python -c "import cv2 ;  print(cv2.__version__)"
}


up-packages

image_io_packages
display_packages
matrix_packages
hdf5_qtgui
python_headers
python_modules

##simple_opencv

increase_dphys_swap

prep_compile_opencv
dep_opencv
config_opencv
compile_opencv

restore_dphys_swap

symlink_opencv
##unit_test


