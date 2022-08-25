org 0x7c00          ; set initial addres
                                                                            
; cls
mov ax, 0x3     ; set video mode ah=0 al=3
int 0x10        ; call bios

jmp menu

fill_string:
    stosb
    loop fill_string
    ret

register_string:
    pusha
    cld                               ; df = 0, faz com que operações de string incrementem si e di
    rep movsb                         ; repete movsb até cx == 0
    popa
    ret

print_char:
    pusha
    mov ah, 0Eh
    mov cx, 1
    int 10h
    popa
    ret

; Chama int 16h que le do teclado e coloca em ax um caracter; imprime e armazena na variável apontada por di
input_string:                   
    xor ax, ax
    int 16h
    call print_char

    cmp al, 13
    je return
    stosb
    loop input_string
    ret

; Limpa memória de vídeo e seta cursor em 0, 0 
clear_screen:                      
    mov ax, 0x0003     ; set video mode ah=0 al=3
    int 0x10        ; call bios

; Seta cursor na posição inicial
    xor dx, dx
    mov ah, 02h
    int 10h
    ret

menu:
    call clear_screen
    
    ; Seta argumentos para print_string
    xor ax, ax                      
    mov bp, welcome                 
    mov cx, 24                      ; length of string (ignoring attributes)
    call print_string

    ; Seta argumentos para input_string
    mov di, option
    mov cx, 1
    call input_string

    ; Se for digitado 1 executa register_name; se 2, search_account
    mov al, [di-1]
    cmp al, '1'
    je register_id
    cmp al, '2'
    je search_account
    jmp menu


register_id:
    mov si, ids_id
    lodsw
    cmp ax, 1
    je limit_memory

    inc ax
    mov di, ids_id
    stosw

    dec ax
    mov di, ids
    add di, ax
    add ax, '1'
    stosw

register_name:
    call clear_screen
    
    mov bp, welcome_cadastro_nome
    mov cx, 4
    call print_string

    ; Seto argumentos para fill_string que limpa a string nome
    mov di, nome                   
    mov cx, 20                      
    mov al, ' '                     
    call fill_string                

    ; Seta argumentos para input 
    mov di, nome                    
    mov cx, 20                       
    call input_string                  
    
    ; Seta argumentos para register_string e next_empty; cx = tamanho de nomes;
    ; mov cx, 200        
    mov ax, [nomes_id]
    mov di, nomes
    add di, ax
    mov si, nome       
    mov cx, 20                      
    call register_string

    mov di, nomes_id
    add ax, 20
    stosw
    


register_cpf:
    call clear_screen

    mov bp, welcome_cadastro_cpf
    mov cx, 3
    call print_string

    ; Seto argumentos para fill_string que limpa a string nome
    mov di, cpf
    mov cx, 11
    mov al, ' '
    call fill_string

    ; Seta argumentos para input 
    mov di, cpf                    
    mov cx, 11                       
    call input_string 

    ; Seta argumentos para register_string e next_empty; cx = tamanho de nomes;
    mov ax, [cpfs_id]
    mov di, cpfs
    add di, ax
    mov si, cpf
    mov cx, 11
    call register_string

    mov di, cpfs_id
    add ax, 11
    stosw
    
    jmp menu


limit_memory:
    call clear_screen

    mov bp, sorry
    mov cx, 10
    call print_string

    mov di, option
    mov cx, 1
    call input_string

    jmp menu

print_account:
    mov bp, ids
    mov cx, 1
    call print_string

    mov bp, nomes
    mov cx, 20
    call print_string

    mov bp, cpfs
    mov cx, 11
    call print_string
    ret


print_string:        ; print_string(bp = string, cx = tamanho)
    ; Imprime a string apontada por di
    push cx
    mov ah, 03h
    int 10h
    pop cx

    xor ax, ax
    mov es, ax
    mov bx, 0x000A
    mov ax, 0x1300
    int 0x10

    ; Imprime um caracter de line feed
    mov al, 0Ah
    call print_char
    mov al, 0Dh
    call print_char
    ret

search_account:
    call clear_screen
    mov bp, welcome_cadastro_cpf
    mov cx, 3
    call print_string

    mov di, cpf
    mov cx, 11
    call input_string

    mov di, cpfs
    mov cx, 11
    mov si, cpf
    search_loop:
        pusha
        repe cmpsb
        je founded
        cmp di, cpfs + 22
        jg menu
        popa
        add di, cx
        jmp search_loop
    founded:
        call clear_screen
        call print_account
        mov di, option
        mov cx, 1
        call input_string
        jmp menu
        
return:                                   
    ret


welcome db "1 - Register", 0Dh, 0Ah, "2 - Search"
welcome_cadastro_nome db "Name"
welcome_cadastro_cpf db "CPF"
sorry db "BD is full"

option db 0
nome times 20 db ' '
cpf times 11 db ' '

ids_id dw 0
ids times 1 dw 0
nomes times 20 db 0
nomes_id dw 0
cpfs times 11 db 0
cpfs_id dw 0

times  510 - ($-$$) db 0
dw 0xAA55 ; boot sector magic number