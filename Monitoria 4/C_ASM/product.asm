SECTION .text
global product4
product4:
    enter 0,0
    mov eax, [ebp+8]
    imul eax, [ebp+12]
    imul eax, [ebp+16]
    imul eax, [ebp+20]
    leave 
    ret