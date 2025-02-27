build:
	docker build -t eloquence .

run:
	docker run --env-file .env --rm eloquence

build_and_run: build run
