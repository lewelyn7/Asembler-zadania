 ## Program 1

### Opis:

Proszę napisać program szyfrujący plik w oparciu o funkcję XOR i hasło wieloznakowe. Wynikiem działania programu powinna być zaszyfrowana kopia pliku wejściowego.

Zakładając, że zawartością pliku wejściowego jest np. tekst:

> "Wszyscy wiedzą, że czegoś nie da się zrobić, aż znajdzie się taki jeden, który nie wie, że się nie da, i on to robi."

a hasłem jest np.:

> "Albert Einstein "

to wówczas szyfrowanie powinno wyglądać następująco:

Wszyscy wiedzą, że czegoś nie da się zrobić, aż (…)  
XOR  
Albert Einstein Albert Einstein Albert Einstein (…)

Zatem hasło powtarzamy tutaj cyklicznie.

Czyli:

'W' xor 'A'

's' xor 'l'

'z' xor 'b'

'y' xor 'e'

's' xor 'r'

'c' xor 't'

'y' xor ' '   (czyli:  y xor spacja )

' ' xor 'E'

'w' xor 'i'

itd...

Szyfrowanie jest symetryczne, więc tym samym hasłem plik powinien móc być odszyfrowany.

Przykład wywołania programu:

```
program1  plik_wej  plik_wyj  "klucz do szyfrowania tekstu"
```

Po uruchomieniu, program powinien wypisać na ekranie wczytane dane, a na końcu powinien wypisać komunikat że proces zakończył się poprawnie lub z błędem.

---

## Program 2

### Opis:

Proszę napisać program, którego parametrami przy uruchamianiu będą cyfra reprezentująca ZOOM oraz dowolny krótki tekst. Po naciśnięciu klawisza ENTER, program powinien wyświetlić na ekranie w trybie graficznym VGA (320x200, 256 kol) podany wcześniej w linii komend tekst powiększony ZOOM razy, wykorzystując do tego wyłącznie bezpośredni dostęp do pamięci obrazu. Do tworzenia obrazu nie wolno wykorzystywać gotowych funkcji DOS oraz BIOS. Program powinien pozwolić na powrót do systemu operacyjnego po naciśnięciu dowolnego klawisza.

Przykład wywołania programu:

```
program 8 To jest tekst!   
```

Efekt może wyglądać np. tak:

![](./image002.jpg)