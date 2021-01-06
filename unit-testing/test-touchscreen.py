
import os
import evdev

os.putenv('TSLIB_CONFFILE', '/etc/ts.conf')
os.putenv('TSLIB_CALIBFILE', '/etc/pointercal')
os.putenv('TSLIB_FBDEVICE', '/dev/fb0')
os.putenv('TSLIB_TSDEVICE', '/dev/input/event1')

TDev = False
#print("Looking for touch screen...")

devices = [evdev.InputDevice(fn) for fn in evdev.list_devices()]
for device in devices:
	#print(device.name)
	if device.name=="stmpe-ts":
		TDev = device

if not TDev:
	print("No touchscreen found.")
	quit()

#print("Found " + TDev.name + " on "+TDev.fn)

mx=-1
my=-1
mp=-1
for event in TDev.read_loop():
	if event.type == evdev.ecodes.EV_ABS:
		if event.code == 0:
			mx = event.value
		elif event.code == 1:
			my = event.value
		elif event.code == 24:
			mp = event.value
	print("X : " + str(mx) + "   Y : " + str(my) + "   Pressure : " + str(mp))

