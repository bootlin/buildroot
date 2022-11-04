#include <sys/queue.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define WORD_LIST	"/root/gdb/word_list"

struct name {
	char *name;
	SLIST_ENTRY(name) next;
};

SLIST_HEAD(name_list, name) name_list;

static int load_words(const char *word_file)
{
	size_t read;
	char *line;
	struct name *name;
	size_t len;
	FILE *file = fopen(word_file, "r");
	if (!file) {
		perror("Failed to open word list");
		return 1;
	}

	while ((read = getline(&line, &len, file)) != -1) {
		name = malloc(sizeof(*name));
		if (!name)
			return 1;

		memset(name, 0x0, sizeof(*name));

		name->name = strdup(line);
		SLIST_INSERT_HEAD(&name_list, name, next);
	}

	return 0;
}

void display_linked_list(void)
{
	struct name *name;

	SLIST_FOREACH(name, &name_list, next) {
		printf("Name: %s\n", name->name);
	};
}

int main(int argc, char **argv)
{
	int ret;
	const char *word_list = WORD_LIST;

	if (argc < 2)
		fprintf(stderr, "Missing word list, using default %s\n", word_list);
	else
		word_list = argv[1];
	
	ret = load_words(word_list);
	if (ret)
		fprintf(stderr, "Failed to load word list\n");

	return ret;
}