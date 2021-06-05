#include <iostream>
#include <sstream>
#include <emscripten/emscripten.h>
#include <cmath>
#include "elliptic_curve.h"
#include "BigInteger.h"
#include "converter.h"


using namespace std;

const char* default_p = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF43";
const char* default_a = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40";
const char* default_b = "77CE6C1515F3A8EDD2C13AABE4D8FBBE4CF55069978B9253B22E7D6BD69C03F1";
const char* default_qx = "0";
const char* default_qy = "6BF7FC3CFB16D69F5CE4C9A351D6835D78913966C408F6521E29CF1804516A93";


extern "C" EMSCRIPTEN_KEEPALIVE char* multiply(char* cM, char* ca, char* cb, char* cqx, char* cqy, char* cscalar) {

    BigInteger M = BigInteger(HexToDec(cM));
    BigInteger a = BigInteger(HexToDec(ca));
    BigInteger b = BigInteger(HexToDec(cb));
    BigInteger qx = BigInteger(HexToDec(cqx));
    BigInteger qy = BigInteger(HexToDec(cqy));
    BigInteger scalar = BigInteger(HexToDec(cscalar));
    EllipticCurve ec(a, b, M);
    Point Q(qx, qy);

    stringstream x;
    stringstream y;
    char time[100] = {};
    Point R = ec.scalarMultiply(scalar, Q, time);
    x << R.getX();
    y << R.getY();

    std::string gx = DecToHex(x.str().c_str());
    std::string gy = DecToHex(y.str().c_str());
    
    char result[10000] = {};
    sprintf(
        result,
        "%s\t\t%s\t\t%s",
        gx.c_str(), gy.c_str(), time);
    return result;
}

extern "C" EMSCRIPTEN_KEEPALIVE char* multiply_with_default(char* scalar) {
    return multiply(
        (char*)default_p,
        (char*)default_a,
        (char*)default_b,
        (char*)default_qx,
        (char*)default_qy,
        scalar
    );
}


