package com.reversefold.glitch.server.player {
	import com.reversefold.glitch.server.Common;
	import com.reversefold.glitch.server.Utils;
	import com.reversefold.glitch.server.data.Config;
	import com.reversefold.glitch.server.data.Imagination;
	
	import org.osmf.logging.Log;
	import org.osmf.logging.Logger;

    public class Imagination {
		private static var log : Logger = Log.getLogger("server.Player");

		public var config : Config;
		public var player : Player;
		public var label = 'Imagination';
		public var upgrades = {};
		public var hand = {};
		public var history = [];
		public var deck;
		public var imagination_purchase_time_ms;
		public var reshuffle_time_ms;
		
		public var converted_at;
		public var xp_at_conversion;
		public var level_at_conversion;
		public var img_after_conversion;
		public var img_at_conversion;
		public var currants_converted_at;
		public var currants_at_conversion;
		public var currants_after_conversion;
		public var currants_tax;
		public var brain_capacity_refunded;

		
		public function Imagination(config : Config, player : Player) : void {
			this.config = config;
			this.player = player;
		}

public function imagination_init(){
    if (deck != null) deck = null;
    if (!hand) hand = {};
    if (!history) history = [];
}

public function imagination_reset(){

    this.imagination_init();
    this.imagination_delete_all_upgrades();
    this.history = [];

    this.player.skills.skills_set_brain_capacity(20);

    this.imagination_reshuffle_hand(true);
}

public function imagination_delete_all_upgrades(){
    for (var id in this.upgrades){
        this.imagination_delete_upgrade(id);
    }

    // Reshuffle the hand, since our deck has likely changed now
    this.imagination_reshuffle_hand(true);
}

//
// Remove an upgrade from us
//

public function imagination_delete_upgrade(id){
    // TODO: What to do about the effects we got from purchasing this!?
    delete this.upgrades[id];

    if (id == 'trade_channel'){
        this.player.apiSendMsg({
            type: 'trade_channel_enable',
            tsid: ''
        });
    }
}

//
// Do we have this upgrade at least once?
//

public function imagination_has_upgrade(id){
    try{
        return this.upgrades[id] ? true : false;
    }catch(e){
        return false;
    }
}

//
// Purchase the upgrade for a player. This deducts imagination and applies effects, but
// does not check pre-requisites
//

public function imagination_purchase_upgrade(hand_id){
    this.imagination_init();

    // Get it from our hand
    var hand = this.imagination_get_hand();
    var card = hand[hand_id];
    if (!card){
        log.error(this+' imagination upgrade purchase failed: not valid card from: '+hand+' with ID: '+hand_id);
        return false;
    }

    // Get details
    var upgrade = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[card.class_tsid];
    if (!upgrade){
        log.error(this+' imagination upgrade purchase failed: invalid upgrade: '+card.class_tsid);
        return false;
    }

    if (upgrade.max_uses && this.imagination_has_upgrade(card.class_tsid)){
        log.error(this+' imagination upgrade purchase failed: max uses: '+card.class_tsid);
        return false;
    }

    // Check cost
    var cost = card.cost;
    if (!this.player.stats.stats_try_remove_imagination(cost, {type: 'imagination_upgrade', hand_id: hand_id, class_tsid: card.class_tsid})){
        log.error(this+' imagination upgrade purchase failed: tried to remove imagination and failed.');
        return false;
    }

    this.imagination_grant(card.class_tsid, card.amount, hand_id);

    this.imagination_purchase_time_ms = new Date().getTime();

    if (this.player.location.upgradeGranted){
        this.player.location.upgradeGranted(this, card.class_tsid);
    }

    return true;
}

public function imagination_purchase_upgrade_confirmed(id){
    if (this.player.location.upgradeConfirmed){
        this.player.location.upgradeConfirmed(this, id);
    }
}

public function imagination_grant(class_tsid, amount=null, hand_id=null, no_growl=false, no_history=false){
    this.imagination_init();

    var upgrade = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[class_tsid];
    if (!upgrade) return false;

    if (upgrade.max_uses && this.imagination_has_upgrade(class_tsid)) return false;

    log.info(this+' granted imagination upgrade '+class_tsid+' ('+amount+')');
    if (!this.upgrades[class_tsid]) this.upgrades[class_tsid] = [];
    this.upgrades[class_tsid].push(Common.time());

    this.player.daily_history.daily_history_push('upgrades_purchased', class_tsid);

    if (!no_growl){
        var status = '';
        if (class_tsid == "quoin_multiplier"){
            status = 'You got the '+upgrade.name.replace(/\{amount\}/g, (amount*100)+'%')+' upgrade!';
        }
        else{
            status = 'You got the '+upgrade.name.replace(/\{amount\}/g, amount)+' upgrade!';
        }
        this.player.sendActivity(status, null, true);
    }

    // Special effects
    if (class_tsid == 'energy_tank'){
        this.player.metabolics.metabolics_set_tank(this.player.metabolics.metabolics_get_tank()+int(amount));
        this.player.metabolics.metabolics_recalc_limits(this.player.is_dead ? false : true); // Refill our tank, unless we're dead

        if (this.player.buffs.buffs_has('zen')) this.player.buffs.buffs_remove('zen');
        this.player.stats.stats_set_meditation_max_today(true);

        var rsp = {
            'type': 'stat_max_changed',
            'stats': {}
        };

        this.player.stats.stats_get_login(rsp.stats);
        this.player.metabolics.metabolics_get_login(rsp.stats);

        this.player.apiSendMsg(rsp);
    }
    else if (class_tsid == 'brain_capacity'){
        this.player.skills.skills_increase_brain_capacity(int(amount));
    }
    else if (class_tsid == 'quoin_multiplier'){
        this.player.stats.stats_increase_quoin_multiplier(Number(amount));
    }
    else if (/quoin_limit/.exec(class_tsid)) {
        this.player.stats.stats_set_quoins_max_today(this.imagination_get_quoin_limit());
    }
    else if (class_tsid == "remoteherdkeeping_production_1" || class_tsid == "remoteherdkeeping_production_2") {
        this.imagination_update_collectors();
    }
    else if (class_tsid == 'snapshotting'){
        this.player.sendCameraAbilities();
    }
    else if (class_tsid == 'camera_mode'){
        this.player.sendCameraAbilities();
    }
    else if (/ancestral_lands_time/.exec(class_tsid) && this.player.buffs.buffs_has("ancestral_nostalgia")) {
        this.player.buffs.buffs_extend_time("ancestral_nostalgia", 60);
    }
    else if (/meditative_arts_daily_limit/.exec(class_tsid)) { //class_tsid == "meditative_arts_daily_limit_1") {
        this.player.stats.stats_set_meditation_max_today();
    }
    else if (class_tsid == 'trade_channel'){
        this.player.trade_chat_group = Common.choose_one(config.trade_chat_groups);
        this.player.apiSendMsg({
            type: 'trade_channel_enable',
            tsid: this.player.trade_chat_group
        });
    }
    /*else if (class_tsid == "meditative_arts_daily_limit_2") {
        this.player.stats.stats_set_meditation_max_today();
    }*/

    // Do effects
    for (var i in upgrade.rewards){
        var r = upgrade.rewards[i];
        switch (r.type){
            case 1: // physics
                this.player.physics.addImaginationPhysics(r.data);
                break;
            case 2: // max energy
                //this.player.metabolics.metabolics_set_max('energy', r.data.max_energy);
                break;
            case 3: // max mood
                //this.player.metabolics.metabolics_set_max('mood', r.data.max_mood);
                break;
            case 4: // inventory slots
                //this.capacity = r.data.slots;
                break;
            case 5: // skill limit
                //if (!this.skills.limit) this.skills.limit = 0; // TODO: Better default? Have it set in skills_init instead
                //this.skills.limit = r.data.limit;
                break;
            case 6: // player prop
                this[r.data.prop_name] = r.data.prop_value;
                break;
            case 8: // Give Item
                this.player.items.createItemFromFamiliar(r.data.class_id, r.data.num);
                break;
            case 9: // Skill Learning Increase
                this.player.skills.applyCategoryReduction(r.data.category_id, r.data.percent);
                // Don't need a default since it keeps a hash and only applies those things that are in the hash
                break;
            case 999: // custom code
                r.data.custom_code.call(r, this);
                break;
        }
    }

    // Record history
    if (!no_history){
        var hand = this.imagination_get_hand();
        var card = hand_id === undefined ? null : hand[hand_id];
        this.history.push({
            class_tsid: class_tsid,
            cost: card ? card.cost : 0,
            amount: amount,
            when: Common.time()
        });
    }

    // If brain capacity and we're now at the limit, remove all brain capacity cards
    if (class_tsid == 'brain_capacity' && this.player.skills.get_brain_capacity() == config.base.brain_capacity_limit){
        hand_id = undefined;
    }
    else if (class_tsid == 'quoin_multiplier' && this.player.stats.stats_get_quoin_multiplier() == config.base.quoin_capacity_limit){
        hand_id = undefined;
    }

    // Remove all copies of this card from our hand
    for (var i in this.hand){
        if (hand_id == i || (hand_id === undefined && this.hand[i].class_tsid == class_tsid)){
            delete this.hand[i];
            break;
        }
    }

    // Re-deal from the deck into our hand
    this.imagination_get_next_upgrades();

    // Tell the client about our new hand contents
    this.player.apiSendMsg({
        type: 'imagination_hand',
        hand: this.imagination_get_login()
    });
}


//
// Take all the cards we are eligible for and build a deck out of it
//

public function imagination_get_deck(){
    var all = this.imagination_get_all();

    var deck = [];

    for (var i in all){
        if (all[i].can_learn){
            var u = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[i];
            if (!u) continue;

            // If we have options, then we are special and need special handling
            if (u.options){
                if (i == 'energy_tank'){
                    var best_level = 0;
                    for (var min_level in u.options){
                        if (min_level > this.player.metabolics.metabolics_get_max_energy()) break;
                        best_level++;
                    }

                    if (best_level) best_level--;

                    var j = 0;
                    for (var min_level in u.options){
                        if (j == best_level){
                            var level = u.options[min_level];
                            for (var k in level.chances){
                                var chance = level.chances[k];
                                if (!chance) continue;

                                var amount = 0;
                                switch (k){
                                    case '0':
                                        amount = 10;
                                        break;
                                    case '1':
                                        amount = 20;
                                        break;
                                    case '2':
                                        amount = 50;
                                        break;
                                    case '3':
                                        amount = 100;
                                        break;
                                    case '4':
                                        amount = 500;
                                        break;
                                }

                                for (var l=0; l<chance; l++){
                                    var row = Utils.copy_hash(u);
                                    row.class_tsid = i;
                                    delete row.options;
                                    row.chance = chance;
                                    row.amount = amount;
                                    row.cost = Math.round(level.cost_per * amount);

                                    deck.push(row);
                                }
                            }

                            break;
                        }

                        j++;
                    }
                }
                else if (i == 'brain_capacity'){
                    if (this.player.skills.get_brain_capacity() >= config.base.brain_capacity_limit) continue;

                    var best_level = 0;
                    for (var min_level in u.options){
                        if (min_level > this.player.skills.get_brain_capacity()) break;
                        best_level++;
                    }

                    if (best_level) best_level--;

                    var j = 0;
                    for (var min_level in u.options){
                        if (j == best_level){
                            var level = u.options[min_level];
                            for (var k in level.chances){
                                var chance = level.chances[k];
                                if (!chance) continue;

                                var amount = 0;
                                var discount = 0;
                                switch (k){
                                    case '0':
                                        amount = 1;
                                        discount = 0;
                                        break;
                                    case '1':
                                        amount = 3;
                                        discount = 0.05;
                                        break;
                                    case '2':
                                        amount = 5;
                                        discount = 0.10;
                                        break;
                                }

                                for (var l=0; l<chance; l++){
                                    var row = Utils.copy_hash(u);
                                    row.class_tsid = i;
                                    delete row.options;
                                    row.chance = chance;
                                    row.amount = amount;
                                    row.cost = Math.round(level.cost_per * amount);
                                    if (discount) row.cost -= Math.round(row.cost * discount);

                                    deck.push(row);
                                }
                            }

                            break;
                        }

                        j++;
                    }
                }
                else if (i == 'quoin_multiplier'){
                    if (this.player.stats.stats_get_quoin_multiplier() >= config.base.quoin_capacity_limit) continue;

                    var best_level = 0;
                    for (var min_level in u.options){
                        if (min_level > this.player.stats.stats_get_quoin_multiplier()) break;
                        best_level++;
                    }

                    if (best_level) best_level--;

                    var j = 0;
                    for (var min_level in u.options){
                        if (j == best_level){
                            var level = u.options[min_level];
                            for (var k in level.chances){
                                var chance = level.chances[k];
                                if (!chance) continue;

                                var amount = 0;
                                switch (k){
                                    case '0':
                                        amount = 0.25;
                                        break;
                                    case '1':
                                        amount = 0.5;
                                        break;
                                    case '2':
                                        amount = 1;
                                        break;
                                }

                                for (var l=0; l<chance; l++){
                                    var row = Utils.copy_hash(u);
                                    row.class_tsid = i;
                                    delete row.options;
                                    row.chance = chance;
                                    row.amount = amount;
                                    row.cost = Math.round(level.cost_per * amount);

                                    deck.push(row);
                                }
                            }

                            break;
                        }

                        j++;
                    }
                }
            }
            else{
                for (var j=0; j<u.chance; j++){
                    var row = Utils.copy_hash(u);
                    row.class_tsid = i;

                    if (i == 'keepable_reshuffle'){
                        row.cost = this.imagination_get_shuffle_card_cost();
                    }
                    else if (i == 'keepable_instant_resurrection'){
                        row.cost = this.imagination_get_resurrection_card_cost();
                    }

                    deck.push(row);
                }
            }
        }
    }

    return deck;
}


//
// Populate our hand from the deck
//

public function imagination_get_next_upgrades(){

    var out = {};
    for (var i in this.hand){
        var card = this.hand[i];
        if (card && card.class_tsid && com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[card.class_tsid]){
            if (card.class_tsid == 'brain_capacity' && this.player.skills.get_brain_capacity() >= config.base.brain_capacity_limit) continue;
            if (card.class_tsid == 'quoin_multiplier' && this.player.stats.stats_get_quoin_multiplier() >= config.base.quoin_capacity_limit) continue;
            out[i] = card;
        }
    }

    //log.info(this+' imagination_get_next_upgrades hand 1: '+out);

    if (Common.num_keys(out) == 3) return out;

    var deck = Utils.shuffle(this.imagination_get_deck());

    for (var i in deck){
        var card = deck[i];
        if (card.max_uses && this.imagination_is_in_hand(card.class_tsid)) continue;

        var simple_card = {
            class_tsid: card.class_tsid,
            amount: card.amount ? card.amount : 0,
            cost: card.cost
        };

        for (var index=0; index<3; index++){
            if (out[index]) continue;

            this.hand[index] = simple_card;
            out[index] = simple_card;
            break;
        }

        if (Common.num_keys(out) == 3) break;
    }

    //log.info(this+' imagination_get_next_upgrades hand 2: '+out);

    return out;
}

//
// Return the list of upgrades we have
//

public function imagination_get_list(){
    this.imagination_init();

    var out = [];

    for (var i in this.upgrades){

        var upgrades = this.upgrades[i];

        out.push({
            'id'    : i,
            'count'  : upgrades.length
        });
    }

    return out;
}

//
// Return a hash of all upgrades, whether we have it, and whether we can get it
//

public function imagination_get_all(){
    this.imagination_init();
    this.player.stats.stats_init();

    var out = {};

    //
    // loop over each upgrade
    //

    for (var i in com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades){

        var u = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[i];
        if (u.is_secret) continue;

        out[i] = {
            'got'       : 0,
            'reqs'      : [],
            'name'      : u.name
        };

        //
        // Do we have it?
        //

        if (this.upgrades[i]){

            out[i].got = 1;
            out[i].count = this.upgrades[i].length;
        }

        //
        // Is it in our hand?
        //

        if (Common.in_array(this.hand, i)){

            out[i].in_hand = 1;
        }
    }

    //
    // calculate requirements
    //

    for (var i in out){

        var u = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[i];


        //
        // loop over all requirements and check them
        //

        for (var j in u.conditions){
            var c = u.conditions[j];

            switch (c.type){
                // In tutorial
                case 1:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.player.location.is_newxp ? 1 : 0
                    });
                    out[i].is_newxp = true;
                    break;
                // Level
                case 2:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.player.stats.level >= c.data.level ? 1 : 0,
                        'need'  : c.data.level,
                        'got'   : this.player.stats.level
                    });
                    break;
                // Imagination
                case 3:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.imagination_has_upgrade(c.data.imagination_id) ? 1 : 0,
                        'imagination_id'    : c.data.imagination_id
                    });
                    break;
                // Skill
                case 4:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.player.skills.skills_has(c.data.skill_id) ? 1 : 0,
                        'skill_id'  : c.data.skill_id
                    });
                    break;
                // Achievement
                case 5:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.player.achievements.achievements_has(c.data.achievement_id) ? 1 : 0,
                        'achievement_id'    : c.data.achievement_id
                    });
                    break;
                // Quest
                case 6:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : this.player.quests.getQuestStatus(c.data.quest_id) == 'done' ? 1 : 0,
                        'quest_id'  : c.data.quest_id
                    });
                    break;
                // Max energy
                case 7:
                    var max = this.player.metabolics.metabolics_get_max_energy();
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : max >= c.data.max_energy ? 1 : 0,
                        'need'  : c.data.max_energy,
                        'got'   : max
                    });
                    break;
                default:
                    out[i].reqs.push({
                        'type'  : c.type,
                        'ok'    : 0
                    });
                    break;
            }
        }

        //
        // ok - do we meet all the requirements?
        //

        if (out[i].got && u.max_uses){
            out[i].can_learn = 0;
        }
        else{
            var ok = 1;

            if (out[i].is_newxp && !this.player.location.is_newxp){
                ok = 0;
            }
            else if (!out[i].is_newxp && this.player.location.is_newxp && !this.imagination_has_upgrade('encyclopeddling') && !this.imagination_is_in_hand('encyclopeddling')){
                ok = 0;
            }

            for (var j=0; j<out[i].reqs.length; j++){

                if (!out[i].reqs[j].ok){
                    ok = 0;
                    break;
                }
            }

            out[i].can_learn = ok;
        }
    }

    return out;
}

