# Reverse Engineering

**mystery1() - calculeaza lungimea unui sir**

@str - adresa de inceput a sirului

La o prima vedere, functia are un singur argument. Urmarind in
GDB, se pare ca ruland executabilul cu parametri, aceasta functie
este apelata pentru contorizarea lungimii fiecarui string dat ca
parametru programului. Functia itereaza prin string in cautarea
terminatorului de sir (0x00). Argumentul functiei trebuie sa fie 
adresa unui sir ASCIIZ, intrucat singura conditie de terminare a 
buclei este gasirea unui byte "0x00".

Return: lungimea sirului.

prototip: int strlen(const char* str)


**mystery2() - cauta un caracter intr-un sir si daca exista
             returneaza pozitia sa in sir**

@str: adresa de inceput a sirului in care se cauta

@chr: caracterul cautat

La o prima vedere, functia are 2 argumente. Urmarind in GDB,
observam ca functia este apelata o singura data de catre
functia print_line care la randul ei este apelata de catre
functia mystery9. Aceasta functie este folosita in afisarea
unei linii prin cautarea terminatorului de linie "\n" (0xa).
Functia parcurge sirul si compara fiecare caracter in parte
cu caracterul primit ca parametru. Functia are un bug, si anume
faptul ca nu se verifica daca am parcurs tot sirul, facandu-se
comparatii cu caracterul cautat si dincolo de dimensiunea
sirului in care cautam. Se va iesi din bucla numai la gasirea
terminatorului de linie.

Return: indexul primei aparitii a caracterului chr in sirul str.

prototip: int strcspn(const char* str, const char chr)


**mystery3() - compara primele n caractere din sirurile date ca 
             parametru**

@str1: adresa de inceput a primului sir

@str2: adresa de inceput a celui de-al doilea sir

@num: numarul de caractere de comparat

La o prima vedere, functia are 3 argumente. Urmarind in GDB, 
observam faptul ca aceasta este apelata de repetate ori in
functia parse_opt pentru identificarea optiunilor rularii
executabilului (-f, -i, -s, -e). Functia itereaza prin cele 2
siruri si compara cele 2 siruri caracter cu caracter. Daca
sirurile difera prin cel putin un caracter, functia returneaza
1, altfel returneaza 0. Functia are un bug, si anume ca nu se
efectueaza verificarea corectitudinii celui de-al treilea
parametru, presupunandu-se ca aceasta verificare este facuta
inaintea apelului acestei functii. Astfel, pentru doua siruri
de 8 caractere se poate apela functia cu num = 10 si se poate
face un buffer overflow. Mai mult, pentru un num suficient de
mare, se poate accesa o zona de memorie interzisa, programul
terminandu-se cu semnalul SIGSEV - Segmentation Fault.

Return: 1 - sirurile difera, 0 - sirurile sunt identice.

prototip: int strncmp(const char* str1, const char* str2, int num)


**mystery4() - copiaza num caractere din sirul sursa in sirul dest**

@destination: adresa de inceput a sirului destinatie

@source: adresa de inceput a sirului sursa

@num: numarul de caractere de copiat

La o prima vedere, functia are 3 argumente. Urmarind in
GDB, se observa ca pentru optiunea -i [file] data ca parametru,
programul va apela mai intai mystery1 pentru a obtine lungimea
numelui fisierului, iar apoi va apela mystery4 pentru a copia
numele fisierului in memorie. Functia are un bug, si anume
faptul ca nu se verifica lungimea sursei, putandu-se copia mai
multe caractere decat lungimea sirului daca o verificare a
parametrilor nu este efectuata inaintea apelului.

prototip: void strncpy(const char* destination, const char* source, int num)


**mystery5() - verifica daca un caracter ascii este cifra**

@chr: caracterul de verificat

La o prima vedere, functia are un singur argument. Urmarind in
GDB, functia este apelata o singura data de catre functia
mystery7. Functia verifica caracterul primit ca argument. Daca
acesta se afla in intervalul [0x30 , 0x39], functia va intoarce
valoarea 1, altfel functia va intoarce valoarea 0.

Return: 1 - daca caracterul este cifra, 0 - altfel.

prototip: int isnumber(const char chr)


**mystery6() - inverseaza un sir**

@str: adresa de inceput a sirului

La o prima vedere, functia are un singur argument. Urmarind in
GDB, se observa ca aceasta functie este apelata strict de
catre functia mystery7 care este apelata in parse_args. 
Functia apeleaza functia mystery1 pentru a determina lungimea
sirului primit ca argument si isi aloca pe stiva spatiu pentru
stocarea sirului in ordine inversa, parcurgandu-l de la coada
la cap. Dupa aceea, se apeleaza functia mystery4 pentru a copia
in eax sirului inversat de pe stiva si se va actualiza sirul cu
inversul sau.

