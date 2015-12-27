这个hw的目的是让我们解释在xv6启动的时候，控制权从bootloader转到kernel这一瞬间时打个断点，解释gdb命令x/24x $esp的输出。

以下是用gdb看到的结果

    (gdb) x/24x $esp
    0x7bdc: 0x00007db4  0x00000000  0x00000000  0x00000000
    0x7bec: 0x00000000  0x00000000  0x00000000  0x00000000
    0x7bfc: 0x00007c4d  0x8ec031fa  0x8ec08ed8  0xa864e4d0
    0x7c0c: 0xb0fa7502  0xe464e6d1  0x7502a864  0xe6dfb0fa
    0x7c1c: 0x16010f60  0x200f7c78  0xc88366c0  0xc0220f01
    0x7c2c: 0x087c31ea  0x10b86600  0x8ed88e00  0x66d08ec0

分析：
xv6的bootloader由bootasm.S和bootmain.c构成，bios首先会把bootloader加载到7c00这个地址，跳转过去，然后开始执行bootasm.S中的代码。在bootasm.S中有以下两句：

    movl    $start, %esp
    call    bootmain

意思是把栈指针设置好，在执行环境里$start这个值是bootloader第一条指令的地址，所以是7c00，esp首先指向7c00，然后call了bootmain，这个操作等价于把下一条指令（通过查看bootblock.asm可知是7c4d，这出现在了上述结果中的第三行第一列）。

所以执行到这里我们应该猜到7c00以上都是bootloader的代码，7bfc存的是7c4d。然后去结果里验证一下，结合着bootblock.asm对照发现7c00以上输出的值和汇编代码一模一样，7bfc也存的是7c4d。

接下来解释为什么结果的第一第二行有28字节的0和一个7db4。函数调了bootmain以后，esp指向7bfc。在bootblock.asm中看bootmain的汇编代码，发现已进入函数会执行如下几条命令：

    7d3b:	55                   	push   %ebp
    7d3c:	89 e5                	mov    %esp,%ebp
    7d3e:	57                   	push   %edi
    7d3f:	56                   	push   %esi
    7d40:	53                   	push   %ebx
    7d41:	83 ec 0c             	sub    $0xc,%esp

其中有4个push（caller负责保存的）和将esp减12的操作（猜测是内存对齐），正好是28字节，解释了为什么会有28字节的0。

在bootmain里，需要把控制权转到OS里，调的是kernel ELF中记录的entry:

    7dae:   ff 15 18 00 01 00       call   *0x10018

此时需要把return address压栈并且esp减4，此时的return address就是下一条指令，即7db4，这就解释了上面的7db4是怎么来的。
