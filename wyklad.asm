in ax,dx
out dx,ax

out addr,al
in al,addr

in al,dx
out dx,al

----BX
zawiera offset segmentu

mov bx,4
mob ax, word ptr ds:[bx]
mov word ptr es:[bx], al

--CX
licznik
rep movsb
loop POS1
jest flaga w do i++ albo i--
----DX
przy in out
przy mnożeniu dzieleniu

mov ax,450
mov bx,2
mul bx; w dx-ax wynik mnożenia ax * bx wynik dx-ax bo jest 32-bitowy (mnozenie 16bitow daje 32bity)

mov dx,100
mov ax,3
out dx,ax

---SI
do operacji na ciągach danych do offsetow
mov si, offset

---SP
stack pointer chyba ze nie uzywamy stosu to mozna do czego innego
push ax
pop ax

---BP
base pointer
jak bx 
do trzymania offsetu

----IP
instruction pointer
CS:[IP] - wskazuje na nastepna instrukcje
call ADDR
jmp ADDR
ret
int NR
call near ptr - dla skokow w tym samym segmencie
-------------
SEGMENTOWE DS ES SS CS
nie da sie bezposrednio, trzeba przez ax

mozna przez stos np
push cs
pop es
wymaga odwolania do pamieci wiec jest wolniejszy
lepiej co sie da zalatwiac w srodku procesora

argumenty jak procedury w C mozna robic

TRYB GRAFICZNY
13h
320x200 256 kolorow

   320 
|------> x
|......    200
|......
v
y

0A000h - adres segmentowy pamieci grafiki
        jesli damy offset 00 to punkt (0,0)

Addr = 320y + x 
BIOS basic input output system
przerwania biosu 10h
do ah numer funkcji
mov ah,0 zmiana tryb karty VGA
mov al,13h ; tryb graf 320x200 256col
-----
mov, 0A000h
mov es,ax
mov ax, word ptr cs:[y]
mov bx, 320
mul bx ; do pary dx-ax = ax * bx
;nigdy nie przekroczy dx i zawsze wyjdzie dx 0 bo male liczby
mov bx, word ptr cs:[x] ; bx = x
add bx, ax ; do bx dodajemy ax
mov byte ptr es:[bx], al ;wrzucamy zawartosc koloru czyli al

mov word ptr cs:[x], 0
mov word ptr cs:[y], 10
mov byte ptr,cs:[k], 15
call zapal


>>>> zmienne mozna przeniesc do code1 na sam koniec zeby wygodniej w jednym segmencie
definiujemy x,y, k

instrukcje trybu graficznego

-----
;czekaj na klawisz
mov al,3h

xor ax,ax ; zeruj ax
int 16h - przerwanie klawiatury czekaj na klawisz

