#include <stdio.h>
#include <stdlib.h>

char buf[128];

int main() {
    int n;
    while ((n = read(0, buf, 128)) != 0) {
        write(1, buf, n);
    }
    return 0;
}
