#include <stdio.h>
typedef int (*fptr)();
fptr example2 (int n)
{
  void h ()
    { printf("%d", n); }
    return h;
}
int main()
{
    fptr h = example2(5);
    h();
    return 0;
}
