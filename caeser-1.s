;compile as shown
;nasm -f elf caeser.sm( output is the object file)
;ld -m elf_i386 -s -o caeser caeser.o(creating the executable file)
;./caeser (execution)

;declaring constant variables
sys_exit equ 1
sys_write equ 4
sys_read equ 3
stdin equ 0
stdout equ 1
stderr equ 2


segment	.text
	global _start		;declared while using gcc


_start:				; entry point for linker

mov eax, message2		;message
mov ebx, length2		;buffer size
call out

mov eax, sys_read		;sys_call (read)
mov ebx, stdin			;standard input
mov ecx, inputStr		;store the input
mov edx, 11			;read the bytes
int 0x80			;syscall 


mov eax, message		;message(stdout)
mov ebx, length			;buffer size
call out

mov eax, sys_read		;sys_call(read)
mov ebx, stdin			;standard input
mov ecx, input2			;store value
mov edx, 4096			;read the bytes
int 0x80			;syscall


mov ebx, message		;preparing ebx
call stringlength		;count length of string


push eax			;save length to stack
mov ecx, eax			;transfer length to eax
dec ecx				;ecx -1

mov ebx, inputStr		;converting the input to integer
call str_int

mov ebx, 26			;ebx == 26
call modulus			;performing a modulus calculation

mov ebx, eax			;transfer eax to ebx
mov eax, input2			;transfer input2 to eax

cipher:
    call change_alphabet
    inc eax			;next char
    dec ecx			;counter = counter - 1
    jnz cipher			;jump while counter !=0

    mov eax, Result
    mov ebx, lengthresult
    call out
    
    mov eax, input2
    pop ebx
    call out
    
    
    mov eax, sys_exit
    int 0x80
    
    
change_alphabet:
    cmp byte[eax], 'A'		;if char lowercase
    jb .return			;if yes return
    
    
    cmp byte[eax], 'Z'		;if char uppercase
    jbe .UPPER			;if yes, uppercase
     
     
    cmp byte[eax], 'z'		;if >z
    ja .return			;if yes return
    
    cmp byte[eax], 'a'		;if >a
    jae .lower			;lowercase
    
    jmp .return
    
    
    
.UPPER:
    add byte [eax], bl		;shift the char
    cmp byte[eax], 'Z'		;
    jbe .return			;finish the function
    
    sub byte [eax], 26		;if not -26
    
    jmp .return
    
    
    
.lower:
    add byte[eax], bl		;shift the char
    cmp byte [eax], 'z'		;
    jbe .return			;finish func
    
    sub byte[eax], 26		;if not -26
.return:
    ret 












segment .bss
inputStr resb 11		;declaring variable for our shift(string)

inputInt resb 4			;11 bytes for the shifter string(int) 

input2 resb 4096		;4096 bytes for string





segment .data
message db 'Please enter your text: '
length equ $ -message

message2 db 'Enter your shift value (0 to 1000): '
length2 equ $ -message2

Result db `Result is : \u001b[32m`
lengthresult equ  $ -Result

errorMsg db "Exiting..."
lenErrorMsg equ $ - errorMsg


out:
    ;save registers
    push eax
    push ebx
    push ecx
    push edx
    
    mov ecx, eax        ; Move message in ECX
    mov edx, ebx        ; Specify size
    mov eax, sys_write  ; sys_write
    mov ebx, stdout     ; stdout
    int 0x80            ; syscall
    
    ;recover registers
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret






print_error:
    ; Print error
    mov eax, sys_write          ; sys_write
    mov ebx, stderr          ; stderr
    mov ecx, errorMsg
    mov edx, lenErrorMsg
    int 0x80            ; syscall

    ; Exit
    mov eax, sys_exit
    int 0x80




stringlength:
    ; Save registers
    push ebx
    push ecx                

    xor ecx, ecx            ; Clear ECX
    
do_slen:
    cmp byte [ebx], 0       ; Is current char empty?
    jz end_slen             ; If yes, jump to end
    
    inc ecx                 ; Increase counter
    inc ebx                 ; Move onto next character
    jmp do_slen             ; Continue loop
    
end_slen:
    mov eax, ecx            ; Place return value in EAX

    ; Recover registers
    pop ecx
    pop ebx
    ret

str_int:
    ; Save registers
    push ebx
    push ecx
    push edx

    call stringlength          ; Get string length
    mov ecx, eax       ; Put length in ecx
    dec ecx            ; For \n
    
    xor eax, eax       ; EAX = 0
    
do_digit:
    ; Check if char is between 0 and 9
    cmp byte [ebx], '0'
    jb print_error
    cmp byte [ebx], '9'
    ja print_error
    
    push eax            ; Save EAX
    push ebx            ; Save EBX
    
    ; Put 10^ECX in eax
    dec ecx             ; Temporarily decrease for next function
    mov ebx, 10
    call power          ; Call function
    inc ecx             ; Increase it back
    
    pop ebx             ; Recover
    
    ; EDX = int(ebx[n])
    xor edx, edx
    mov dl, [ebx]       ; EDX = EBX[0]
    sub edx, '0'        ; EDX = EDX - '0'
    
    ; EAX *= EDX   ->     EAX = EBX[n] * 10^ECX
    mul edx             ; EAX = EDX * i32
    mov edx, eax
    
    pop eax
    
    add eax, edx        ; Result += EBX[0] * 10^ECX
    inc ebx             ; Move on next char
    dec ecx             ; Update counter
    jnz do_digit
    
    ; Recovering the  registers
    pop edx
    pop ecx
    pop ebx
    
    ret

power:
    ; Save registers
    push ecx            ; Save ECX
    push ebx            ; Save EBX

    xor eax, eax        ; Empty result | EAX = 0
    inc eax             ; EAX = 1
    
    cmp ecx, 0          ; Is ECX == 0
    je end_power        ; If so, end function
    
do_power:
    mul ebx             ; EAX *= EBX
    dec ecx             ; Update counter
    jnz do_power        ; While counter != 0
    
end_power:
    ; Recover registers
    pop ebx             ; Recover EBX
    pop ecx             ; Recover ECX
    
    ret

modulus:
    push edx            ; Save EDX
    xor edx, edx        ; Empty EDX
    div ebx             ; EDX:EAX / EBX | quotient -> EAX; modulus -> EDX

    mov eax, edx        ; Store result in eax
    pop edx             ; Restore EDX
    ret                 ; Return

