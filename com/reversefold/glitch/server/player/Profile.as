package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Profile extends Common {
        private static var log : Logger = Log.getLogger("server.player.Profile");

        public var config : Config;
        public var player : Player;
		
		public var home_profile;

        public function Profile(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


//
// this file contains functions that load data needed for displaying profiles
// on the website. things are componentized so we only load the data we need
// on each page.
//


//
// for each house, we make one remote call, which in turn makes one
// remote call to its parent street.
//

public function profile_get_houses(){
    if (!this.home_profile) this.profile_update_house_info();

    if (this.home_profile){
        return this.home_profile;
    } else {
        return {};
    }
}

public function profile_get_home_street(){
    if (!this.home_profile) this.profile_update_house_info();

    if (this.home_profile && this.home_profile.exterior){
        return this.home_profile.exterior;
    } else {
        return {};
    }
}

public function profile_update_house_info(){
    if (!this.home_profile) this.home_profile = {};

    if (!this.player.houses.home) return;

    var out = {};

    var found_house = false;

    for (var i in this.player.houses.home){
        var house = this.player.houses.home[i];
        if (house && !house.getProp('is_deleted')){
            out[i] = house.pols_get_profile_info();
        }
    }

    this.home_profile = out;
}

//
// one remote call per group
//

public function profile_get_groups(is_self){

    var out = [];

    if (!this.player.groups.groups) return out;

    for (var i in this.player.groups.groups){

        var info = this.player.groups.groups[i].get_basic_info();

        if (info.mode == 'public' || info.mode == 'public_apply' || is_self){

            out.push(info);
        }
    }

    return out;
}


//
// no remote calls, no IO
//

public function profile_get_metabolics(){

    var out = {};

    out.energy = {
        'value' : this.player.metabolics.energy.value,
        'max'   : this.player.metabolics.energy.top
    };

    out.mood = {
        'value' : this.player.metabolics.mood.value,
        'max'   : this.player.metabolics.mood.top
    };

    return out;
}


//
// no remote calls, loads all items in pack
//

public function profile_get_inventory(){

    var out = [];

    var items = this.player.apiGetAllItems();
    for (var i in items){
        var item = items[i];

        out.push({
            'tsid'      : item.tsid,
            'class_tsid'    : item.class_tsid,
            'stack_size'    : item.count
        });
    }

    return out;
}

    }
}
