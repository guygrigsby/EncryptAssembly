SECTION .bss
  left2:      resq  1  ; reserved 16 bytes for l2
  right2:     resq  1  ; reserved 16 bytes for r2 

SECTION .data
  left0:      dq    0xA0000009
  right0:     dq    0x8000006B
  key0:       dq    0x90001C55
  key1:       dq    0x1234ABCD
  key2:       dq    0xFEDCBA98
  key3:       dq    0xE2468AC0
  delta1:     dq    0x11111111
  delta2:     dq    0x22222222
  mFormat:    db    "m = %x%x", 10, 0
  cFormat:    db    "c = %x%x", 10, 0
  encrypt:    dq    0x1
  mask:       dq    0x00000000FFFFFFFF
SECTION .text
  global main
  extern printf
main:

  mov rdi, mFormat
  mov rsi, [left0]
  mov rdx, [right0]
  xor rax, rax          ; printf uses rax for # of vector args
  call printf

  mov r15, [mask]
  
  mov r8, [right0]          ;
  mov r9, [key0]        ;
  mov r10, [key1]       ;
  mov r11, [delta1]     ;
  mov r13, [left0]           ;
  mov rax, left2
  mov rbx, [encrypt]
  call _do_half         ; pushes rip onto stack and jumps to _do_half

  mov r8, [left2]          ;
  mov r9, [key2]        ;
  mov r10, [key3]       ;
  mov r11, [delta2]     ;
  mov r13, [right0]           ;
  mov rax, right2
  mov rbx, [encrypt]
  call _do_half
  
  mov rdi, cFormat
  mov rsi, [left2]
  mov rdx, [right2]
  xor rax, rax          ; printf uses rax for # of vector args
  call printf

  mov r8, [left2]          ;
  mov r9, [key2]        ;
  mov r10, [key3]       ;
  mov r11, [delta2]     ;
  mov r13, [right2]           ;
  xor rbx, rbx
  call _do_half
  
  mov rdx, r8

  ;mov r8, [right0]     ; already there
  mov r9, [key0]        ;
  mov r10, [key1]       ;
  mov r11, [delta1]     ;
  mov r13, [left2]           ;
  xor rbx, rbx
  call _do_half
  
  mov rsi, r8
  mov rdi, mFormat
  xor rax, rax          ; printf uses rax for # of vector args
  call printf
  
  
  ; Terminate program
  mov rax,1            ; 'exit' system call
  mov rbx,0            ; exit with error code 0
  int 80h              ; call the kernel

_do_half:
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

  mov r8, r13           ; other half of message
  
  cmp rbx, [encrypt]
  jne dec
  add r8, r11           ; this is encrypted
  and r8, r15           ; mask most sig 32 bits
  mov [rax], r8         ; store it
  jmp end
dec:
  sub r8, r11           ; this is decrypted
  and r8, r15           ; mask most sig 32 bits
end:
  ret                   ; pops top of stack into rip
