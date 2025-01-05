/mob
    icon = 'icons/mobs.dmi'
    icon_state = "player"

/mob/verb/set_sustain_cpu(value as num)
	world << "sustain_cpu set to [value]"
	sustain_cpu = value

/mob/verb/set_sustain_chance(value as num)
	world << "sustain_chance set to [value]"
	sustain_chance = value


/world
	loop_checks = FALSE

#define CPU_SIZE 60
#define WINDOW_SIZE 16

#define WRAP(val, min, max) clamp(( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) ),min,max)

#define CONSUME_UNTIL(target_usage) \
	while(world.tick_usage < (target_usage)) {\
		var/_knockonwood_x = 0;\
		_knockonwood_x += 20;\
	}

var/list/cpu_values = new /list(CPU_SIZE)
var/list/avg_cpu_values = new /list(CPU_SIZE)
var/cpu_index = 1
var/last_cpu_update = -1
var/obj/screen/usage_display/cpu_tracker = new()

/obj/screen/usage_display
	screen_loc = "CENTER-2, CENTER+3"
	maptext_width = 256
	maptext_height = 256
	color = list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,1,0)
	plane = 1

var/sustain_cpu = 0
var/sustain_chance = 100

/world/Tick()
	unroll_cpu_value()
	if(sustain_cpu && prob(sustain_chance))
		// avoids  byond sleeping the loop and causing the MC to infinistall
		CONSUME_UNTIL(min(sustain_cpu, 10000))


/world/proc/unroll_cpu_value()
	if(last_cpu_update == world.time)
		return
	last_cpu_update = world.time
	var/avg_cpu = world.cpu

	// We need to hook into the INSTANT we start our moving average so we can reconstruct gained/lost cpu values
	var/lost_value = 0
	// Defaults to null or 0 so the wrap here is safe for the first 16 entries
	lost_value = cpu_values[WRAP(cpu_index - WINDOW_SIZE, 1, CPU_SIZE + 1)]

	// ok so world.cpu is a 16 entry wide moving average of the actual cpu value
	// because fuck you
	// I want the ACTUAL unrolle value, so I need to deaverage it. this is possible because we have access to ALL values and also math
	// yes byond does average against a constant window size, it doesn't account for a lack of values initially it just sorta assumes they exist.
	// ♪ it ain't me, it ain't me ♪

	// Second tick example
	// avg = (A + B) / 4
	// old_avg = (A) / 4
	// (avg * 4 - old_avg * 4) roughly sans floating point BS = B
	// Fifth tick example
	// avg = (B + C + D + E) / 4
	// old_avg = (A + B + C + D) / 4
	// (avg * 4 - old_avg * 4) roughly = E - A
	// so after we start losing numbers we need to add the one we're losing
	// We're trying to do this with as few ops as possible to avoid noise
	// soooo
	// E = (avg * 4 - old_avg * 4) + A

	var/last_avg_cpu = avg_cpu_values[WRAP(cpu_index - 1, 1, CPU_SIZE + 1)]
	var/real_cpu = (avg_cpu * WINDOW_SIZE - last_avg_cpu * WINDOW_SIZE) + lost_value

	// cache for sonic speed
	cpu_values[cpu_index] = real_cpu
	avg_cpu_values[cpu_index] = avg_cpu
	cpu_index = WRAP(cpu_index + 1, 1, CPU_SIZE + 1)
	var/full_time = CPU_SIZE * world.tick_lag / 10 // convert from ticks to seconds
	cpu_tracker.maptext = "Tick: [world.time / world.tick_lag]\nFrame Behind CPU: [real_cpu]\nMax [full_time]s: [max(cpu_values)]\nMin [full_time]s: [min(cpu_values)]"

/client/New()
	screen += cpu_tracker
	return ..()