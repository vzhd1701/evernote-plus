THRIFT_SRC := evernote-thrift/src
OUTPUT_DIR := build

DOCKER_IMAGE := cspwizard/thrift:0.21.0

generate-local:
	mkdir -p $(OUTPUT_DIR)
	thrift --gen py:enum,type_hints -out $(OUTPUT_DIR) -r $(THRIFT_SRC)/NoteStore.thrift 2>&1 | grep -vE "64-bit constant|No generator named|^$$" || true;
	find $(OUTPUT_DIR) -type f -name "*-remote" -delete

generate-docker:
	mkdir -p $(OUTPUT_DIR)
	docker run --rm -v $(PWD)/$(THRIFT_SRC):/data -v $(PWD)/$(OUTPUT_DIR):/out $(DOCKER_IMAGE) --gen py:enum,type_hints -out /out -r /data/NoteStore.thrift
	find $(OUTPUT_DIR) -type f -name "*-remote" -delete

build:
	poetry build

update-submodule:
	git submodule update --remote --merge

clean:
	rm -rf dist/
	rm -rf build/
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete
