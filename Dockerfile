FROM rust:latest

ADD extra-cargo-conf /

RUN apt-get update && apt-get install -y \
	build-essential \
        cmake \
        curl \
        file \
		git \
		gcc-mingw-w64 && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && \
	curl https://sh.rustup.rs -sSf && \
	rustup target add x86_64-pc-windows-gnu && \
	rustup target add x86_64-apple-darwin && \
	bash -c 'cat /extra-cargo-conf >> ~/.cargo/config && rm /extra-cargo-conf'

