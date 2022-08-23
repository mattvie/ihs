# ihs
Repositório da disciplina de Interface Hardware-Software, CIn-UFPE, 2022

Para compilar:
nasm file.asm -o file.bin
ou
sudo nasm -f bin file.asm -o file.bin

Para executar:
qemu-system-i386 file.bin
ou
sudo qemu-system-i386 -fda file.bin
