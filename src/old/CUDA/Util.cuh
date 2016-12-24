#pragma once

#define CALL_CUDA( err ) \
{ if (err != cudaSuccess) \
    {std::cout<<"cuda Error "<< cudaGetErrorString(err)<<" in "<<__FILE__<<" at line "<<__LINE__<<"\n"; exit(EXIT_FAILURE); }\
}

#define NOT_FOUND_DEV  56546456;

__device__ void MemCpyDev(char *dest, const char *src, size_t len, size_t offset = 0)
{
	for (size_t i = 0; i < len; ++i) {
		dest[i+offset] = src[i];
	}
}

__device__ size_t StrLenDev(const char *str)
{
  const size_t MAX_LEN = 10000;
	for (size_t i = 0; i < MAX_LEN; ++i) {
		const char &c = str[i];
		if (c == '\0') {
			return i;
		}
	}

	return NOT_FOUND_DEV;
}

__device__ void AppendStr(char *dest, UINT32 &destSize, const char *str)
{
	size_t len = StrLenDev(str);
	MemCpyDev(dest, str, len, destSize);
	destSize += len;
}

__device__ void AppendStr(char *dest, const char *str)
{
	UINT32 destSize = 0;
	AppendStr(dest, destSize, str);
}

__device__ void swap(char &a, char &b)
{
	char c = a;
	a = b;
	b = c;
}

__device__ void reverse(char str[], int length)
{
    int start = 0;
    int end = length -1;
    while (start < end)
    {
        swap(*(str+start), *(str+end));
        start++;
        end--;
    }
}

__device__ char* itoa(int num, char* str, int base)
{
    int i = 0;
    bool isNegative = false;

    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }

    // In standard itoa(), negative numbers are handled only with
    // base 10. Otherwise numbers are considered unsigned.
    if (num < 0 && base == 10)
    {
        isNegative = true;
        num = -num;
    }

    // Process individual digits
    while (num != 0)
    {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }

    // If number is negative, append '-'
    if (isNegative)
        str[i++] = '-';

    str[i] = '\0'; // Append string terminator

    // Reverse the string
    reverse(str, i);

    return str;
}

__device__ char * dtoa(char *s, double n) {
	const double PRECISION = 0.00000000000001;
	const int MAX_NUMBER_STRING_SIZE = 32;

    // handle special cases
    if (isnan(n)) {
    	AppendStr(s, "nan");
    } else if (isinf(n)) {
    	AppendStr(s, "inf");
    } else if (n == 0.0) {
    	AppendStr(s, "0");
    } else {
        int digit, m, m1;
        char *c = s;
        int neg = (n < 0);
        if (neg)
            n = -n;
        // calculate magnitude
        m = log10(n);
        int useExp = (m >= 14 || (neg && m >= 9) || m <= -9);
        if (neg)
            *(c++) = '-';
        // set up for scientific notation
        if (useExp) {
            if (m < 0)
               m -= 1.0;
            n = n / pow(10.0, m);
            m1 = m;
            m = 0;
        }
        if (m < 1.0) {
            m = 0;
        }
        // convert the number
        while (n > PRECISION || m >= 0) {
            double weight = pow(10.0, m);
            if (weight > 0 && !isinf(weight)) {
                digit = floor(n / weight);
                n -= (digit * weight);
                *(c++) = '0' + digit;
            }
            if (m == 0 && n > 0)
                *(c++) = '.';
            m--;
        }
        if (useExp) {
            // convert the exponent
            int i, j;
            *(c++) = 'e';
            if (m1 > 0) {
                *(c++) = '+';
            } else {
                *(c++) = '-';
                m1 = -m1;
            }
            m = 0;
            while (m1 > 0) {
                *(c++) = '0' + m1 % 10;
                m1 /= 10;
                m++;
            }
            c -= m;
            for (i = 0, j = m-1; i<j; i++, j--) {
                // swap without temporary
                c[i] ^= c[j];
                c[j] ^= c[i];
                c[i] ^= c[j];
            }
            c += m;
        }
        *(c) = '\0';
    }
    return s;
}

