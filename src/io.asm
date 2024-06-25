
.text
.globl _put_str

# Print a string (passed through %rdi)
_put_str:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, -8(%rbp)
    jmp PUTSL1
PUTSL0:
    # Print current character
    movq $1, %rax
    movq $1, %rdi
    movq -8(%rbp), %rsi
    movq $1, %rdx
    syscall

    # Increment the pointer
    addq $1, -8(%rbp)
PUTSL1:
    movq -8(%rbp), %rbx
    cmpb $0, (%rbx)
    jne PUTSL0
    popq %rbp
    ret
