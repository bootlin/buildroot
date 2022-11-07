
all: app

libauthent.so: authent_library.c authent_library.h
	gcc -g -fPIC -shared -o $@ $<

app: app.c authent_library.h libauthent.so
	gcc -g $< -L. -I. -lauthent -o $@