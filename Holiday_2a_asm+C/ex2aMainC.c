#include <stdio.h>

int function(char character, char text[]);

void readString(char text[], int len, FILE* file1);

int main()
{
    char text[100] = "", character;
    int len = 100, nrOfAppearences = 0;
    
    FILE* file1;
    FILE* output;
    
    file1 = fopen("File1.txt", "r");
    output = fopen("output.txt", "w");
    
    //fread(text, 1, len, file1);
    readString(text, len, file1);
    
    printf("Introduce the character: ");
    scanf("%c", &character);
    
    printf("The sentence is: %s \n", text);
    printf("The char is: %c \n", character);
    
    nrOfAppearences = function(character, text);
    
    printf("The given character appears %u times \n", nrOfAppearences);
    printf("The new text is: %s", text);
    
    fclose(file1);
    fclose(output);
    return 0;
}

void readString(char text[], int len, FILE* file1)
{
    fread(text, 1, len, file1);
}
