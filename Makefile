VERSION ::= $(shell cat VERSION.txt)
COSIGN ::= cosign
KEY ::= $(PERSONAL_GCP_KEY)
DOCKERTAG ::= ghcr.io/sgtcodfish/ace:$(VERSION)

.PHONY: printkey
printkey:
	@echo $(KEY)

bin/main: main.go
	@mkdir -p bin
	CGO_ENABLED=0 go build -o $@ $*

.PHONY: ver
ver: VERSION.txt
	@echo "version: $(VERSION)"

.PHONY: dockerbuild
dockerbuild: bin/main VERSION.txt
	docker build -t $(DOCKERTAG) .

.PHONY: dockerpush
dockerpush: dockerbuild
	docker push $(DOCKERTAG)

.PHONY: dockersave
dockersave: bin/ace-$(VERSION).tar

bin/ace-$(VERSION).tar: dockerbuild
	docker save $(DOCKERTAG) > $@

.PHONY:
cosign:
	$(COSIGN) sign --key "$(KEY)" $(DOCKERTAG)

.PHONY:
cosign-verify-gcp:
	$(COSIGN) verify --key "$(KEY)" $(DOCKERTAG)

.PHONY:
cosign-verify-local:
	$(COSIGN) verify --key ./PUBKEY $(DOCKERTAG)
