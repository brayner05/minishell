.text
.globl _str_index
.globl _strip_newline
.globl _str_eq

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

_strip_newline:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, -8(%rbp)
    jmp L6
L5:
    addq $1, -8(%rbp)
L6:
    movq -8(%rbp), %rax
    movb (%rax), %al
    cmpb $'\n', %al
    jne L5
    movq $0, -8(%rbp)
    popq %rbp
    ret


# Compares two strings (rdi, rsi)
_str_eq:
LSTREQ1:
    # Check if str1[i] == '\0'
    cmpb $0, (%rdi)
    je LSTREQF

    # Check if str2[i] == '\0'
    cmpb $0, (%rsi)
    je LSTREQF

    # Check if str1[i] == str2[i]
    movb (%rdi), %al
    cmpb %al, (%rsi)
    jne LSTREQF

    addq $1, %rdi
    addq $1, %rsi
    jmp LSTREQ1

LSTREQF:
    movb (%rdi), %al
    cmpb %al, (%rsi)
    je LSTREQS
    xorq %rax, %rax
    ret

LSTREQS:
    movq $1, %rax
    ret
