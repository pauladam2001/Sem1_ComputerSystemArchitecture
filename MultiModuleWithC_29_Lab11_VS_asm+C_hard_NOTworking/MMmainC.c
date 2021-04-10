#include <stdio.h>

void MMmirror(char sir1[], char sir2[]);

//Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 

int main()
{
    char given_sentence[100] = "";
    char new_word[100] = "";
    
    printf("Introduce the sentence: ");
    gets(&given_sentence);
    //printf("You entered: %s \n", given_sentence);
    MMmirror(given_sentence, new_word);
    printf("This program just ended!");
    return 0;
}
    