.text
.globl _put_str
.globl _str_index

# Print a string (passed through %rdi)
_put_str:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, -8(%rbp)
    jmp L1
L0:
    # Print current character
    movq $4, %rax
    movq $1, %rbx
    movq -8(%rbp), %rcx
    movq $1, %rdx
    int $0x80

    # Increment the pointer
    addq $1, -8(%rbp)
L1:
    movq -8(%rbp), %rbx
    cmpb $0, (%rbx)
    jne L0
    popq %rbp
    ret

# Find the first index of a character in a string
_str_index:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, -8(%rbp)     # Address of string
    movq %rsi, %rax
    movb %al, -16(%rbp)     # Character to find
    movq $0, -24(%rbp)
    jmp L3
L2:
    addq $1, -8(%rbp)
    addq $1, -24(%rbp)
L3:
    # If at the end of the string, return -1
    movq -8(%rbp), %rax
    movb (%rax), %al
    testb %al, %al
    jz L4

    # Loop if the current character != the character to find
    movq -8(%rbp), %rax
    movb -16(%rbp), %bl
    cmpb (%rax), %bl
    jne L2

    # If the character is found, return its index
    movq -24(%rbp), %rax
    popq %rbp
    ret
L4:
    movq $-1, %rax
    popq %rbp
    ret
