{
	 (SinOsc.ar(MouseX.kr(220, 550, 1).poll)* EnvGen.ar(Env.perc(0.1, 30), doneAction:0)) +
	 (SinOsc.ar(MouseX.kr(330, 660, 1).poll) * EnvGen.ar(Env.perc(0.1, 20), doneAction:0)) +
	 (SinOsc.ar(XLine.kr(MouseX.kr(1,4), 250, 0,2, doneAction:2)) * 0.1) +

// 	DynKlank.ar(`[[880, 990, 1100, 1220, 1330] * MouseX.kr(1, 10, 0.1,2),  nil, [0.2, 0.3, 0.2, 0.4] * MouseX.kr(0.1, 2, 1)], Impulse.ar(2, 0, 0.1))!4 +
	LFNoise0.ar(340)

// 	LFPulse.ar(LFPulse.kr(MouseX.kr(0, 5), 0, 0.3, 200, 300), 0, 0.2, 0.1)


	// + LFPulse.ar(LFPulse.kr(MouseX.kr(0.1, 10), 0, 0.3, 200, 400), 0, 0.2, 0.1)


	// Limiter.ar(DynKlank.ar(`[[220, 330, 440, 660, 770] * LFPulse.kr(MouseX.kr(1, 10, 1)),  nil, [1, 1, 2, 3] * MouseX.kr(0.1, 2, 1)], HPF.ar(WhiteNoise.ar(0.05), MouseX.kr(40,10000,-1))))


	// ( DynKlank.ar(`[[220, 330, 440, 660, 770] * LFPulse.kr(MouseX.kr(1, 10, 1)),  nil, [1, 1, 2, 3] * MouseX.kr(0.1, 2, 1)], HPF.ar(WhiteNoise.ar(0.05), MouseX.kr(40,10000,-1))) * 0.1)

}.play;

ServerOptions.devices; // all devices
Server.default.options.outDevice_("MacBook Pro Speakers");

