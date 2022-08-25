ORG 0x7C00
BITS 16

jmp start

wordd: db "testing",0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov cx, ax

    mov si, wordd
    mov di, 0

    .loop:
        lodsb

        cmp al, 0
        je .done

        mov bl, 'a'
        cmp al, bl
        je .inc

        mov bl, 'e'
        cmp al, bl
        je .inc

        mov bl, 'i'
        cmp al, bl
        je .inc
        
        mov bl, 'o'
        cmp al, bl
        je .inc
        
        mov bl, 'u'
        cmp al, bl
        je .inc

        jmp .loop
        .inc: 
            inc cx
            jmp .loop

    .done:
        mov ax, cx
        call print_number

print_number:
    mov bl, 10
    mov cx, 0

    .loop:
        xor dx, dx
        div bx

        inc cx

        add dx, '0'
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
