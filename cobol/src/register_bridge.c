#include <libcob.h>

extern int REGISTER(char *name, char *pin, char *result);

void register_bridge(char *name, char *pin, char *result) {
    cob_init(0, NULL);
    REGISTER(name, pin, result);
}
