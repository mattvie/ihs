ORG 0x7C00
BITS 16
    jmp start

msg: db "hello, world!", 0x0D, 0x0A, 0

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ;; configurando IVT
    ;; print_number é a label / ip
    ;; 50H chega no 0x140 (?)
    mov di, 0x140
    mov word[di], print_number
    mov word[di+2], cs

    push msg
    call print_string
    ;;call get_keyboard_input

    mov bx, 145
    push bx
    int 0x50 ;;50H

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