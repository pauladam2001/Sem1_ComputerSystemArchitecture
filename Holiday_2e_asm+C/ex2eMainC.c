#include <stdio.h>

int function(char text[]);

int main()
{
    char text[100] = "";
    int nrOfWords = 0;
    int len = 100;
    
    FILE* file;
    file = fopen("File1.txt", "r");
    
    fread(text, 1, len, file);
    //fread(text, sizeof(text), 1, file);
    printf("The text is: %s \n", text);
    
    nrOfWords = function(text);
    
    printf("Number of words = %u", nrOfWords);
    
    fclose(file);
    return 0;
}
