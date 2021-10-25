
section .data
repl_prompt: db "Heya> "
ret_0: db "You entered 0!"
section .bss
; Input
  inp resb 1
section .text
  global _start
_exit:
  mov rax, 60
  mov rdi, 0
  syscall
  ; ===============|
    ; _START
    ; Prints prompt by calling _show_prompt:
    ;, takes input, calls _parse:, on ret, checks for change in
    ; exit flag. If the exit flag has not been changed, then jumps to itself.
    ; ===============|
  _start:
    ; Check for exit code set to 1:
    mov rdi, 1
    cmp rdi, inp
    je _exit
    mov rdi, 0
    je _retzer
    ; Read
    call _prompt
    call _repl_input
    ; Evaluate
    mov rsi, inp
    mov rax, 1
    mov rdi, 1
    mov rdx, 2
    syscall
    mov rsi, 10
    mov rax, 1
    mov rdi, 1
    mov rdx, 2
    syscall
    ; Loop
    jmp _start
    ; ===============|
    ; _REPL_INPUT
    ; Takes kernel standard in, returns to _repl.
    ; ===============|
  _repl_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, inp
    mov rdx, 64
    syscall
    ret
    ; ===============|
    ; _PROMPT
    ; Prints prompt, returns to _repl
    ; ===============|
  _prompt:
    mov rax, 1
    mov rdi, 1
    mov rsi, repl_prompt
    mov rdx, 6
    syscall

    ret
    _retzer:
    mov rax, 1
    mov rdi, 1
    mov rsi, ret_0
    mov rdx, 14
    syscall
