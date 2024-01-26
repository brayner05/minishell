
all: main.o
	ld -m elf_x86_64 -o ashell main.o

main.o: main.asm
	as -o main.o main.asm