//
// Get the upgrades in our hand (this might be empty -- call imagination_get_next_upgrades() if you want to always get 3 back)
//
public function imagination_get_hand(){
    this.imagination_init();
    return this.hand;
}

public function imagination_is_in_hand(class_tsid){
    var hand = this.hand;
    for (var i in hand){
        if (hand[i].class_tsid == class_tsid) return true;
    }

    return false;
}

public function imagination_remove_from_hand(class_tsid){
    var found = false;
    var hand = this.hand;
    for (var i in hand){
        if (hand[i].class_tsid == class_tsid){
            delete hand[i];
            found = true;
        }
    }

    return found;
}

//
// Reshuffle the hand
//
// TODO: Costs!?!?!?!?
//
public function imagination_reshuffle_hand(silent){
    this.imagination_init();
    this.hand = {};

    this.reshuffle_time_ms = new Date().getTime();
    this.imagination_get_next_upgrades();


    // Tell the client about our new hand contents
    if (!silent){
        this.player.apiSendMsg({
            type: 'imagination_hand',
            hand: this.imagination_get_login(),
            and_open: true,
            is_redeal: true
        });
    }
    else{
        this.player.apiSendMsg({
            type: 'imagination_hand',
            hand: this.imagination_get_login(),
            is_redeal: true
        });
    }

    return true;
}

