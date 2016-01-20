1. Explain in one sentence what happens.

第两次acquire，检测到该CPU占着这个锁，于是panic。

2. Explain in a few sentences why the kernel panicked. You may find it useful to look up the stack trace (the sequence of %eip values printed by panic) in the kernel.asm listing.

利用pcs数组中的call stack信息可以看出，在执行idestart函数的时候来了一个时钟中断，调用了yield，其中检测了cpu->ncli这个变量，因为这个cpu获得了两把锁，所以这个值是2，于是就panic了。

3. Explain in a few sentences why the kernel didn't panic. Why do file_table_lock and ide_lock have different behavior in this respect?

原因是file_table_lock保护的临界区足够短，时钟中断还来不及触发。如果在该临界区中加一段长时间的while循环，就会panic。

4. Why does release() clear lk->pcs[0] and lk->cpu before clearing lk->locked? Why not wait until after?

如果在清除lk->locked之后清除，那么就会有一小段空隙，在这个空隙里如果时钟中断来了，就会成功获得这个锁，然后设置lk->pcs[]和lk->cpu，此时再调度到原来的进程，将lk->pcs[]和lk->cpu清除，就会出错。


