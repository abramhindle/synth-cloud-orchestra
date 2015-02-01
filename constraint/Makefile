run:	synth.out
	cat synth.out

synth.out: synth.mpg
	glpsol --math synth.mpg  --wcpxlp synth.cplex --output synth.out

