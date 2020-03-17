make all to make all to create a kernel object
Use commands insmod and rmmod to insert a module and remove a module
$sudo insmod simplemodules.ko
$lsmod | head -5 # check the if a module is loaded
$dmesg | tail -1 #check a message from kernel
$sudo rmmod simplemodules.ko
$lsmod | head -5 # check the if a module is loaded
$dmesg | tail -1 #check a message from kernel

or use make clean to clean a kernel object
