(
SynthDef('brainwave',{
	arg pitch = 200;
	var sound = SinOsc.ar(pitch,mul:0.2);
	var linen = Env.linen(0.01,sustainTime:0,releaseTime:1);
	var env = EnvGen.kr(linen, doneAction:2);
	Out.ar(0,sound*env);
}).add;
)

Synth('brainwave', [pitch:200]);
(
OSCdef('brainListener',{
	arg msg;
	Synth('brainwave', [volume:msg[1]*400+60]);

},"/brainwave");
)