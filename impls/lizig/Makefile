STEPS = step0_repl step1_read_print step2_eval step3_env step4_if_fn_do step5_tco step6_file step7_quote step8_macros step9_try stepA_mal
SOURCES = $(wildcard step*.zig)
EXISTING_STEPS = $(SOURCES:.zig=)

all: $(EXISTING_STEPS)

$(STEPS):
	zig build -Dname=$@ -Droot_source_file=$@.zig

.PHONY: all $(STEPS) clean

clean:
	rm -rf .zig-cache/ zig-out/
	rm -f *~
