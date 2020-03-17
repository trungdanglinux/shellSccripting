all : simplemodules.c
	make -C /lib/modules/`uname -r`/build M=${PWD} modules
clean :
	make -C /lib/modules/`uname -r`/build M=${PWD} clean
obj-m := simplemodules.o
