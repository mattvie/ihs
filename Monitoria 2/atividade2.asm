ORG 0x7C00
BITS 16
    jmp start


start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ;; Pegando input do teclado e colocando ele em al
    call get_keyboard_input

    ;; Salvando char em uma região de memória
    push bp
    mov bp, sp
    sub sp, 8
    mov BYTE[bp-1], al

    ;; print number?
    movsx bx, BYTE[bp-1]
    push bx
    call print_number

    ;; Printando o char


end:
    jmp $ ;halt

get_keyboard_input:
.loop:
    mov ah, 0x00
    int 0x16
    ;; char lido vai estar em al
    cmp al, 0x0D
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    ret

print_string:
    push bp ;; salvar bp
    mov bp, sp  ;;bp -> topo da pilha
    ;; bp+0 -> bp antigo
    ;; bp+2 -> offset retorno
    ;; bp+4 -> primeiro parametro
    ;; está de 2 em 2 pq modo real é 16 bits. no modo protegido seria de 4 em 4 bytes
    mov si, [bp+4]
        
    .loop:
        lodsb
        or al, al
        jz .done
        mov ah, 0x0E
        int 0x10
        jmp .loop
    .done:
        pop bp  ;;devolver bp
        ret 2   ;; n_parametros * 2 (modo real)

print_string_simples:
    ;;mov si, hello
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
    push bp
    mov bp, sp
    ;; bp+0 -> bp antigo
    ;; bp+2 -> flags
    ;; bp+4 -> cs
    ;; bp+6 -> ip
    ;; bp+8 -> 1o parametro
    mov ax, [bp+8]
    mov bx, 10
    mov cx, 0

    .loop1:
        mov dx, 0
        div bx
        ; resposta vai estar no ac, resto no dx
        add dx, 48
        push dx
        inc cx
        cmp ax, 0
        jne .loop1

    .loop2:
        pop ax
        mov ah, 0x0E
        int 0x10
        loop .loop2

    .done:
    ;; código...
        pop bp
        iret

; assinatura de boot
    times 510-($-$$) db 0
    dw 0xAA55