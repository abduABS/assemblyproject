name "mycode"   ; output file name (max 8 chars for DOS compatibility)

org  100h	; set location counter to 100h



ret   ; return to the operating system.

msg         db "press any key..."
msg_size =  $ - offset msg






