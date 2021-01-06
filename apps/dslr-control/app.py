#!/bin/env python3

import os
import pygame
from pygame.locals import *
from time import sleep

import RPi.GPIO as GPIO
from os.path import exists

pin1 = 23
pin2 = 22
pin3 = 27
#pin3 = 21
pin4 = 18

bouncetime = 200

#GPIO.setmode(GPIO.BOARD)
GPIO.setmode(GPIO.BCM)

#GPIO.cleanup()

GPIO.setup(pin1, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(pin2, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(pin3, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(pin4, GPIO.IN, pull_up_down=GPIO.PUD_UP)


# add callback functins here.
def test_btn_press(channel):
    print('button pressed')


def initialize_gpio():
    # declare event outside of loop
    GPIO.add_event_detect(pin1,
            GPIO.FALLING,
            callback=test_btn_press,
            bouncetime=bouncetime
            )
    
    GPIO.add_event_detect(pin2,
            GPIO.FALLING,
            callback=test_btn_press,
            bouncetime=bouncetime
            )
    
    GPIO.add_event_detect(pin3,
            GPIO.FALLING,
            callback=test_btn_press,
            bouncetime=bouncetime
            )
    
    GPIO.add_event_detect(pin4,
            GPIO.FALLING,
            callback=test_btn_press,
            bouncetime=bouncetime
            )
    

#GPIO.cleanup()


def setupBacklight():
    try:
        with open("/sys/class/gpio/export", "w") as bfile:
            bfile.write("252")
    except:
        return False

    try:
        with open("/sys/class/gpio/gpio252/direction", "w") as bfile:
            bfile.write("out")
    except:
        return False

    return True

def Backlight(light):
    try:
        with open("/sys/class/gpio/gpio252/value", "w") as bfile:
            bfile.write("%d" % (bool(light)))
    except:
        pass



def event_watcher():
    while True:
        for event in pygame.event.get():
            if(event.type is MOUSEBUTTONUP):
                #if(pygame.mouse.get_pressed()[0]):
                print(pygame.mouse.get_pos())
                break

        #sleep(0.5)

####
os.putenv('SDL_VIDEODRIVER', 'fbcon')
os.putenv('SDL_FBDEV'      , '/dev/fb1')
os.putenv('SDL_MOUSEDRV'   , 'TSLIB')
os.putenv('SDL_MOUSEDEV'   , '/dev/input/touchscreen')
os.putenv('TSLIB_CALIBFILE'   , '/etc/pointercal')
os.putenv('TSLIB_TSDEVICE'   , '/dev/input/event1')

# Init pygame and screen
pygame.init()
pygame.mouse.set_visible(True)
#pygame.mouse.set_cursor((8,8),(0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0))

size = width, height = 320, 240
screen = pygame.display.set_mode(size, pygame.FULLSCREEN)
#screen = pygame.display.set_mode((0,0), pygame.FULLSCREEN)

initialize_gpio()

try:
    #while True:
    event_watcher()
        #sleep(0.5)
except KeyboardInterrupt:
    pass

print("end")
