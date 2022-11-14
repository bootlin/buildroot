#define _GNU_SOURCE
#include <unistd.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <inttypes.h>
#include <pthread.h>

#define SEC_TO_NSEC	1000000000ULL
#define MSEC_TO_USEC	1000ULL
#define MSEC_TO_NSEC	1000000ULL

static uint64_t timespec_to_nano(struct timespec *spec)
{
	return spec->tv_sec * SEC_TO_NSEC + spec->tv_nsec;
}


static void work(uint64_t busy_time_msec)
{
	struct timespec start = {0, 0}, end = {0, 0};
	uint64_t start_nano, end_nano, work_time_nano;

	clock_gettime(CLOCK_MONOTONIC, &start);
	start_nano = timespec_to_nano(&start);

	work_time_nano = busy_time_msec * MSEC_TO_NSEC;

	do {
		clock_gettime(CLOCK_MONOTONIC, &end);
		end_nano = timespec_to_nano(&end);
	} while ((end_nano - start_nano) < work_time_nano);
}

static uint64_t sleep_time = 0;
static uint64_t busy_time = 0;

static void *worker_func(void *arg)
{
	while(1) {
		usleep(sleep_time);
		work(busy_time);
	}

	return NULL;
}

int main(int argc, char **argv)
{
	int ret;
	struct sched_param param;
	int cpu_count, cpu;
	pthread_t *threads;
	cpu_set_t cpuset;

	if (argc < 4) {
		fprintf(stderr, "%s <sleep_time_msec> <work_time_msec> <cpu_count>\n,", argv[0]);
		return 0;
	}

	sleep_time = atoi(argv[1]) * MSEC_TO_USEC;
	busy_time = atoi(argv[2]);
	cpu_count = atoi(argv[3]);

	printf("Sleeping for %" PRIu64 " usec and working for %" PRIu64 " usec\n", sleep_time, busy_time);

	memset(&param, 0, sizeof(param));

	param.sched_priority = 98;

	ret = sched_setscheduler(0, SCHED_FIFO, &param);
	if (ret) {
		perror("Failed to set scheduler");
		return ret;
	}

	threads = malloc(cpu_count * sizeof(pthread_t));
	if (!threads) {
		fprintf(stderr, "Failed to allocate data for threads\n");
		return EXIT_FAILURE;
	}

	for (cpu = 0; cpu < cpu_count; cpu++) {
		printf("Starting thread for cpu %d\n", cpu);
		 ret = pthread_create(&threads[cpu], NULL, worker_func, NULL);
		 if (ret < 0) {
			fprintf(stderr, "Failed to allocate data for threads\n");
			return EXIT_FAILURE;
		}

		CPU_ZERO(&cpuset);
		CPU_SET(cpu, &cpuset);
		pthread_setaffinity_np(threads[cpu], sizeof(cpu_set_t), &cpuset);
	}

	for (cpu = 0; cpu < cpu_count; cpu++) {
		 ret = pthread_join(threads[cpu], NULL);
	}

	return 0;
}