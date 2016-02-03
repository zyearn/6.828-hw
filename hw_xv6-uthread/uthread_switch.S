	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register, which should be caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    pushal

    /* save current esp*/
    movl current_thread, %eax
    movl %esp, (%eax)

    /* restore next_thread esp */
    movl next_thread, %eax
    movl (%eax), %esp

    /* set current_thread and next_thread */
    movl %eax, current_thread
    movl $0, next_thread

    popal
	ret				/* pop return address from stack */