prototip: void strrev(const char* str)


**mystery7() - converteste un sir format din cifre in valoarea sa
             intreaga**

@str: adresa de inceput a sirului de convertit

La o prima vedere, functia are un singur argument. Urmarind in
GDB, se observa ca aceasta functie este apelata strict in functia
parse_args si este folosita pentru a converti in numere valorile
date ca parametru programului pentru optiunile -s si -e. Functia
apeleaza mai intai mystery1 pentru a calcula numarul de iteratii,
iar apoi mystery6 pentru a inversa sirul. Apoi urmeaza o bucla
software in care se parcurge sirul caracter cu caracter si se
apeleaza functia mystery5 care verifica daca acel caracter este
cifra sau nu. Daca este cifra, se converteste din caracter in
cifra prin scaderea valorii "0" din ASCII (0x30) si se obtine
valoarea cifrei reprezentata prin acel caracter. Totodata,
functia retine local pe stiva valoarea de return a functiei pe
care o actualizeaza la fiecare iteratie, inmultind valoarea
curenta cu 10 si adunand cifra curenta.

Return: valoarea numarului reprezentat ca sir de caractere.

prototip: int atoi(const char* str)


**mystery8() - cauta patternul dat intr-un string**

@str: adresa de inceput a stringului

@pattern: adresa de inceput a patternului

@size: dimensiunea patternului

La o prima vedere, functia primeste 3 argumente. Urmarind in
GDB, se observa faptul ca aceasta functie este apelata de catre
functia mystery9 in momentul in care aceasta a gasit un terminator
de linie. Functia va cauta patternul in string pana la gasirea lui
"\n". Functia foloseste 2 contori locali, unul pentru string la 
[ebp - 4] si unul pentru pattern la [ebp - 8]. Cautarea patternului
se face comparand caracter cu caracter string-ul cu patternul pana
la gasirea unui match sau pana la intalnirea terminatorului de
linie. 

Return: 1 - linia contine patternul dat, 0 - linia nu contine patternul.

prototip: int searchpattern(const char* str, const char* pattern, int size)


**mystery9() - Cauta patternul dat in string in intervalul [start, stop]**

@str: adresa de inceput a sirului de parsat

@start: indicele de start

@stop: indicele de stop

@pattern: patternul cautat

La o prima vedere, functia primeste 4 argumente. Urmarind in GDB,
se observa faptul ca aceasta functie se va apela numai daca dam
programului optiunea "-f" pentru cautarea unui pattern. Functia
va calcula adresa de inceput a stringului conform indicelui de
start si va calcula lungimea patternului. Functia verifica daca
in intervalul [start stop] se afla un terminator de linie. Daca
nu se afla niciun terminator de linie, functia isi va incheia
executia. Daca un terminator de linie "\n" este gasit, se apeleaza
functia mystery8 pentru sirul incepand de la indicele de start
care va decide daca linia respectiva contine patternul pe care
programul il primeste ca parametru. Daca linia contine patternul,
se va apela functia print_line pentru afisarea liniei si se va trece
la urmatoarea linie.

prototip: void fgrep(char* str, int start, int stop, char* pattern)


**start() - functia main a programului**

@argc: numarul de parametri ai executabilului

@argv: parametrii executabilului

La o prima vedere, functia are doua argumente. Urmarind in GDB,
se pare ca ruland executabilul fara parametri, programul are un
comportament diferit fata de rularea acestuia cu parametri.
Acest fapt este datorat functiei start care salveaza in memorie
parametrii programului si verifica daca executabilul are parametri.
De aici, daca programul nu are parametri se apeleaza functia
do_simple_echo si functia do_exit si se iese din program. Altfel,
daca programul are parametri, se apeleaza functiile parse_args si
do_run si apoi do_exit pentru a iesi din program. Codul este
incarcat cu operatii inutile precum nop-uri sau push-uri si alocare
de memorie nefolosita pe stiva.

prototip: void start(int argc, char const *argv[])


**do_simple_echo() - functia care citeste maxim 32 de caractere de la
	           tastatura si le afiseaza la consola**

La o prima vedere, functia nu are argumente. Urmarind in GDB, se pare
ca ruland executabilul, programul asteapta ca noi sa introducem date
de la tastatura. Daca introducem peste 32 de caractere, vor fi
salvate si afisate doar primele 32 de caractere, in timp ce celelalte
vor fi considerate comenzi in afara programului. In interiorul functiei
se apeleaza functiile do_read si do_write pentru citirea de la tastatura
si afisarea la consola. String-ul citit in functia do_read este salvat in
stack frame-ul functiei do_simple_echo, de unde este preluat de catre
functia do_write pentru afisarea la consola.

