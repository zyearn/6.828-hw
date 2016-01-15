1. 把本来的返回地址，即tf->eip压栈，造成函数调用的假象

2. 把tf->eip设置为handler的地址，就可以从内核返回到handler，执行完成后执行ret，即把栈上的地址弹出并返回，这个地址在1中被设置为原来的eip

对trap.c的修改如下：

    if (proc && (tf->cs & 3) == 3) {
        proc->ticksnow++;

        if (proc->alarmhandler && proc->alarmticks && proc->ticksnow % proc->alarmticks == 0) {
            proc->ticksnow = 0;
            tf->esp -= 4;
            *(uint *)(tf->esp) = tf->eip;
            tf->eip = (uint) proc->alarmhandler;
        }
    }

