package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Prop;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import flash.utils.Dictionary;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Stats extends Common {
        private static var log : Logger = Log.getLogger("server.player.Stats");

		private var stats : Stats;

        public var config : Config;
        public var player : Player;

		public var xp : Prop;
		public var level : int;
		public var currants : Prop;
		public var daily_quoin_limit : int;
		public var quoins_today : Prop;
		public var meditation_today : Prop;
		public var misc : Dictionary;
		public var favor_points : Dictionary;
		public var street_history : *;
		public var giant_emblems : Dictionary;
		public var rube_trades : Prop;
		public var rube_lure_disabled : Prop;
		public var imagination : Prop;
		public var credits : Prop;
		public var quoin_multiplier : int;
		public var has_subscription : Boolean = false;
		public var level_up_time : int;
		public var making_xp_today : Prop;
		public var recipe_xp_today : Dictionary = null;
		public var last_rube_trade : int;
		public var daily_count : Dictionary = null;
		public var subscription_end;
		public var charades;
		
		public var daily_favor : Dictionary;
		
		public var donation_xp_today : Prop;

        public function Stats(config : Config, player : Player) {
			stats = this;

            this.config = config;
            this.player = player;
        }

public function stats_init(){

    if (config.level_limit){
        var info = this.stats_calc_level_xp_needed(config.level_limit);
        this.xp = new Prop(0, 0, info[config.level_limit].xp_for_this);
    }
    else{
        this.xp = new Prop(0, 0, 2000000000);
    }

    var temp_level = this.stats_calc_level_from_xp_simple(this.xp.value);
    if (this.level != temp_level){
        this.level = temp_level;
    }

    this.currants = new Prop(0, 0, 2000000000);


    var quoin_limit = (this.daily_quoin_limit) ? this.daily_quoin_limit : this.player.imagination.imagination_get_quoin_limit();

    this.quoins_today = new Prop(0, 0, quoin_limit);
    // WTF is this? Why do we delete right after initing? if (this.quoins_today) delete this.quoins_today;
    this.meditation_today = new Prop(0, 0, (this.player.get_meditation_bonus() * this.player.metabolics.metabolics_get_max_energy()));
    // WTF? Why do we delete right after initing? if (this.meditation_today) this.meditation_today = null;

    if (!this.misc) this.misc = new Dictionary();
    if (!this.favor_points) {
        this.favor_points = new Dictionary();
    }

    if (!this.street_history){
    //if (this.street_history === undefined || this.street_history === null){
        this.street_history = {};//apiNewOwnedDC(this);
        this.street_history.label = 'Street History';
        this.street_history.streets = {};
        this.street_history.pols = {};
    }

    if(this.giant_emblems === undefined || this.giant_emblems === null) {
        this.giant_emblems = new Dictionary();
    }

    this.rube_trades = new Prop(0, 0, 3);
    this.rube_lure_disabled = new Prop(0, 0, 1);

    this.imagination = new Prop(0, 0, 2000000000);
    this.credits = new Prop(0, 0, 2000000000);
	
	this.making_xp_today = new Prop(0, 0, 2000000000);

    if (!this.quoin_multiplier) this.quoin_multiplier = 1;

    //if (!this.has_subscription) this.has_subscription = false;

    //delete this.stats.beans_made;
}

public function stats_delete(){
/*
    delete this.stats;
    delete this.favor_points;
    delete this.giant_emblems;
*/
    this.stats_reset_street_history();
	this.player.stats = new Stats(config, player);
}

public function stats_reset_xp(){

    this.stats_init();
    this.xp.apiSet(0);
    this.stats_add_xp(0);
}

public function stats_reset_imagination(){

    this.stats_init();
    this.imagination.apiSet(0);
    this.stats_add_imagination(0);
}

public function stats_reset_favor(){

    this.favor_points = null;
    this.stats_init();
}

public function stats_reset_street_history(){
    if (this.street_history){
        this.street_history.streets = {};
        this.street_history.pols = {};
    }
}

public function stats_calc_level_from_xp_simple(xp){

    var ret = this.stats_calc_level_from_xp(xp);

    return ret.level;
}

public var xp_for_level = [
    400,
    1091,
    2180,
    3795,
    6085,
    9219,
    13393,
    18826,
    25766,
    34490,
    45305,
    58551,
    74604,
    93876,
    116819,
    143924,
    175726,
    212806,
    255793,
    305366,
    362256,
    427250,
    501193,
    584989,
    679606,
    786079,
    905510,
    1039074,
    1188021,
    1353678,
    1537454,
    1740841,
    1965421,
    2212865,
    2484939,
    2783508,
    3110539,
    3468103,
    3858382,
    4283670,
    4746380,
    5249045,
    5794324,
    6385006,
    7024015,
    7714412,
    8459403,
    9262341,
    10126733,
    11056241,
    12054692,
    13126080,
    14274570,
    15504507,
    16820419,
    18227022,
    19729227,
    21332145,
    23041093
];
public function stats_calc_level_from_xp(xp){

    if (xp < this.xp_for_level[0]){
        return {
            level       : 1,
            xp_for_this : 0,
            xp_for_next : this.xp_for_level[0]
        };
    }

    for (var l=0; l<this.xp_for_level.length; l++){
        if (this.xp_for_level[l] > xp) break;
    }

    return {
        level       : l+1,
        xp_for_this : this.xp_for_level[l-1],
        xp_for_next : (this.xp_for_level[l] ? this.xp_for_level[l] : 0)
    };
}

public function stats_calc_level_xp_needed(up_to){

    var out = {};

    out[1] = {
        xp_for_this : 0,
        xp_for_next : this.xp_for_level[0]
    };

    var l = 1;
    while (l < up_to){

        out[l+1] = {
            xp_for_this : this.xp_for_level[l-1],
            xp_for_next : (this.xp_for_level[l] ? this.xp_for_level[l] : 0)
        };

        if (config.level_limit && l >= config.level_limit) break;
        l++;
    }

    return out;
}

public function stats_at_level_cap(){
    if (this.stats_get_level() >= config.level_limit) return true;
    return false;
}

public function stats_next_level(){
	/*
    if (!this.stats){
        this.stats_init();
    }
	*/

    var ret = this.stats_calc_level_from_xp(this.xp.value);
    var needed = ret.xp_for_next - this.xp.value;

    this.stats_add_xp(needed+1, true);
}

public function stats_get_xp_mood_bonus(){
    var mood = this.player.metabolics.metabolics_get_percentage('mood');

    // With pleasant equilibrium, the player will not drop below 0.75 multiplier.
    if (mood < 50 && this.player.buffs.buffs_has('pleasant_equilibrium')){
        mood = 49;
    }

    if (mood < 10){
        return 0;
    }
    else if (mood < 20){
        return 0.5;
    }
    else if (mood < 50){
        return 0.75;
    }
    else if (mood < 70){
        return 0.9;
    }
    else if (mood < 80){
        return 1;
    }
    else if (mood < 90){
        return 1.1;
    }
    else{
        return 1.2;
    }
}

public function stats_add_xp(xp, no_bonus = false, context = null){
	/*
    if (!this.stats){
        this.stats_init();
    }
	*/

    //
    // Apply mood bonus
    //

    if (!no_bonus && !this.player.is_dead){
        xp = this.stats_xp_apply_bonus(xp);
    }


    //
    // Increment counters
    //

    var imagination = this.stats.imagination.apiInc(xp);
    this.player.daily_history.daily_history_increment('imagination', imagination);

    if (this.player.isOnline() && imagination){
        Server.instance.apiSendAnnouncement({
            type: "imagination_stat",
            delta: imagination
        });
    }

    if (context && imagination){
        var log_args = [];
        for (var k in context){
            log_args.push(k+':'+context[k]);
        }

        Server.instance.apiLogAction('GAIN_IMAGINATION', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'imagination='+imagination);
    }
    else if (imagination){
        Server.instance.apiLogAction('GAIN_IMAGINATION', 'pc='+this.player.tsid, 'imagination='+imagination);
    }

    if (this.xp.value >= 7652 && this.player.quests.getQuestStatus('puzzle_level_light_perspective') == 'none') {
        this.player.quests.quests_offer('puzzle_level_light_perspective');
    }
    if (this.xp.value >= 11306 && this.player.quests.getQuestStatus('radiant_glare') == 'none') {
        this.player.quests.quests_offer('radiant_glare');
    }
    if (this.xp.value >= 16110 && this.player.quests.getQuestStatus('mental_block') == 'none') {
        this.player.quests.quests_offer('mental_block');
    }
    if (this.xp.value >= 4940 && this.player.quests.getQuestStatus('puzzle_level_color_blockage') == 'none') {
        this.player.quests.quests_offer('puzzle_level_color_blockage');
    }
    if (this.xp.value >= 30128 && this.player.quests.getQuestStatus('join_club') == 'none') {
        if (this.player.butler.butler_tsid) {
            var butler = Server.instance.apiFindObject(this.player.butler.butler_tsid);
            if (!butler.available_quests) {
                butler.setAvailableQuests(['join_club']);
            }
            else {
                butler.available_quests.push('join_club');
            }
        }
    }
    if (this.xp.value >= 22296 && this.player.quests.getQuestStatus('btc_room_3') == 'none') {
        this.player.quests.quests_offer('btc_room_3');
    }
    if (this.xp.value >= 39898 && this.player.quests.getQuestStatus('mental_block_2') == 'none') {
        this.player.quests.quests_offer('mental_block_2');
    }
    if (this.xp.value >= 34490 && this.player.quests.getQuestStatus('picto_pattern') == 'none') {
        this.player.quests.quests_offer('picto_pattern');
    }

    //
    // Check level limit
    //

    if (config.level_limit && this.level >= config.level_limit && xp >= 0) return imagination;

    xp = this.stats.xp.apiInc(xp);
    this.player.daily_history.daily_history_increment('xp', xp);
    var info = this.stats_calc_level_from_xp(this.stats.xp.value);

    if (this.player.isOnline() && xp){
        Server.instance.apiSendAnnouncement({
            type: "xp_stat",
            delta: xp
        });
    }

    if (xp) this.player.quests.quests_give_level();

    //
    // Check level up
    //

    if (info.level != this.stats.level){

        this.stats.level = info.level;

        this.player.metabolics.metabolics_recalc_limits(false);

        if (!this.player.is_dead){
            var energy_added = this.player.metabolics.metabolics_set_energy(this.player.metabolics.energy.top);
            var mood_added = this.player.metabolics.metabolics_set_mood(this.player.metabolics.mood.top);
        }
        else{
            var energy_added = 0;
            var mood_added = 0;
        }

        //log.info('player has levelled up!');
        this.player.sendActivity("Woo! you've reached level "+info.level+"!!!");
        this.player.sendLocationActivity(this.player.label + " just reached level "+info.level+"!", this, this.player.buddies.buddies_get_ignoring_tsids());

        this.level_up_time = time();

        //
        // rewards are based on xp needed to hit this level (non-cumm)
        //

        var prev_level = info.level - 1;
        var info2 = this.stats_calc_level_xp_needed(prev_level);
        var xp_needed = 0;
        if (info2 && info2[prev_level]) xp_needed = info2[prev_level].xp_for_next - info2[prev_level].xp_for_this;

        var reward_currants;
        if (this.stats.level <= 25 || this.stats.level % 5 == 0){
            reward_currants = Math.round(xp_needed / 40) * 10;
        }
        else{
            reward_currants = 0;
        }

        // From Excel: round(log(xp_needed)*log(xp_needed)*sqrt(xp_needed)/20)
        var reward_favor = Math.round(Math.pow(Math.log(xp_needed)/Math.LN10, 2) * (Math.sqrt(xp_needed) / 20));

        this.stats_add_currants(reward_currants);
        this.stats_add_favor_points('all', reward_favor);
        this.player.daily_history.daily_history_increment('level_up', 1);


        //
        // Now that all rewards are handed out, construct the new_level message (needs to come after rewards given so the stats blocks are correct)
        //

        var rsp = {
            'type': 'new_level',
            'sound': 'LEVEL_UP',
            'stats': {},
            'rewards': {
                'currants': reward_currants,
                'favor': {0: {giant: 'all', points: reward_favor}}
            }
        };

        if (!this.player.has_done_intro) rsp.do_not_annc = true;

        this.stats_get_login(rsp.stats);
        this.player.metabolics.metabolics_get_login(rsp.stats);

        this.player.sendMsgOnline(rsp);


        // Tell your friends
        this.player.buddies.buddies_update_reverse_cache();
        var rsp = {
            'type': 'pc_level_up',
            'tsid': this.player.tsid,
            'label': this.player.label,
            'level': this.stats.level
        };

        this.player.buddies.reverseBuddiesSendMsg(rsp);

        // Check for 11 secret locations start:
        if (this.stats.level >= this.player.eleven_secrets.secretLocationsQuestLevel()) {
            this.player.eleven_secrets.startSecretLocationsQuest();
        }

        this.player.activity_notify({
            type    : 'level_up',
            level   : this.stats.level
        });

        Server.instance.apiLogAction('LEVEL_UP', 'pc='+this.player.tsid, 'level='+this.stats.level, 'energy='+energy_added, 'mood='+mood_added, 'currants='+reward_currants, 'favor='+reward_favor);

        this.stats_init(); // Stats init sets a lot of props that change when you level up
    }

    if (context && xp){
        var log_args = [];
        for (var k in context){
            log_args.push(k+':'+context[k]);
        }

        Server.instance.apiLogAction('GAIN_XP', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'xp='+xp);
    }

    return xp;
}

public function stats_get_xp(){
    if (!this.stats){
        this.stats_init();
    }

    return this.stats.xp.value;
}


public function stats_get_imagination(){
    if (!this.stats){
        this.stats_init();
    }

    return this.stats.imagination.value;
}

public function stats_set_imagination(num, quiet=false){
    this.stats_init();

    var change = num - this.stats.imagination.value;
    this.stats.imagination.apiSet(num);

    if (change && !quiet){
        Server.instance.apiSendAnnouncement({
            type: "imagination_stat",
            delta: change
        });
    }
}

public function stats_add_imagination(num, context = null){
    if (!num) return 0;
    this.stats_init();

    var change = this.stats.imagination.apiInc(num);
    this.player.daily_history.daily_history_increment('imagination', change);

    Server.instance.apiSendAnnouncement({
        type: "imagination_stat",
        delta: change
    });

    if (context){
        var log_args = [];
        for (var k in context) {
            log_args.push(k+':'+context[k]);
        }
        if (change > 0) {
            Server.instance.apiLogAction('GAIN_IMAGINATION', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'imagination='+change);
        }
    }

    return change;
}

public function stats_remove_imagination(num, context){
    this.stats_init();

    var change = this.stats.imagination.apiDec(num);

    Server.instance.apiSendAnnouncement({
        type: "imagination_stat",
        delta: change
    });

    if (context){
        var log_args = [];
        for (var k in context) {
            log_args.push(k+':'+context[k]);
        }
        if (change < 0) {
            Server.instance.apiLogAction('LOSE_IMAGINATION', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'imagination='+change);
        }
    }

    return change;
}

public function stats_try_remove_imagination(num, context){
    this.stats_init();

    if (this.stats.imagination.value < num) return false;

    this.stats_remove_imagination(num, context);

    return true;
}

public function stats_has_imagination(num){
    this.stats_init();

    return (this.stats.imagination.value < num) ? false : true;
}


public function stats_xp_apply_bonus(xp){
    var multiplier = this.stats_get_xp_mood_bonus();

    xp = Math.round(xp * multiplier);

    // no-no powder nerf
    if (this.player.buffs.buffs_has('no_no_powder')){
        xp = Math.round(xp * 0.2);
    }

    return xp;
}

public function stats_get(){

    var out = {};
    this.stats_get_login(out);
    return out;
}

public function stats_get_login(out){

    this.stats_init();
    this.player.skills.skills_init();

    var ret = this.stats_calc_level_from_xp(this.stats.xp.value);

    out.level   = ret.level;
    out.xp = {
        'total' : this.stats.xp.value,
        'base'  : ret.xp_for_this,
        'nxt'   : ret.xp_for_next
    };
    out.currants    = this.stats.currants.value;

    out.quoin_multiplier = this.stats.quoin_multiplier;

    out.favor_points = {};
    for (var i in this.favor_points){
        out.favor_points[i] = this.favor_points[i].value;
    }

    out.favor_points_new = {};
    for (var i in this.favor_points){
        out.favor_points_new[i] = {
            current: this.favor_points[i].value,
            max: this.stats_get_max_favor(i),
            cur_daily_favor: (this.daily_favor && this.daily_favor[i]) ? this.daily_favor[i] : 0
        };
    }

    out.skill_training = {};

    var queue = this.player.skills.skills_get_queue();
    if (num_keys(queue)){
        for (var i in queue){
            if (!queue[i].is_paused){
                var skill = this.player.skills.skills_get(i);
                out.skill_training = {
                    tsid: i,
                    name: this.player.skills.skills_get_name(i),
                    desc: skill.description,
                    time_remaining: queue[i].end - time(),
                    total_time: this.player.skills.skills_points_to_seconds(skill.point_cost),
                    is_accelerated: queue[i].is_accelerated
                };
            }
        }
    }

    out.skill_unlearning = {};
    var unlearningqueue = this.player.skills.skills_get_unlearning();

    if (unlearningqueue && unlearningqueue.id){
        var id = unlearningqueue.id;
        var unskill = this.player.skills.skills_get(id);
        out.skill_unlearning = {
            tsid: id,
            name: this.player.skills.skills_get_name(id),
            desc: unskill.description,
            time_remaining: unlearningqueue.queue.remaining,
            total_time: unlearningqueue.queue.unlearn_time
        };
    }

    out.num_skills = this.player.skills.skills_get_count();
    out.brain_capacity = this.player.skills.get_brain_capacity();
    out.skill_learning_modifier = this.player.skills.skills_get_learning_time_modifier();

    out.quoins_today = {
        value   : this.stats.quoins_today.value,
        max : this.stats.quoins_today.top
    };

    out.meditation_today = {
        value   : this.stats.meditation_today.value,
        max : this.stats.meditation_today.top
    };

    out.energy_spent_today = intval(this.player.daily_history.daily_history_get(current_day_key(), 'energy_consumed')) * -1;
    out.xp_gained_today = intval(this.player.daily_history.daily_history_get(current_day_key(), 'xp'));

    out.imagination = this.stats.imagination.value;
    out.imagination_gained_today = intval(this.player.daily_history.daily_history_get(current_day_key(), 'imagination'));

    out.imagination_hand = this.player.imagination.imagination_get_login();
    out.imagination_shuffle_cost = 0;
    out.imagination_shuffled_today = this.player.achievements.achievements_get_daily_label_count('imagination', 'shuffle') ? true : false;

    out.credits = this.stats.credits.value;
    out.is_subscriber = this.stats_is_sub();
}

public function stats_set_quoins_today(num){
    this.stats_add_quoins_today(num - this.stats.quoins_today.value);
}

public function stats_add_quoins_today(num){

    var change;
    if (num >= 0){
        change = this.stats.quoins_today.apiInc(num);
    }
    else{
        change = this.stats.quoins_today.apiDec(num * -1);
    }

    if (this.stats.quoins_today.value == this.stats.quoins_today.top && !this.player.location.isParadiseLocation()){
        this.player.prompts.prompts_add({
            txt     : "Wowza! You've reached your limit on quoins for this game day.",
            icon_buttons    : false,
            timeout     : 10,
            choices     : [
                { value : 'ok', label : 'OK' }
            ]
        });
        if (this.stats.quoins_today.top == 150){
            this.player.show_rainbow('rainbow_150coinstoday');
        }else{
            this.player.show_rainbow('rainbow_100coinstoday');
        }

        Server.instance.apiLogAction('QUOIN_LIMIT', 'pc='+this.player.tsid, 'limit='+this.stats.quoins_today.top);

        // http://bugs.tinyspeck.com/9138
        //this.player.buffs.buffs_remove('crazy_coin_collector');
    }

    if (change && this.player.isOnline()){
        Server.instance.apiSendAnnouncement({
            type: "quoins_stat",
            delta: change
        });
    }

    return change;
}

public function stats_set_quoins_max_today(num){
    this.daily_quoin_limit = num;
    this.stats.quoins_today.apiSetLimits(0, num);

    if (this.player.isOnline()){
        Server.instance.apiSendAnnouncement({
            type: "quoins_stat_max",
            delta: num
        });
    }
}

public function stats_set_meditation_max_today(no_client=null){
    this.meditation_today = new Prop(0, 0, (this.player.get_meditation_bonus() * this.player.metabolics.metabolics_get_max_energy()));

    var rsp = {
        'type': 'stat_max_changed',
        'stats': {}
    };

    if (!no_client){
        this.stats_get_login(rsp.stats);
        this.player.metabolics.metabolics_get_login(rsp.stats);
        Server.instance.apiSendMsg(rsp);
    }
}

public function stats_set_making_xp_today(recipe_id, num){
    this.stats_add_making_xp_today(recipe_id, num - this.stats.making_xp_today.value);
}

public function stats_add_making_xp_today(recipe_id, num){

    if (!this.stats.recipe_xp_today){
        this.stats.recipe_xp_today = new Dictionary();
    }

    if (!this.stats.recipe_xp_today[recipe_id]){
        this.stats.recipe_xp_today[recipe_id] = new Prop(); //this.apiNewProperty(recipe_id.toString(), 0);
    }
    this.stats.recipe_xp_today[recipe_id].apiSetLimits(0, this.player.making.making_get_xp_ceiling());

    var change;
    if (num >= 0){
        change = this.stats.recipe_xp_today[recipe_id].apiInc(num);
    }
    else{
        change = this.stats.recipe_xp_today[recipe_id].apiDec(num * -1);
    }

    return change;
}

public function stats_set_meditation_today(num){
    this.stats_add_meditation_today(num - this.stats.meditation_today.value);
}

public function stats_add_meditation_today(num){
    if (num >= 0){
        var change = this.stats.meditation_today.apiInc(num);
    }
    else{
        var change = this.stats.meditation_today.apiDec(num * -1);
    }

    if (this.stats.meditation_today.top && this.stats.meditation_today.value == this.stats.meditation_today.top){
        var tomorrow = timestamp_to_gametime(time()+ (game_days_to_ms(1)/1000));
        tomorrow[3] = 0;
        tomorrow[4] = 0;

        var remaining = gametime_to_timestamp(tomorrow) - time();
        this.player.buffs.buffs_apply('zen', {duration: remaining});
    }

    if (change && this.player.isOnline()){
        Server.instance.apiSendAnnouncement({
            type: "meditation_stat",
            delta: change
        });
    }

    return change;
}

public function stats_set_currants(num){
    this.stats_init();

    var change = num - this.stats.currants.value;
    this.stats.currants.apiSet(num);

    Server.instance.apiSendAnnouncement({
        type: "currants_stat",
        delta: change
    });
}

public function stats_add_currants(num, context = null){
    if (!num) return 0;
    this.stats_init();

    var change = this.stats.currants.apiInc(num);

    Server.instance.apiSendAnnouncement({
        type: "currants_stat",
        delta: change
    });

    // Check for currants achievements
    if (this.stats_get_currants() >= 2022 && !this.player.achievements.achievements_has('pennypincher')){
        this.player.achievements.achievements_grant('pennypincher');
    }

    if (this.stats_get_currants() >= 5011 && !this.player.achievements.achievements_has('moneybags')){
        this.player.achievements.achievements_grant('moneybags');
    }

    if (this.stats_get_currants() >= 11111 && !this.player.achievements.achievements_has('lovable_skinflint')){
        this.player.achievements.achievements_grant('lovable_skinflint');
    }

    if (context){
        var log_args = [];
        for (var k in context) {
            log_args.push(k+':'+context[k]);
        }
        if (change > 0) {
            Server.instance.apiLogAction('GAIN_CURRANTS', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'currants='+change);
        }
    }

    return change;
}

public function stats_remove_currants(num, context){
    this.stats_init();

    var change = this.stats.currants.apiDec(num);

    Server.instance.apiSendAnnouncement({
        type: "currants_stat",
        delta: change
    });

    if (context){
        var log_args = [];
        for (var k in context) {
            log_args.push(k+':'+context[k]);
        }
        if (change < 0) {
            Server.instance.apiLogAction('LOSE_CURRANTS', 'pc='+this.player.tsid, 'context=['+log_args.join(",")+']', 'currants='+change);
        }
    }
    else if (change < 0){
        Server.instance.apiLogAction('LOSE_CURRANTS', 'pc='+this.player.tsid, 'currants='+change);
    }

    return change;
}

public function stats_try_remove_currants(num, context=null){
    this.stats_init();

    if (this.stats.currants.value < num) return false;

    this.stats_remove_currants(num, context);

    return true;
}

public function stats_has_currants(num){
    this.stats_init();

    return (this.stats.currants.value < num) ? false : true;
}

public function stats_set_rube_trades(num) {
    this.stats_init();

    this.stats.rube_trades.apiSet(num);
}

public function stats_add_rube_trade() {
    this.stats_init();

    this.stats.rube_trades.apiInc(1);
    this.stats.last_rube_trade = time();
}

public function stats_get_last_rube_trade() {
    return this.stats.last_rube_trade;
}

public function stats_get_rube_trades() {
    return this.stats.rube_trades.value;
}

public function stats_set_temp_buff(buff_class_tsid, stat_id, value){

    if (!this.stats.misc.buffs){
        this.stats.misc.buffs = {};
    }

    if (!this.stats.misc.buffs[buff_class_tsid]){
        this.stats.misc.buffs[buff_class_tsid] = {};
    }

    this.stats.misc.buffs[buff_class_tsid][stat_id] = value;
}

public function stats_fixup_buffs(){

    this.player.metabolics.metabolics_recalc_limits(false);

    if (!this.stats.misc.buffs) return;

    for (var i in this.stats.misc.buffs){

        if (!this.player.buffs.buffs_has(i)){

            delete this.stats.misc.buffs[i];
        }
    }
}

public function stats_get_currants(){

    this.stats_init();

    return this.stats.currants.value;
}

public function stats_get_level(){

    this.stats_init();

    return this.stats.level;
}

public function stats_add_favor_points(giant, value, suppress_prompt=false){
    if (giant == 'all'){
        for (var i=0; i<config.base.giants.length; i++){
            this.stats_add_favor_points(config.base.giants[i], value);
        }

        return value;
    }
    else if (giant == 'street'){
        log.error("Uh-oh, don't know how to do this yet.");
        return 0;
    }
    else{
        /* Make sure this is a real giant */
        if(!in_array(giant, config.base.giants)) {
            this.player.sendActivity("Oops, there was a problem communicating with the Giants, and you didn't receive some favor when you should have. Please let us know by filing a bug report!");
            log.error(this+" failed to receive "+value+" favor, because giant "+giant+" is not a real giant.");
            return;
        }

        this.favor_points[giant] = new Prop(0, 0, this.stats_get_max_favor(giant));
        var change = this.favor_points[giant].apiInc(value);

        if (change){
            this.player.achievements.achievements_increment('favor_points', giant, change);
            this.player.counters.counters_increment('favor_points', giant, change);
            Server.instance.apiSendAnnouncement({
                type: "favor_stat",
                giant: giant,
                delta: change
            });

            if (!suppress_prompt && this.stats_has_favor_points(giant, this.stats_get_max_favor(giant))){

                var txt = "You have reached "+this.stats_get_max_favor(giant)+" favor points with "+capitalize(giant.replace("ti", "tii"))+". Get to a shrine and collect your emblem!";
                this.player.prompts.prompts_add({
                    txt     : txt,
                    icon_buttons    : false,
                    timeout     : 10,
                    choices     : [
                        { value : 'ok', label : 'OK' },
                    ]
                });
                this.player.sendActivity(txt);
            }
        }

        return change;
    }
}

public function stats_remove_favor_points(giant, value){
    this.favor_points[giant] = new Prop(0, 0, this.stats_get_max_favor(giant));
    var change = this.favor_points[giant].apiDec(value);

    if (change){
        Server.instance.apiSendAnnouncement({
            type: "favor_stat",
            giant: giant,
            delta: change
        });
    }

    return change;
}

public function stats_get_favor_points(giant){
    if (!this.favor_points) return 0;

    if (!this.favor_points[giant]) return 0;

    return this.favor_points[giant].value;
}

public function stats_get_most_favor(){
    var most_giant = null;
    var most_points = 0;

    for (var giant in this.favor_points){
        var points = this.stats_get_favor_points(giant);
        if (points > most_points){
            most_points = points;
            most_giant = giant;
        }
    }

    return most_giant;
}

public function stats_has_favor_points(giant, value){
    return this.stats_get_favor_points(giant) >= value ? true : false;
}

public function stats_add_street_history(tsid, is_pol){
    if (!this.street_history) this.stats_init();

    if (is_pol){
        this.street_history.pols[tsid] = time();
    }
    else{
        this.street_history.streets[tsid] = time();
    }
}

public function stats_get_street_history() {
    return this.street_history.streets;
}

public function stats_get_pol_history() {
    return this.street_history.pols;
}

public function stats_get_last_street_visit(tsid){
    if (!this.street_history) return 0;
    if (this.street_history.streets && this.street_history.streets[tsid]){
        return this.street_history.streets[tsid];
    }
    else if (this.street_history.pols && this.street_history.pols[tsid]){
        return this.street_history.pols[tsid];
    }

    return 0;
}

public function stats_add_emblem(giant) {
    if(!this.giant_emblems) {
        this.giant_emblems = new Dictionary();
    }

    this.giant_emblems[giant] = new Prop(0, 0, 100000);
    this.giant_emblems[giant].apiInc(1);
}

public function stats_get_emblems(giant) {
    if(!this.giant_emblems || !this.giant_emblems[giant]) {
        return 0;
    }

    return this.giant_emblems[giant].value;
}

public function stats_get_max_favor(giant) {
    return config.emblem_favor_cost + (this.stats_get_emblems(giant) * config.emblem_favor_increment);
}

public function stats_set_rube_lure_disabled(disabled){
    if (!this.stats.rube_lure_disabled) this.stats_init();

    if (disabled){
        this.stats.rube_lure_disabled.apiSet(1);
    }else{
        this.stats.rube_lure_disabled.apiSet(0);
    }
}

public function stats_rube_lure_disabled(){
    if (!this.stats.rube_lure_disabled) this.stats_init();
    return this.stats.rube_lure_disabled.value;
}

public function stats_get_daily_count(class_tsid){
    if (!this.stats.daily_count) this.stats.daily_count = new Dictionary();
    if (!this.stats.daily_count[class_tsid]) this.stats.daily_count[class_tsid] = 0;
    return this.stats.daily_count[class_tsid];
}

public function stats_init_daily_counter(){
    if (!this.stats.daily_count){
        this.stats.daily_count = new Dictionary();
    }
}

public function stats_reset_daily_counter(){
    this.stats.daily_count = new Dictionary();
}

public function stats_get_daily_counter(class_tsid){
    this.stats_init_daily_counter();
    if (!this.stats.daily_count[class_tsid]) this.stats.daily_count[class_tsid] = 0;
    return this.stats.daily_count[class_tsid];
}

public function stats_set_daily_counter(class_tsid, num){
    this.stats_init_daily_counter();
    this.stats.daily_count[class_tsid] = num;
}

public function stats_inc_daily_counter(class_tsid, num){
    this.stats_init_daily_counter();
    if (!this.stats.daily_count[class_tsid]) this.stats.daily_count[class_tsid] = 0;
    this.stats.daily_count[class_tsid] += 1;
}

public function stats_dec_daily_counter(class_tsid, num){
    this.stats_init_daily_counter();
    if (!this.stats.daily_count[class_tsid]) this.stats.daily_count[class_tsid] = 0;
    this.stats.daily_count[class_tsid] -= 1;
}

public function stats_set_credits(num){
    this.stats_init();

    var change = num - this.stats.credits.value;
    this.stats.credits.apiSet(num);

    Server.instance.apiSendAnnouncement({
        type: "credits_stat",
        delta: change
    });
}

public function stats_spend_credits(num, args){
    this.stats_init();

    if (num == 0){
        args.ok = 1;
        args.amount = 0;
        this[args.callback](args);
        return true;
    }

    if (this.stats.credits.value < num){
        args.ok = 0;
        args.amount = num;
        this[args.callback](args);
        return false;
    }

    // Tell the web app, which will sync back to us eventually
    args.player = this.player.tsid;
    args.amount = num;
    Utils.http_post('callbacks/credits_spend.php', args, this.player.tsid);

    return true;
}

public function stats_has_credits(num){
    this.stats_init();

    return (this.stats.credits.value < num) ? false : true;
}

public function stats_get_credits(){
    this.stats_init();

    return this.stats.credits.value;
}

public function stats_set_sub(is_sub, sub_end){
    this.stats_init();
    this.stats.has_subscription = is_sub ? true : false;
    if (is_sub) this.stats.subscription_end = sub_end;

    Server.instance.apiSendAnnouncement({
        type: "subscriber_stat",
        status: is_sub ? true : false
    });
}

public function stats_is_sub(){
    this.stats_init();

    if (!this.stats.has_subscription) return false;

    return (this.stats.subscription_end < time()) ? false : true;
}

public function stats_get_quoin_multiplier(){
    return this.stats.quoin_multiplier;
}

public function stats_set_quoin_multiplier(amount){
    this.stats.quoin_multiplier = amount;
    if (this.stats.quoin_multiplier > config.base.quoin_capacity_limit) this.stats.quoin_multiplier = config.base.quoin_capacity_limit;
}

public function stats_increase_quoin_multiplier(amount){
    this.stats.quoin_multiplier += amount;
    if (this.stats.quoin_multiplier > config.base.quoin_capacity_limit) this.stats.quoin_multiplier = config.base.quoin_capacity_limit;
}

public function stats_get_all_favor(){

    var out = {};
    for (var i=0; i<config.base.giants.length; i++){

        var g = config.base.giants[i];
        var name = g.replace('ti', 'tii');

        var max_daily_favor = this.stats_get_max_favor(g);
        var cur_daily_favor = 0;

        if (this.daily_favor && this.daily_favor[g]){
            cur_daily_favor = this.daily_favor[g].value;
        }

        out[g] = {
            name        : name,

            current     : this.stats_get_favor_points(g),
            max     : this.stats_get_max_favor(g),

            max_daily_favor : max_daily_favor,
            cur_daily_favor : cur_daily_favor
        };
    }
    return out;
}

public function stats_get_favor_summary(){

    var max_daily = this.stats_donation_xp_limit();
    var cur_daily = 0;

    if (this.stats.donation_xp_today) cur_daily = this.stats.donation_xp_today.value;
    if (this.stats.level >= config.level_limit) max_daily = 0;

    return {
        max_daily_xp    : max_daily,
        cur_daily_xp    : cur_daily,
        giants      : this.stats_get_all_favor()
    };

}

public function stats_donation_xp_limit(){

    var level_data = this.stats_calc_level_from_xp(this.stats_get_xp());
    var level = level_data.level;
    var xp_base = 0;

    if (level <= 5) {
        xp_base = 250;
    } else if (level <= 10) {
        xp_base = 500;
    } else if (level <= 30) {
        var multiplier = 0.2 - (level - 11) * 0.005;
        xp_base = (level_data.xp_for_next - level_data.xp_for_this) * multiplier;
    } else if (level == 60){
        xp_base = 170894.8; // hard-coded value for what you get at level 59: http://bugs.tinyspeck.com/8535
    } else {
        xp_base = (level_data.xp_for_next - level_data.xp_for_this) * 0.1;
    }

    if (xp_base <= 0) xp_base = 0;

    return Math.round(xp_base);
}

    }
}
