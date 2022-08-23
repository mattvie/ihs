ORG 0x7C00
BITS 16

;; o org diz para o nasm que o código executável deve começar a partir desse endereço
;; é uma instrução para o montador

jmp start

hello: db "Hello, World!", 0x0A, 0x0D, 0

;; significados : string, \r, \n, {fim da string}

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    call print_string

    mov ax, 256
    call print_number

    jmp end

print_string:
    mov si, hello
    .loop:
        lodsb

        cmp al, 0
        je .done

        mov ah, 0x0E
        int 10h ;; instruções de vídeo

        jmp .loop

    .done:
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