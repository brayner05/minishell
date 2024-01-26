.data
prompt:         .string "$ "
input_buffer:   .zero 1024
exit_keyword:   .string "quit"

.text
.globl _start

_start:
m_loop:
    call _print_prompt
    call _get_input
    movq $input_buffer, %rdi
    movq $' ', %rsi
    call _str_index
    jmp m_loop

_exit:
    movq $1, %rax
    xorq %rbx, %rbx
    int $0x80

# Print the prompt to the screen
_print_prompt:
    movq $prompt, %rdi
    call _put_str
    ret

# Read user input into the input buffer
_get_input:
    movq $3, %rax
    movq $0, %rbx
    movq $input_buffer, %rcx
    movq $1023, %rdx
    int $0x80
    ret

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
    movq -8(%rbp), %rax
    movb (%rax), %al
    testb %al, %al
    jz L4

    movq -8(%rbp), %rax
    movb -16(%rbp), %bl
    cmpb (%rax), %bl
    jne L2

    movq -24(%rbp), %rax
    popq %rbp
    ret
L4:
    movq $-1, (%rax)
    popq %rbp
    ret
