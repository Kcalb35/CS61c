#include "ll_cycle.h"
#include <stddef.h>

int ll_has_cycle(node *head) {
  node *tortoise, *hare;
  tortoise = hare = head;
  while (1) {
    if (tortoise &&  tortoise->next)
      tortoise = tortoise->next;
    else
      return 0;
    if (hare && hare->next && hare->next->next)
      hare = hare->next->next;
    else
      return 0;
    if (tortoise == hare)
      return 1;
  }
}