prototip: void do_simple_echo()


**do_read() - citeste size caractere din stream in buffer**

@stream: de unde se citeste (0 - stdin sau file descriptor)

@buffer: zona de memorie in care se citeste

@size: numarul de caractere citite

La o prima vedere, functia are 3 argumente. Urmarind in GDB, se pare ca
ruland executabilul fara parametri, programul va apela functia
do_simple_echo de unde se apeleaza functia do_read pentru a se citi de la
tastatura. Ruland executabilul cu parametri, se vor apela functiile
parse_args si do_run iar in do_run se va apela functia read_from_file
care apeleaza functia do_read pentru a citi din fisier. Astfel, aceasta
functie este folosita de program atat pentru citirea de la tastatura cu
apelul do_read(0, buff, 32), cat si pentru citirea din fisier cu apelul
do_read(fp, buffer, size). 

Return: numarul de caractere citite

prototip: int do_read(FILE* stream, char* buffer, int size)


**do_write() - scrie size caractere din buffer in stream**

@stream: unde se scrie (1 - stdout sau file descriptor)

@buffer: zona de memorie din care se scrie

@size: numarul de caractere scrise

La o prima vedere, functia are 3 argumente. Urmarind in GDB, se pare ca
ruland executabilul fara parametri, programul va apela functia
do_simple_echo de unde se apeleaza functia do_write pentru a se scrie la
consola. Ruland executabilul cu parametri, se vor apela functiile
parse_args si do_run iar in do_run se va apela functia mystery9 care
apeleaza functia print_line care apeleaza functia do_write dar si functia
print_string care la randul ei apeleaza functia do_write. In toate 3
cazurile, do_write va afisa la tastatura, avand apelul
do_write(1, buffer, size).

Return: numarul de caractere scrise

prototip: int do_write(FILE* stream, char* buffer, int size)

**do_open() - deschide un fisier**

@filename: numele fisierului de deschis

@accmode: tipul de acces pentru fisier

@permission: permisiunile pe fisier

La o prima vedere, functia primeste 3 argumente. Urmarind in GDB, se
observa faptul ca aceasta functie este apelata in interiorul functiei
read_from_file pentru a deschide fisierul. Aceasta functie va apela
syscall_wrapper cu codul 5 pentru un apel de sistem in care fisierul
va fi deschis. 

Return: file descriptor-ul fisierului

prototip: FILE* do_open(const char* filename, int accmode, int permission)

**do_close() - inchide un fisier**

@stream: file descriptor-ul fisierului de inchis

La o prima vedere, functia primeste un singur argument. Urmarind in GDB,
se observa faptul ca aceasta functie este apelata in interiorul functiei
read_from_file pentru a inchide fisierul deschis anterior. Aceasta functie
va apela syscall_wrapper cu codul 6 pentru un apel de sistem in care
fisierul va fi inchis.

prototip: void do_close(FILE* stream)


**read_from_file() - citeste maxim num caracter dintr-un fisier**

@filename: numele fisierului din care se citeste

@buffer: adresa de memorie a bufferului in care se citeste

@num: numarul maxim de caractere citite

La o prima vedere, functia primeste 3 argumente. Urmarind in GDB,
se observa faptul ca aceasta functie este apelata de catre functia
do_run doar in cazul in care programul a primit ca parametru un
fisier din care sa citeasca. Se apeleaza functia do_open pentru a
deschide fisierul si se retine descriptorul de fisier local pe
stiva. Dupa care se apeleaza functia do_read pentru a citi maxim
num caractere din fisier. Dupa citire, se inchide fisierul prin
apelarea functiei do_close si se returneaza numarul de caractere
citite.

Return: numarul de caractere citite.

prototip: int read_from_file(const char* filename, char* buffer, int num)


**do_exit() - scoate programul din executie**

@error: codul de eroare cu care se iese din executia programului

La o prima vedere, programul primeste un singur argument. Urmarind in GDB,
se observa faptul ca in urma apelarii acestei functii, programul isi va
incheia executia. Acest fapt este dator apelarii functiei syscall_wrapper
cu optiunea de oprire a programului. 

prototip: void do_exit(int error)


**parse_args() - parseaza argumentele programului si le salveaza in memorie**

