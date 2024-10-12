


//supercollider workshop
//technical museum 11.10.2024



s.boot;


//supercollider workshop
//technical museum 11.10.2024
//https://github.com/ffforces/algorave-helsinki-workshop-altparty-2024/


//sc links
//supercollider discord: https://discord.gg/th9vCaXP
//algorave helsinki discord: https://discord.gg/aJb6UTZft4
//https://scsynth.org/
//https://supercollider.github.io/
//https://sccode.org/



//ctrl + enter for evaluating
//cmd+enter on macs
// shift+enter evaluate only that line

"hello world!!";


// these are comments


//using parentheses is super handy. everything is evaluated what is inside the parenthesis


(

"hello world!!";


)








//sound version of hello world


{SinOsc.ar(100, mul:0.2)}.play;
{SinOsc.ar}.play;
//kr
//{SinOsc.ar(SinOsc.kr(1).range(20,120))}.play;


//default arguments
//SinOsc.ar(





//control + dot
//cmd + dot
// to kill the sound



//ctrl d to see help file


{SinOscFB.ar(100,feedback:0.9, mul:0.2)}.play;

{SinOscFB.ar(100,0.9, 0.2)}.play;

{SinOscFB.a100,mul: 0.2)}.play;




{SinOscFB.ar(100,mul: 0.2)}.play;

30.midicps;

{VarSaw.ar(freq: LFTri.ar(1).range(30,50).midicps, iphase: 0.0, width: LFTri.ar(0.1).range(0.0,1.0),mul: 0.3, add: 0.0)}.play;




rrand(20,400);




//choose from an array
[3000,3001,4,50,20].choose;
[0,3,6,3].wchoose([0.1,0.4,0.4,0.4].normalizeSum);
1000.rand;





(

{SinOsc.ar(rrand(80,400),mul:0.1)}.play;

)


//notice how the server just adds all these oscilatiors on top of each other


//synth definion

x.free;

(
SynthDef(\sin,{ arg freq=90;
	
var osc=VarSaw.ar(freq,mul:0.2);

//notice the multichannel expansion !2
Out.ar(0, osc!2);
}
).add;
)

x=Synth(\sin);
//does not work
x1=Synth(\sin);

x.set(\freq, 130);

x.set(\freq, rrand(30,600));

x.set(\freq, rrand(30,60).midicps);




//advance example

(
~task= Tdef(\t, {
	loop{
		x.set(\freq, rrand(30,60).midicps);

	0.2.wait;
	}


}
);
)

~taskPlay=~task.play;
~taskPlay.stop;


(
SynthDef(\sin,{ arg freq=90;

		var osc=VarSaw.ar(freq,mul:0.3);

//notice the multichannel expansion !2
		Out.ar(0, osc!2);
	}
).add;
)





(
SynthDef(\sin,{ arg freq=90, ratio1=1;
	var osc1, osc2, env1, env2;
	env1=EnvGen.kr(Env.new([0,1,0],[10,2]),doneAction:2);
	env2=EnvGen.kr(Env.new([0,1,0],[5,2]),doneAction:0);
	osc2=SinOsc.ar(freq*ratio1,mul:1000)*env2;
	osc1=SinOsc.ar(freq+osc2,mul:0.3)*env1;


//notice the multichannel expansion !2
		Out.ar(0, osc1!2);
	}
).add;
)



x=Synth(\sin);


(
~pattern=Pbindef(\synth,
	\instrument,\sin,
	\ratio1, Pwhite(1.0,2.0),
	\freq, Pseq([30,32,30,40],inf).midicps,
	\dur, Pwhite(5,0.3),
);
)

~patternPlay=~pattern.play;
~patternPlay.stop;


//////////////////////////////////////

(
SynthDef(\sin,{ arg freq=90, ratio1=1,index;
	var osc1, osc2, env1, env2,env3;
	env1=EnvGen.kr(Env.new([0,1,0],[10,2]),doneAction:2);
	env2=EnvGen.kr(Env.new([0,1,0],[5,1]),doneAction:0);
	env3=EnvGen.kr(Env.new([0.01,1,0.01],[0.1,10]),doneAction:0);
	osc2=SinOsc.ar(freq*ratio1*env3,mul:freq*index)*env2;
	osc1=SinOsc.ar(freq+osc2,mul:0.2)*env1;


//notice the multichannel expansion !2
	Out.ar(0, Limiter.ar(osc1!2));
	}
).add;
)






(
~pattern=Pbindef(\synth,
	\instrument,\sin,
	\ratio1, Pwhite(1.0,20.0),
	\freq, Pseq([30,32,30,40],inf)+2.midicps,
	\index, Pwhite(1.0,1000.0),
	\dur, Pwhite(2,0.3),
);
)

