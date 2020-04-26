data1 segment
arglen dw 0 
haslolen dw 0
buf db 256 dup(0)
plik1 db 16 dup("$")
plik2 db 16 dup("$")
haslo db 256 dup("$")
przeczytano dw 0
plik1string db 10, "plik1: ", "$"
plik2string db 10, "plik2: ", "$"
haslostring db 10, "haslo: ", "$"
blad_args db 10, "blad parsowania argumentow","$"
bladotwarcias db 10,"blad otwarcia pliku","$"
bladczytanias db 10,"blad czytania z pliku","$"
bladutworzeniaplikus db 10,"blad utworzenia pliku", "$"
uchwytplik1 dw ?
uchwytplik2 dw ?

args db 256 dup(0)
data1 ends

code1 segment
start1:
        ; set up sack
        mov ax, seg stos1
        mov ss,ax
        mov sp, offset stos1
        

        ;copy to args, set arglen
        mov ax, seg args
        mov es, ax
        mov di, offset args
        mov cx, 0
        mov cl, byte ptr ds:[80h]
        dec cx
        mov word ptr es:[arglen],cx
        mov si, 82h
        rep movsb ; movs from ds:si to es:di
        
        ;set ds to data segment
        mov ds, ax
        
;loop for parsing arguments 
        mov cx, ds:[arglen]
        mov di, offset args
        mov si, offset plik1
        mov al, " "         ; space for comparing
plik1loop:
        cmp ds:[di], al
        je plik2s
        mov ah, ds:[di]     ; ah as tmp mem
        mov ds:[si], ah
        inc si
        inc di
        loop plik1loop
        mov ax, offset blad_args    ; raise exception
        push ax
        call wypisz
        call koniec
plik2s:
        inc si
        mov ah, 0
        mov ds:[si], ah
        mov si, offset plik2 
        inc di
        dec cx
plik2loop:
        cmp ds:[di], al
        je haslos
        mov ah, ds:[di]
        mov ds:[si], ah
        inc si
        inc di
        loop plik2loop
        mov ax, offset blad_args
        push ax
        call wypisz
        call koniec
haslos:
        inc si
        mov ah, 0
        mov ds:[si], ah
        mov si, offset haslo
        inc di
        mov ds:[haslolen], cx
        dec cx
hasloloop:
        cmp ds:[di], al
        mov ah, ds:[di]
        mov ds:[si], ah
        inc di
        inc si
        loop hasloloop
        mov ah, 0
        mov ds:[si], ah
        
        ;;wypisywanie argumentow
        mov ax, offset plik1string
        push ax
        call wypisz
        pop ax
        mov ax, offset plik1
        push ax
        call wypisz
        pop ax

        mov ax, offset plik2string
        push ax
        call wypisz
        pop ax
        mov ax, offset plik2
        push ax
        call wypisz
        pop ax

        mov ax, offset haslostring
        push ax
        call wypisz
        pop ax
        mov ax, offset haslo
        push ax
        call wypisz
        pop ax
        ;;otwieranie plikow
        mov dx, offset plik1
        mov al, 0
        call otworz
        jb bladotwarcia
        mov ds:[uchwytplik1], ax

        mov dx, offset plik2
        mov al, 1
        call otworz
        mov ds:[uchwytplik2], ax
        jnb poutworzeniu

        ;;tworzenie pliku i otwieranie
        mov ah, 3Ch; create file func
        mov cx, 2  ; TODO attribute
        mov dx, offset plik2
        int 21h
        jb bladutworzeniapliku
        mov al, 1
        mov dx, offset plik2
        call otworz
        mov ds:[uchwytplik2], ax
        jb bladotwarcia 
poutworzeniu: 
czytajzplikuloop:
        mov ah, 3fh
        mov bx, word ptr ds:[uchwytplik1]
        mov cx, 256d
        lea dx, offset buf 
        int 21h
        jb bladczytania
        cmp ax, 0
        je poszyfrowaniu
        mov ds:[przeczytano], ax
        mov cx, ax 
        mov si, offset buf
        mov di, offset haslo
szyfrujloop:
        mov ah, ds:[di]
        cmp ah, 0
        jne pozerowaniu
        mov di, offset haslo
pozerowaniu:
        mov al, ds:[di]
        xor ds:[si], al 
        inc si
        inc di
        loop szyfrujloop
zapis:  mov ah, 40h
        mov bx, ds:[uchwytplik2]
        mov cx, ds:[przeczytano]
        mov dx, offset buf
        int 21h
        mov ax, ds:[przeczytano]
        cmp ax, 0d
        jne czytajzplikuloop
poszyfrowaniu: 
        call koniec
bladotwarcia:
        mov ax, offset bladotwarcias
        push ax
        call wypisz
        call koniec
bladczytania:
        mov ax, offset bladczytanias
        push ax
        call wypisz
        call koniec
bladutworzeniapliku:
        mov ax, offset bladutworzeniaplikus
        push ax
        call wypisz
        call koniec
koniec:
        mov   ax,4c00h
        int   21h
        ret
error:
        mov ah,9
        lea dx, blad_args
        int 21h
        ret

;wypisz offset napisu na stacku
wypisz: 
        push ax
        push dx
        push di
        mov di, sp
        add di, 8
        mov dx, ss:[di]
        mov ax, 0
        mov ah, 9
        int 21h
        pop di
        pop dx
        pop ax
        ret

otworz: ; in dx filename, handle returned in ax,  al 0read-only, 1write-only
        mov ah, 3dh ; open file command
        int 21h     ; interrupt if file exists handle returned in ax
        ret
code1 ends

stos1 segment stack
        dw 100 dup(?)
        top1 dw ?
stos1 ends

end start1
