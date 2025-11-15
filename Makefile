OCAML_VARIANT=ocaml-variants.5.2.0+options
DEV_PACKAGES=ocaml-lsp-server
BUILD_PACKAGES=ocamlformat.0.26.2,odoc

build:
	opam exec -- dune build

update-schema:
	git submodule update --init --recursive

init-dev:
	npm i
	make update-schema
	opam switch create . --packages=${OCAML_VARIANT},${BUILD_PACKAGES},${DEV_PACKAGES} -y --deps-only
