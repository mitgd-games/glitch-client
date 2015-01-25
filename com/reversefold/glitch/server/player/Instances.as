package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Instances extends Common {
        private static var log : Logger = Log.getLogger("server.player.instances");

        public var config : Config;
        public var player : Player;
		
		public var label : String;
		public var instances;
		public var previously;

        public function Instances(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


//
// http://svn.tinyspeck.com/wiki/SpecInstances
//

public function instances_init(){
    if (!this.instances){
        //this.instances = Server.instance.apiNewOwnedDC(this);
        this.label = 'Instances';
        this.instances = {};
        this.previously = {};
    }
}

public function instances_reset(){
    this.instances_delete_all();
    this.instances_init();
}

public function instances_delete_all(){
    if (this.instances){
        for (var i in this.instances.instances){
            if (this.instances.instances[i]){
                this.instances.instances[i].destroy(true);
            }
        }

        this.instances.instances = {};

        //this.instances.apiDelete();
        //delete this.instances;
    }
}

//
// Create an instance of label 'id' based on location 'base_tsid'
//

public function instances_create(id, base_tsid, options=null, location_options=null){
    var instance;
    if (this.instances_has(id)){
        // If they already have an instance with this id, make sure that the base_tsids match before re-using it
        instance = this.instances_get(id);
        if (instance.base_tsid == base_tsid) return instance;
        var locations = instance.get_locations();
        for (var i in locations){
            var loc = Server.instance.apiFindObject(locations[i]);
            if (loc && loc.getProp('instance_of') == base_tsid) return instance;
        }

        // Destroy it, we won't be using it
        instance.apiSetTimerX('destroy', 60*1000, true);
    }

    log.info(this+' Creating instance '+id);
    instance = Server.instance.apiNewGroup('instance');
    instance.init(id, base_tsid, options, location_options);

    this.instances_add(id, instance);

    return instance;
}

public function instances_add(id, instance){
    this.instances.instances[id] = instance;
}

//
// Enter instance 'id', if possible, at position x,y
//

public function instances_enter(id, x, y, immediate=false){
    var instance = this.instances_get(id);
    if (!instance) return false;

    log.info(this+' Entering instance '+id);

    // delete follow references */
    this.player.removeFollowers();

    if (instance.player_enter(this)){
        if (this.player.location.pols_is_pol() && !this.player.location.pols_is_owner(this) && !this.player.location.getProp('is_public')){
            this.instances.previously[id] = this.player.location.pols_get_entrance_outside();
        }
        else{
            this.instances.previously[id] = this.player.get_simple_location();
        }

        if (immediate){
            this.player.teleportToLocation(instance.get_entrance(), x, y);
        }
        else{
            this.player.teleportToLocationDelayed(instance.get_entrance(), x, y);
        }

        return true;
    }
    else if (instance.is_member(this)){
        // Already a member, move to the entrance
        if (!this.instances.previously[id]) this.instances.previously[id] = this.player.get_simple_location();
        if (immediate){
            this.player.teleportToLocation(instance.get_entrance(), x, y);
        }
        else{
            this.player.teleportToLocationDelayed(instance.get_entrance(), x, y);
        }

        return true;
    }

    return false;
}

//
// Tell instance 'id' we want to exit
//

public function instances_exit(id, randomize=false, no_auto_return=false){
    var instance = this.instances_get(id);
    if (!instance) return false;

    var prompt_uid = instance.get_prompt_uid();
    if (prompt_uid){
        this.player.prompts.prompts_remove(prompt_uid);
    }

    log.info(this+' Exiting instance '+id);
    return instance.player_exit(this, randomize, no_auto_return);
}

//
// The instance 'id' says we are leaving
//

public function instances_left(id, randomize, no_auto_return, force=false){
    var instance = this.instances_get(id);
    if (!instance) return false;

    log.info(this+' Left instance '+id);

    var prev = Utils.copy_hash(this.instances_get_exit(id));

    delete this.instances.instances[id];
    delete this.instances.previously[id];

    if ((!instance.getProp('no_auto_return') && !no_auto_return) || force){
        //
        // If we're dead and this happens, we should NOT teleport back to our location
        // Instead, we should swap the resurrect location with this one, UNLESS they are the same???
        //

        if (prev.tsid != this.player.location.tsid){
            log.info(this+' Instance previous location '+prev);
            if (!instance.is_location(this.player.location.tsid)){
                log.info(this+' not in a location in this instance');

                for (var i in this.instances.previously){
                    if (instance.is_location(this.instances.previously[i].tsid)){
                        log.info(this+' swapping in '+prev+' for '+i);
                        this.instances.previously[i] = prev;
                        break;
                    }
                }
            }
            else if (this.player.is_dead && prev != this.player.resurrect_location){
                this.player.resurrect_location = prev;
            }
            else{
                var x = prev.x;
                if (randomize) x += randInt(-150, 150);

                var prev_loc = Server.instance.apiFindObject(prev.tsid);
                if (prev_loc && prev_loc.pols_is_pol() && !prev_loc.pols_is_owner(this) && !prev_loc.getProp('is_public')){
                    prev_loc = prev_loc.pols_get_entrance_outside();
                }
                this.player.teleportToLocationDelayed(prev_loc.tsid, x, prev.y);
            }
        }
        else{
            log.info(this+' Already in '+prev);
        }
    }
    else{
        if (prev.tsid != this.player.location.tsid){
            log.info(this+' Instance previous location '+prev);
            if (!instance.is_location(this.player.location.tsid)){
                log.info(this+' not in a location in this instance');

                for (var i in this.instances.previously){
                    if (instance.is_location(this.instances.previously[i].tsid)){
                        log.info(this+' swapping in '+prev+' for '+i);
                        this.instances.previously[i] = prev;
                        break;
                    }
                }
            }
            else if (this.player.is_dead && prev != this.player.resurrect_location){
                this.player.resurrect_location = prev;
            }
        }
        else{
            log.info(this+' Already in '+prev);
        }
    }

    return true;
}

public function instances_get_exit(id){
    if (this.instances.previously[id]){
        return this.instances.previously[id];
    }
    else{
        return config.default_location;
    }
}

//
// Have the familiar tell us we're leaving
//

public function instances_exit_familiar(id, txt){
    this.player.familiar.familiar_send_alert_now({
        'callback'  : 'instances_exit_familiar_do',
        'txt'       : txt,
        'instance_id'   : id
    });
}

public function instances_exit_familiar_do(choice, details){
    var instance = this.instances_get(details.instance_id);
    //if (!instance) return;

    if (choice == 'start'){
        return {
            'txt' : details.txt,
            'choices' : {
                1: {
                    txt : 'OK',
                    value   : 'accept'
                }
            }
        };
    }

    if (choice == 'accept'){
        if (instance){
            this.instances_exit(details.instance_id);
        }
        else{
            this.player.teleportSomewhere();
        }
        return {
            done: true
        };
    }
}

//
// Player has logged out, tell instances
//

public function instances_logout(){
    this.instances_init();
    for (var i in this.instances.instances){
        if (this.instances.instances[i]) this.instances.instances[i].player_logout(this);
    }
}

//
// Player has logged in, tell instances
//

public function instances_login(){
    this.instances_init();
    for (var i in this.instances.instances){
        if (this.instances.instances[i]) this.instances.instances[i].player_login(this);
    }
}

//
// Get a reference to instance 'id'
//

public function instances_get(id){
    if (this.instances.instances[id]){
        return this.instances.instances[id];
    }
}

public function instances_has(id){
    return this.instances.instances[id] ? true : false;
}

//
// Run every time a player enters a location
//

public function instances_location_enter(loc){
    for (var i in this.instances.instances){
        var instance = this.instances.instances[i];
        if (!instance) continue;

        //
        // If this location is in the instance, let it know the player entered
        // Otherwise, tell the instance that the player is no longer in an instance location
        //

        if (instance.is_location(loc.tsid)){
            instance.player_entered_location(this, loc);
        }
        else{
            instance.player_exited_location(this, loc);
        }
    }
}

public function instances_schedule_exit_prompt(id, show_after){
    log.info(this+' schedling exit prompt '+id+' in '+show_after);
    return this.player.events.events_add({callback: 'instances_show_exit_prompt', instance_id: id}, show_after);
}

public function instances_show_exit_prompt(details){
    if (this.player.is_dead) return this.instances_schedule_exit_prompt(details.instance_id, 60);

    log.info(this+' showing exit prompt '+details.instance_id);
    var instance = this.instances_get(details.instance_id);
    if (!instance) return false;

    var uid = this.player.prompts.prompts_add({
        txt     : 'Are you stuck? Do you want to leave this place?',
        icon_buttons    : true,
        timeout     : 0,
        choices     : [
            { value : 'yes', label : 'Yes, please' },
            { value : 'no', label : 'No thanks' },
        ],
        callback    : 'instances_exit_via_prompt',
        instance_id : details.instance_id
    });

    instance.set_prompt_uid(uid);

    return true;
}

public function instances_exit_via_prompt(value, details){

    if (value == 'yes'){
        log.info(this+' exiting instance '+details.instance_id+' via prompt');

        this.instances_left(details.instance_id, false, false, true);
    }
    else{
        log.info(this+' delaying exiting instance '+details.instance_id+' via prompt');
        this.instances_schedule_exit_prompt(details.instance_id, 2*60);
    }
}

public function instances_cancel_exit_prompt(id){
    log.info(this+' Canceling exit prompt for instance '+id);
    var instance = this.instances_get(id);
    if (!instance) return false;

    this.player.events.events_remove(function(details){ return details.callback == 'instances_show_exit_prompt' && details.instance_id == id; });

    var prompt_uid = instance.get_prompt_uid();
    if (prompt_uid){
        this.player.prompts.prompts_remove(prompt_uid);
    }
}

////////////////////////////////////////////////////////////////////////////////

//
// Functions that have no other place
//

public function instances_create_delayed(details){
    this.instances_create(details.instance_id, details.tsid, details.options, details.location_options);
    if (!this.instances_enter(details.instance_id, details.x, details.y)){
        log.error(this+' could not enter '+details.instance_id+' instance');
    }
    else if (details.exit_delay){
        this.instances_schedule_exit_prompt(details.instance_id, details.exit_delay);
    }
}

public function instances_exit_delayed(details) {
    if(details.id) {
        this.instances_exit(details.id);
    }
}

// Finds the first instance exit point we have that is not *also* another instance
public function instances_unwind_exit(){
    for (var i in this.instances.previously){
        var prev = this.instances.previously[i];
        var prev_loc = Server.instance.apiFindObject(prev.tsid);
        if (prev_loc && !prev_loc.isInstance()) return prev;
    }

    return {};
}

// Quest hints
public function hintPrompt(text, time_delay, location_event_yes, location_event_no, yes_label, no_label) {
    if (!yes_label) { yes_label = "Yes, please" };
    if (!no_label) { no_label = "No thanks" };

    var uid = this.player.prompts.prompts_add({
        txt     : text,
        icon_buttons    : true,
        timeout     : 0,
        choices     : [
            { value : 'yes', label : yes_label },
            { value : 'no', label : no_label },
        ],
        callback    : 'hintResponse',
        location_event_yes: location_event_yes,
        location_event_no: location_event_no,
        hint_text: text,
        delay: time_delay
    });

}

public function  hintResponse(value, details) {
    if (value == "yes") {
        if (details.location_event_yes) {
            this.player.location.events_broadcast(details.location_event_yes);
        }
        //log.info("HINT: event is "+details.location_event+" and delay is "+details.delay);
    }
    else {
        if (details.delay > 0) {
            this.apiSetTimer("hintPrompt", details.delay, details.hint_text, details.delay, details.location_event_yes, details.location_event_no, details.choices[0].label, details.choices[1].label);
        }
        else {
            if (details.location_event_no) {
                this.player.location.events_broadcast(details.location_event_no);
            }
        }
    }
}

    }
}
