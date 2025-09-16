#include <stdlib.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include <sys/stat.h>

void sig_alarm(int sig)
{

}

int main(void)
{
	int wfd;
	struct stat statbuf;

	open("/tmp/tmp.GcHbq7ZR1i", O_RDONLY);
	open("/etc/fstab", O_RDONLY);
	wfd = creat("/tmp/tmp.tZE4mgFoO5", S_IRWXU);

	signal(SIGALRM, sig_alarm);
	kill(0, SIGALRM);

	open("/etc/init.d/S20urandom", O_RDONLY);
	open("/etc/config", O_RDONLY);

	close(wfd);
	kill(1, SIGABRT);

	getpid();

	lstat("/lib/libdl.so.2", &statbuf);

	return 0;
}