//
// Login information for the client
//
public function imagination_get_login(){
    var hand = this.imagination_get_next_upgrades();

    var out = [];

    for (var i in hand){
        var card = hand[i];
        var upgrade = com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades[card.class_tsid];
        if (!upgrade) continue;

        var current = null;
        var upgraded = null;
        var post_script = null;
        switch (card.class_tsid){
            case 'brain_capacity':{
                current = this.player.skills.get_brain_capacity();
                upgraded = current+card.amount;
                post_script = "Your current Brain Capacity is {current}. Buying this will make it {upgraded}";
                break;
            }
            case 'energy_tank':{
                current = this.player.metabolics.metabolics_get_tank();
                upgraded = current+card.amount;
                post_script = "Your current Energy Tank is {current}. Buying this will make it {upgraded}";
                break;
            }
            case 'quoin_multiplier':{
                current = this.player.stats.quoin_multiplier;
                upgraded = current+card.amount;
                current = current.toFixed(2);
                upgraded = upgraded.toFixed(2);
                post_script = "Your current Quoin Multiplier is {current}. Buying this will make it {upgraded}";
                break;
            }
        }

        var name = upgrade.name;
        var desc = upgrade.desc;

        if (card.class_tsid == 'quoin_multiplier'){
            name = upgrade.name.replace(/\{amount\}/g, card.amount.toFixed(2));
            desc = upgrade.desc.replace(/\{amount\}/g, card.amount.toFixed(2));
        }else{
            name = upgrade.name.replace(/\{amount\}/g, card.amount);
            desc = upgrade.desc.replace(/\{amount\}/g, card.amount);
        }

        if (post_script){
            desc += ' '+post_script;
        }

        if (current && upgraded){
            desc = desc.replace(/\{current\}/g, current);
            desc = desc.replace(/\{upgraded\}/g, upgraded);
        }

        out.push({
            id: i,
            class_tsid: card.class_tsid,
            name: name,
            desc: desc,
            cost: card.cost,
            config: upgrade.config
        });
    }

    return out;
}

