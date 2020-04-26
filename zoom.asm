data1 segment
tekst db 256 dup("$")
zoom db 0 
zoomstr db 4 dup("$")
zoomtytul db 10,"powiekszenie: ", "$"
teksttytul db 10,"tekst: ", "$"
tekstlen dw 0
znakiplik db "ZNAKI.TXT",0
znakibufor db 85 dup("$")
bladargs db 10, "blad parsowania argumentow","$"
blad_znaki_plik db 10,"blad otwarcia pliku z danymi","$"
bladodczytuplikus db 10,"blad odczytu pliku ze znakami","$"
bladustawieniaoffsetus db 10,"blad ustawienia offsetu", "$"
debugg db 10,"debug..","$"
znakihandle dw 0
args db 256 dup(0)
arglen dw 0
linenumber db 0
letterit db 0
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
        ;rep movsb ; movs from ds:si to es:di
        
;loop for parsing arguments TODO $ escaping
        xor cx,cx
        mov cl, ds:[80h]
        dec cx
        mov si, 82h
        mov di, offset zoomstr
        mov al, " "
zoomloop:
        cmp ds:[si], al
        je tekstj
        mov ah, ds:[si]
        mov es:[di], ah
        inc si
        inc di
        loop zoomloop
        mov ax, offset bladargs
        push ax
        call wypisz
        call koniec
tekstj:
        ;;parsowanie str
        sub ah, 48d
        mov es:[zoom], ah

        inc di
        mov ah, 0
        mov ds:[si], ah
        mov di, offset tekst
        inc si
        dec cx
tekstloop:
        mov ah, ds:[si]
        mov es:[di], ah
        inc si
        inc di
        inc es:[tekstlen]
        loop tekstloop

        mov ah, 0
        mov ds:[di], ah
       
        mov ax, seg tekst 
        mov ds,ax

        ;;wypisywanie argumentow
        mov ax, offset zoomtytul
        push ax
        call wypisz
        pop ax
        mov ax, offset zoomstr
        push ax
        call wypisz
        pop ax

        mov ax, offset teksttytul
        push ax
        call wypisz
        pop ax
        mov ax, offset tekst
        push ax
        call wypisz
        pop ax


        mov si, offset tekst
        mov cx, ds:[tekstlen]

        ;uruchomienie trybu graficznego
        mov ah, 0
        mov al, 13h
        int 10h

        mov bx, 0A000h
        mov es, bx

dlakazdejlitery:
        push cx
        push si
        ;otwieranie pliku ze znakami
        mov dx, offset znakiplik
        mov al, 0
        call otworz
        mov ds:[znakihandle], ax
        jb bladotwarcia
        
        mov al, ds:[si]

        ;TODO Closing files
znajdzloop:
        ;przygotownie do czytania
        mov ah, 3Fh
        mov bx, ds:[znakihandle]
        mov dx, offset znakibufor
        xor cx, cx
        mov cx, 84d 
        int 21h
        jb bladoodczytupliku
        mov al, ds:[si]
        cmp al, ds:[znakibufor+1]
        je znaleziono
;        push ax
;        mov ax, offset tekst
;        push ax
;        call wypisz
;        pop ax
;        pop ax
;
;        ;move file pointer
;        mov ah,42h  ;move file function
;        mov al, 1   ;move from current position
;        ;;in bx already is handle
;        mov cx, 0   ;most significant part of offset
;        mov dx, 84d ;least significant part of offset
;        int 21h
;        jb bladustawieniaoffsetu

        jmp znajdzloop
znaleziono:


        xor cx,cx
        mov cx, 8d
osiemrazydlalinii:        
        push cx
       
        ;ustawianie pozycji na bitmapie
        mov di, offset znakibufor  ; w di offset bitmapy
        add di, 4d                 ; zeby ominac znak i skoczyc do bitmapy odrazu
        mov ax, 8d
        sub ax, cx
        mov bx, 10d
        mul bx
        add di, ax
        
        mov ax, 8d
        sub ax, cx  ;
        mov bx, 320d
        mul bx      ; w ax jest adres w trakcie wyliczania ax = nr_lini*320
        mov cl, ds:[letterit]
        add ax, cx
        xor bx,bx
        mov bl, ds:[zoom]
        mul bx ; teraz razy zoom
       


        xor cx, cx
        mov cl, ds:[zoom]
razyzoomlinie:
        push cx
        
        xor cx,cx
        mov cl, 8d
razykolumny:
        push cx
        
        xor cx,cx
        mov cl, ds:[zoom]
razyzoomkolumny:
        push cx

        ; tutaj dzikie rzeczy
        
        mov bl, "0"
        cmp ds:[di], bl
        je wypelnijzerem
        jmp wypelnijjedynka
wypelnijzerem:
        mov bl, 0d
        push di
        mov di, ax
        mov es:[di], bl
        pop di
        jmp powypelnieniu
wypelnijjedynka:
        mov bl, 4d
        push di
        mov di, ax 
        mov es:[di], bl
        pop di
powypelnieniu:

        inc ax      ; aby zapalamy nastepny piksel
        pop cx
        loop razyzoomkolumny

        inc di      ; skaczemy na nastepne miejsce bitmapy
        
        pop cx
        loop razykolumny

        sub di, 8d  ; wracamy do poczatku lini w bitmapie
        add ax, 320d ; offset calego wiersza

        push ax
        mov ax, 8d
        xor bx,bx
        mov bl, ds:[zoom]
        mul bx
        mov bx, ax
        pop ax
        sub ax, bx
        pop cx
        loop razyzoomlinie
        

        pop cx
        loop osiemrazydlalinii


        pop si
        inc si
        add ds:[letterit], 8d
        pop cx

        dec cx
        jne dlakazdejlitery

        mov ah, 3Eh
        mov bx, ds:[znakihandle]
        int 21h

        xor ax,ax
        mov al, 3h
        int 16h
        
        mov ax, 3
        int 16

        call koniec
        
koniec:
        mov   ax,4c00h
        int   21h
        ret
bladarg:
        mov ax, offset bladargs
        push ax
        call wypisz
        call koniec

bladotwarcia:
        mov ax, offset blad_znaki_plik
        push ax
        call wypisz
        call koniec

bladustawieniaoffsetu:
        mov ax, offset bladustawieniaoffsetus
        push ax
        call wypisz
        call koniec

bladoodczytupliku:
        mov ax, offset bladodczytuplikus
        push ax
        call wypisz
        call koniec
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
