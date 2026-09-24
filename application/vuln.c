#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void win(void)
{
    printf("\n[+] win(): shell nel container avviata\n");
    fflush(stdout);
    system("/bin/sh");
}

void vulnerable(void)
{
    char buffer[64];
    printf("Inserisci il tuo nome: ");
    fflush(stdout);
    read(0, buffer, 256);
    printf("Ciao, %s\n", buffer);
}

int main(void)
{
    setvbuf(stdout, NULL, _IONBF, 0);
    vulnerable();
    printf("Programma terminato normalmente.\n");
    return 0;
}