////////////////////////////////////////////////////////////////////////////////

//
// Functions specific to upgrades go down here
//

////////////////////////////////////////////////////////////////////////////////

public function imagination_get_achievement_modifier(){
    if (this.imagination_has_upgrade('achievement_reward_bonus_5')){
        return 0.10;
    }
    else if (this.imagination_has_upgrade('achievement_reward_bonus_4')){
        return 0.08;
    }
    else if (this.imagination_has_upgrade('achievement_reward_bonus_3')){
        return 0.06;
    }
    else if (this.imagination_has_upgrade('achievement_reward_bonus_2')){
        return 0.04;
    }
    else if (this.imagination_has_upgrade('achievement_reward_bonus_1')){
        return 0.02;
    }

    return 0;
}

public function imagination_get_quest_modifier(){
    if (this.imagination_has_upgrade('quest_reward_bonus_5')){
        return 0.10;
    }
    else if (this.imagination_has_upgrade('quest_reward_bonus_4')){
        return 0.08;
    }
    else if (this.imagination_has_upgrade('quest_reward_bonus_3')){
        return 0.06;
    }
    else if (this.imagination_has_upgrade('quest_reward_bonus_2')){
        return 0.04;
    }
    else if (this.imagination_has_upgrade('quest_reward_bonus_1')){
        return 0.02;
    }

    return 0;
}

