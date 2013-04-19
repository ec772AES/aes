# Example Makefile for the optimised ANSI C Rijndael code
# v3.0

# Gnu compiler
CC=gcc
# Compiler flags
CFLAGS=-O2 -DINTERMEDIATE_VALUE_KAT -DFULL_UNROLL
# Flags for code, use -DTRACE_KAT_MCT print status info
LDFLAGS=
SOURCES=rijndael-alg-fst.c rijndael-api-fst.c rijndael-test-fst.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=rijndael-test-fst
# call make rijndael-test-fst
$(EXECUTABLE):	$(OBJECTS)

clean:
	rm -rf *o rijndael-test-fst