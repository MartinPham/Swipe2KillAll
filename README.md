Swipe 2 Kill All
=====
A Little iOS tweak, allow swiping Homescreen card in AppSwitcher to kill all apps. Support iOS 10

1) Install

Add Cydia repo http://martinpham.gitlab.io/cydia then search Swipe 2 Kill All

or

Use [DEB file](/packages/com.martinpham.swipe2killall_0.0.1-3+debug_iphoneos-arm.deb) to install.

2) Build

``make package``

3) Build & Run

Change IP & Port of your device's SSH in ``Makefile`` file
``THEOS_DEVICE_IP = 127.0.0.1``
``THEOS_DEVICE_PORT = 2222``

``make package install``