public function imagination_get_quoin_limit() {

    // juicing for end of world
    return 1355100037;

    if (this.imagination_has_upgrade('daily_quoin_limit_5')) {
        return 150;
    }
    else if (this.imagination_has_upgrade('daily_quoin_limit_4')) {
        return 140;
    }
    else if (this.imagination_has_upgrade('daily_quoin_limit_3')) {
        return 130;
    }
    else if (this.imagination_has_upgrade('daily_quoin_limit_2')) {
        return 120;
    }
    else if (this.imagination_has_upgrade('daily_quoin_limit_1')) {
        return 110;
    }

    return config.daily_quoin_limit;
}

// Get the distance of the transcendental radiation effect which depends on
// upgrades + level of transcendental radiation skill.
public function imagination_get_radiation_distance() {

    var level = this.player.skills.skills_get_highest_level("transcendental_radiation_1");

    var dist = 0;

    if (level == 1){
            dist = 400;
    }
    else if (level == 2){
            dist = 800;
    }
    else if (level == 3) {
            dist = 1500;
    }

    if (this.imagination_has_upgrade('transcendental_radius_3')) {
        dist = 10000; // special value which means radiate to all on level
    }
    else if (this.imagination_has_upgrade('transcendental_radius_2')) {
        dist = 2 * dist;
    }
    else if (this.imagination_has_upgrade('transcendental_radius_1')) {
        dist = 1.5 * dist;
    }

    //log.info("IMG dist is "+dist);
    return dist;
}

public function imagination_update_collectors() {
    if (this.player.houses.home) {
        var inside = this.player.houses.home.interior;
        var outside = this.player.houses.home.exterior;

        var milkers = [];
        var collectors = [];
        var i = 0;
        var j = 0;

        if (inside){
            milkers = inside.find_items("butterfly_milker");
            collectors = inside.find_items("meat_collector");

            //log.info(this+" updating "+milkers.length+" milkers and "+collectors.length+" collectors");

            for (i in milkers){
                milkers[i].onChangeInterval();
            }

            for (j in collectors){
                collectors[j].onChangeInterval();
            }
        }

        if (outside){
            milkers = outside.find_items("butterfly_milker");
            collectors = outside.find_items("meat_collector");

            //log.info(this+" updating "+milkers.length+" milkers and "+collectors.length+" collectors");

            for (i in milkers){
                milkers[i].onChangeInterval();
            }

            for (j in collectors){
                collectors[j].onChangeInterval();
            }
        }
    }
}

public var imagination_shuffle_card_cost = [
    25,
    30,
    35,
    40,
    45,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
    130,
    140,
    150,
    160,
    170,
    180,
    190,
    200,
    210,
    220,
    230,
    240,
    250,
    260,
    270,
    280,
    290,
    300,
    310,
    320,
    330,
    340,
    350,
    360,
    370,
    380,
    390,
    400,
    410,
    420,
    430,
    440,
    450,
    460,
    470,
    480,
    490,
    500,
    500,
    500,
    500,
    500,
    500
];

public function imagination_get_shuffle_card_cost(){
    return this.imagination_shuffle_card_cost[this.player.stats.stats_get_level()-5];
}

public function imagination_get_resurrection_card_cost(){
    return Math.max(20, this.player.metabolics.metabolics_get_max_energy() * 0.1);
}

public var imagination_conversion_energy = [
    [140, 900],
    [150, 1200],
    [170, 1900],
    [190, 2700],
    [210, 3700],
    [230, 4900],
    [250, 6100],
    [270, 7300],
    [300, 9100],
    [330, 11500],
    [360, 13900],
    [390, 16300],
    [420, 19100],
    [450, 22100],
    [480, 25100],
    [520, 29500],
    [560, 34300],
    [600, 39100],
    [640, 43900],
    [680, 48700],
    [720, 53500],
    [760, 58500],
    [800, 64100],
    [850, 71100],
    [900, 78100],
    [950, 85100],
    [1000, 92100],
    [1050, 100100],
    [1100, 108100],
    [1150, 116100],
    [1200, 124100],
    [1250, 132100],
    [1310, 141700],
    [1370, 151300],
    [1430, 160900],
    [1490, 170500],
    [1550, 181100],
    [1610, 191900],
    [1670, 202700],
    [1730, 213500],
    [1790, 224300],
    [1850, 235100],
    [1920, 247700],
    [1990, 260300],
    [2060, 274100],
    [2130, 288100],
    [2200, 302100],
    [2270, 316100],
    [2340, 330100],
    [2410, 344100],
    [2480, 358100],
    [2550, 373100],
    [2620, 388500],
    [2700, 406100],
    [2780, 423700],
    [2860, 441300]
];

