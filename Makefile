build:
	docker build -t eloquence .

run:
	docker run --rm eloquence

build_and_run: build run
