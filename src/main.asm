.data
prompt:         .string "$ "
input_buffer:   .zero 1024
exit_keyword:   .string "exit"
error_msg:      .string ": no script or executable found\n"

.text
.extern _put_str
.extern _str_index
.extern _strip_newline
.globl _start

_start:
main_loop:
    call _print_prompt
    call _get_input

    call _check_quit
    cmpq $1, %rax
    je _exit

    movq $input_buffer, %rdi
    call _strip_newline

    call _fork
    cmpq $0, %rax
    je child
    jne main_loop

child:
    movq $59, %rax
    movq $input_buffer, %rdi
    movq %rdi, %rsi
    movq $0, %rdx
    syscall

    cmpq $0, %rax
    jl command_error
    jge _exit

command_error:
    movq $input_buffer, %rdi
    call _put_str
    movq $error_msg, %rdi
    call _put_str

_exit:
    movq $60, %rax
    xorq %rdi, %rdi
    syscall

# Print the prompt to the screen
_print_prompt:
    movq $prompt, %rdi
    call _put_str
    ret

# Read user input into the input buffer
_get_input:
    movq $0, %rax
    movq $0, %rdi
    movq $input_buffer, %rsi
    movq $1023, %rdx
    syscall
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

_fork:
    movq $57, %rax
    syscall
    ret
