package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Moutaineering extends Common {
        private static var log : Logger = Log.getLogger("server.player.Moutaineering");

        public var config : Config;
        public var player : Player;

        public function Moutaineering(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


// Overlay display
// If isFaded is true, the overlay will fade in for the 1.5 * the number of seconds specified in
// this.rungs[rung].freezeTime (see config.party_spaces).
public function displayFreeze(rung, isFaded=false){
    //log.info("MT displaying freeze for "+rung);

    if (!this.player.party.party || !this.player.party.party.get_space()) {
        log.error("MT mountain function called on player who's not in a party space");
        return;
    }

    var rungs = this.player.party.party.get_space().getProp('rungs');
    var data = rungs[rung];

    for (var id in data.ids) {
        if (isFaded) {
            //log.info("MT Turning on "+data.ids[id]+" with fade time "+data.freezeTime*1500);
            this.player.announcements.geo_deco_toggle_visibility(data.ids[id], true, data.freezeTime * 1500);
        }
        else {
            //log.info("MT Turning on "+data.ids[id]);

            this.player.announcements.geo_deco_toggle_visibility(data.ids[id], true);
        }
    }
}

// Overlay removal
public function removeFreeze(rung) {

    if (!this.player.party.party || !this.player.party.party.get_space()) {
        log.error("MT mountain function called on player who's not in a party space");
        return;
    }


    var rungs = this.player.party.party.get_space().getProp('rungs');
    var data = rungs[rung];

    for (var id in data.ids) {
        //log.info("MT Turning off "+data.ids[id]);
        this.player.announcements.geo_deco_toggle_visibility(data.ids[id], false, 1);
    }
}

// Called at end of intro sequence
public function displayAllRungs() {
    var rungs = this.player.party.party.get_space().getProp('rungs');
    var current_freeze_rung = this.player.location.getCurrentFreezeRung();

    for (var r in rungs) {
        if (r >= current_freeze_rung) {
            this.displayFreeze(r);
        }
        else {
            this.removeFreeze(r);
        }
    }

    this.player.location.recordMountaineer(this.player.tsid);
}

// Pan the camera to a rung and turn the deco on for that rung if necessary.
// Then schedule a timer to show the next rung.
public function showRung(rung) {
    //this.player.sendActivity("Showing rung "+rung+" current freeze at "+current_freeze_rung);

    if (!this.player.party.party || !this.player.party.party.get_space()) {
        log.error("MT mountain function called on player who's not in a party space");
        return;
    }

    var rungs = this.player.party.party.get_space().getProp('rungs');
    var rung_data = rungs[rung];

    var height = rung_data.yPos - /*0.5*/rung_data.height;
    this.player.sendActivity("MT Intro moving camera to "+height);
    log.info("MT intro moving camera to "+height);

    this.player.apiSendMsg({
        type: 'camera_center',
        pt:{x:0, y:height},
        duration_ms: 1500
    });

    //if (rung == current_freeze_rung) {
        //this.player.sendActivity("Scheduling freeze display");
        this.apiSetTimerX('displayAllRungs', 3000);
    //}

    /*if (rung > 1) {
        this.apiSetTimerX("showRung", 1500, rung-1, current_freeze_rung);
    }*/
}

public function onColdZone(box) {
    var player_height = Math.round(60);
    var player_width =  Math.round(50);
    log.info("MT coldzone player pos "+this.player.x+" "+this.player.y+" dims "+player_height+" "+player_width+" box pos "+box.x+" "+box.y+" dims "+box.w+" "+box.h);
    if (this.player.x+(player_width/2) >= box.x-(box.w/2) &&
        this.player.x-(player_width/2) <= box.x+(box.w/2) &&
        this.player.y - player_height <= box.y &&                          // top of player above bottom of box
        this.player.y >= box.y-box.h){     // bottom of player below top of box
        this.player.metabolics.metabolics_lose_energy(3);
        this.apiSetTimerX('onColdZone', 1000, box);

        log.info("MT player in coldzone");
        log.info("MT "+(this.player.y-player_height)+" "+box.y);
        log.info("MT "+this.player.y+" "+(box.y-box.h));

        var messages = ['Buurrr! A cold zone.',
                        'Urf. A blast of chill fills your little Glitch veins.',
                        'It feels colder here then other areas of the mountain.',
                        'An icy chill washes over you.',
                        'Soooooo Coooooold!'];


        this.player.announcements.apiSendAnnouncement({
            type: 'vp_canvas',
            uid: 'cold_zone',
            canvas: {
                color: '#0000cc',
                steps: [
                    {alpha:.5, secs:.5},
                    {alpha:.5, secs:.25},
                    {alpha:0, secs:.5},
                    {alpha:0, secs:3.75}
                ],
                loop: false
            }
        });

        this.player.sendActivity(choose_one(messages));
    }
}

public function onEnterVWindZone(id) {
    this.player.physics.addCTPCPhysics({   gravity: 4,
                            vx_max: 1.0
                        }, this.player.tsid
                        );

    this.onSendWindMessage();
    //log.info("MT entered windzone");
    this.onWindZone(id);
}

public function onEnterHWindZone(id) {
    this.player.physics.addCTPCPhysics({
                        //gravity: 4,
                        vx_accel_add_in_air : 2,
                        vx_accel_add_in_floor: 2
                        //duration_ms : 4000
                        }, this.player.tsid
                        );

    this.onSendWindMessage();
    //log.info("MT entered windzone");
    this.onWindZone(id);
}

public function onSendWindMessage() {
    var messages = ["The wind is so strong here that it's like walking into a wall of air.",
                        'You are suddenly blown around like a ragdoll.',
                        'Urg. A sudden gust of wind hits you.',
                        'A blast of wind cuts straight through to your bones.',
                        "Woah! It's windy here."
                        ];

    this.player.sendActivity(choose_one(messages));
}

public function onExitWindZone(id) {
    this.player.physics.removePhysics(this.player.tsid, true);

    this.player.location.removePlayerFromWind(this.player.tsid, id);
}

public function onWindZone(id, box=null) {
    //log.info("MT checking windzone");

    // If it's not a mountaineering level, bail out.
    if (!this.player.location.isMountain || !this.player.location.isMountain()) {
        return;
    }

    // If there's no box, then find the box (this happens the first time through).
    if (!box) {
        box = this.player.location.find_hitbox_by_id(id);
    }

    // If the id was bad, then bail out.
    if (!box) return;

    //log.info("MT windzone box is "+box);

    var player_height = Math.round(60);
    var player_width =  Math.round(50);

    //log.info("MT player height "+player_height+" width "+player_width);
    //log.info("MT player position "+this.player.x+" "+this.player.y);


    if (this.player.x+(player_width/2) >= box.x-(box.w/2) &&
        this.player.x-(player_width/2) <= box.x+(box.w/2) &&
        this.player.y - player_height <= box.y &&  // top of player above bottom of box
        this.player.y >= box.y-box.h){             // bottom of player below top of box
        //log.info("MT in windzone");
        this.apiSetTimerX('onWindZone', 500, id, box);
    }
    else {
        //log.info("MT out of windzone");
        //this.player.sendActivity("Whew. You're out of the wind. ");
        this.onExitWindZone(id);
    }
}

    }
}
