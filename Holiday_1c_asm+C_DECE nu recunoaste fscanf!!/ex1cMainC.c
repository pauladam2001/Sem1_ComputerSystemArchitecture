#include <stdio.h>

void function(FILE* file1, FILE* file2, char stringWithNumbersInBase2[]);

int main()
{
    char stringWithNumbersInBase2[100] = "";
    
    FILE* file1;
    FILE* file2;
    
    file1 = fopen("File1.txt", "r");
    file2 = fopen("File2.txt", "a");
    
    function(file1, file2, stringWithNumbersInBase2);
    
    fclose(file1);
    fclose(file2);
    return 0;
}
                  