public var imagination_conversion_quoin = [
    [1.4, 400],
    [1.5, 500],
    [1.7, 1000],
    [1.9, 1500],
    [2.1, 2250],
    [2.3, 3250],
    [2.5, 4250],
    [2.7, 5250],
    [3.0, 8500],
    [3.3, 10900],
    [3.6, 13300],
    [3.9, 15700],
    [4.2, 18500],
    [4.5, 21500],
    [4.8, 24500],
    [5.2, 28900],
    [5.5, 32500],
    [5.9, 37300],
    [6.2, 41300],
    [6.5, 45500],
    [6.8, 49700],
    [7.1, 54100],
    [7.4, 58900],
    [7.8, 65300],
    [8.2, 72100],
    [8.6, 79300],
    [8.9, 84700],
    [9.2, 90500],
    [9.6, 98500],
    [9.9, 104500],
    [10.2, 110900],
    [10.5, 117500],
    [10.9, 126300],
    [11.2, 133300],
    [11.6, 142900],
    [11.9, 150100],
    [12.2, 157700],
    [12.6, 168100],
    [12.9, 175900],
    [13.1, 181300],
    [13.4, 189700],
    [13.7, 198100],
    [14.0, 206500],
    [14.3, 215500],
    [14.6, 224500],
    [14.9, 233500],
    [15.2, 243100],
    [15.4, 249700],
    [15.7, 259600],
    [15.9, 266200],
    [16.1, 273200],
    [16.3, 280600],
    [16.5, 288000],
    [16.7, 295400],
    [17.0, 269500],
    [17.2, 314900]
];

