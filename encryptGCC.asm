SECTION .bss
  r2:         resb  4  ; reserved 4 bytes for r2 
  l2:         resb  4  ; reserved 4 bytes for l2

SECTION .data
  l0:         dq    0xA0000009
  r0:         dq    0x8000006B
  key0:       dq    0x90001C55
  key1:       dq    0x1234ABCD
  key2:       dq    0xFEDCBA98
  key3:       dq    0xE2468AC0
  delta1:     dq    0x11111111
  delta2:     dq    0x22222222
  pFormat:    db    "0x%08x", 10, 0
  mask:       dq    0x00000000FFFFFFFF
SECTION .text
  global main
  extern printf
main:

  mov r15, [mask]
  mov r8, [r0]          ;
  mov r9, [key0]        ;
  mov r10, [key1]       ;
  mov r11, [delta1]     ;
  mov r12, r8           ; r0 to reuse

  shl r8, 4             ; shift r0 left by 4
  add r9, r8            ; add key0 to r0 << 4
  and r9, r15           ; mask most sig 32 bits

  add r11, r12          ; r0 + delta1
  and r11, r15          ; mask most sig 32 bits

  mov r8, r12           ; fresh r0
  shr r8, 5             ; shift r0 right 5
  add r8, r10           ; add key1 to r0 >> 5
  and r8, r15           ; mask most sig 32 bits

  xor r8, r9            ;
  xor r11, r8           ; 

  mov r8, [l0]           ;
  add r8, r11           ; this is l2
  and r8, r15
  mov [l2], r8           ; store it

  mov rdi, pFormat
  mov rsi, r8
  xor rax, rax

  call printf

  ; Terminate program
  mov eax,1            ; 'exit' system call
  mov ebx,0            ; exit with error code 0
  int 80h              ; call the kernel
