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
    
    mov edi, [ebp + 8]
    
    xor eax, eax
    xor ecx, ecx
    not ecx
    repne scasb
    not ecx
    dec ecx
    mov eax, ecx
    
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

m31:
    mov al, [ebx]
    mov ah, [edx]
    cmp al, ah
    jne m32
    inc ebx
    inc edx
    loop m31
    xor eax, eax
    jmp m33

m32:
    mov eax, 1

m33:
    leave
    ret
    
mystery4:
    enter 0, 0
    push ebx
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov ecx, [ebp + 16]

m41:
    mov dl, [ebx]
    mov [eax], dl
    inc eax
    inc ebx
    loop m41
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

m71:
    mov bl, [esi + ecx]
    cmp bl, 0
    je m72
    
    sub bl, 48
    push ebx
    mov ebx, 10
    mov eax, [ebp - 4]
    mul ebx
    pop ebx
    add eax, ebx
    mov [ebp - 4], eax
    inc ecx
    jmp m71

m72:
    leave
    ret
    
mystery8:
    enter 16, 0
    
    mov dword [ebp - 4], 0
    mov dword [ebp - 8], 0
    

m81:
    mov eax, [ebp - 8]
    cmp eax, [ebp + 16]
    jae m82
    
    mov edx, [ebp + 8]
    mov eax, [ebp - 4]
    add eax, edx
    mov al, [eax]
    
    cmp al, 10
    je m82
    
    mov dl, al
    
    mov ecx, [ebp + 12]
    mov eax, [ebp - 8]
    add eax, ecx
    mov al, [eax]
    
    cmp dl, al
    je m83
    
    mov dword [ebp - 8], 0
    jmp m85

m83:
    inc dword [ebp - 8]

m84:
    mov eax, [ebp - 8]
    cmp eax, [ebp + 16]
    jne m85
    mov eax, 1
    jmp m86

m85:
    inc dword [ebp - 4]
    jmp m81

m82:
    xor eax, eax

m86:
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

m91:
    mov eax, [ebp - 12]
    cmp eax, [ebp + 16]
    jae m92
    
    mov edx, [ebp + 8]
    add eax, edx
    mov al, [eax]
    cmp al, 10
    jne m93
    
    mov eax, [ebp - 16]
    add eax, edx
    
    push dword [ebp - 20]
    push dword [ebp + 20]
    push eax
    call mystery8
    add esp, 12
    
    test eax, eax
    je m94
    
    mov edx, [ebp + 8]
    mov eax, [ebp - 16]
    add eax, edx
    
    push eax
    call print_line
    add esp, 4

m94:
    mov eax, [ebp - 12]
    inc eax
    mov [ebp - 16], eax

m93:
    inc dword [ebp - 12]
    jmp m91

m92:
    leave
    ret