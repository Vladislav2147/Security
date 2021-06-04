#define _CRT_SECURE_NO_WARNINGS 1

#include <iostream>
#include <sstream>

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


//
//char** myFunction(const char* scalar) {
//    bigint p = bigint(scalar);
//    char* qxqy[2];
//    std::string str1 = p.to_string();
//    int len = str1.length() + 1;
//    qxqy[0] = new char[len];
//    qxqy[1] = new char[len];
//    strcpy_s(qxqy[0], len, str1.c_str());
//    strcpy_s(qxqy[1], len, str1.c_str());
//    return qxqy;
//}

char** multiply(char* cM, char* ca, char* cb, char* cqx, char* cqy, char* cscalar) {

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
    int lenx = gx.length() + 1;
    int leny = gy.length() + 1;
    static char* qxqy[3];
    qxqy[0] = new char[lenx];
    qxqy[1] = new char[leny];
    qxqy[2] = new char[sizeof(time)];
    strcpy_s(qxqy[0], lenx, gx.c_str());
    strcpy_s(qxqy[1], leny, gy.c_str());
    strcpy_s(qxqy[2], sizeof(time), time);
    return qxqy;
}

char** multiply_with_default(char* scalar) {
    return multiply(
        (char*)default_p,
        (char*)default_a ,
        (char*)default_b,
        (char*)default_qx,
        (char*)default_qy,
        scalar);
}

int main()
{

    cout << "begin" << endl;
    char** qeqe = multiply_with_default((char*)"69E273C25F23790C9E423207ED1F283418F2749C32F033456739734BB8B5661F");
    cout << qeqe[0] << endl;
    cout << qeqe[1] << endl;
    cout << qeqe[2] << endl;
    return 0;
}

