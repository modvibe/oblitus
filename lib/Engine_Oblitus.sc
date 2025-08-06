// Engine_Oblitus
// Binson Echorec emulation engine for norns
// Multi-tap delay with magnetic drum characteristics

Engine_Oblitus : CroneEngine {
    var <synth;
    var <delay_bus;
    var <wet_bus;
    var <delay_synths;
    var <input_level = 0.5;
    var <speed = 1.0;
    var <feedback = 0.3;
    var <mix = 0.5;
    var <mode = 1;
    var <head_states;
    
    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }
    
    alloc {
        // Initialize delay buses
        delay_bus = Bus.audio(context.server, 2);
        wet_bus = Bus.audio(context.server, 2);
        
        // Initialize head states (4 playback heads)
        head_states = [1, 0, 0, 0];
        
        // Create main processing synth
        SynthDef(\oblitus_main, {
            arg in_bus, out_bus, delay_bus, wet_bus, speed = 1.0, mix = 0.5, input_level = 0.5;
            var input, dry, wet, output;
            
            // Get audio input
            input = In.ar(in_bus, 2) * input_level;
            dry = input;
            
            // Send to delay bus
            Out.ar(delay_bus, input);
            
            // Receive processed signal from delay synths
            wet = In.ar(wet_bus, 2);
            
            // Mix dry and wet signals
            output = (dry * (1 - mix)) + (wet * mix);
            
            // Output
            Out.ar(out_bus, output);
        }).add;
        
        // Multi-tap delay synth with tape characteristics
        SynthDef(\oblitus_delay, {
            arg in_bus, out_bus, 
                delay_time_1 = 0.075, delay_time_2 = 0.15, 
                delay_time_3 = 0.225, delay_time_4 = 0.3,
                head_1 = 1, head_2 = 0, head_3 = 0, head_4 = 0,
                feedback = 0.3, speed = 1.0, mode = 1;
            
            var input, delayed, output;
            var delay_times, heads, taps;
            var tape_flutter, tape_tone;
            
            input = In.ar(in_bus, 2);
            
            // Calculate delay times based on speed (inverse relationship)
            delay_times = [delay_time_1, delay_time_2, delay_time_3, delay_time_4] / speed;
            heads = [head_1, head_2, head_3, head_4];
            
            // Magnetic tape characteristics
            tape_flutter = LFNoise2.kr(0.5).range(0.98, 1.02); // Speed flutter
            tape_tone = LPF.ar(input, 8000); // High frequency rolloff
            
            // Create delay taps
            taps = delay_times.collect { |time, i|
                var tap = DelayC.ar(tape_tone, 2.0, time * tape_flutter);
                tap = LPF.ar(tap, 6000 - (i * 800)); // Progressive HF loss
                tap = tap * heads[i]; // Head on/off
                tap;
            };
            
            // Mode-specific mixing
            output = case
                { mode == 1 } { // Echo mode - single repeat
                    taps[0] * 0.8;
                }
                { mode == 2 } { // Repeat mode - multiple repeats
                    var sum = taps[0] + (taps[1] * 0.7);
                    sum = DelayC.ar(sum + (sum * feedback), 2.0, delay_times[0]);
                    sum;
                }
                { mode == 3 } { // Swell mode - all heads
                    var sum = taps.sum / 4;
                    sum = sum + (sum * feedback * 0.3);
                    sum;
                };
            
            // Soft saturation for analog character
            output = (output * 2).tanh * 0.5;
            
            Out.ar(out_bus, output);
        }).add;
        
        context.server.sync;
        
        // Start main synth
        synth = Synth(\oblitus_main, [
            \in_bus, context.in_b,
            \out_bus, context.out_b,
            \delay_bus, delay_bus,
            \wet_bus, wet_bus,
            \speed, speed,
            \mix, mix,
            \input_level, input_level
        ], context.xg);
        
        // Start delay processing synth
        delay_synths = Synth(\oblitus_delay, [
            \in_bus, delay_bus,
            \out_bus, wet_bus,
            \feedback, feedback,
            \speed, speed,
            \mode, mode,
            \head_1, head_states[0],
            \head_2, head_states[1],
            \head_3, head_states[2],
            \head_4, head_states[3]
        ], context.xg);
        
        // Register OSC commands
        this.addCommand("speed", "f", { arg msg;
            speed = msg[1];
            synth.set(\speed, speed);
            delay_synths.set(\speed, speed);
        });
        
        this.addCommand("feedback", "f", { arg msg;
            feedback = msg[1];
            delay_synths.set(\feedback, feedback);
        });
        
        this.addCommand("mix", "f", { arg msg;
            mix = msg[1];
            synth.set(\mix, mix);
        });
        
        this.addCommand("input_level", "f", { arg msg;
            input_level = msg[1];
            synth.set(\input_level, input_level);
        });
        
        this.addCommand("head_state", "if", { arg msg;
            var head_num = msg[1].asInteger;
            var state = msg[2];
            if ((head_num >= 1) && (head_num <= 4)) {
                head_states[head_num - 1] = state;
                delay_synths.set(("head_" ++ head_num).asSymbol, state);
            };
        });
        
        this.addCommand("echo_mode", "", { arg msg;
            mode = 1;
            delay_synths.set(\mode, mode);
        });
        
        this.addCommand("repeat_mode", "", { arg msg;
            mode = 2;
            delay_synths.set(\mode, mode);
        });
        
        this.addCommand("swell_mode", "", { arg msg;
            mode = 3;
            delay_synths.set(\mode, mode);
        });
    }
    
    free {
        synth.free;
        delay_synths.free;
        delay_bus.free;
        wet_bus.free;
    }
}