/mob
    icon = 'icons/mobs.dmi'
    icon_state = "player"


/datum/screamer

/datum/screamer/New()
    . = ..()
    world.log << "screamer created"

/datum/screamer/Del()
    . = ..()
    world.log << "screamer deleted (out of scope)"

/client/verb/measure_and_del()
    _measure_and_del(src)

/proc/_measure_and_del(client/handle)
    set waitfor = FALSE
    sleep(1) // Detach from the verb
    measure(handle)
    world.log << "yeeting client"
    del(handle)
    world.log << "yoted client"

/proc/measure(client/handle)
    set waitfor = FALSE
    var/datum/screamer/lad = new()
    . = handle.MeasureText("Bullshit Garbage")
    // screamer del is called when this stack is exited
    world.log << "measure finished"