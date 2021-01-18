datasg segment PARA 'data'
	n dw 10
	datasg ends
stacksg segment stack PARA 'stack'
	dw 50 dup(?)
	stacksg ends

conwaysg segment para 'conwayy'
    assume cs:conwaysg,ds:datasg,ss:stacksg
	conway proc far
		push ax
		push bx
		push cx
		push bp
		;stack: ds,0,n,cs,offset,ax,bx,cx,bp 
		mov bp,sp
		mov ax,[bp+12]	
		cmp ax,0
		je l1
		cmp ax,3
		jae l2
		mov ax,1
		jmp last
l1: 	mov ax,0
		jmp last			
l2:     dec ax
        push ax
        inc ax
        call conway
        pop bx 
        push bx
        call conway
        pop cx
        sub ax,bx
        push ax
        call conway
        pop ax
        add ax,cx
last: 	mov [bp+12],ax
		pop bp
		pop cx
		pop bx
		pop ax
		retf
		conway endp
		conwaysg ends

codesg segment PARA 'code'
	assume cs:codesg,ds:datasg,ss:stacksg
	main	proc near
			push ds
			xor ax, ax
			push ax
			mov ax, datasg
			mov ds, ax
			
			push n
			call conway
			pop n
			push n
			call printint
		    retf
		    main endp
			
			
	printint proc near
		push ax
		push bx
		push cx
		push dx
		push bp
		
		mov bp, sp
		mov ax, 10
		mov bx, [bp+12]

l3: mov cx, 10
        mul cx
        cmp ax, bx
        jna l3
        div cx
        xchg ax, bx        
l4:     
        xor dx, dx   

        div bx 
        push dx 
        xor dx, dx
        xchg ax, bx
        div cx
        xchg ax, bx
        pop dx 
        xchg ax, dx
          
        push ax
           
        mov ah, 2
        add dl, '0'
        int 21h
        pop ax
        cmp ax,0
        ja l4
		
		pop bp
		pop dx
		pop cx
		pop bx
		pop ax

		ret 2
		printint endp
		codesg ends
		end main
	



