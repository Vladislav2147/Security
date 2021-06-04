#include <stdio.h>
#include <emscripten/emscripten.h>
#include "bigint_in_one.h"

#ifdef __cplusplus
extern "C" {
#endif

    EMSCRIPTEN_KEEPALIVE int someFunc(int num) {
        bigint a = 5;
        return num + 1;
    }

    EMSCRIPTEN_KEEPALIVE int myFunction(int num) {
        return someFunc(num);
    }

#ifdef __cplusplus
}
#endif