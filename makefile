go: lex.yy.c symtab.c
		gcc symtab.c lex.yy.c -lfl -ly -lm -o go

lex.yy.c: w.l
		flex w.l

symtab.c: w.y
		bison -dv w.y

clean:
		rm -f lex.yy.c
		rm -f w.output
		rm -f w.tab.h
		rm -f w.tab.c