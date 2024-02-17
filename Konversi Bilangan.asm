
org 100h

mulai:
    xor ax,ax
    xor bx,bx
    mov ax,3h
    int 10h
    jne mulai                   ;Memulai prograam

pros:                          
    call awal                   ;Memanggil awal (baris 75)
    call menu                   ;Memanggil Menu (baris 101)
    call pilih                  ;Memanggil Pilih (baris 92)
    mov ah,1
    int 21h
    call cek
        
conbin:                         ;Konversi 8Bit Desimal Ke Biner
    mov ah,9
    lea dx,baris
    int 21h             
    call input_dec              ;(baris 127)
    call proses_decb            ;(baris 307)
    call lagi                   ;(baris 392)
    
conhex:                         ;Konversi 8Bit Desimal Ke Hexadesimal
    mov ah,9
    lea dx,baris
    int 21h             
    call input_dec              ;(baris 127)
    call proses_dech            ;(baris 345)
    call lagi                   ;(baris 392)
         
exit:                           ;Exit Program
    mov ah,4ch
    int 21h
    ret

baris   db 0ah,0dh,'$'
msg     db '====PROGRAM KONVERSI BILANGAN====   $'
psn1    db 'PROJECT ARSIKOM KEL 8 - ES SQUAD    $'
psn2    db 'Faris Afra M. & M. Renaldi Saputra  $'
pil     db 'Masukkan Pilihan Anda         : $'
menu1   db '   1. Desimal Ke Biner              $'
menu2   db '   2. Desimal Ke Hexadesimal        $'
cdes    db 'Masukkan Angka Desimal        : $'
hcdes   db 'Hasil Konversi Biner          : $'
ulang   db 0AH,0DH, 'Mau ulangi program <y/t> ? $'
hcdes1  db 'Hasil Konversi Hexadesimal    : $'
cbin    db 'Masukan Angka Biner           : $'
hcbin   db 'Unsigned      : $'
hcbin1  db 'Hasil Konversi Hexadesimal    : $'
chex    db 'Masukkan Hexadesimal          : $'
hchex   db 'Hasil Konversi Desimal        : $'
hchex1  db 'Hasil Konversi Biner          : $'
SIGN    DB 'Sign           : $'
ket     db 'Hasil Konversi Desimal              $'
a dw ?
d dw ?
c db ?
x db ?
one dw ?
z db ?
P DB ?
Q DB ?
L DW ?
M DW ?
MINUSZ DB '-$'
table db '0123456789ABCDEF'    ;Tabel Xlat
result db 16 dup<'x'>, 'b'
OVER DB 'OVERFLOW <DILUAR BATAS>$'

awal proc
    mov ah,9
    lea dx,msg
    int 21h
    lea dx,baris
    int 21h
    lea dx,psn1
    int 21h
    lea dx,baris
    int 21h
    lea dx,psn2
    int 21h
    lea dx,baris
    int 21h
    ret
    awal endp

pilih proc
    mov ah,9
    lea dx,baris
    int 21h
    lea dx,pil
    int 21h
    ret
    pilih endp

menu proc
    mov ah,9
    lea dx,baris
    int 21h
    lea dx,menu1
    int 21h
    lea dx,baris
    int 21h
    lea dx,menu2
    int 21h
    lea dx,baris
    int 21h   
    ret
    menu endp

cek proc
    cmp al,31h
    je conbin
    cmp al,32h
    je conhex
    cmp al,33h
    je exit
    jne mulai
    ret
    cek endp

input_dec PROC                ;input bil desimal
    PUSH    BX
    PUSH    CX
    PUSH    Dx 
    
BEGIN:
    MOV AH,9
    MOV dx,offset cdes
    INT 21h
    XOR BX,BX
    XOR CX,CX
    MOV AH,1
    INT 21h
    CMP AL,'-'
    JE MINUS
    CMP AL,'+'
    JE PLUS
    JMP REPEAT2   
    
MINUS:                  
    MOV CX,1
    mov z,1   
    
PLUS:
    INT 21h       
    
REPEAT2:
    CMP AL,'0'
    JNGE    NOT_DIGIT
    CMP AL,'9'
    JNLE    NOT_DIGIT
    AND AX,000Fh
    PUSH    AX
    MOV AX,10
    MUL BX
    POP BX
    jo overflow
    ADD BX,AX
    jc overflow
    MOV AH,1
    INT 21h
    CMP AL,0Dh
    JNE REPEAT2
    MOV AX,BX
    OR  CX,CX
    JE keluar
    NEG AX      
    
Keluar:
    POP DX
    POP CX
    POP BX
    jmp lanjuts1
    RET        
    
NOT_DIGIT:
    MOV AH,2
    MOV DL,0Dh
    INT 21h
    MOV DL,0Ah
    INT 21h
    JMP BEGIN
    lanjuts1:
    mov bx,ax
    ret           
    
input_dec ENDP    
    
input_bin proc
    mov cx,8
    xor bx,bx
    mov ah,1
    int 21h       
    
whileb:
    cmp al,0dh
    je end_whileb
    cmp al,31h
    jg mulai
    cmp al,30h
    jl mulai
    and al,0Fh
    shl bx,1
    or bl,al
    cmp cl,1
    je end_whileb
    int 21h
    loop whileb  
    
