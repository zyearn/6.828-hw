https://pdos.csail.mit.edu/6.828/2014/homework/xv6-zero-fill.html

这个作业要我们把page allocation改成lazy的，原因是不是所有的allocation都会立即用到或者可能压根不会用（比如large sparse arrays），改动在同目录的lazy.diff中。

基础部分比较简单，按照hint一步一步做就可以了。

## Challenges

1. Handle negative sbrk() arguments

sbrk的参数是负数意味着应用程序要把内存还给OS。这个不能像分配那样lazy地做，因为在分配的时候proc->sz以下的空间只要没有设置PTE就可以lazy分配，而回收的时候proc->sz已经减小，那么如果要等到下次再回收OS怎么知道要回收哪些内存？

所以实现方式是如果sbrk的参数n小于0，立刻调用deallocuvm释放给OS（通过growproc来调deallocuvm）。

// 这里有个问题，代码里没有对n的大小进行检查，所以如果n传入-proc->sz，好像就能把程序的所有用户空间代码返还给OS了。

2. Handle error cases such as sbrk() arguments that are too large

在非lazy情况中，函数allocuvm里已经有这个检查了，所以要把检查的代码给搬过来。

3. Verify that fork() and exit() work even if some sbrk()'d address have no memory allocated for them.

// TODO

4. Correctly handle faults on the invalid page below the stack.

// TODO

5. Make sure that kernel use of not-yet-allocated user addresses works -- for example, if a program passes an sbrk()-allocated address to read().

// TODO
