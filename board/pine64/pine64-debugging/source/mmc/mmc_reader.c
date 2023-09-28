#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	int size, fd, ret;
	const char *device;
	char *buff;

	if (argc < 2) {
		fprintf(stderr, "%s <file> <block_size>\n", argv[0]);
		return EXIT_FAILURE;
	}

	device = argv[1];
	size = atoi(argv[2]);

	buff = aligned_alloc(size, size);
	if (!buff) {
		fprintf(stderr, "Failed to allocate memory\n");
		return EXIT_FAILURE;
	}

	fd = open(device, O_RDONLY | O_DIRECT);
	if (fd < 0) {
		fprintf(stderr, "Failed to open file\n");
		return EXIT_FAILURE;
	}


	// ioctl(fd, BLKGETSIZE64, &file_size_in_bytes);

	/* Loop while reading data from the device */
	while (1) {
		ret = read(fd, buff, size);
		if (ret < 0) {
			fprintf(stderr, "Failed to read file: %s\n", strerror(ret));
			return EXIT_FAILURE;
		} else if (ret == 0) {
			lseek(fd, 0, SEEK_SET);
		}
	}

	return EXIT_SUCCESS;
}