
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    FILE *fp_bin = NULL;
    unsigned char c = 0;
    char *binary_file_name = NULL;
    char *array_name = NULL;
    unsigned long array_size = 0;
    int opt = 0;

    extern char *optarg;
    extern int optind, opterr, optopt;

    while ((opt = getopt(argc, argv, "i:")) != -1)
    {
        switch (opt)
        {
        case 'i':
            binary_file_name = optarg;
            break;
        default:
            break;
        }
    }

    if (optind >= argc)
    {
        fprintf(stderr, "Expected argument after options\n");
        exit(EXIT_FAILURE);
    }

    array_name = argv[optind];

    if (binary_file_name == NULL)
    {
        fp_bin = stdin;
    }
    else
    {
        fp_bin = fopen(binary_file_name, "rb");
        if (fp_bin == NULL)
        {
            perror("fopen");
            fprintf(stderr, "File not found: binary_file_name: %s\n", binary_file_name);
            exit(EXIT_FAILURE);
        }
    }

    /* read binary file and convert C array and it's count. */
    printf("const unsigned char %s_array[] = {\n\t", array_name);
    while (1)
    {
        c = fgetc(fp_bin);
        if (feof(fp_bin))
        {
            break;
        }
        printf("0x%02x, ", c);
        array_size++;
        if ( array_size % 10 == 0)
        {
            printf("\n\t");
        }
    }
    printf("\n};\n");
    printf("const unsigned long %s_size = %lu;\n\n", array_name, array_size);

    if (binary_file_name)
    {
        fclose(fp_bin);
    }
}
