SECTION .bss
  r2:         resb  4  ; reserved 4 bytes for r2 
  l2:         resb  4  ; reserved 4 bytes for l2

SECTION .data
  hello:     db 'Hello world!',10
  helloLen:  equ $-hello
  r0:         dd    0xA0000009
  l0:         dd    0x8000006B
  key0:       dd    0x90001C55
  key1:       dd    0x1234ABCD
  key2:       dd    0xFEDCBA98
  key3:       dd    0xE2468AC0
  delta1:     dd    0x11111111
  delta2:     dd    0x22222222
  pFormat:    db    "%#010x", 10, 0
  mask:       dq    0x00000000FFFFFFFF
SECTION .text
  global main
  extern printf
main:

  mov r8, [r0]           ;
  mov r9, [key0]         ;
  mov r10, [key1]        ;
  mov r11, [delta1]      ;
  mov r12, r8           ; r0 to reuse

  shl r8, 4              ; shift r0 left by 4
  add r9, r8            ; add key0 to r0 << 4
  
  add r11, r12          ; r0 + delta1

  mov r8, r12           ; fresh r0
  shr r8, 5              ;
  add r8, r10           ; add key1 to r0 >> 5

  xor r8, r8            ;
  xor r11, r8           ; 

  mov r8, [l0]           ;
  add r8, r11           ; this is l2
  mov [l2], r8           ; store it
 
  ;mov edx, 4             ; length = 4 bytes
  
  
  ; Write 'Hello world!' to the screen
  ;mov eax,4            ; 'write' system call
  ;mov ebx,1            ; file descriptor 1 = screen
  ;mov ecx,hello        ; string to write
  ;mov edx,helloLen     ; length of string to write
  ;int 80h              ; call the kernel

  ; Terminate program
  mov eax,1            ; 'exit' system call
  mov ebx,0            ; exit with error code 0
  int 80h              ; call the kernel
