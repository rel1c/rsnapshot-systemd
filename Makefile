all: build

build:
	./create-services.sh

clean:
	rm -v rsnapshot*.{service,timer}
