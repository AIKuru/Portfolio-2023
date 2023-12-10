
b = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Hihat/MD16_HH_2.wav");
c = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Kick/Kick 02.wav");
d = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Crash/Crash MPCVB Fat2.wav");
e = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Hihat/wams20_op-hat_bell-choke_p.wav");
f = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Ride/19_RIDE_02.wav");
g = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Tom/606HT_01_TapeSat.wav");
h = Buffer.read(s, "/Users/aydin/Music/samples/Drum Hits octa 2020/Crash/20_CRASH.wav");
b.bufnum;
c.bufnum;
d.bufnum;
e.bufnum;
f.bufnum;
g.bufnum;
h.bufnum;

(
SynthDef(\fmwithhighpass, {
	|out = 0, amp = 0.7, freq, decay = 0.1, mull, cutoff, modfreq = 2|
	var signal;
	signal = SinOsc.ar(150 + SinOsc.ar(modfreq, mul:400));
	signal = signal * EnvGen.kr(Env.perc(decay * rrand(0.2, 1)), gate: 0.5, doneAction:2);
	signal = signal * HPF.ar(signal, cutoff);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\fmwithlowpass, {
	|out = 0, amp = 0.7, freq, decay = 0.1, mull, cutoff, modfreq = 2|
	var signal;
	signal = SinOsc.ar(150 + SinOsc.ar(modfreq, mul:400));
	signal = signal * EnvGen.kr(Env.perc(decay * rrand(0.2, 1)), gate: 0.5, doneAction:2);
	signal = signal * LPF.ar(signal, cutoff);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\bass1, {
	| out = 0, amp, freq = 400, decay = 0.1, attack |
	var signal;
	signal = SinOsc.ar(freq - rrand(20, 60));
	signal = signal * EnvGen.kr(Env.perc(attack, decay * rrand(0.2, 1)), gate: 0.5, doneAction:2);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\fm, {
	|out = 0, amp = 0.7, freq = 200, decay = 1, mull, modfreq = 2|
	var signal;
	signal = SinOsc.ar(freq + SinOsc.ar(modfreq, mul:400));
	signal = signal * EnvGen.kr(Env.perc(decay * 1), gate: 0.5, doneAction:2);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\realdeal, {
	|out = 0, amp = 0.7, freq = 200, decay = 0.1, mull, modfreq = 2|
	var signal;
	signal = SinOsc.ar(freq *  SinOsc.ar(modfreq, mul:400));
	signal = signal * EnvGen.kr(Env.perc(decay), gate: 0.5, doneAction:2);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\realdealnoise, {
	|out = 0, amp = 0.7, freq = 200, decay = 0.1, mull, cutoff = 340, modfreq = 2|
	var signal;
	signal = WhiteNoise.ar(0.1) + SinOsc.ar(freq *  SinOsc.ar(modfreq, mul:400));
	signal =  signal * EnvGen.kr(Env.perc(decay), gate: 0.5, doneAction:2);
		signal = signal * LPF.ar(signal, cutoff);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef(\spookystringnoise,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff=8000 rq=0.2 lfowidth=0.01 lforate=3.8 pan=0.0|

	var pulse, filter, env, lfo;

	lfo = LFTri.kr(lforate,Rand(0,2.0)!2);

	//LFO only on second oscillator
	pulse = Mix(Saw.ar(freq*[1,1.001]*[1.0,1.0+(lfowidth*lfo)]))*0.5;

	filter = BHiPass.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,3),gate,doneAction:2);

	Out.ar(out,Pan2.ar( WhiteNoise.ar(0.25)*filter*env*amp,pan));
}).add;
SynthDef(\spookystrings,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff=8000 rq=0.2 lfowidth=0.01 lforate=3.8 pan=0.0|

	var pulse, filter, env, lfo;

	lfo = LFTri.kr(lforate,Rand(0,2.0)!2);

	//LFO only on second oscillator
	pulse = Mix(Saw.ar(freq*[1,1.001]*[1.0,1.0+(lfowidth*lfo)]))*0.5;

	filter = BHiPass.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,3),gate,doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));
}).add;
SynthDef('closedhat', {
	var hatosc, hatenv, hatnoise, hatoutput;
	hatnoise = {LPF.ar(WhiteNoise.ar(1),8000)};
	hatosc = {HPF.ar(hatnoise,2400)};
	hatenv = {Line.ar(1, 0, 0.1)};
	hatoutput = (0.5 * hatosc * hatenv);
	Out.ar(0,
		Pan2.ar(hatoutput, 0)
	);
}).add;
SynthDef("bassWarsaw", {
	arg
	//Standard Values:
	out = 0, freq = 200, gate = 1, amp = 0.5, pan = 0, att = 0.01, dec = 0.3, sus = 0.4, rel = 0.1,
	//Other Controls:
	slideTime = 0.17, cutoff = 1100, width = 0.15, detune = 1.005, preamp = 4;
	var snd, env;
	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);
	freq = Lag.kr(freq, slideTime);
	snd = VarSaw.ar(freq: [freq, freq * detune], width: width, mul: preamp);
	snd = Mix(snd).distort;
	snd = snd * env;
	snd = LPF.ar(snd, cutoff, amp);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
SynthDef(\hoover, {
	|out = 0, amp = 0.7, freq|
	var signal;
	signal = Saw.ar(freq) + Saw.ar(freq * 0.5);
	Out.ar(out, signal.dup * amp);
}).add;
SynthDef("beating", {arg freq = 440, amp = 0.1, art = 1, out = 0;
	var env, snd1, snd2;
	env = EnvGen.ar(Env.perc(0.01, art), doneAction: 2);
	snd1 = SinOsc.ar(freq);
	snd2 = SinOsc.ar(Line.kr(freq+15, freq, art));
	Out.ar(0, Pan2.ar(Mix([snd1, snd2]), 0, amp*env))
}).play;
SynthDef.new(\pulsewave, {
	|out = 0, amp = 0.5, decay = 0.5|
	var freq, signal;
	freq = LFPulse.ar(LFPulse.kr(3, 0, 0.3, 200, 200), 0, 0.2, 0.1);
	signal = freq;
	signal = signal * EnvGen.kr(Env.perc(0,1, decay), doneAction:2);
	Out.ar(out, signal.dup * amp);
}).play;
)

(

SynthDef.new(\sampler1, {
	|rate, out, amp = 0.5, dur = 0.5, speed = 0.5, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: b.numChannels,
		bufnum: b.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler2, {
	|rate, out, amp = 0.5, dur = 1, speed = 0.6, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: c.numChannels,
		bufnum: c.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler3, {
	|rate, out, amp = 0.5, dur = 0.5, speed = 0.5, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: d.numChannels,
		bufnum: d.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler4, {
	|rate, out, amp = 0.5, dur = 1, speed = 0.6, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: e.numChannels,
		bufnum: e.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler5, {
	|rate, out, amp = 0.5, dur = 0.5, speed = 0.5, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: f.numChannels,
		bufnum: f.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler6, {
	|rate, out, amp = 0.5, dur = 0.5, speed = 0.5, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: g.numChannels,
		bufnum: g.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
SynthDef.new(\sampler7, {
	|rate, out, amp = 0.5, dur = 0.5, speed = 0.5, buf|
	var trigger = Impulse.kr(speed);
	var signal = PlayBuf.ar(
		numChannels: h.numChannels,
		bufnum: h.bufnum,
		doneAction: 2);
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: Done.freeSelf);
	Out.ar(out, signal.dup * amp * env);
}).add;
)

//EFFECTS

(
SynthDef(\delay, {
	|in, out, delaytime = 0.2, maxdelaytime = 1|
	var input, effect;
	input = In.ar(in);
	effect = DelayN.ar(input, maxdelaytime, delaytime * rrand(0.5, 3.0));
	Out.ar(out, effect.dup);
}).add;
SynthDef(\delaylong, {
	|in, out, delaytime = 4, maxdelaytime = 1|
	var input, effect;
	input = In.ar(in);
	effect = DelayN.ar(input, maxdelaytime, delaytime);
	Out.ar(out, effect.dup);
}).add;
SynthDef.new(\reverb, {
	|in, out|
	var effect, mix, room, damp;
	effect = In.ar(in);
	effect = FreeVerb.ar(effect, 0.25, 0.5);
	Out.ar (out, effect.dup);
}).add;
SynthDef.new(\reverblongtail, {
	|in, out, mix = 1, room = 1|
	var effect;
	effect = In.ar(in);
	effect = FreeVerb.ar(effect, mix, room);
	Out.ar (out, effect.dup);
}).add;
)
(
SynthDef.new(\BPF1, {
	arg in, out, freq, rq;
	var effect, sig;
	sig = In.ar(in);
	effect = BPF.ar(sig, freq, rq);
	Out.ar(out, effect.dup);
}).add;
)
///GROUPS & EFFECTS:

a = Synth.new(\reverb,
	[\in, ~reverbbus, \out, 0], ~effects);
c = Synth.new(\reverblongtail,
	[\in, ~reverbbus2, \out, 0], ~effects);

b = Synth.new(\delaylong,
	[\in, ~delaybus, \out, 0], ~effects);
d = Synth.new(\delay,
	[\in, ~delaybus2, \out, 0], ~effects);

SynthDef.new(\jack, {
	arg in, out;
	var sig, effect;
	sig = In.ar(in);
	effect =


~synths = Group.new(s);
~samplers = Group.new(s);
~effects = Group.new(s, addAction: 'addToTail');

~delaybus = Bus.audio(s);
~delaybus2 = Bus.audio(s);
~reverbbus = Bus.audio(s);
~reverbbus2 = Bus.audio(s);

////77
/////77
///////777
//////////77777
//////////77777777

////POSSIBLE INTRO

Pbindef(\x117, \instrument, \realdeal, \dur, 0.2, \amp, 0.07, \freq, Prand(
	[0.1, 0.2, 0.3, 0.4,
], inf)).play(quant: 0.5);
Pbindef(\x244, \instrument, \realdeal, \freq, Prand([140, 880, 200, 215], inf), \dur, 0.1, \amp, Pseq([0, 0, 0.04, 0], inf)).play(quant: 1);
Pbindef(\x1172, \instrument, \realdealnoise, \dur, 0.4, \cutoff, 140, \decay, 0.4, \amp, 0.2).play(quant: 0.5);


Pbindef(\x117, \instrument, \realdeal, \dur, 0.2, \amp, 0.02, \freq, Prand(
	[0.1, 0.2, 0.3, 0.4,
], inf)).play(quant: 0.5);
Pbindef(\x118, \instrument, \realdeal,
		\out, ~delaybus, \dur, Pwhite(0.04, 0.8, inf), \amp, 0.03, \freq, Prand(
	[1.4, 0.2, 0.3, 0.4,
], inf)).play(quant: 1);
//MUTE ALL INTRO:
Pdef(\x117).stop;
Pdef(\x118).stop;

//NOISEY BOYS

Pbindef(\x244, \instrument, \realdeal, \freq, Prand([140, 880, 200, 215], inf), \dur, 0.1, \amp, Pseq([0, 0, 0.001, 0], inf)).play(quant: 1);

Pbindef(\x1172, \instrument, \realdealnoise, \dur, 0.4, \cutoff, 180, \decay, 0.4, \amp, 0.1).play(quant: 0.5);
Pbindef(\x1172, \instrument, \realdealnoise, \dur, 0.4, \cutoff, 240, \decay, 0.8, \amp, 0.3).play(quant: 0.5);
Pbindef(\x1172, \instrument, \realdealnoise, \dur, 0.4, \cutoff, 290, \decay, 0.2, \amp, 0.3).play(quant: 0.5);

//MUTE ALL NOISE:
Pdef(\x244).stop;

Pdef(\x1172).stop;

/////7
//////77
///////7777
////////777777

//MAIN SYNTH

	Pbindef(\xx1, \instrument, \beating, \art, Pwhite(0.5, 2, inf), \midinote, Prand([39, 47, 52]+10, inf), \dur, Prand([0.8, 0.2, 0.1, 0.1, 0.7], inf), \amp, Pseq(
	[0, 0, 0.2, 0,
		0.0, 0, 0.2, 0,
		0, 0, 0.35, 0,
		0.0, 0.35, 0.25, 0.2,
], inf)).play(quant: 1);

//variation1

Pbindef(\xx1, \instrument, \beating, \art, Pwhite(0.5, 1, inf), \midinote, Prand([39, 47]+11, inf), \dur, Prand([0.5, 0.2, 0.1, 0.1, 0.4]-0.1, inf),\amp, Pseq(
	[0, 0, 0.2, 0,
		0.0, 0, 0.2, 0,
		0, 0, 0.35, 0,
		0.0, 0.35, 0.25, 0.2,
], inf)).play(quant: 1);


Pbindef(\xx2, \instrument, \beating, \art, Pwhite(0.1, 1, inf), \midinote, Prand([39, 47]+16, inf), \dur, Prand([0.5, 0.2, 0.1, 0.1, 0.4], inf),\amp, Pseq(
	[0.0, 0.35, 0.25, 0.2,
], inf)).play(quant: [1, 0.5]);


	Pbindef(\xx1, \instrument, \beating, \art, Pwhite(0.1, 0.5, inf), \midinote, Prand([39, 47]+16, inf), \dur, Prand([0.5, 0.2, 0.1, 0.1, 0.4]-0.1, inf),\amp, Pseq(
	[0, 0, 0.2, 0,
		0.0, 0, 0.2, 0,
		0, 0, 0.35, 0,
		0.0, 0.35, 0.25, 0.2,
], inf)).play(quant: 1);


Pbindef(\xx2, \instrument, \beating, \art, Pwhite(0.1, 0.2, inf), \midinote, Prand([39, 47]+16, inf), \dur, Prand([0.5, 0.2, 0.1, 0.1, 0.4], inf),\amp, Pseq(
	[0.0, 0.35, 0.25, 0.2,
], inf)).play(quant: [1, 0.5]);

//MUTE MAIN:
Pdef(\xx1).stop;
Pdef(\xx2).stop;


///techy synths1

Pbindef(\xxx1, \instrument, \bassWarsaw, \midinote, Prand([41, 52]+10, inf), \dur, 0.1, \amp, Pseq(
	[0.2, 0.5, 0.0, 0,
		0.0, 0, 0.0, 0,
		0, 0, 0, 0,
		0.0, 0.0, 0.2, 0.7,
], inf)).play(quant: 1);


Pbindef(\xxx1, \instrument, \bassWarsaw, \midinote, Prand([41, 52]+10, inf), \dur, 0.1, \amp, Pseq(
	[0.3, 0.7, 0.0, 0,
		0.0, 0, 0.0, 0,
		0, 0, 0, 0,
		0.0, 0.0, 0, 0,
], inf)).play(quant: 1);

///TECHY SYNTH2

Pbindef(\xxx2, \instrument, \bassWarsaw, \midinote, Prand([41, 52, 66, 41]+22, inf), \dur, 0.1, \amp, Pseq(
	[0, 0, 0.0, 0,
		0, 0, 0, 0,
0.7, 0.6, 0.5, 0,
		0.0, 0.0, 0.0, 0.0,
			0, 0, 0.0, 0,
		0.0, 0, 0.0, 0,
		0, 0, 0.0, 0,
		0.0, 0.0, 0.0, 0.0,
], inf)).play(quant: 1);

//TECHY PAD
(
	Pbindef(\x3212, \instrument, \bassWarsaw,\out, ~reverbbus2, \freq, 340+Pwhite(0, 134, inf), \dur, 0.2, \rel, 1, \sus, 1, \dec, 1,  \att, Pwhite(0.02, 0.7, inf), \cutoff, 800, \detune, 1.020, \amp, Pseq(
		[0.6, 0.2, 0, 0,
		0.6, 0.2, 0.5, 0.2,
		0, 0, 0, 0,
		0, 0, 0, 0,

		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,

		0, 0, 0, 0,
		0, 0, 0, 0], inf)).play(quant: 2);
)

Pdef(\xxx1).stop;
Pdef(\xxx2).stop;
Pdef(\x3212).stop;

//16TH SYNTHS:
Pbindef(\x32222, \instrument, \bassWarsaw, \dur, 0.1, \amp, Pseq([0.2, 0.4, 0.2]-0.1, inf)).play(quant: [1, 0.5]);

Pbindef(\x32223dry, \instrument, \bassWarsaw, \midinote, 39, \dur, 0.1, \amp, Pseq([0, 0.4, 0.2], inf)).play(quant: 1);

Pbindef(\x32223reverb, \instrument, \bassWarsaw, \midinote, 39, \dur, 0.1, \out, ~reverbbus2, \amp, Pseq([0.4, 0.1, 0.2], inf)).play(quant: 1);
Pbindef(\x32223reverb, \instrument, \bassWarsaw, \midinote, 39, \dur, 0.1, \out, ~reverbbus2, \amp, Pseq([0.4, 1, 0.2], inf)).play(quant: 1);
Pdef(\x32223reverb).stop;

///MUTE 16TH/ACID
Pdef(\x32222).stop;
Pdef(\x32223).stop;
Pdef(\x41).stop;

/////77
/////7777
///HIHATS (1)

//BASIC OFFBEAT HH 4 FIRST PATTERN
Pbindef(\xhh1, \instrument, \sampler1, \dur, 0.4, \amp, Pseq([0.2, 0.4, 0.2], inf)).play(quant: 1);

Pbindef(\xhh1, \instrument, \sampler1, \dur, 0.4, \amp, Pseq(
	[0, 0, 0, 0,
	0, 0, 0, 0,
	0.2, 0.1, 0.2, 0.1,
	0.2, 0.1, 0.2, 0.1,
], inf)).play(quant: 1);

Pdef(\xhh1).stop;
//BASIC OFFBEAT HH 2

	Pbindef(\reverbhat, \instrument, \sampler1, \out, ~reverbbus, \dur, 0.2, \amp, Pseq(
	[0.2, 0.1, 0.2, 0.1,
	0.2, 0.1, 0.2, 0.1,
], inf)).play(quant: 1);

Pdef(\reverbhat).stop;
//BASIC OFFBEAT HH 1

Pbindef(\hihat, \instrument, \sampler4, \dur, 0.4, \amp, Pseq([0.1, 0.05], inf)).play(quant: 1);
Pdef(\hihat).stop;

//BASIC OFFBEAT HH 3

Pbindef(\x3222, \instrument, \sampler1, \dur, 0.1, \amp, Pseq([0.2, 0.4, 0.2]-0.1, inf)).play(quant: [1, 0.5]);
Pdef(\x3222).stop;



//HIHATVARIATONS
Pbindef(\x35, \instrument, \sampler1, \dur, 0.8, \out, ~reverbbus2, \amp, Pseq(
	[0, 0, 0.7, 0,
		0.0, 0, 0.7, 0,
], inf)).play(quant: 1);


///////////////////////
////CRASH1///
//one hit per bar
Pbindef(\x16, \instrument, \sampler3, \dur, 3.2, \amp, 0.2,).play(quant: 1);
//two hits per bar
Pbindef(\x16, \instrument, \sampler3, \dur, 0.8, \amp, 0.2,).play(quant: 1);
//CRASH2
Pbindef(\x388, \instrument, \sampler7, \dur, 0.6, \amp, Pseq([0.1, 0.0, 0, 0.5], inf)).play(quant: 1);


//KICKS
Pbindef(\x30, \instrument, \sampler2, \dur, 0.4, \amp, Pseq([0.1, 0.7, 0.5], inf)).play(quant: 4);
Pbindef(\x31, \instrument, \sampler2, \dur, 1.2, \amp, Pseq([0.5, 1, 0.5], inf)).play(quant: 2);
Pbindef(\x33, \instrument, \sampler2, \dur, 0.8, \amp, Pseq(
	[0.2, 0.5, 0.2, 0.5,
		0.2, 0.5, 0.2, 0.5,
		0.5, 0, 0, 0,
		0, 0, 0, 0
], inf)).play(quant: 1);


//MUTE ALL KICKS:
Pdef(\x30).stop;
Pdef(\x31).stop;
Pdef(\x33).stop;
//MUTE ALL CRASH:
Pdef(\x16).stop;
Pdef(\x388).stop;
//MUTE ALL HIHAT:
Pdef(\x34).stop;
Pdef(\reverbhat).stop;
Pdef(\x17).stop;
Pdef(\x35).stop;
Pdef(\x36).stop;
Pdef(\x3222).stop;
Pdef(\x3223).stop;
Pdef(\hihat).stop;

//BREAKDOWN:
//STRINGnoise

Pbindef(\STRING3,
		\instrument, \spookystrings,
		\midinote,Pseq([69,70],inf),
		\dur,9.5,
		\amp,0.2,
		\lfowidth,0.04,
		\cutoff,1000,
	\out, ~reverbbus2,
	\rq,0.1).play(quant: 0.5);

//ENDBREAKDOWN:
Pdef(\STRING1).stop;
Pdef(\STRING2).stop;
Pdef(\STRING3).stop;

Pbindef(\STRING1,
		\instrument, \spookystringnoise,
		\midinote,Pseq([69,70,88,99],inf),
		\dur,Pseq([4,0.2, 0.2],inf),
		\amp,0.2,
		\lfowidth,0.04,
		\cutoff,1000,
	\rq,0.1).play(quant: 1);
Pbindef(\STRING2,
		\instrument, \spookystringnoise,
		\midinote,Pseq([69,75],inf),
		\dur,9.5,
		\amp,0.2,
		\lfowidth,0.04,
		\cutoff,1000,
	\rq,0.1).play(quant: 1);

//16thkick:
Pbindef(\kick44, \instrument, \sampler2, \dur, 0.1, \amp, 0.2).play(quant: 1);
//noisereturn:
Pbindef(\x1172, \instrument, \realdealnoise, \dur, 0.4, \cutoff, 360, \decay, 0.4, \amp, 0.1).play(quant: 0.5);
//fullkick:
Pbindef(\x30, \instrument, \sampler2, \dur, 0.4, \amp, Pseq([0.5, 0.7, 0.5, 0.7], inf)).play(quant: 1);

//reverbhat:
	Pbindef(\reverbhat, \instrument, \sampler1, \out, ~reverbbus, \dur, 0.2, \amp, Pseq(
	[0.2, 0.1, 0.2, 0.1,
	0.2, 0.1, 0.2, 0.1,
], inf)).play(quant: 1);
//tomdelay:
Pbindef(\x32delay, \instrument, \sampler6,  \speed, 2, \out, ~delaybus2, \dur, Prand([0.2, 0.1, 0.3],inf), \amp,Pseq([0.1, 0, 0.3], inf)).play(quant: 1);
Pdef(\x32delay).stop;
//tomreverb:
Pbindef(\x322, \instrument, \sampler6,  \speed, 2, \out, ~reverbbus, \dur, Prand([0.2, 0.1, 0.3],inf), \amp,Pseq([0.1, 0, 0.3], inf)).play(quant: 1);
Pdef(\x322).stop;
Pdef(\x30).stop;


TempoClock.tempo = TempoClock.tempo * 2 ////TEMPOCONTROL

SynthDef("bassWarsaw", {
	arg
	//Standard Values:
	out = 0, freq = 200, gate = 1, amp = 0.5, pan = 0, att = 0.01, dec = 0.3, sus = 0.4, rel = 0.1,
	//Other Controls:
	slideTime = 0.17, cutoff = 1100, width = 0.15, detune = 1.005, preamp = 4;
	var snd, env;
	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);
	freq = Lag.kr(freq, slideTime);
	snd = VarSaw.ar(freq: [freq, freq * detune], width: width, mul: preamp);
	snd = Mix(snd).distort;
	snd = snd * env;
	snd = LPF.ar(snd, cutoff, amp);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
//ACID
(
Pbindef(\x41, \instrument, "bassWarsaw",
	\amp, 0.1,
	\gate, 1,
	\att, 0.1,
	\dec, 2,
    \dur, 1,
   \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, \rest], inf),
    \scale, Scale.choose;
).play(quant: [1, 0.5]);
)

