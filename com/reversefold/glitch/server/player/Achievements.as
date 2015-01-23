package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import flash.utils.Dictionary;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Achievements extends Common {
        private static var log : Logger = Log.getLogger("server.player.achievements");

        public var config : Config;
        public var player : Player;
		
		public var label : String;
		public var queue : Array;
		
		public var counters : Dictionary;
		public var achievements : Dictionary;
		
		public var place_time_counters;
		public var daily_counters;
		public var callback_queue;
		public var jump_count : int;
		public var utime : int;

        public function Achievements(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function achievements_init(){
    if (this.achievements === null){
        //this.achievements = apiNewOwnedDC(this);
        this.label = 'Achievements';
        this.achievements = new Dictionary();
        this.queue = [];
    }

    if (this.place_time_counters === undefined || this.place_time_counters === null){
        this.place_time_counters = {};
    }

    if (    (this.daily_counters === undefined || this.daily_counters === null) ||
        (this.daily_counters.today_key === undefined || this.daily_counters.today_key === null) ||
        this.daily_counters.today_key != current_day_key()
        ){
            this.daily_counters = {};
            this.daily_counters.today_key = current_day_key();
    }

    if (!this.callback_queue) this.callback_queue = {};
}

public function achievements_login(){
    this.achievements_run_queue();

    // Check for 11 secret locations start:
    if (this.player.stats.level >= this.player.eleven_secrets.secretLocationsQuestLevel()) {
        this.player.eleven_secrets.startSecretLocationsQuest();
    }
}

public function achievements_delete_all(){
	apiDeleteTimers();
	this.player.achievements = new Achievements(config, player);
	/*
    if (this.achievements){
        this.apiDelete();
        delete this.achievements;
    }
	*/
}

public function achievements_reset_counters(){
    // DO NOT do a callback here. This is just for removing the counters hash for players that have been migrated
    //delete this.counters;
	this.counters = null;
}

var achievements_to_save = ['collection_egg_hunter', 'collection_street_creator_dirt', 'collection_street_creator_earth', 'collection_street_creator_rock', 'collection_street_creator_wood', 'fine_friend', 'good_buddy', 'jolly_good_chap', 'a1_comrade', 'best_pal', 'ascended', 'ascended_level11', 'ascended_level23', 'ascended_level31', 'ascended_level41', 'ascended_level61', 'ascended_level83', 'ascended_level101']; // Don't forget to modify pc.resetForTesting() to make sure they also keep any associated trophies
public function achievements_reset(){

    this.achievements_init();
    //this.achievements = {};
    //this.queue = [];
    this.jump_count = 0;

    for (var id in this.achievements){
        if (!in_array_real(id, this.achievements_to_save)) delete this.achievements[id];
    }

    var ids_to_restore = [];
    for (var id in this.queue){
        if (in_array_real(id, this.achievements_to_save)) ids_to_restore.push(id);
    }

    for (var id in ids_to_restore){
        this.achievements_grant(id, true);
    }

    this.place_time_counters = {};

    Utils.http_post('callbacks/achievement_counter.php', {player: this.player.tsid, 'do_counter_reset': 1}, this.player.tsid);
}

//
// Increment a counter used for tracking achievement progress
//

public function achievements_increment(group, label, count, no_callback=false, immediate_callback=false){
    this.achievements_init();

    if (group && group.length > 50){
        log.error(this+' achievements_increment group is too long: '+group);
        return;
    }

    if (label && label.length > 60){
        log.error(this+' achievements_increment label is too long: '+label);
        return;
    }

    if (count === undefined){
        count = 1;
    }

    if ((this.player.location.is_newxp && this.player.location.class_tsid != 'newbie_island') || this.player.location.is_skillquest) return;

    //if (config.is_dev) log.info('Incrementing achievement counter '+group+' ' + label + ': '+count);
    if (!count) return;

    if (!no_callback){
        this.achievements_do_callback('increment', group, label, count);
        if (immediate_callback) this.achievements_run_callback_queue();
    }
}

public function achievements_increment_delayed(args) {
    this.achievements_increment(args.group, args.label, args.count);
}

//
// Decrement a counter, which we never do, except for collections
//

public function achievements_decrement(group, label, count){
    this.achievements_init();

    if (group && group.length > 50){
        log.error(this+' achievements_decrement group is too long: '+group);
        return;
    }

    if (label && label.length > 60){
        log.error(this+' achievements_decrement label is too long: '+label);
        return;
    }

    if (count === undefined){
        count = 1;
    }

    if ((this.player.location.is_newxp && this.player.location.class_tsid != 'newbie_island') || this.player.location.is_skillquest) return;

    //if (config.is_dev) log.info('Decrementing achievement counter '+group+' ' + label + ': '+count);

    this.achievements_do_callback('decrement', group, label, count);
}


//
// Explicitly set a counter value
// Accomplished by nuking it and then calling achievements_increment()
//

public function achievements_set(group, label, count){
    this.achievements_init();

    if (group && group.length > 50){
        log.error(this+' achievements_set group is too long: '+group);
        return;
    }

    if (label && label.length > 60){
        log.error(this+' achievements_set label is too long: '+label);
        return;
    }

    if (count === undefined){
        count = 1;
    }

    if ((this.player.location.is_newxp && this.player.location.class_tsid != 'newbie_island') || this.player.location.is_skillquest) return;

    this.achievements_do_callback('set', group, label, count);
}

//
// Reset a counter
//

public function achievements_reset_label_count(group, label){
    this.achievements_do_callback('set', group, label, 0);
}

public function achievements_reset_group(group){
    this.achievements_do_callback('set', group, null, 0);
}

public function achievements_do_callback(mode, group, label, value){
    if (!this.callback_queue) this.callback_queue = {};
    if (!this.callback_queue[mode]) this.callback_queue[mode] = {};
    if (!this.callback_queue[mode][group]) this.callback_queue[mode][group] = {};

    if (!label) label = 'no_label';
    if (!this.callback_queue[mode][group][label]) this.callback_queue[mode][group][label] = 0;
    if (value && mode != 'set') this.callback_queue[mode][group][label] += value;
    if (mode == 'set') this.callback_queue[mode][group][label] = value;

    if (!this.apiTimerExists('achievements_run_callback_queue')) this.apiSetTimer('achievements_run_callback_queue', 30000);
    return;
}

public function achievements_run_callback_queue(){

    var args = {
        player: this.player.tsid
    };

    var idx = 0;
    var remainder = {};
    //log.info(this.callback_queue);
    for (var mode in this.callback_queue){
        var groups = this.callback_queue[mode];
        for (var group in groups){
            var labels = groups[group];
            for (var label in labels){
                var value = labels[label];

                var l_args = {
                    mode: mode,
                    group: group
                };

                if (label != 'no_label') l_args.label = label;

                var key = 'achievement['+idx+']';
                for (var k in l_args){
                    args[key+'['+k+']'] = l_args[k];
                }

                if (value !== undefined){
                    args[key+'[value]'] = intval(value);
                    if (value - args[key+'[value]']){
                        if (!remainder[mode]) remainder[mode] = {};
                        if (!remainder[mode][group]) remainder[mode][group] = {};
                        if (!remainder[mode][group][label]) remainder[mode][group][label] = 0;
                        remainder[mode][group][label] += (value - args[key+'[value]']);
                    }
                    //log.info(args);

                    var achievements = this.achievements_get_from_counter(group, label);
                    for (var i in achievements){
                        var id = achievements[i];
                        if (!this.achievements_has(id) && !this.achievements_is_queued(id)){
                            var ac = this.achievements_get(id);

                            if (!ac || !num_keys(ac.conditions)) continue;

                            var key2 = key+'[to_check]['+id+']';
                            var conditions = '';
                            for (var j in ac.conditions){
                                var condition = ac.conditions[j];
                                if (num_keys(ac.conditions) == 1 && condition.type == 'has_currants') continue;

                                args[key2+'['+j+'][type]'] = condition.type;
                                if (condition.group) args[key2+'['+j+'][group]'] = condition.group;
                                if (condition.label) args[key2+'['+j+'][label]'] = condition.label;
                                args[key2+'['+j+'][value]'] = condition.value;
                            }
                        }
                    }
                }
                else{
                    //log.info(args);
                }

                //log.info(args);
                //utils.http_post('callbacks/achievement_counter.php', args, this.player.tsid);

                idx++;
            }
        }
    }

    if (num_keys(args) > 1){
        Utils.http_post('callbacks/achievement_counter.php', args, this.player.tsid);
    }

    this.callback_queue = remainder;
}

//
// Grant multiple achievements
//

public function achievements_grant_multiple(){
    if (config.is_dev) log.info(this+'achievements_grant_multiple');
    for (var i=0; i < arguments.length; i++){
        if (config.is_dev) log.info(this+'achievements_grant_multiple running: '+arguments[i]);
        this.achievements_grant(arguments[i]);
    }
}

//
// Grant the player an achievement
//

public function achievements_grant(id, close_payload = null){
    if (this.player.tsid == 'PCRN0MDLUUT195N' || config.is_dev) log.info(this+' achievements_grant '+id);
    if (this.achievements_has(id)) return;

    var achievement = this.achievements_get(id);
    if (!achievement){
        log.error(this+' unlocked invalid achievement: '+id);
        return;
    }

    Utils.http_post('callbacks/achievement_counter_by_day.php', {player: this.player.tsid, achievement: id, shareworthy: achievement.is_shareworthy}, this.player.tsid);

    //
    // If the player is offline, queue it
    //

    if (!this.player.isOnline() || ((!this.player.has_done_intro || this.player.location.is_newxp || this.player.location.is_skillquest) && this.player.location.class_tsid != 'newbie_island')){
        if (this.player.tsid == 'PCRN0MDLUUT195N' || config.is_dev) log.info(this+' achievements_grant queueing '+id);
        return this.achievements_add_queue(id);
    }

    if (this.player.tsid == 'PCRN0MDLUUT195N' || config.is_dev) log.info(this+' achievements_grant giving '+id);
    this.achievements[id] = time();


    var status = 'You got the '+achievement.name+' badge!';
    if (achievement.status_text) status = achievement.status_text;
    this.player.sendActivity(status, null, true);

    var text = this.label + ' just got the '+this.achievements_linkify(id)+' badge!';
    this.player.sendLocationActivity(text, this, this.player.buddies.buddies_get_ignoring_tsids());

    var out = {
        type            : 'achievement_complete',
        tsid            : id,
        name            : achievement.name,
        desc            : achievement.desc,
        swf_url         : achievement.url_swf,
        is_shareworthy  : achievement.is_shareworthy,
        status_text     : status,
        url             : config.web_root+'/profiles/'+this.player.tsid+'/achievements/'+achievement.url+'/'
    };

    if (close_payload) out.close_payload = close_payload;

    // If we have the silvertongue buff, adjust achievement values accordingly
    var multiplier = this.player.buffs.buffs_has('gift_of_gab') ? 1.2 : this.player.buffs.buffs_has('silvertongue') ? 1.05 : 1.0;
    multiplier += this.player.imagination.imagination_get_achievement_modifier();

    // See here: http://bugs.tinyspeck.com/8804
    // It would be nice if we had access to the category, but luckily these completist achievements are
    // easy to detect.
    if (/completist/.exec(id)) {
        log.info(this+" level is "+this.player.stats.stats_get_level()+" and multiplier is "+multiplier);

        var level = this.player.stats.stats_get_level();

        if (level > 4){
            multiplier *= (this.player.stats.stats_get_level() / 4);
        }

        log.info(this+" new multiplier is "+multiplier);
    }

    var ac_rewards = achievement.rewards;
    if (ac_rewards){

        out.rewards = {
            xp      : round_to_5(ac_rewards.xp * multiplier),
            energy      : round_to_5(ac_rewards.energy  * multiplier),
            mood        : round_to_5(ac_rewards.mood  * multiplier),
            currants    : round_to_5(ac_rewards.currants  * multiplier)
        };

        if (ac_rewards.favor){
            out.rewards.favor = [{
                giant   : ac_rewards.favor.giant,
                points  : round_to_5(ac_rewards.favor.points * multiplier)
            }];
        }

        if (ac_rewards.items){
            out.rewards.items = ac_rewards.items;
        }

        if (ac_rewards.recipes){
            var recipes = {};
            for (var i in ac_rewards.recipes){
                if (!this.player.making.making_recipe_is_known(ac_rewards.recipes[i].recipe_id)){
                    recipes[i] = ac_rewards.recipes[i].recipe_id;
                }
            }
            out.rewards.recipes = recipes;
        }

        if (out.rewards.xp){
            if (!out.rewards.imagination) out.rewards.imagination = 0;
            out.rewards.imagination += out.rewards.xp;
            out.rewards.imagination = round_to_5(out.rewards.imagination);
            delete out.rewards.xp;
        }

    }
    else{
        out.rewards = {};
    }

    if (achievement.collection_type){
        //
        // Remove all items from the player's inventory
        //

        var trophy_items = [];
        for (var i in achievement.conditions){
            var condition = achievement.conditions[i];
            if (condition.group == 'in_inventory'){
                if (achievement.collection_type == 2) this.player.items.items_destroy(condition.label, condition.value);

                var prot = Server.instance.apiFindItemPrototype(condition.label);
                if (prot){
                    var item = {
                        class_tsid  : condition.label,
                        label       : prot.name_single,
                        desc        : prot.description
                    };

                    // Items with sounds
                    if (prot.is_musicblock){
                        item.sound = config.sounds.music_map[condition.label.toUpperCase()];
                    }

                    trophy_items.push(item);
                }
            }
        }

        var trophy = this.achievement_get_trophy(id);


        this.player.daily_history.daily_history_push('collections', id);

        out.type = 'collection_complete';
        out.trophy_items = trophy_items;
        out.trophy = trophy;

        out.sound = 'TROPHY_RECEIVED';

        Server.instance.apiLogAction('TROPHY_UNLOCKED', 'pc='+this.player.tsid, 'achievement='+id, 'xp='+intval(out.rewards.imagination), 'mood='+intval(out.rewards.mood), 'energy='+intval(out.rewards.energy), 'currants='+intval(out.rewards.currants), 'favor_giant='+(out.rewards.favor ? out.rewards.favor[0].giant : 'none'), 'favor_points='+(out.rewards.favor ? intval(out.rewards.favor[0].points) : 0));
    }
    else{
        this.player.daily_history.daily_history_push('achievements', id);
        out.sound = 'ACHIEVEMENT_UNLOCKED';


        Server.instance.apiLogAction('ACHIEVEMENT_UNLOCKED', 'pc='+this.player.tsid, 'achievement='+id, 'xp='+intval(out.rewards.imagination), 'mood='+intval(out.rewards.mood), 'energy='+intval(out.rewards.energy), 'currants='+intval(out.rewards.currants), 'favor_giant='+(out.rewards.favor ? out.rewards.favor[0].giant : 'none'), 'favor_points='+(out.rewards.favor ? intval(out.rewards.favor[0].points) : 0));
    }
    this.apiSendMsgAsIs(out);

    if (achievement.onComplete) achievement.onComplete.call(achievement, this);
    if (achievement.on_apply) achievement.on_apply.call(achievement, this);

    this.player.activity_notify({
        type    : 'achievement',
        id  : id
    });
}

public function achievements_add_queue(id){
    if (!this.queue) this.queue = [];

    if (this.achievements_is_queued(id)) return;
    this.queue.push(id);
    this.utime = time();
}

public function achievements_run_queue(){
    if (this.player.tsid == 'PCRN0MDLUUT195N') log.info(this+' achievements_run_queue');
    if (!this.queue || !this.queue.length) return;

    var queue = Utils.copy_hash(this.queue);
    this.queue = [];

    for (var i in queue){
        if (this.player.tsid == 'PCRN0MDLUUT195N') log.info(this+' achievements_run_queue giving '+queue[i]);
        this.achievements_grant(queue[i]);
    }
}

public function achievements_get_queue(){
    return this.queue;
}

public function achievements_is_queued(id){
    if (!this.achievements || !this.queue) return false;

    return in_array_real(id, this.queue);
}

public function achievement_get_trophy(id){
    var achievement = this.achievements_get(id);

    var trophy = {};
    if (achievement && achievement.rewards && achievement.rewards.items){
        for (var i in achievement.rewards.items){
            var it = achievement.rewards.items[i];
            var prot = Server.instance.apiFindItemPrototype(it.class_id);
            if (prot && prot.is_trophy){
                trophy = {
                    class_tsid  : it.class_id,
                    label       : prot.name_single,
                    desc        : prot.description
                };
            }
        }
    }

    return trophy;
}

//
// Test if the player has an achievement
//

public function achievements_has(id){
    return this.achievements[id] ? 1 : 0;
}

public function achievements_delete(id){
    delete this.achievements[id];
}

//
// Like the old achievements_check_requirements, but *only* checks in_inventory requirements -- for collection achievements
//

public function achievements_check_in_inventory(id){

    var ac = this.achievements_get(id);

    if (!ac || !num_keys(ac.conditions)) return false;

    for (var condition in ac.conditions){
        var data = ac.conditions[condition];

        if (data.type === null){
            return false;
        }
        else if (data.type == 'counter' && data.group == 'in_inventory'){
            if (this.player.bag.countItemClass(data.label) < intval(data.value)){
                return false;
            }
        }
        else{
            log.error('Undefined achievement condition for '+id+' in achievements_check_in_inventory(): '+data.type+' - '+data.group);
            return false;
        }
    }

    return true;
}

//
// Get a list of achievement ids that have the counter as a condition
//

// Defined once here, instead of inside the loop in achievements_get_from_counter, for perf reasons
var group_types = ['group_count', 'group_sum'];

public function achievements_get_from_counter(group, label){
    var out = {};

    // Retarded, but serguei insists it's faster
    var local_group_types = this.group_types;

    var counters = config.base.data_achievement_counters;
    for (var type in counters){
        var groups = counters[type];
        for (var counter_group in groups){
            var labels = groups[counter_group];
            for (var counter_label in labels){
                var classes = labels[counter_label];
                for (var i in classes){
                    var class_id = classes[i];

                    var matches = false;
                    if (in_array_real(type, local_group_types) && counter_group == group){
                        matches = true;
                    }
                    else if (type == 'counter' && counter_group == group && counter_label == label){
                        matches = true;
                    }

                    if (matches){
                        out[class_id] = class_id;
                    }
                }
            }
        }
    }

    return out;
}

//
// Fetch the details of an achievement
//

public function achievements_get(id){
    try{
        var prot = Server.instance.apiGetJSFileObject('achievements/'+id+'.js');
        return prot;
    }
    catch(e){
        log.error('Could not load non-existent achievement: '+id);
        return null;
    }
}

public function achievements_get_name(id){
    var achievement = this.achievements_get(id);
    if (!achievement) return '';

    return achievement.name;
}

public function achievements_linkify(id){
    var achievement = this.achievements_get(id);

    if (!achievement) return '';

    if (!achievement.is_secret) {
        return '<a href=\"event:external|http://www.glitch.com/achievements/'+achievement.category+'/'+achievement.url+'/\">'+achievement.name+'</a>';
    }

    return achievement.name;
}

//
// Get a list of the achievements the player has
//

public function achievements_get_list(){

    var out = [];

    for (var i in this.achievements){

        var achievement = Utils.copy_hash(this.achievements_get(i));
        if (achievement){
            achievement.id = i;
            achievement.when = this.achievements[i];

            out.push(achievement);
        }
    }

    return out;
}

public function achievements_get_profile(){

    if (!this.achievements) return {};

    var out = {};

    for (var i in this.achievements){
        var key = '.' + this.achievements[i] + i;

        out[i] = this.achievements[i];
    }

    return out;
}

public function achievements_get_all(){

    var out = {};

    for (var i in this.achievements){

        out[i] = this.achievements[i];
    }

    return out;
}

public function achievementsGetCount(){
    return this.achievements.__length;
}

public function achievementsGetLatest(){
    var row = this.achievements.__latestKeyValue;

    if (row.key){
        var latest_achievement = Utils.copy_hash(this.achievements_get(row.key));
        if (!latest_achievement) return null;

        latest_achievement.id = row.key;
        latest_achievement.when = row.value;

        return latest_achievement;
    } else {
        return null;
    }
}

var leaderboardless_achievements = ['ascended', 'ascended_level11', 'ascended_level23', 'ascended_level31', 'ascended_level41', 'ascended_level61', 'ascended_level83', 'ascended_level101'];
public function achievements_get_leaderboard_count(){

    var count = 0;
    for (var i in this.achievements){
        if (!in_array_real(i, this.leaderboardless_achievements)) count++;
    }

    return count;
}

//
//
//
//  Daily trackers
//
//
//

// For testing only:
public function achievements_reset_daily() {
    this.daily_counters = {};
}

public function achievements_increment_daily(group, label, count){
    if (group == 'today_key'){
        log.error('Invalid group sent to achievements_increment_daily');
        return false;
    }

    this.achievements_init();

    if (count === undefined){
        count = 1;
    }

    //if (config.is_dev) log.info('Incrementing achievement counter '+group+' ' + label + ': '+count);
    if (!count) return;

    if (!this.daily_counters[group]){
        this.daily_counters[group] = {};
    }

    if (!this.daily_counters[group][label]){
        this.daily_counters[group][label] = count;
    }
    else{
        this.daily_counters[group][label] += count;
    }
}

public function achievements_get_daily_label_count(group, label){
    this.achievements_init();
    if (!this.daily_counters[group]){ return 0; }
    return intval(this.daily_counters[group][label]);
}

//
// Number of labels in a group
//

public function achievements_get_daily_group_count(group){
    this.achievements_init();
    if (!this.daily_counters[group]){ return 0; }
    return num_keys(this.daily_counters[group]);
}

//
// Sum of all labels in a group
//

public function achievements_get_daily_group_sum(group){
    this.achievements_init();
    if (!this.daily_counters[group]){ return 0; }

    var sum = 0;
    for (var label in this.daily_counters[group]){
        sum += intval(this.daily_counters[group][label]);
    }
    return sum;
}

//
// Arbitrary place-based limits for arbitrary times
//
// (aka Piggy-capturing limit)
//

public function achievements_set_place_time(action, place, ts){
    this.achievements_init();

    if (!this.place_time_counters[action]){
        this.place_time_counters[action] = {};
    }
    this.place_time_counters[action][place] = ts;
    return true;
}

public function achievements_set_place_time_now(action, place){
    var now = time();
    return this.achievements_set_place_time(action, place, now);
}

public function achievements_get_place_time(action, place){
    this.achievements_init();

    if (!this.place_time_counters[action] || !this.place_time_counters[action][place]){
        return false;
    } else {
        return this.place_time_counters[action][place];
    }
}

public function achievements_reset_place_time(action, place){
    this.achievements_init();

    if (!this.place_time_counters[action] || !this.place_time_counters[action][place]){
        return false;
    } else {
        delete this.place_time_counters[action][place];
        return true;
    }
}

public function achievements_reset_place_time_action(action){
    this.achievements_init();

    if (!this.place_time_counters[action]){
        return false;
    } else {
        delete this.place_time_counters[action];
        return true;
    }
}

public function achievements_place_time_ago_enough(action, place, delta){
    this.achievements_init();

    if (!this.place_time_counters[action] || !this.place_time_counters[action][place]){
        return true;
    } else {
        return (time() - delta > this.place_time_counters[action][place]) ? true : false;
    }
}


public function achievements_admin_get_when(args){

    if (this.achievements[args.class_tsid]){
        return this.achievements[args.class_tsid];
    }

    return 0;
}

    }
}
