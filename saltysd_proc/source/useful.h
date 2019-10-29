#ifndef USEFUL_H
#define USEFUL_H

#include <switch.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>

static inline void SaltySD_printf(const char* format, ...)
{
    char buffer[256];

    va_list args;
    va_start(args, format);
    vsnprintf(buffer, 256, format, args);
    va_end(args);
    
    svcOutputDebugString(buffer, strlen(buffer));
    
    FILE* f = fopen("sdmc:/SaltySD/saltysd.log", "ab");
    if (f)
    {
        fwrite(buffer, strlen(buffer), 1, f);
        fclose(f);
    }
}


#define debug_log(...) \
    {char log_buf[0x200]; snprintf(log_buf, 0x200, __VA_ARGS__); \
    svcOutputDebugString(log_buf, strlen(log_buf));}
    
#endif // USEFUL_H
