target remote :1234
symbol-file vmlinux
b start_kernel
la src
c

