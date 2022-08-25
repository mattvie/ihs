ORG 0x7C00
BITS 16
    jmp start

parameter times 30 db 0

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ;; configurando IVT
    ;; print_string é a label / ip
    ;; 0x100 -> 0x40
    mov di, 0x100
    mov word[di], print_string
    mov word[di+2], cs

    ;; get string
    ;; di --> string
    ;; cx = tamanho max da string
    ;; Seta argumentos para input 
    mov di, parameter                    
    mov cx, 30                       
    call input_string

    

    int 0x40
    
end:
    jmp $ ;halt

print_string:    
    mov bp, parameter
    push cx

    ;; Get cursor position and shape interruption
    ;; CH = Start scan line, CL = End scan line, DH = Row, DL = Column 
    mov ah, 0x3
    ;inc DH
    int 0x10
    pop cx

    xor ax, ax
    mov es, ax
    mov bx, 0x000A
    mov ax, 0x1300
    int 0x10

    ;; \n e fim de string
    mov al, 0xa
    call print_char
    mov al, 0xd
    call print_char
ret

input_string:
    ;; Read key press interruption
    ;; Passa a tecla pressionada para o AL
    ;; AL também é usado em print_char
    mov ah, 0x0
    int 0x16
    call print_char

    cmp al, 13
    je return
    stosb
    loop input_string
ret

return:                                   
ret

print_char:
    ;; Teletype output
    ;; AL = Character, BH = Page Number
    pusha
    mov ah, 0xe
    mov bh, 0
    int 10h
    popa
ret

fill_string:
    stosb
    loop fill_string
ret

    ;; assinatura de boot
    times 510-($-$$) db 0
    dw 0xAA55