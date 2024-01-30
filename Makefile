
all: bin/main.o bin/string.o
	ld -m elf_x86_64 -o bin/ashell bin/main.o bin/string.o

bin/%.o: src/%.asm
	as -o $@ $^

clean:
	rm -rf bin/*.o