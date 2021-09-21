VERSION ::= $(shell cat VERSION.txt)

bin/main: main.go
	@mkdir -p bin
	CGO_ENABLED=0 go build -o $@ $*

.PHONY: ver
ver: VERSION.txt
	@echo "version: $(VERSION)"

.PHONY: dockerbuild
dockerbuild: bin/main VERSION.txt
	docker build -t quay.io/adjetstack/ace:$(VERSION) .

.PHONY: dockersave
dockersave: bin/ace-$(VERSION).tar

bin/ace-$(VERSION).tar: dockerbuild
	docker save quay.io/adjetstack/ace:$(VERSION) > $@
