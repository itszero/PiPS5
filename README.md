# PiPS5

![Screenshot](https://raw.githubusercontent.com/itszero/pips5/master/pips5.png)

Make sharing your PS5 screenshots and video clips just a little bit easier.

The code is provided as-is and no support will be provided.

# Requirements

- RaspberryPi Zero W
- Understand how [teslausb](https://github.com/cimryan/teslausb) works

# How does it work?

Raspberry Pi can emulate USB gadgets so we emulate it as a USB mass storage device that PS5 can write into and than we start a web server which provide you UI to access into the content of that emulated storage.

While the access is enabled on the Web UI, the storage will be unmounted from PS5. You will need to lock it again for it to be usable on PS5.

# Setup

I might have missed some steps here...

From a computer:

- run `yarn; yarn build` in the repo
- copy the repo into the sd card (to the root of your raspberry pi OS rootfs at /pips5)

From the raspberry pi:

- Setup USB gadget mode (add `dtoverlay=dwc2` to `/boot/config`, add `dwc2` and `g_mass_storage` to `/etc/modules`)
- Install nginx, supervisor, avahi-daemon, ruby
- Change its hostname to pips5 (this allows it to be reachable via pips5.local)
- copy `supervisord.conf` to `/etc/supervisord/conf.d/pips5.conf`
- copy `nginx.conf` to `/etc/nginx/sites-available/default`
- add `fstab` to `/etc/fstab`
- add `modprobe.conf` to `/etc/modprobe.conf`
- run `setup.sh` to create a 4GB image file
- run `bundle install` in the repo
- make sure nginx, supervisor and avahi-daemon are enabled (`systemctl enable`)
