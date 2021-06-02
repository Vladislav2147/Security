#include <stdio.h>
#include <emscripten/emscripten.h>

#ifdef __cplusplus
extern "C" {
#endif
    EMSCRIPTEN_KEEPALIVE
    int myFunction(int num) {
        return num + 1;
    }

#ifdef __cplusplus
}
#endif