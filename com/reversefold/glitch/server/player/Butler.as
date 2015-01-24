package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Butler extends Common {
        private static var log : Logger = Log.getLogger("server.player.butler");

        public var config : Config;
        public var player : Player;
		
		public var butler_tsid;
		public var last_command_time;

        public function Butler(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function createButler(x_pos) {

    if (this.butler_tsid) {

        var old_butler = Server.instance.apiFindObject(this.butler_tsid);

        if (!old_butler || (old_butler.location != this.player.houses.home.exterior)) {
            // check for error cases - if we find one, just delete the butler and start over
            this.removeButler();
        }
        else {
            this.player.sendActivity("You already have a Butler.");
            return; // only one butler per person
        }
    }

    var loc = this.player.houses.home.exterior;

    if (!loc) { return; }

    var butler = null;
    if (loc == this.player.location) {
        if (Math.abs(x_pos - this.player.x) < 25) {
            if ((this.player.x +50) < this.player.location.geo.r) {
                x_pos = this.player.x +50;
            }
            else {
                x_pos = this.player.x - 50;
            }
        }

        butler = this.player.location.createItemStackWithPoof('bag_butler', 1, x_pos, this.player.y);
    }
    else {
        this.player.sendActivity("You must be on your home street to create a butler.");
    }

    if (butler) {
        butler.setInstanceProp('owner_tsid', this.player.tsid);
        this.butler_tsid = butler.tsid;
        butler.randomize();

        butler.apiSetTimerX("doIntro", 2000, this); //.doIntro(this);

        // Can't update the butler on creation because the location isn't set yet. Do it here instead:
        butler.stateChange("attending", "start");
        this.last_command_time = new Date().getTime();
        butler.stepBackFromPlayer(this, this.player.x);

        butler.onUpdate();
    }
}

public function removeButler(){
    if (!this.butler_tsid) { return; }

    var butler = Server.instance.apiFindObject(this.butler_tsid);

    log.info("Deleting butler "+butler);

    if (butler) {
        butler.im_close(this);
        butler.apiDelete();
    }

    this.butler_tsid = null;
}

public function has_butler(){
    return this.butler_tsid ? true : false;
}

public function giveButlerBox() {

    if (this.has_butler()) {
        return;
    }

    if (!this.player.has_done_intro || this.player.return_to_gentle_island || this.player.quests.getQuestStatus('leave_gentle_island') == 'todo'){
        return;
    }

    if (this.player.stats.stats_get_level() < 3) {
        return;
    }

    if (this.player.houses.home && this.player.houses.home.exterior && this.player.houses.home.exterior.item_exists("butler_box")) {
        return;
    }

    if (this.player.houses.home && this.player.houses.home.exterior) {
        this.player.houses.home.exterior.createItemStackWithPoof('butler_box', 1, 50, -97);
    }
}

public function getButler(){
    if (this.butler_tsid) {
        return Server.instance.apiFindObject(this.butler_tsid);
    }

    return null;
}

// Transmit info to butlers for improved buttling

public function notifyButlersAboutTower(){

    var tower_data = {  player: this.player.tsid,
                        completion_time: time()        // timestamp in seconds
                    };

    var tsids = this.player.buddies.buddies_get_reverse_tsids();

    var player = null;
    var butler = null;
    for (var id in tsids) {
        player = getPlayer(tsids[id]);
        if (player) {
            butler = player.getButler();
            if (butler) {
                butler.notifyAboutTower(tower_data);
            }
        }
    }
}

    }
}