end_whileb:
    ret        
    
input_bin endp


input_hex proc
    mov cx,2
    mov ah,1
    int 21h     
    
whileh:
    cmp al,0dh
    je end_whileh
    cmp al,46h
    jg PERIKSA
    cmp al,30h
    jl mulai    
    
PERIKSA:
    CMP AL,66h
    JG MULAI
    cmp al,39h
    jg hurufh            
    and al,0Fh
    jmp geserh
    hurufh:
    sub al,37h
    AND AL,0FH   
    geserh:
    shl bl,4
    or bl,al
    cmp cl,1
    je end_whileh
    int 21h
    loop whileh  
    end_whileh:
    ret          
    
input_hex endp
 
proses_bin proc
    mov ah,9
    lea dx,baris
    int 21h
    lea dx,baris
    int 21h
    lea dx,ket
    int 21h
    lea dx,baris
    int 21h
    lea dx,hcbin
    int 21h
    xor dx,dx
    xor ax,ax
    mov ax,bx
    call print_al
    ret       
    
print_al proc
    cmp al, 0
    jne print_al_r
    push ax
    mov al, '0'
    mov ah, 0eh
    int 10h
    pop ax
    ret       
    print_al_r:
    pusha
    mov ah, 0
    cmp ax, 0
    je pn_done
    mov dl, 10
    div dl
    call print_al_r
    mov al, ah
    add al, 30h
    mov ah, 0eh
    int 10h
    jmp pn_done  
    pn_done:
    popa
    ret
    endp

proses_decb proc
    cmp bx,255d
    jg overflow
    cmp bx,-128d
    jl overflow
    mov ah,9
    lea dx,baris
    int 21h
    lea dx,hchex1
    int 21h
    xor dx,dx
    xor ax,ax
    MOV AX,BX     
    
print_al_bin proc
    pusha
    mov cx,8
    mov bl, al
    p1:    
    mov ah, 2
    mov dl, '0'
    test bl, 10000000b
    jz zero
    mov dl, '1'
    zero:  
    int 21h
    shl bl, 1
    loop p1
    mov dl, 'b'
    int 21h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    popa
    ret
    endp

proses_dech proc
    cmp bx,255d
    jg overflow
    cmp bx,-128d
    jl overflow
    MOV Z,AL
    MOV AH,9
    LEA DX,BARIS
    INT 21h
    LEA DX,hcbin1
    INT 21h
    XOR DX,DX
    MOV DL,Z
    lea bx, table
    mov al, dl
    shr al, 4
    xlat
    mov ah, 0eh
    int 10h
    mov al, dl
    and al, 0fh
    xlat
    mov ah, 0eh
    int 10h
    ret

proses_8binh proc
    MOV Z,bl
    MOV AH,9
    LEA DX,BARIS
    INT 21h
    LEA DX,HCbin1
    INT 21h
    XOR DX,DX
    MOV DL,Z
    lea bx, table 
    mov al, dl
    shr al, 4
    xlat
    mov ah, 0eh
    int 10h        
    mov al, dl
    and al, 0fh
    xlat
    mov ah, 0eh
    int 10h
    ret         
    
selesai:
    mov ah,4ch
    int 21h
    ret        

lagi proc         
j:
    mov ah,9
    LEA DX,BARIS
    INT 21H
    LEA DX,BARIS
    INT 21H
    lea dx,baris
    int 21h
    lea dx,ulang
    int 21h
    mov ah,1
    int 21h
    cmp al,'y'
    je mulai
    cmp al,'Y'
    je mulai
    cmp al,'t'
    je exit
    cmp al,'T'
    je exit
    jne j
    ret
    lagi endp

PROSES_8SIGN PROC
    MOV AL,BL
    MOV Q,AL
    AND AL,7FH
    CMP AL,Q
    JNE PROSSIGN
    JMP TAMPILKAN

PROSSIGN:
    NEG AL
    XOR AL,80H
    MOV P,AL 
    MOV AH,9
    LEA DX,BARIS
    INT 21H
    LEA DX,SIGN
    INT 21H
    LEA DX,MINUSZ
    INT 21H
    MOV AL,P
    JMP IKI
    
TAMPILKAN:
    mov ah,9
    lea dx,baris
    int 21h
    lea dx,SIGN
    int 21h
    xor dx,dx
    xor ax,ax
    mov ax,bx
    call print_al1
    ret

IKI:        
   print_al1 proc
   cmp al, 0
   jne print_al_r1
   push ax
   mov al, '0'
   mov ah, 0eh
   int 10h
   pop ax
   ret   
   
print_al_r1:
   pusha
   mov ah, 0
   cmp ax, 0
   je pn_done2
   mov dl, 10
   div dl
   call print_al_r1
   mov al, ah
   add al, 30h
   mov ah, 0eh
   int 10h
   jmp pn_done2  
   
pn_done2:
   popa
   ret
   endp
    
OVERFLOW:
   MOV AH,9
   LEA DX,BARIS
   INT 21H
   LEA DX,OVER
   INT 21H
   CALL LAGI