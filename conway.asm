datasg	SEGMENT BYTE 'veri'

n       DW 10

datasg	ENDS
stacksg	SEGMENT BYTE STACK 'yigin'
		DW 200 DUP(?)
stacksg	ENDS 

codesg1	SEGMENT PARA 'kod1'
		ASSUME CS:codesg1

CONWAY  PROC FAR     
        PUSH BP
        PUSH AX
        PUSH BX
        PUSH DX 
        ;n,CS,IP,BP,AX,DX,AX(n),CS,IP,BP,AX,DX
        MOV BP, SP 
        MOV AX, [BP+12] 
         
        CMP AX, 0
        JNE neToZero 
        MOV WORD PTR[BP+12], 0
        JMP done
neToZero:CMP AX, 2
        JA repeat
        MOV WORD PTR[BP+12], 1    
        JMP done
           
repeat: DEC AX        
        PUSH AX
        CAll FAR PTR CONWAY  ;a(n-1)
        POP BX
        INC AX
        SUB AX, BX           ;n-a(n-1)
        PUSH AX
        CAll FAR PTR CONWAY  ;a(n-a(n-1))
        POP DX
        PUSH BX
        CALL FAR PTR CONWAY ;a(a(n-1))
        POP BX

        ADD BX, DX
        MOV [BP+12], BX
done:   POP DX
        POP BX
        POP AX
        POP BP
        RETF
        ;recur with the new value  
                 
CONWAY  ENDP
codesg1 ENDS

codesg2	SEGMENT PARA 'kod2'
		ASSUME CS:codesg2
PRINTINT PROC FAR           
    MOV CX,0 
    MOV DX,0 
    label1:  
        CMP AX,0 
        JE print1        
        MOV BX,10          
        DIV BX                    
        PUSH DX               
        INC CX               
        XOR DX,DX 
        JMP label1 
    print1:  
        CMP CX,0 
        JE exit
        POP DX 
        ADD DX,48 
        MOV AH,02h 
        INT 21h 
        DEC CX 
        JMP print1 
exit: 
ret 
PRINTINT ENDP 
codesg2 ENDS

codesg3	SEGMENT PARA 'kod3'
		ASSUME CS:codesg3, DS:datasg, SS:stacksg    
		
main	PROC FAR
		PUSH DS				
		XOR AX, AX
		PUSH AX
		MOV AX, datasg		
		MOV DS, AX	
            
        PUSH n        
        CALL FAR PTR CONWAY       
        POP AX
        CALL FAR PTR PRINTINT
		
		RETF
main	ENDP
codesg3	ENDS
		END main