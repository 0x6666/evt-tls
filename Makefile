all: clean evt test_evt gen_cert test
evt:
	cd libuv && python gyp_uv.py
	make -C ./libuv/out
	clang -g -Wall -o $@ test_tls.c evt_tls.c uv_tls.c -lssl -lcrypto -lrt libuv/out/Debug/libuv.a -ldl -lpthread

gen_cert:
	openssl req -x509 -newkey rsa:2048 -nodes -keyout server-key.pem  \
        -out server-cert.pem -config ssl_test.cnf

test_evt:
	clang -g -Wall -o $@ evt_test.c evt_tls.c -lssl -lcrypto -lrt

test:
	./test_evt

clean:
	-rm evt
	-rm test_evt
