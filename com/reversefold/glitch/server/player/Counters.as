package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import flash.utils.Dictionary;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Counters extends Common {
        private static var log : Logger = Log.getLogger("server.player.achievements");

		public var counters : Dictionary;
		public var label : String;
        public var config : Config;
        public var player : Player;

        public function Counters(config : Config, player : Player) {
            this.config = config;
            this.player = player;
            counters_init();
        }


//
// Management of counters on a player
// This is like the old achievements code, except it should be used sparingly
// Only for things that you need synchronous access to
//

public function counters_init(){
    if (this.counters === undefined || this.counters === null){
        //this.counters = apiNewOwnedDC(this);
        this.label = 'Counters';
        this.counters = new Dictionary();
    }
}

public function counters_delete_all(){
    if (this.counters){
        //this.counters.apiDelete();
        delete this.counters;
    }
}

public function counters_reset(){

    this.counters_init();
    this.counters = {};
}

public function counters_increment(group, label, count){
    this.counters_init();

    if (count === undefined){
        count = 1;
    }

    if (!this.counters[group]){
        this.counters[group] = {};
    }

    if (!this.counters[group][label]){
        this.counters[group][label] = count;
    }
    else{
        this.counters[group][label] += count;
    }
}

//
// Explicitly set a counter value
// Accomplished by nuking it and then calling counters_increment()
//

public function counters_set(group, label, count){
    this.counters_init();

    if (count === undefined){
        count = 1;
    }

    if (this.counters_get_label_count(group, label) == count) return;

    if (this.counters[group]){
        delete this.counters[group][label];
        if (!count) return;
    }

    this.counters_increment(group, label, count);
}

//
// Get a counter value
//

public function counters_get_label_count(group, label){
    if (!this.counters || !this.counters[group]){ return 0; }
    return int(this.counters[group][label]);
}

//
// Number of labels in a group
//

public function counters_get_group_count(group){
    if (!this.counters || !this.counters[group]){ return 0; }
    return num_keys(this.counters[group]);
}

//
// Sum of all labels in a group
//

public function counters_get_group_sum(group){

    try{
        var sum = 0;
        for (var label in this.counters[group]){
            sum += intval(this.counters[group][label]);
        }
        return sum;
    } catch(e){
        return 0;
    }
}

//
// Reset a counter
//

public function counters_reset_label_count(group, label){
    if (!this.counters || !this.counters[group]){ return 0; }

    delete this.counters[group][label];
    if (!num_keys(this.counters[group])) this.counters_reset_group(group);
}

public function counters_reset_group(group){
    delete this.counters[group];
}

//////////////////////////////////////////////////////////////////////

var counter_groups_to_sync = ['time_played'];
public function counters_sync_from_achievements(){
    for (var group in this.player.achievements.counters){
        if (!in_array_real(group, counter_groups_to_sync)) continue;

        for (var label in this.player.achievements.counters[group]){
            this.counters_set(group, label, this.player.achievements.counters[group][label]);
        }
    }
}

public function counters_fix_locations_visited(){
    var locations = this.counters.locations_visited;
    for (var i in locations){
        //log.info(this+' counters_fix_locations_visited checking location: '+i);
        var found = false;
        for (var group in this.counters){
            if (group.substr(0, 23) == 'streets_visited_in_hub_'){
                for (var label in this.counters[group]){
                    if (label == i){
                        found = true;
                        //log.info(this+' counters_fix_locations_visited found: '+i+', value: '+this.counters[group][label]);
                        break;
                    }
                }
            }

            if (found) break;
        }

        if (!found){
            log.info(this+' counters_fix_locations_visited not found: '+i);
            var loc = Server.instance.apiFindObject(i);
            if (loc && loc.countsTowardHubAchievement(this)){
                //log.info(this+' counters_fix_locations_visited counts toward achievement: '+i+', hub: '+loc.hubid);

                log.info(this+' counters_fix_locations_visited setting: streets_visited_in_hub_'+loc.hubid+', '+i+', '+locations[i]);
                this.player.achievements.achievements_set('streets_visited_in_hub_'+loc.hubid, i, locations[i]);
                this.counters_set('streets_visited_in_hub_'+loc.hubid, i, locations[i]);

                var count = this.counters_get_label_count('streets_visited_in_hub', 'number_'+loc.hubid);
                var group_count = this.counters_get_group_count('streets_visited_in_hub_'+loc.hubid);

                log.info(this+' counters_fix_locations_visited '+i+' group_count: '+group_count+', count: '+count);
                if (group_count > count){
                    this.player.achievements.achievements_set('streets_visited_in_hub', 'number_'+loc.hubid, group_count);
                    this.counters_set('streets_visited_in_hub', 'number_'+loc.hubid, group_count);
                }
            }
        }
    }
}

    }
}
