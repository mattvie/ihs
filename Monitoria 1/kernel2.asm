ORG 0x7C00
BITS 16

;; o org diz para o nasm que o código executável deve começar a partir desse endereço
;; é uma instrução para o montador

jmp start

wordd: db "a",0
a: db "a",0
e: db "e",0
i: db "i",0
o: db "o",0
u: db "u",0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov si, wordd
    mov di, '3'

    .loop:
        lodsb

        cmp al, 0
        je .done

        cmp al, a
        je .success

        cmp al, e
        je .success

        cmp al, i
        je .success

        cmp al, o
        je .success

        cmp al, u
        je .success

        jmp .loop

    .success:
        inc di
        ret

    .done:
        mov ax, di
        call print_number
        ret


print_number:
    mov bl, 10
    mov cx, 0

    .loop:
        xor dx, dx
        div bx

        inc cx

        add dx, '0' ;; ou 48, da tabela ASCII
        push dx

        cmp ax, 0
        je .loop2

        jmp .loop

    .loop2:
        pop ax

        mov ah, 0x0E
        int 0x10

        loop .loop2

end:
    jmp $

times 510-($-$$) db 0
dw 0xAA55

;; times 510-($-$$) db 0 calcula o tamanho do código, e completa o resto com 0 para que tenha exatamente 512 bytes