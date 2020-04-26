; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   MASM汇编格式
;   全局变量的定义
     Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
     Up_Rt equ 2                  ;
     Up_Lt equ 3                  ;
     Dn_Lt equ 4                  ;
     delay equ 50000					; 计时器延迟计数,用于控制画框的速度
     ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
;     .386
     org 7c00h					; 程序加载到100h，可用于生成COM/7c00H引导扇区程序
;    ASSUME cs:code,ds:code				；org伪指令置于汇编语言程序的开始，规定程序开始的位置
;   code SEGMENT
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
                mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax				; DS = CS
	mov es,ax					; ES = CS
	mov ax,0B800h				; 文本窗口显存起始地址
	mov es,ax					; ES = B800h
	mov byte[char],'A'
	mov di,0
	mov cx,28
	call DispStr
	jmp loop1
DispStr:
	xor ax,ax
	mov dh,8ch
 	mov dl, byte[BootMessage+di] 
  	mov [es:di],dl
	mov si,0
	inc di
	loop DispStr
  	ret

loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	inc si
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,50
	sub ax,bx
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  dr2dl
	jmp show
dr2ur:
      mov word[x],48
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt	
      jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],1
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1  ;100
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],1
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,50
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],48
      mov byte[rdul],Up_Lt	
      jmp show
	
show:	
	push cx
	push es
	push dx
	push di

	mov di,0
    	xor ax,ax                 ; 计算显存地址
      	mov ax,word[x]
	mov bx,80		
	mul bx	
	mov di,ax	
	mov ax,word[y]
	mov bx,2
	mul bx
	add di,ax

	mov dl, byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov dh,8ch
	mov [es:di],dl			;  显示字符的ASCII码值

	pop di
	pop dx
	pop es
	pop cx
	jmp loop1
	
end:
    jmp $                   ; 停止画框，无限循环 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 2
    y    dw 0
    char db 'A'
    BootMessage db '1','0','8','0','3','0','4','0','0','0','0','0','9','0','6','0','L','0','i','0','X','0','i','0','n','0','$'
;code ENDS
;     END start
