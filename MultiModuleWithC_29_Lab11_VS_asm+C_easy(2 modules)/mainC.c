#include <stdio.h>

void function(char sir1[], char sir2[]); //declare the procedure defined in the assembly code

//Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 

int main()
{
    char given_sentence[100] = "";
    char new_word[100] = "";
    
    printf("Introduce the sentence: ");
    gets(&given_sentence);  //read the sentence from the keyboard
    //printf("You entered: %s \n", given_sentence);
    function(given_sentence, new_word); //call the function that reverse the words in assembly
    printf("This program just ended!");
    return 0;
}