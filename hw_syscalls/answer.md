## Part One: System call tracing

Hint: modify the syscall() function in syscall.c

trival. 从proc->tf->eax中可以拿到syscall number，然后做个映射表输出就可以了。

Challenge: print the system call arguments

IA32上函数是通过stack来传递参数的，syscall也不例外。proc->tf->esp存的是user-space的栈指针，里面存的是return address，所以nth argument就是proc->tf->esp+4+4*n。

## Part Two: Date system call

为了新增date系统调用，按照着原有的例子改就行了，具体实现代码在date.diff中。

系统调用是怎么实现的？

有一个.h文件暴露接口，有一个.c文件来实现接口，在x86上实现方法是c语言层内联汇编int指令（或者直接汇编实现），把系统调用号放入eax，进入内核模式，内核中有一个系统调用表，根据eax的值来索引这个表得到一个函数地址，然后Jmp过去执行这个函数（如果系统调用叫xxx，内核对应的函数一般叫sys_xxx）。

// TODO
Challenge: add a dup2() system call
