.data
prompt:         .string "$ "
input_buffer:   .zero 1024
exit_keyword:   .string "exit"
error_msg:      .string ": no script or executable found\n"

.text
.extern _put_str
.extern _str_index
.extern _strip_newline
.extern _str_eq
.globl _start

_start:
main_loop:
    movq $prompt, %rdi
    call _put_str
    call _readline
    movq $input_buffer, %rdi
    movq $exit_keyword, %rsi
    call _str_eq
    cmpq $1, %rax
    je exit
    call _put_str
    jmp main_loop
exit:
    movq $60, %rax
    xorq %rdi, %rdi
    syscall

_readline:
    movq $0, %rax
    movq $0, %rdi
    movq $input_buffer, %rsi
    movq $1024, %rdx
    syscall
    ret
