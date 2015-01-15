<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
; -odac           -iadc     -d    ;;;RT audio I/O
-odac           -iadc     -d  -+rtaudio=jack -+jack_client=csoundlp  -b 500 -B 2000   ;;;RT audio I/O
;   -d  -+rtaudio=jack -+jack_client=csoundlp  -b 500 -B 2000   ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o grain3.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
       	sr = 44100
	kr = 441
	ksmps = 100
	nchnls = 1
	0dbfs = 1

instr lp
	idur = p3
	ifreq = p4
ain	in
aout	butterlp ain, ifreq
	out aout
endin

</CsInstruments>
<CsScore>
t 0 60
f 1 0 16384 10 1 ; sine wave

i"lp" 0 360000 1000

</CsScore>
</CsoundSynthesizer>
