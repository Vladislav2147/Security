#include <iostream>
#include <sstream>

#include <cmath>
#include "BigInteger.h"


BigInteger powych(BigInteger x, int n) {
    if (n == 0) return 1;
    BigInteger result = BigInteger(x);
    for (int i = 0; i < n - 1; i++) {
        result *= x;
    }
    return result;
}

//Decode digit and return BigInteger value
BigInteger decodeDigit(char digit)
{
    //We have digit greater than 10 (A, B, C etc.)
    if (digit >= 65)
        //'A' has value 65 in ASCII, so 65 - 55 is 10, 'B' has value 66 so 66 - 55 is 11 etc.
        return digit - 55;
    else
    {
        std::string val;
        val += digit;
        return std::stoi(val);
    }
}

std::string HexToDec(std::string value) {
    BigInteger val = 0;
    int power = value.length() - 1;

    for (unsigned int i = 0; i < value.length(); i++)
    {
        val += decodeDigit(value[i]) * powych(16, power);
        power--;
    }

    std::stringstream buffer;
    buffer << val;
    return buffer.str();
}

std::string DecToHex(std::string value) {
    char digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    std::string sysValTemp, sysVal;
    BigInteger decVal = BigInteger(value);

    while (decVal != 0)
    {
        sysValTemp += digits[(int)(decVal % 16).to_int64()];

        decVal /= 16;
    }

    //Revert value
    for (int i = sysValTemp.length() - 1; i >= 0; i--)
        sysVal += sysValTemp[i];

    return sysVal;
}

std::string DecToBin(std::string value) {
    char digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    std::string sysValTemp, sysVal;
    BigInteger decVal = BigInteger(value);

    while (decVal != 0)
    {
        sysValTemp += digits[(int)(decVal % 2).to_int64()];

        decVal /= 2;
    }

    //Revert value
    for (int i = sysValTemp.length() - 1; i >= 0; i--)
        sysVal += sysValTemp[i];

    return sysVal;
}

