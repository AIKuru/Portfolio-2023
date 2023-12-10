///noise box



OSCdef(\since, {|...args|
	var msg = args[0].postln;
	~receiveValue.value(msg[1]);
	~receiver2.value(msg[2]);
}, 'distance');
~receiver2 = {| value2|
	~fm2.set(\freq, value2);
};

~receiveValue = {| value |
	~noise.set(\freq, value+300);
	~fm.set(\freq, value);
};
~noise = {
	LFNoise1.ar(freq: \freq.kr(1, 0.3), mul:0.1)
}.play;
~fm = {
	Saw.ar(LFNoise1.kr(1,1e3,freq: \freq.kr(1, 0.3)),0.3)*FSinOsc.ar(SampleRate.ir/2,1).dup}.play;
~fm2 = {|out=0, amp=0.1, controlrate1 = 200, controlrate2 = 0.1|
		var signal;
	signal = DFM1.ar(Pulse.ar(freq: \freq.kr(400, 0.3), mul:0.4) + Pulse.ar(freq: \freq.kr(1, 03)))!2;
				Out.ar(out, signal.dup * amp);
			}.play;



OSCdef(\sinceee, {|...args|
	var msg = args[0].postln;
	~receiveValueB.value(msg[1]);
}, 'distance');
~receiveValueB = {| value |
	~noiseb.set(\freq, value+300);
	~fmb.set(\freq, value+300);
};
~noiseb = {
	LFNoise1.ar(freq: \freq.kr(1, 0.3), mul:0.1)
}.play;
~fmb =  { arg modHz=100, modAmp=200, out=0;
			var car, mod;
				mod = SinOsc.ar(modHz, mul:modAmp);
	car = SinOsc.ar(freq: \freq.kr(100, 0.5)+ mod) * 0.21;
			Out.ar(out, car);
}.play

//percussive sounds

OSCdef(\prcsing28,  {

SynthDef.new(\FM1, {
			arg carrierHz=500, modHz=100, modAmp=200, out=0;
			var car, mod, env;
	env = EnvGen.kr(Env.perc(attackTime:0.01, releaseTime:0.1, level:1.0, curve:-4.0), doneAction:2);
				mod = SinOsc.ar(modHz, mul:modAmp);
			car = SinOsc.ar(carrierHz + mod) * 0.21;
			Out.ar(out, car);
}).play;
}, '/yacollision');

(
OSCdef(\prcsing22, {
SynthDef(\realdeal, {
	|out = 0, amp = 0.6, freq = 200, decay = 0.1, mull, modfreq = 2|
	var signal;
	signal = SinOsc.ar(freq *  SinOsc.ar(modfreq, mul:400));
	signal = signal * EnvGen.kr(Env.perc(decay), gate: 0.5, doneAction:2);
	Out.ar(out, signal.dup * amp);
}).play;
}, '/ybcollision');
)





OSCdef(\prcsing33, {

	SynthDef.new(\pulsewave, {
	|out = 0, amp = 0.3, decay = 20, freq2|
	var freq, signal;
	freq = LFPulse.ar(LFPulse.kr(3, 0, 0.3, 200, freq2), 0, 0.2, 0.1);
	signal = freq;
	signal = signal * EnvGen.kr(Env.perc(0,1, decay), doneAction:2);
	Out.ar(out, signal.dup * amp);
}).play;
}, '/yccollision');


OSCdef(\prcsing44, {
SynthDef(\decimator, {
		|out=0, amp=1, controlrate1 = 100, controlrate2 = 0.3|
		var signal;
		signal = DFM1.ar(Pulse.ar(100.1, mul:0.4), SinOsc.kr(SinOsc.kr(controlrate2).range(0.2, 5)).range(80, 2000), 0.1, inputgain: 0.10, mul:0.1)!2;
				Out.ar(out, signal.dup * amp);
			}).play;
}, 'ydcollision');
