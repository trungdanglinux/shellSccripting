#include <linux/init.h>
#include <linux/module.h>
#include <linux/sched.h>

int init_simple(void){
 printk("The module is now loaded\n");
 return 0;
}

void  cleanup_simple(void){
 printk("The module is now unloaded\n");
 
}

module_init(init_simple);
module_exit(cleanup_simple);


