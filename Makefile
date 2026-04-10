# Default target
all: build

# Build the compiler
build:
	shards build doisc

# Run the compiler with a file argument
run: build
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make run FILE=path/to/file.dois"; \
		exit 1; \
	fi
	./bin/doisc $(FILE)


# Run default test file, likely to be removed later on
test: build
	./bin/doisc ./examples/test.dois

# Clean build artifacts (optional)
clean:
	rm -rf ./bin