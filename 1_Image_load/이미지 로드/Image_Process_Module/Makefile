
include ../Makedefs

TRG = image_process.o
SRC = image_process.c

all: $(TRG)

$(TRG) : $(SRC)
	$(CC) $(CFLAGS) -c $(SRC) -o $(TRG)

install:
	cp -f ./$(TRG) $(MODULE_INSTALL_DIR)
	
clean:
	rm -f *.o *.dis
