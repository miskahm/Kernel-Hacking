#include "types.h"
#include "stat.h"
#include "user.h"


int
main (int argc, char *argv[])
{
    int i = 0;
    if(argc < 2)
    {
        //Count systemcalls if only one argument is given
        count(i);
        exit();
    }
    else if (argc == 2)
    {
        if (strcmp(argv[1],"-r") ==0)
        {
            i = 1;
            count(i);
            exit();
        }
        printf(2,"Usage: 'count' or 'count -r'\n");
        exit();
    }
    
    printf(2,"Usage: 'count' or 'count -r'\n");
    exit();
}