~patternPlay=~pattern.play;
~patternPlay.stop;







/////////////////////////////////////////////




(
SynthDef(\acid,{ arg freq=90, ratio1=1,index,ffreq=0,envAtt=0.1,envRel=0.2,filtAtt=0.1, filtRel=0.2,res=0.4,vol=0.9,width;
	var osc1, osc2, env1, env2,env3,filter;
	env1=EnvGen.kr(Env.new([0,1,0],[envAtt, envRel]),doneAction:2);
	env2=EnvGen.kr(Env.new([0.1,1,0.1],[filtAtt,filtRel]),doneAction:0);
	//env3=EnvGen.kr(Env.new([0.01,1,0.01],[0.1,10]),doneAction:0);
	osc1=VarSaw.ar(freq,0,width);
	osc1=RLPF.ar(osc1,ffreq*env2,res)*env1;

//notice the multichannel expansion !2
	Out.ar(0, Limiter.ar(osc1*vol!2));
	}
).add;
)






(
~pattern=Pbindef(\synth,
	\instrument,\acid,
	\freq, Prand([30,32,30,40],inf).midicps,
	\ffreq, Pwhite(1000,8300),
	\dur, 0.13,
	\vol, 0.4,
	\res, Pwhite(0.1,0.9),
	\width, Pseq([0.1,0.2,0.4,0.9],inf),
	\envAtt,0.02,
	\envRel,0.23,
	\filtRel,0.01,
	\filtAtt,0.2,

);
)

~patternPlay=~pattern.play;
~patternPlay.stop;



//

Ndef.clear;


(
Ndef(\sin, {
	VarSaw.ar(LFTri.kr(rrand(0.1,10)).range(40,rrand(80,5000)),mul:0.5)!2;

}
);
)


(
Ndef(\sin, {
	SinOsc.ar(200,mul:0.6)!2;

}
);
)

Ndef(\sin).play;
Ndef(\sin).stop;
Ndef.clear;
Ndef(\sin).clear(20);


Ndef(\sin).fadeTime=4;


(
Ndef(\sin, {
	SinOsc.ar(rrand(40,1000),mul:0.4)!2;

}
);
)

(
Ndef(\sin, {
	SinOsc.ar(rrand(40,70).midicps,mul:0.4)!2;

}
);
)

Ndef(\sin).fadeTime=0.10;

//

(
Ndef(\sin, {
	VarSaw.ar([60,30,40,50,70].choose.midicps,mul:0.5)!2;

}
);
)

(
Ndef(\lfo, {
	LFDNoise3.kr(20).range(20,80).midicps

}
);
)

(
Ndef(\sin, { arg frekvenssi=100;
	VarSaw.ar(frekvenssi,mul:0.5)!2;

}
);
)



Ndef(\sin).map(\frekvenssi, Ndef(\lfo));



(
Ndef(\lfo, {
	LFTri.kr(1).range(20,1000)

}
);
)

(
Ndef(\lfo, {
	LFDNoise3.kr(LFDNoise0.kr(0.1).range(0.1,1000)).range(20,4000)

}
);
)

PlayBuf

Ndef.clear;



//samples

//helpfile
PlayBuf


Buffer.freeAll;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // remember to free the buffer later.

~b1=Buffer.read(s,"D:/tee/Aani/sample/fieldrecording/kasinoranta.wav");

b.bufnum;
(
Ndef(\sample,{arg bufnum;
	PlayBuf.ar(1,bufnum,rate:1,loop:1)!2;


}
);
)

Ndef(\sample).set(\bufnum, b);
Ndef(\sample).play;





(
Ndef(\sample,{arg bufnum;
	PlayBuf.ar(1,bufnum,rate:SinOsc.ar(0.1).range(-4,10),loop:1)!2;


}
);
)



(
Ndef(\sample,{arg bufnum;
	Mix.fill(20, {PlayBuf.ar(1,bufnum,rate:Rand(-2.0,2.0),startPos:SinOsc.ar(Rand(0.1,10)).unipolar*BufFrames.kr(b),loop:1)*0.1})!2;


}
);
)

Ndef




Ndef(\sample).filter(1, {arg in; RLPF.ar(in, LFTri.kr(LFTri.kr(0.1).range(0.1,10)).range(20,2000))});



Ndef(\sample).filter(1, {arg in; FreeVerb.ar(in, 1)});


Ndef(\sample).set(\wet2,0.3);

Ndef(\sample).set(\wet1,1);























//
