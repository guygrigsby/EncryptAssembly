nasm -f elf64 encrypt.asm
ld -m elf_x86_64 -s -o encrypt encrypt.o
./encrypt
