EXE=bin/markdownd
ALL_SRC=*.go

.PHONY: all clean run fmt

all: $(EXE)

clean:
	rm -rf $(EXE)

$(EXE): $(ALL_SRC) vendor_data.go
	go build -o $(EXE)

vendor_data.go: vendor/pygments
	rm -f vendor_data.go
	tar cf vendor.tar --exclude=vendor/pygments/tests/* --exclude=*.pyc vendor/
	go-bindata -func="VendorData" -nomemcopy -out="vendor_data.go" vendor.tar
	echo 'var VendorMD5 = "'$$(md5sum vendor.tar | awk '{print $$1}')'"' >> vendor_data.go
	rm vendor.tar

fmt: $(PROJECT_SRC)
	@gofmt -s -l -w $(PROJECT_SRC)
