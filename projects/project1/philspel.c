/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

int main(int argc, char **argv)
{
  if (argc != 2)
  {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  return 0;
}

unsigned int stringHash(void *s)
{
  char *string = (char *)s;
  unsigned int total = 0;
  while (*string)
  {
    total += (int)*string;
    string++;
  }
  return total % 2255;
}

int stringEquals(void *s1, void *s2)
{
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  return strcmp(string1, string2);
}

void readDictionary(char *dictName)
{
  FILE *fp = fopen(dictName, "r");
  if (!fp)
  {
    fprintf(stderr, "File not exists.");
    exit(1);
  }
  char c;
  unsigned int length = 0, capcity = 60;
  char *string = calloc(capcity, sizeof(char));
  while ((c = fgetc(fp)) != EOF)
  {
    // expand
    if (length == capcity)
    {
      capcity *= 2;
      string = realloc(string, capcity);
    }
    if (c != '\n')
    {
      string[length++] = c;
    }
    else
    {
      string[length++] = '\0';
      insertData(dictionary, string, string);

      capcity = 60;
      string = calloc(capcity, sizeof(char));
      length = 0;
    }
  }
  fclose(fp);
}

void processInput()
{
  char c;
  unsigned int length = 0, capcity = 60;
  char *string = calloc(capcity, sizeof(char));
  int isWord = 1, isFound = 0;
  while (1)
  {
    c = getchar();
    if (length == capcity)
    {
      capcity *= 2;
      string = realloc(string, capcity);
    }

    if (c == '\n' || c == ' ' || c == EOF)
    {
      // word finish
      string[length++] = '\0';
      if (isWord && length > 1)
      {
        if (findData(dictionary, string))
          isFound = 1;
        char *cursor = string + 1;
        while (*cursor)
        {
          *cursor = tolower(*cursor);
          cursor++;
        }
        if (findData(dictionary, string))
          isFound = 1;
        *string = tolower(*string);
        if (findData(dictionary, string))
          isFound = 1;
        if (isWord && !isFound)
          printf(" [sic]");
      }
      // clean up
      length = 0;
      isWord = 1;
      isFound = 0;
    }
    else
    {
      // word middle
      if (!isalpha(c))
        isWord = 0;
      string[length++] = c;
    }
    if (c == EOF)
      break;
    putchar(c);
  }
}
