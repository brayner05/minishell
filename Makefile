
all: main.o string.o
	ld -m elf_x86_64 -o bin/ashell bin/main.o bin/string.o

%.o: src/%.asm
	as -o bin/$@ $^

clean:
	rm -rf *.o