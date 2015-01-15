<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
; -odac           -iadc     -d    ;;;RT audio I/O
; -odac:csoundfm:input           -iadc:csoundfm:output     -d  -+rtaudio=jack -+jack_client=csoundfm  -b 500 -B 2000   ;;;RT audio I/O
 -odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundfm  -b 500 -B 2000   ;;;RT audio I/O
; -d  -+rtaudio=jack -+jack_client=csoundfm  -b 500 -B 2000  -L stdin ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o grain3.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
       	sr = 44100
	kr = 441
	ksmps = 100
	nchnls = 1
	0dbfs = 1

instr 1
	idur = p3
	iamp = p4
	ifreq = p5
	icar = p6
	imod = p7
kamp	phasor 10
aout	foscili kamp, ifreq, icar, imod, 1, 1
	out aout
endin

</CsInstruments>
<CsScore>
t 0 60
f 1 0 16384 10 1 ; sine wave

i1 0 360000 1 440 7 6

</CsScore>
</CsoundSynthesizer>
