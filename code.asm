name "mycode"   ; output file name (max 8 chars for DOS compatibility)

org  100h	; set location counter to 100h

.code
; inputting numbers, please note that all numbers must be under 20d for the LCM to work, overflow may result otherwise
; numbers between 20-10d may take much longer time to calculate LCM than numbers 0-10d, please consider the limitations of 8086
;in ax, 71h
;mov w, ax
;in ax, 71h
;mov x, ax
;in ax, 72h
;mov y, ax
;in ax, 72h
;mov z, ax

;Checking if the four numbers are equal, if equal it prints the number and halts the application otherwise it continues
mov al, w
cmp al, x
je eqContinue1
jmp notequal

eqContinue1:
cmp al,y
je eqContinue2 
jmp notequal

eqContinue2:
cmp al, z
jge equal
jmp notequal

equal:
mov al, 47h ; Set interrupt vector number to 47h
mov dx, ISR 
mov ah, 25h ; Set function number to 25h (DOS set interrupt vector)
int 21h 

int 47h ; Call our custom interruptthat stores the flags, code segment and the IP to the stack

hlt

ISR: ; custom interrupt 
;mov ah, 09h
;mov dx, offset x 
;int 21h            
;iret ; Return from interrupt and pops the flags, code and IP address


notequal:
;find the maximum number out of the four numbers
mov al, w
cmp al, x
jge continue1
mov al, x
jmp continue1

continue1:
cmp al,y
jge continue2 
mov al, y
jmp continue2

continue2:
cmp al, z
jge assignMax
mov al, z
jmp assignMax

assignMax:
mov max, al

OUT 80h, ax ; Outputs the number to 80h

;find the minimum out of the four numbers
mov al, w
cmp al, x
jle minContinue1
mov al, x
jmp minContinue1

minContinue1:
cmp al,y
jle minContinue2 
mov al, y
jmp minContinue2

minContinue2:
cmp al, z
jle assignMin
mov al, z
jmp assignMin

assignMin:
mov min, al

OUT 80h, ax ; Outputs the number to 80h

;storing numbers between min and max in ds and starting with si as an offset
mov al,max
mov bl,min

sub al,bl 
dec al
mov cx,ax
mov al,max
loop1:
dec ax
mov [si],ax
inc si
loop loop1

;finding average of the numbers and storing the answer at xy:zw    
push ds  ; move ds to the stack
push si  ; move si to the stack

xor dx, dx

mov dl,w
add dl,x
add dl,y
add dl,z

xor ax,ax

add al, z
shl ax, 8
mov al, w
mov si, ax


xor ax, ax

add al, x
shl ax, 8
add al, y
mov ds, ax



mov bl,4
mov ax, dx

div bl
mov [si], al
inc si
mov [si], ah   
pop si ; pop si out of the stack
pop ds ; pops ds out of the stack
test ah,ah  ; Checking whether there is a remainder
jnz isnotint
test al, 1  ; checking whether the number is odd
jnz isodd
jmp conlcm

isnotint:
mov al, 98h ; Set interrupt vector number to 98h
mov dx, ISR2 
mov ah, 25h ; Set function number to 25h (DOS set interrupt vector)
int 21h 

int 98h ; Call our custom interrupt where the flags, CS, and IP are pushed
jmp conlcm

isodd:
mov al, 1h ; Set interrupt vector number to 1h
mov dx, ISR3 
mov ah, 25h ; Set function number to 25h (DOS set interrupt vector)
int 21h 

int 1h ;  Call our custom interrupt where the flags, CS, and IP are pushed
jmp conlcm


ISR2:
mov ah, 09h
mov dx, offset avgint 
int 21h            
iret ; Return from interrupt and popping the flags, CS, and the IP

ISR3:
mov ah, 09h
mov dx, offset avgodd
int 21h            
iret ; Return from interrupt and popping the flags, CS, and the IP

; Calculate LCM
conlcm:

; used to Calculate the LCM
check:
xor ax, ax
add al, max
mov bx, lcm 
add bx, ax
mov lcm, bx
xor ax, ax
 
mov ax, lcm
mov bl, w 
div bl
cmp ah, 0
jne check

mov ax, lcm
mov bl, x 
div bl
cmp ah, 0
jne check

mov ax, lcm
mov bl, y 
div bl
cmp ah, 0
jne check

mov ax, lcm
mov bl, z 
div bl
cmp ah, 0
jne check

; Used to output the LCM value
;mov ah, 09h   
;mov dx, offset lcm
;int 21h            

HLT
;data used for testing
.data
w db 08h
x db 04h
y db 03h
z db 01h 
min db 0h
max db 0h
lcm dw 0h
avgint dw "Average is not an integer$"
avgodd dw "Average is odd$"
                               


ret   ; return to the operating system.









