; Mares Catalin-Constantin 322 CD

BITS 32
extern print_line
global mystery1:function
global mystery2:function
global mystery3:function
global mystery4:function
global mystery7:function
global mystery8:function
global mystery9:function

section .text

mystery1:
    enter 0, 0
    
    push ebx
    mov edi, [ebp + 8]
    
    xor eax, eax
    xor ebx, ebx
    
mystery1_l1:
    mov bl, [edi]
    test ebx, ebx
    je mystery1_l2
    
    add eax, 1
    add edi, 1
    jmp mystery1_l1
    
mystery1_l2:
    pop ebx
    leave
    ret
    
mystery2:
    enter 0, 0
    
    mov edi, [ebp + 8] 
    mov dl, [ebp + 12]
    
    xor eax, eax

m21:
    mov bl, [edi]
    
    cmp bl, 0
    je m24
    
    cmp bl, dl
    je m23
    
    inc eax
    inc edi
    jmp m21

m24:   
    mov eax, 0xffffffff

m23:
    leave
    ret
    
mystery3:
    enter 0, 0
    mov ebx, [ebp + 8]
    mov edx, [ebp + 12]
    mov ecx, [ebp + 16]

mystery3_l1:
    mov al, [ebx]
    mov ah, [edx]
    cmp al, ah
    jne mystery3_l2
    add ebx, 1
    add edx, 1
    loop mystery3_l1
    xor eax, eax
    jmp mystery3_l3

mystery3_l2:
    mov eax, 1

mystery3_l3:
    leave
    ret
    
mystery4:
    enter 0, 0
    push ebx
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov ecx, [ebp + 16]

mystery4_l1:
    mov dl, [ebx]
    mov [eax], dl
    add eax, 1
    add ebx, 1
    loop mystery4_l1
    pop ebx
    leave
    ret
    
mystery7:
    enter 4, 0
    
    xor edx, edx
    xor ebx, ebx
    
    mov dword [ebp - 4], 0
    
    xor ecx, ecx
    mov esi, [ebp + 8]

mystery7_l1:
    mov bl, [esi + ecx]
    cmp bl, 0
    je mystery7_l2
    
    sub bl, 48
    push ebx
    mov ebx, 10
    mov eax, [ebp - 4]
    mul ebx
    pop ebx
    add eax, ebx
    mov [ebp - 4], eax
    add ecx, 1
    jmp mystery7_l1

mystery7_l3:
    mov eax, 0xffffffff

mystery7_l2:
    leave
    ret
    
mystery8:
    enter 16, 0
    
    mov dword [ebp - 4], 0
    mov dword [ebp - 8], 0

mystery8_l1:
    mov eax, [ebp - 8]
    cmp eax, [ebp + 16]
    jae mystery8_l2

    mov edx, [ebp + 8]
    mov eax, [ebp - 4]
    add eax, edx
    mov al, [eax]
    
    cmp al, 10
    je mystery8_l2
    
    mov dl, al
    
    mov ecx, [ebp + 12]
    mov eax, [ebp - 8]
    add eax, ecx
    mov al, [eax]
    
    cmp dl, al
    je mystery8_l3
    
    mov dword [ebp - 8], 0
    jmp mystery8_l5

mystery8_l3:
    add dword [ebp - 8], 1

mystery8_l4:
    mov eax, [ebp - 8]
    cmp eax, [ebp + 16]
    jne mystery8_l5
    mov eax, 1
    jmp mystery8_l6

mystery8_l5:
    add dword [ebp - 4], 1
    jmp mystery8_l1

mystery8_l2:
    xor eax, eax

mystery8_l6:
    leave
    ret
    
mystery9:
    enter 24, 0
    
    mov eax, [ebp + 12]
    mov [ebp - 16], eax
    mov [ebp - 12], eax
    
    push dword  [ebp + 20]
    call mystery1
    add esp, 4
    
    mov [ebp - 20], eax

mystery9_l1:
    mov eax, [ebp - 12]
    cmp eax, [ebp + 16]
    jae mystery9_l2
    
    mov edx, [ebp + 8]
    add eax, edx
    mov al, [eax]
    cmp al, 10
    jne mystery9_l3
    
    mov eax, [ebp - 16]
    add eax, edx
    
    push dword [ebp - 20]
    push dword [ebp + 20]
    push eax
    call mystery8
    add esp, 12
    
    test eax, eax
    je mystery9_l4
    
    mov edx, [ebp + 8]
    mov eax, [ebp - 16]
    add eax, edx
    
    push eax
    call print_line
    add esp, 4

mystery9_l4:
    mov eax, [ebp - 12]
    add eax, 1
    mov [ebp - 16], eax

mystery9_l3:
    add dword [ebp - 12], 1
    jmp mystery9_l1

mystery9_l2:
    leave
    ret