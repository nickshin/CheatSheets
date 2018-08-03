# Writing Linux Device Drivers

written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://github.com/nickshin/CheatSheets/>

* * *

<https://opensourceforu.com/tag/linux-device-drivers/>
- excellent (but wordy) overview to write linux device drivers from scratch

* * *

## [The Linux Kernel Module Programming Guide](http://tldp.org/LDP/lkmpg/2.6/html/lkmpg.html)

```sh
lsmod		# reads: /proc/modules

modprobe
#	/etc/modprobe.conf
#	/lib/modules/version/modules.dep

modinfo *.ko
```

* * *

- linux/module.h
	- every kernel module needs to include this
	- for list of available symbols exported by kernel:

```sh
cat /proc/kallsyms
```

- linux/kernel.h
	- printk()
	- KERN_ALERT KERN_INFO etc.  (there are 8 priorities)


- linux/fs.h

```c
struct file_operations {
    struct module *owner;

    loff_t(*llseek)        (struct file *, loff_t, int);

    ssize_t(*read)         (struct file *, char __user *, size_t, loff_t *);
    ssize_t(*aio_read)     (struct kiocb *, char __user *, size_t, loff_t);

    ssize_t(*write)        (struct file *, const char __user *, size_t, loff_t *);
    ssize_t(*aio_write)    (struct kiocb *, const char __user *, size_t, loff_t);

    int (*readdir)         (struct file *, void *, filldir_t);
    unsigned int (*poll)   (struct file *, struct poll_table_struct *);
    int (*ioctl)           (struct inode *, struct file *, unsigned int, unsigned long);
    int (*mmap)            (struct file *, struct vm_area_struct *);

    int (*open)            (struct inode *, struct file *);
    int (*flush)           (struct file *);
    int (*release)         (struct inode *, struct file *);

    int (*fsync)           (struct file *, struct dentry *, int datasync);
    int (*aio_fsync)       (struct kiocb *, int datasync);
    int (*fasync)          (int, struct file *, int);

    int (*lock)            (struct file *, int, struct file_lock *);

    ssize_t(*readv)        (struct file *, const struct iovec *, unsigned long, loff_t *);
    ssize_t(*writev)       (struct file *, const struct iovec *, unsigned long, loff_t *);

    ssize_t(*sendfile)     (struct file *, loff_t *, size_t, read_actor_t, void __user *);
    ssize_t(*sendpage)     (struct file *, struct page *, int, size_t, loff_t *, int);

    unsigned long (*get_unmapped_area)
                           (struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
};

struct file_operations fops = {
	.read = device_read,
	.write = device_write,
	.open = device_open,
	.release = device_release
};
```

* * *

```make
obj-m += hello-1.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

* * *

#### Example 2-7. hello-5.c

- fairly complete module summary with: MACROS, parameters, init, exit 

More `char_driver` examples see: `SolidusCode` and `rulingminds/mod_*`

* * *

#### Example 5-3. procfs3.c

/proc

```c
struct proc_dir_entry
```

- create the file `/proc/helloworld` in the function

```c
int init_module() {
	create_proc_entry( const char*, umode_t, struct proc_dir_entry* );
```

- return a value (and a buffer) when the file `/proc/helloworld` is **read** in the callback function

```c
unsigned long copy_to_user( void __user*, const void*, unsigned long );
```

- return a value when the file `/proc/helloworld` is **writen** in the callback function

```c
unsigned long copy_from_user( void*, const void __user*, unsigned long );
```

- and delete the file `/proc/helloworld` in the function

```c
void cleanup_module() {
	remove_proc_entry( const char*, struct proc_dir_entry* );
```

* * *

**Device Drivers**

The ioctl number encodes:
- the major device number
- the type of the ioctl
- the command
- and the type of the parameter

need (though not required) an official ioctl assignment:
- Documentation/ioctl-number.txt

#### Example 7-1 to 7-3

- fairly complete ioctl summary with:

```c
register_chrdev     (init)
unregister_chrdev   (exit)
put_user            (read)
get_user            (write)

file_operations.ioctl = int device_ioctl(  // (module/kernelspace)
	/* see include/linux/fs.h */
		struct inode *inode,
		struct file *file,
	/* number and param for ioctl */
		unsigned int ioctl_num,
		unsigned long ioctl_param);
// which basically is a switch statement of ioctl_request_IDs
```

- ioctl requests (MACRO) IDs:

```c
_IOR (MAJOR_NUM, ioctl_num, ioctl_param)
_IOWR(MAJOR_NUM, ioctl_num, ioctl_param)
```

- ioctl is accessed by: (app/userspace)

```c
fd = open( "name_of_device", 0 );
ret_val = ioctl( fd, ioctl_request_ID, data );
```

* * *
* * *

**system calls**

user process fill the registers with values, then tells the kernel to jump
(via `interrupt 0x80`) to a previously defined location in the kernel
-- this is no longer running in restricted user mode

* * *

#### Example 8-1 syscall.c

- make a syscall

- note: `sys_call_table` is no longer exported
	- to keep people from doing potential harmful things,
		you will have to patch your current kernel in order to have `sys_call_table` exported.
		In the example directory you will find a README and the patch.

* * *

To add a new syscall to the kernel: see `rulingminds/0_system_calls_notes.txt`

* * *
* * *

#### Example 10-2 kbleds.c

**fun drivers**
- Blink keyboard leds until the module is unloaded

* * *
* * *

## USB device driver

[Linux Device Drivers, Third Edition](http://lwn.net/Kernel/LDD3/)
- PDF all chapters

<http://www.linuxforu.com/2011/10/usb-drivers-in-linux-1/>

<http://www.linuxforu.com/2011/11/usb-drivers-in-linux-2/>

<http://www.linuxforu.com/2011/12/data-transfers-to-from-usb-devices/>

- /usb/serial/usb-serial.h

```c
struct usb_serial_device_type {
	struct module *owner;
	char *name;
	const struct usb_device_id *id_table;
	char num_interrupt_in;
	char num_bulk_in;
	char num_bulk_out;
	char num_ports;
	struct list_head driver_list;
	int (*probe) (struct usb_serial *serial);
	int (*attach) (struct usb_serial *serial);
	int (*calc_num_ports) (struct usb_serial *serial);
	void (*shutdown) (struct usb_serial *serial);
	int  (*open) (struct usb_serial_port *port,
	              struct file * filp);
	void (*close) (struct usb_serial_port *port,
	               struct file * filp);
	int  (*write) (struct usb_serial_port *port,
	               int from_user,
	               const unsigned char *buf,
	               int count);
	int  (*write_room) (struct usb_serial_port *port);
	int  (*ioctl) (struct usb_serial_port *port,
	               struct file * file,
	               unsigned int cmd,
	               unsigned long arg);
	void (*set_termios) (struct usb_serial_port *port,
	                     struct termios * old);
	void (*break_ctl) (struct usb_serial_port *port,
	                   int break_state);
	int  (*chars_in_buffer)
	       (struct usb_serial_port *port);
	void (*throttle) (struct usb_serial_port *port);
	void (*unthrottle) (struct usb_serial_port *port);
	void (*read_int_callback)(struct urb *urb);
	void (*read_bulk_callback)(struct urb *urb);
	void (*write_bulk_callback)(struct urb *urb);
};
```

* * *

