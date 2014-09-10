SECTION .bss
  cText:      resq  1  ; reserve 16 bytes for cypher text
  left2:      resq  1  ; reserved 8 bytes for l2
  right2:     resq  1  ; reserved 8 bytes for r2 

SECTION .data
  left0:      dq    0xA0000009
  right0:     dq    0x8000006B
  key0:       dq    0x90001C55
  key1:       dq    0x1234ABCD
  key2:       dq    0xFEDCBA98
  key3:       dq    0xE2468AC0
  delta1:     dq    0x11111111
  delta2:     dq    0x22222222
  pFormat:    db    "C  = 0x%016x", 10, 0
  mask:       dq    0x00000000FFFFFFFF
SECTION .text
  global main
  extern printf
main:
  mov r15, [mask]
  
  mov r8, [right0]          ;
  mov r9, [key0]        ;
  mov r10, [key1]       ;
  mov r11, [delta1]     ;
  mov r13, [left0]           ;
  mov rax, left2
  call _encrypt_half

  mov r8, [left0]          ;
  mov r9, [key2]        ;
  mov r10, [key3]       ;
  mov r11, [delta2]     ;
  mov r13, [right0]           ;
  mov rax, right2
  call _encrypt_half

  mov rdi, pFormat
  mov rsi, [right2]
  xor rax, rax
  call printf

  ; Terminate program
  mov rax,1            ; 'exit' system call
  mov rbx,0            ; exit with error code 0
  int 80h              ; call the kernel

_encrypt_half:
  mov r12, r8
  shl r8, 4             ; shift left by 4
  add r9, r8            ; add key to msg << 4
  and r9, r15           ; mask most sig 32 bits

  add r11, r12          ; msg + delta
  and r11, r15          ; mask most sig 32 bits

  mov r8, r12           ; fresh msg
  shr r8, 5             ; shift msg right 5
  add r8, r10           ; add key to msg >> 5
  and r8, r15           ; mask most sig 32 bits

  xor r8, r9            ;
  xor r11, r8           ; 

  mov r8, r13           ;
  add r8, r11           ; this is encrypted
  and r8, r15
  mov [rax], r8           ; store it
  mov rdi, pFormat
  mov rsi, r8
  xor rax, rax
  call printf
  ret