La o prima vedere, functia nu primeste niciun parametru. Urmarind in GDB,
se observa faptul ca aceasta functie se foloseste de parametrii programului
care au fost salvati in memorie in functia start. Functia verifica daca sunt
date optiuni programului si retine local pe stiva la ebp - 16 ce optiuni au
fost date si salveaza in memorie numele sirului (pentru -i), patternul cautat
(pentru -f), indexul de inceput (pentru -s) si indexul de sfarsit. Functia
parseaza string-ul argv din 4 in 4 pentru a extrage argumentele pe rand, dupa
care verifica daca argumentul este o optiune (incepe cu "-" 0x2d) si daca da
se apeleaza functia parse_opt care va returna ce optiune s-a dat dupa "-".
In functie de optiunea gasita se retine in memorie parametrul fiecarei optiuni
si se trece la urmatorul argument. Pentru parsarea tuturor argumentelor se
retine la nivel local un contor pentru cati parametri au fost parsati. Dupa
parsarea unui argument se verifica daca acel contor a ajuns la valoarea argc.
Daca da, se reia parsare, altfel executia functiei se incheie.

prototip: void parse_args()


**parse_opt() - parseaza o optiune data ca parametru programului**

@option: adresa de inceput a optiunii

La o prima vedere, functia primeste un singur argument. Urmarind in GDB, se
observa faptul ca aceasta functie preia argumentul si il compara, pe rand
cu "-f", "-s", "-e" si "-i". Mai intai, functia apeleaza mystery1 pentru a
calcula lungimea optiunii. Daca lungimea difera de 2, se iese din executia
programului. Altfel, se va face comparatia cu "-f" prin intermediul functiei
mystery3. Daca optiunea este "-f" se va returna valoarea 8. Altfel, se va face 
comparatia cu "-s". Daca optiunea este "-s" se va returna valoarea 2. Altfel,
se va face comparatia cu "-e". Daca optinea este "-e" se va returna valoarea 4.
Altfel, se va face comparatia cu "-i". Daca optiunea este "-i" se va returna
valoarea 1. Daca optiunea difera de toate cele 4 se va returna 0xfffffffe.

Return: tipul comenzii.

prototip: int parse_opt(const char* option)


**do_run() - ruleaza functionalitatea programului in functie de optiunile date
           ca argument**

La o prima vedere, functia nu primeste niciun argument. Urmarind in GDB, se 
observa faptul ca aceasta se apeleaza numai in cazul rularii executabilului
cu parametri. Pe baza unei variabile din memorie salvate in functia parse_args
care retine ce optiuni au fost date executabilului, aceasta functie verifica
mai intai daca executabilul a primit optiunea "-f". Daca da, se va apela
functia read_from_file. Altfel, se va apela functia do_read si se va citi de la
tastatura. Apoi se verifica daca exeutabilul a primit optiunea "-s". Daca da,
se retine in registru indexul de start. Daca nu, indexul de start va fi 0.
Apoi se verifica daca executabilul a primit optiunea "-e". Daca da, se retine
in registru indexul de stop. Daca nu, indexul de stop va fi sfarsitul sirului
citit, fie din fisier, fie de la tastatura.


**print_line() - afiseaza o linie la consola**

@str: adresa de inceput a liniei

La o prima vedere, functia primeste un singur argument. Urmarind in GDB, se
observa faptul ca aceasta functie este apelata de catre mystery9 pentru a
afisa la consola liniile din fisier care contin patternul data ca parametru
programului prin "-f". Functia verifica prin apelul lui mystery2 daca
sirul contine terminator de linie sau nu. Daca aceasta contine un terminator
de linie, se va apela functia print_string. Altfel, se va apela functia 
do_write.

prototip: void print_line(const char* str)


**print_string() - afiseaza un sir la consola**

@str: adresa de inceput a sirului

La o prima vedere, functia primeste un singur argument. Urmarind in GDB, se
observa faptul ca aceasta functie este apelata de catre print_line atunci
cand sirul contine un terminator de linie. Functia calculeaza lungimea sirului
prin metoda mystery1 si apeleaza functia do_write pentru afisare.

prototip: void print_string(const char* str)



Programul implementeaza o parte din comanda bash fgrep. Acesta poate primi ca
argumente optiunile "-i" pentru a cauta intr-un fisier, "-f" pentru a cauta un
pattern anume, "-s" pentru a cauta de la un anumit index din fisier si "-e"
pentru a cauta pana la un anumit index in fisier. Rulat fara parametri, acesta
va citi de la tastatura un sir si il va afisa. 

La nivel de optimizari:

**SIZE:**
1) Am inlocuit instructiuni de tipul add eax, 1 cu inc eax si altele de genul
2) Am reimplementat mystery1 cu o bucla hardware
3) Am eliminat functia mystery6


**SPEED:**
1) Am optimizat algoritmul de la atoi in mystery7, renuntand la apelul functiilor
mystery5 si mystery6
2) Am eliminat verificarea unor conditii inutile
3) Am extras portiuni din cod din bucle
