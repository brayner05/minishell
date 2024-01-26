.data
prompt:         .string "$ "
input_buffer:   .zero 1024
exit_keyword:   .string "exit"

.text
.globl _start

_start:
m_loop:
    call _print_prompt
    call _get_input

    call _check_quit
    cmpq $1, %rax
    je _exit

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

# Check if the user has entered the exit keyword
_check_quit:
    pushq %rbp
    movq %rsp, %rbp
    movq $input_buffer, -8(%rbp)
    movq $exit_keyword, -16(%rbp)
compare:
    # Check if at the end of either string
    movq -8(%rbp), %rax
    movb (%rax), %al
    cmpb $0, %al
    je equal

    movq -16(%rbp), %rax
    movb (%rax), %al
    cmpb $0, %al
    je equal

    # Check if current character in both strings are equal
    movq -8(%rbp), %rax
    movb (%rax), %al

    movq -16(%rbp), %rbx
    movb (%rbx), %bl

    cmp %al, %bl
    jne not_equal

    addq $1, -8(%rbp)
    addq $1, -16(%rbp)
    jmp compare
equal:
    movq $1, %rax
    popq %rbp
    ret
not_equal:
    movq $0, %rax
    popq %rbp
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
    movq $-1, %rax
    popq %rbp
    ret
