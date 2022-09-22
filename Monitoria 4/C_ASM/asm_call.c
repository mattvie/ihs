#include <stdio.h>
extern long product4(long, long, long, long);

int main()
{
    int var1 = 1, var2 = 2, var3 = 3, var4 = 4;
    printf("Product: %ld\n", product4(var1, var2, var3, var4));
    return 0;
}