public function imagination_convert(){
    // Only once
    if (this.converted_at) return;

    //log.info(this+' imagination_convert start');
    this.player.stats.stats_reset_imagination();
    this.imagination_reset();

    var level = this.player.stats.stats_get_level();
    if (level == 1){
        this.converted_at = Common.time();
    }

    // Set their iMG amount
    var xp = this.player.stats.stats_get_xp();
    var iMG = 0;
    if (level <= 30){
        iMG = xp;
    }
    else if (level <= 40){
        iMG = 408419 + ((xp - 408419) * 0.5);
    }
    else if (level <= 50){
        iMG = 740897 + ((xp - 1073375) * 0.5);
    }
    else if (level <= 60){
        iMG = 1402798 + ((xp - 2397177) * 0.25);
    }
    iMG = Math.round(iMG);

    var original_iMG = iMG;
    //log.info(this+' imagination_convert iMG: '+iMG);

    // On dev, give upgrades based on skills, etc
    var give_upgrades = true;
    if (config.is_dev) give_upgrades = true;

    if (level > 4){
        var energy = this.imagination_conversion_energy[level-5];
        if (give_upgrades){
            this.player.metabolics.metabolics_set_tank(0);
            this.imagination_grant('energy_tank', energy[0]);
        }
        iMG -= energy[1];
        //log.info(this+' imagination_convert energy_tank iMG: '+iMG);

        var quoin = this.imagination_conversion_quoin[level-5];
        if (give_upgrades){
            this.player.stats.stats_set_quoin_multiplier(1);
            this.imagination_grant('quoin_multiplier', quoin[0]-1.0);
        }
        iMG -= quoin[1];
        //log.info(this+' imagination_convert quoin_multiplier iMG: '+iMG);
    }

    var next_iMG = iMG;

    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['snapshotting'].cost;
    if (this.player.skills.skills_has('snapshotting_1') && (next_iMG / original_iMG) > 0.25){
        if (give_upgrades) this.imagination_grant('snapshotting', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['snapshotting'].cost;
        //log.info(this+' imagination_convert snapshotting iMG: '+iMG);
    }

    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[20].cost_per * 1;
    if (this.player.skills.skills_has('betterlearning_1') && (next_iMG / original_iMG) > 0.25){
        if (give_upgrades) this.imagination_grant('brain_capacity', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[20].cost_per * 1;
        //log.info(this+' imagination_convert betterlearning_1 iMG: '+iMG);
    }

    // Brain capacity is now 21
    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[20].cost_per * 2;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[23].cost_per * 1;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_1'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_1'].cost;
    if (this.player.skills.skills_has('betterlearning_2') && (next_iMG / original_iMG) > 0.25 && this.player.skills.get_brain_capacity() == 21){
        if (give_upgrades) this.imagination_grant('brain_capacity', 3);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[20].cost_per * 2;
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[23].cost_per * 1;

        if (give_upgrades) this.imagination_grant('learntime_alchemy_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_animal_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_cooking_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_gardening_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_harvesting_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_industrial_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_1'].cost;

        if (give_upgrades) this.imagination_grant('learntime_wellness_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_1'].cost;
        //log.info(this+' imagination_convert betterlearning_2 iMG: '+iMG);
    }

    // Brain capacity is now 24
    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[23].cost_per * 3;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[27].cost_per * 1;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_2'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_2'].cost;
    if (this.player.skills.skills_has('betterlearning_3') && (next_iMG / original_iMG) > 0.25 && this.imagination_has_upgrade('learntime_wellness_1')){
        if (give_upgrades) this.imagination_grant('brain_capacity', 4);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[23].cost_per * 3;
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[27].cost_per * 1;

        if (give_upgrades) this.imagination_grant('learntime_alchemy_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_animal_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_cooking_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_gardening_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_harvesting_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_industrial_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_2'].cost;

        if (give_upgrades) this.imagination_grant('learntime_wellness_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_2'].cost;
        //log.info(this+' imagination_convert betterlearning_3 iMG: '+iMG);
    }

    // Brain capacity is now 28
    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[27].cost_per * 3;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[31].cost_per * 1;
    if (this.player.skills.skills_has('betterlearning_4') && (next_iMG / original_iMG) > 0.25 && this.imagination_has_upgrade('learntime_wellness_2')){
        if (give_upgrades) this.imagination_grant('brain_capacity', 4);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[27].cost_per * 3;
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[31].cost_per * 1;
        //log.info(this+' imagination_convert betterlearning_4 iMG: '+iMG);
    }

    // Brain capacity is now 32
    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[31].cost_per * 3;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[35].cost_per * 2;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_3'].cost;
    next_iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_3'].cost;
    if (this.player.skills.skills_has('betterlearning_5') && (next_iMG / original_iMG) > 0.25 && this.imagination_has_upgrade('learntime_wellness_2')){
        if (give_upgrades) this.imagination_grant('brain_capacity', 5);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[31].cost_per * 3;
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['brain_capacity'].options[35].cost_per * 2;

        if (give_upgrades) this.imagination_grant('learntime_alchemy_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_alchemy_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_animal_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_animal_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_cooking_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_cooking_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_gardening_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_gardening_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_harvesting_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_harvesting_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_industrial_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_industrial_3'].cost;

        if (give_upgrades) this.imagination_grant('learntime_wellness_3', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['learntime_wellness_3'].cost;
        //log.info(this+' imagination_convert betterlearning_5 iMG: '+iMG);
    }

    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_ability'].cost;
    if (this.player.skills.skills_has('unlearning_1') && (next_iMG / original_iMG) > 0.25){
        if (give_upgrades) this.imagination_grant('unlearning_ability', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_ability'].cost;
        //log.info(this+' imagination_convert unlearning_1 iMG: '+iMG);
    }

    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_time_1'].cost;
    if (this.player.skills.skills_has('unlearning_2') && (next_iMG / original_iMG) > 0.25 && this.imagination_has_upgrade('unlearning_ability')){
        if (give_upgrades) this.imagination_grant('unlearning_time_1', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_time_1'].cost;
        //log.info(this+' imagination_convert unlearning_2 iMG: '+iMG);
    }

    next_iMG = iMG - com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_time_2'].cost;
    if (this.player.skills.skills_has('unlearning_3') && (next_iMG / original_iMG) > 0.25 && this.imagination_has_upgrade('unlearning_time_1')){
        if (give_upgrades) this.imagination_grant('unlearning_time_2', 1);
        iMG -= com.reversefold.glitch.server.data.Imagination.data_imagination_upgrades['unlearning_time_2'].cost;
        //log.info(this+' imagination_convert unlearning_3 iMG: '+iMG);
    }

    // Set it
    this.player.stats.stats_set_imagination(iMG);

    // Record some data
    this.xp_at_conversion = xp;
    this.level_at_conversion = level;
    this.img_after_conversion = iMG;
    this.img_at_conversion = original_iMG;
    this.converted_at = Common.time();

    // Reset hand
    this.imagination_reshuffle_hand(true);
    //log.info(this+' imagination_convert end');
}

public function imagination_convert_currants(){
    // Only once
    if (this.currants_converted_at) return;

    var currants = this.player.stats.stats_get_currants();

    var tax = 0;

    if (currants >= 50000){
        //log.info(this+' imagination_convert_currants taxing 50000');
        tax += Math.round((Math.min(currants, 100000) - 50000) * 0.15);
    }

    if (currants >= 100000){
        //log.info(this+' imagination_convert_currants taxing 100000');
        tax += Math.round((Math.min(currants, 250000) - 100000) * 0.25);
    }

    if (currants >= 250000){
        //log.info(this+' imagination_convert_currants taxing 250000');
        tax += Math.round((Math.min(currants, 500000) - 250000) * 0.40);
    }

    if (currants >= 500000){
        //log.info(this+' imagination_convert_currants taxing 500000');
        tax += Math.round((Math.min(currants, 1000000) - 500000) * 0.66);
    }

    if (currants >= 1000000){
        //log.info(this+' imagination_convert_currants taxing 1000000');
        tax += Math.round((Math.min(currants, 2000000) - 1000000) * 0.66);
    }

    if (currants >= 2000000){
        //log.info(this+' imagination_convert_currants taxing 2000000');
        tax += Math.round((currants - 2000000) * 0.66);
    }

    // Record some data
    this.currants_at_conversion = currants;
    this.currants_after_conversion = (currants-tax);
    this.currants_tax = tax;
    this.currants_converted_at = Common.time();

    this.player.stats.stats_set_currants(currants-tax);
    return true;
}

public function imagination_convert_currants_reset(){
    if (this && this.currants_at_conversion){
        this.player.stats.stats_set_currants(this.currants_at_conversion);
        return true;
    }

    return false;
}


public function admin_imagination_just_upgrades(args){

    var upgrades = [];
    if (!this.history) return upgrades;

    for (var i=0; i<this.history.length; i++){

        var up = this.history[i];

        if (args.exclude_series && up.class_tsid == 'brain_capacity') continue;
        if (args.exclude_series && up.class_tsid == 'quoin_multiplier') continue;
        if (args.exclude_series && up.class_tsid == 'energy_tank') continue;

        upgrades.push({
            upgrade: up.class_tsid,
            when: up.when,
            cost: up.cost,
            amount: up.amount
        });
    }
    upgrades.sort(function(a,b){
        return b.when-a.when;
    });

    if (args.limit && args.limit > upgrades.length){
        upgrades = upgrades.slice(0, args.limit);
    }

    return upgrades;
}

public function admin_imagination_get_upgrades(args){

    var out = {};

    out.upgrades = this.admin_imagination_just_upgrades(args);
    out.coin_multiplier = this.player.stats.quoin_multiplier;
    out.brain_capacity = this.player.skills.capacity;
    out.energy_tank = this.player.metabolics.energy.top;

    // find upgrades that aren't in our history
    out.pre_history = [];
    if (this && this.upgrades){

        // make map of things we already have
        var got_map = {};
        for (var i=0; i<out.upgrades.length; i++){
            got_map[out.upgrades[i].when+"-"+out.upgrades[i].upgrade] = 1;
        }

        // loop over skills
        for (var i in this.upgrades){
            for (var j=0; j<this.upgrades[i].length; j++){
                var key = this.upgrades[i][j]+"-"+i;
                var key2 = (this.upgrades[i][j]-1)+"-"+i; // 1 sec previous
                var key3 = (this.upgrades[i][j]+1)+"-"+i; // 1 sec after
                if (!got_map[key] && !got_map[key2] && !got_map[key3]){
                    out.pre_history.push({
                        upgrade: i,
                        when: this.upgrades[i][j],
                        cost: 0,
                        amount: 0
                    });
                }
            }
        }
    }


    return out;
}

public function admin_imagination_latest_upgrades(args){

    var up = this.admin_imagination_just_upgrades(args);
    var num = args.limit_upgrades ? args.limit_upgrades : 3;

    return {
        latest: up.slice(0, num),
        total: up.length
    };
}

public function admin_imagination_count_upgrades(){

    // returns a count of upgrades, used to check if we have any.
    // this count is not correct, since it really just counts unique card class_tsids
    // and you can have multiple of many cards

    if (!this.upgrades) return 0;
    return Utils.array_keys(this.upgrades).length;
}

public function imagination_rollback_brain_capacity(args){
    if (!this || this.brain_capacity_refunded) return;

    var upgrades = this.admin_imagination_just_upgrades(args);

    var capacity_refunded = 0;
    var img_refunded = 0;
    var upgrades_removed = 0;
    for (var i=0; i<upgrades.length; i++){
        var up = upgrades[i];
        if (up && up.upgrade == 'brain_capacity' && up.cost){
            img_refunded += up.cost;
            this.player.stats.stats_add_imagination(up.cost, {type: 'brain_capacity_refund'});
            capacity_refunded += up.amount;
            upgrades_removed++;
        }
    }

    if (capacity_refunded){
        this.player.skills.skills_set_brain_capacity(this.player.skills.get_brain_capacity()-capacity_refunded);

        var message = "All those Brain Capacity upgrades you purchased? Refunded! Why? Because we had some pricing bugs and didn't explain things very well. Sorry about that!\n\n";
        message += "But in (almost) all cases, the upgrades are now significantly cheaper and you have all your imagination back so you can make the right decisions. The decisions you always wanted to make.\n\n";
        message += "In your case, "+Common.pluralize(upgrades_removed, "upgrade", "upgrades")+" were refunded and you got "+img_refunded+" iMG back in total. Your current brain capacity is "+this.player.skills.get_brain_capacity()+".\n\n";
        message += "Also, enjoy this 5-pack of Awesome Stew on the house.\n\n";
        message += "Love,\n";
        message += "Team Tiny Speck";
        this.player.mail.mail_send_special_item("awesome_stew", 5, message, 1);
    }

    this.brain_capacity_refunded = true;
}

public function imagination_rollback_quoin_multiplier(args){
    var multiplier = this.player.stats.stats_get_quoin_multiplier();
    if (multiplier <= config.base.quoin_capacity_limit) return;

    var upgrades = this.admin_imagination_just_upgrades(args);

    var capacity_refunded = 0;
    var img_refunded = 0;
    var upgrades_removed = 0;
    var running_total = 1.0;
    for (var i=0; i<upgrades.length; i++){
        var up = upgrades[i];
        if (up && up.upgrade == 'quoin_multiplier' && up.cost){
            running_total += up.amount;
            if (running_total > config.base.quoin_capacity_limit){
                img_refunded += up.cost;
                this.player.stats.stats_add_imagination(up.cost, {type: 'quoin_multiplier_refund'});
                capacity_refunded += up.amount;
                upgrades_removed++;
            }
        }
    }

    if (capacity_refunded){
        this.player.stats.stats_set_quoin_multiplier(100);

        var message = "Ahoy Glitch,\n\n";
        message += "You know those Quoin Multiplier cards? Well, they were *supposed* to be limited so that the quoin multiplier maxed out at 100. But, apparently we didn't do that. And you got a multiplier over 100 ("+multiplier+", to be precise). Well, we're sorry but fair's fair for future players: since the cap at 100 is now in place, we gotta take your excess multiplier back. But, at least we're refunding your imagination. You got "+img_refunded+" back in your refund. Spend it wisely, and with our apologies.\n\n";
        message += "(Don't worry: there will be other things to spend iMG on in the future.)\n\n";
        message += "Love,\n";
        message += "- Tiny Speck";
        this.player.mail.mail_add_player_delivery(null, null, 0, message, 0, false);
    }

    return {
        ok: 1,
        capacity_refunded: capacity_refunded,
        img_refunded: img_refunded
    }
}

public function imagination_check_quoin_multiplier(args){
    var upgrades = this.admin_imagination_just_upgrades(args);

    var capacity_refunded = 0;
    var img_refunded = 0;
    var upgrades_removed = 0;
    var running_total = 1.0;
    var multiplier_upgrades = [];
    for (var i=0; i<upgrades.length; i++){
        var up = upgrades[i];
        if (up && up.upgrade == 'quoin_multiplier' && up.when < 1337993444){
            multiplier_upgrades.push(up);

            if (up.cost){
                running_total += up.amount;
                if (running_total > config.base.quoin_capacity_limit){
                    img_refunded += up.cost;
                    capacity_refunded += up.amount;
                    upgrades_removed++;
                }
            }
        }
    }

    return {
        ok: 1,
        capacity_refunded: capacity_refunded,
        img_refunded: img_refunded,
        upgrades_removed: upgrades_removed,
        running_total: running_total,
        multiplier_upgrades: multiplier_upgrades
    }
}

// Sets our imagination balance to the cost of the *cheapest* card in our hand. Used for newxp
public function imagination_reduce_to_hand(){
    var hand = this.imagination_get_hand();

    var cheapest = 0;
    for (var i in hand){
        var card = hand[i];
        if (!card) continue;

        if (!cheapest || card.cost < cheapest){
            cheapest = card.cost;
        }
    }

    if (cheapest && cheapest > this.player.stats.stats_get_imagination()) this.player.stats.stats_set_imagination(cheapest, true);

    return cheapest;
}

    }
}
