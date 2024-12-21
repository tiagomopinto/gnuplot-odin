FLAGS := -o:aggressive -microarch:native -no-bounds-check -disable-assert -no-type-assert -vet -strict-style
TARGET := gplot

$(TARGET) : main.odin gnuplot/*.odin
	odin build main.odin -file $(FLAGS) -out:$@

.PHONY : run clean

run :
	@./$(TARGET)

clean :
	@rm -rf $(TARGET)
