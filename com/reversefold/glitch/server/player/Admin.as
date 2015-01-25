package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.data.MapsProd;
    import com.reversefold.glitch.server.data.Pols;
    import com.reversefold.glitch.server.player.Player;
    import com.reversefold.glitch.server.utils.CraftyTasking;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Admin extends Common {
        private static var log : Logger = Log.getLogger("server.player.Admin");

        public var config : Config;
        public var player : Player;

        public function Admin(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function adminSetLocation(loc){

log.info('arg', loc);

    var location = Server.instance.apiFindObject(loc.tsid);

    if (!location){
        return 0;
    }

    location.apiMoveIn(this, loc.x, loc.y);

    log.info('moved player');
    return 1;
}

public function adminSendActivity(arg){
    this.player.sendActivity(arg.msg);
}

public function adminTeleport(arg){
    //if (!this.player.is_god) return {ok: 0, error: "You're not allowed to do that."};

    if (arg.sudo_make_me_an_instance){
        var instance = this.player.instances.instances_create('admin_teleport_'+arg.tsid, arg.tsid, {preserve_links: true});
        this.player.instances.instances_enter('admin_teleport_'+arg.tsid, arg.x, arg.y);

        return {
            'ok' : 1,
            'was_online' : 1,
            'is_queued': 1
        };

    }

    if (arg.really_the_freaking_template && arg.really_the_freaking_template == "0") arg.really_the_freaking_template = false;
    var ignore_instance_me = arg.really_the_freaking_template ? true : false;
    return this.player.teleportToLocation(arg.tsid, arg.x, arg.y, {'ignore_instance_me': ignore_instance_me});
}

public function adminLocationTeleport(arg){
    if (arg.is_token && this.player.teleportation.teleportation_get_token_balance()){
        return this.player.teleportation.teleportation_map_teleport(arg.dst, true);
    }
    else{
        return {ok: 0, error: 'Whaaaaa????'};
    }
}

public function adminLogout(arg){
    return this.player.apiLogout();
}

public function adminGetBuddyTsids(arg){

    var out = [];

    for (var i in this.player.friends){
        if (i != 'reverse'){
            for (var j in this.player.friends[i].pcs){
                out.push(j);
            }
        }
    }

    return out;
}

public function adminAddBuddyToGroup(args){

    return this.player.buddies.addToBuddyGroup(args.group_id, args.player_tsid, args.ignore_limit, args.skip_notify);
}

public function adminRemoveBuddy(args){

    return this.player.buddies.removeBuddy(args.player_tsid);
}

public function adminBuddiesAddIgnore(args){
    var pc = getPlayer(args.player_tsid);
    if (!pc) return 'invalid_player';

    this.player.buddies.buddies_add_ignore(pc);

    return 'ok';
}

public function adminBuddiesRemoveIgnore(args){
    var pc = getPlayer(args.player_tsid);
    if (!pc) return 'invalid_player';

    this.player.buddies.buddies_remove_ignore(pc);

    return 'ok';
}

public function adminBuddiesHasMax(args){
    var out = {};
    out.has_max = this.player.buddies.buddiesHasMax();
    if (out.has_max){
        out.reverse_buddies = this.player.buddies.buddies_get_reverse_tsids();
    }
    return out;
}

public function adminIsBuddy(args){

    return this.player.buddies.getBuddyGroup(args.tsid) ? 1 : 0;
}


public function adminHasBagSpace(args){
    var stack = false;;
    if (args && args.stack_tsid){
        stack = Server.instance.apiFindObject(args.stack_tsid);
    }
    return this.player.bag.isBagFull(stack) ? 0 : 1;
}

/*
public function adminExec(args){
    try {
        return eval(args.code);
    }
    catch (e){
        log.error('Exception during ADMIN_CALL eval', args, e);
    }
}
*/

//
// this is a function for executing code and returning
// something afterwards. an array of statements to execute
// is sent and we return the value of the last one.
//
/*
public function adminExecMulti(args){
    try {
        //log.info('adminExecMulti()');
        var len = args.code.length;
        for (var i=0; i<len; i++){
            //log.info('LINE '+i+': '+args.code[i]);
            if (i == len-1){
                var ret = null;
                eval('ret = '+args.code[i]);
                return {ok: 1, ret: ret};
            }else{
                eval(args.code[i]);
            }
        }
    }
    catch (e){
        log.error('Exception during ADMIN_CALL eval return', args, e);
        return { ok: 0, e: e};
    }
}

public function adminDebugSkills(){
    this.adminGetSkills();
    return Server.instance.apiGetIOOps();
}
*/

public function adminGetProfile(args){

    this.player.init();

    var out = {};

    //
    // online?
    //

    out.is_online = Server.instance.apiIsPlayerOnline(this.player.tsid);


    //
    // core stats
    //

    out.stats = this.player.stats.stats_get();


    //
    // contact status
    //

    out.is_me = 0;
    out.is_contact = 0;
    out.is_rev_contact = 0;
    out.is_ignoring = 0;
    out.is_ignored_by = 0;

    if (args.viewer_tsid){


        //
        // do we count the viewer as a contact
        //

        var ret = this.player.buddies.getBuddyGroup(args.viewer_tsid);
        if (ret != null){
            out.is_contact = 1;
            out.contact_group = ret;
        }


        //
        // does the viewer count us as a contact
        //

        var viewer = Server.instance.apiFindObject(args.viewer_tsid);
        var ret = viewer ? viewer.getBuddyGroup(this.player.tsid) : null;
        if (ret != null){
            out.is_rev_contact = 1;
            out.rev_contact_group = ret;
        }


        //
        // are we ignoring the viewer/are they ignoring us?
        //

        out.is_ignoring = viewer && this.player.buddies.buddies_is_ignoring(viewer) ? true : false;
        out.is_ignored_by = viewer && this.player.buddies.buddies_is_ignored_by(viewer) ? true : false;


        //
        // Hellooooo? Is it me you're looking forrrrr?
        //

        if (args.viewer_tsid == this.player.tsid){
            out.is_me = 1;
        }
    }


    //
    // everything else
    //

    if (!args.skip_inventory) out.inventory = this.player.profile.profile_get_inventory();

    if (!args.skip_skills){
        out.skills = this.player.skills.skills_get_list();
        out.skills_learning = this.player.skills.skills_get_learning();
        out.can_unlearn = this.player.imagination.imagination_has_upgrade('unlearning_ability');
    }

    if (!args.skip_groups) out.groups = this.player.profile.profile_get_groups(out.is_me);

    if (!args.skip_metabolics) out.metabolics = this.player.profile.profile_get_metabolics();

    if (!args.skip_buddies){
        if (!args.limit_buddies){
            this.player.buddies.buddies_init();
            out.friends = this.player.buddies.buddies_get_login(1000);
            out.ignoring = this.player.buddies.buddies_get_ignoring_login();
        } else {
            out.friends = this.player.buddies.buddies_get_random_slice(args.limit_buddies);
        }
    }

    if (!args.skip_achievements) out.achievements = this.player.achievements.achievements_get_profile();

    out.location = {
        'name' : this.player.location.label,
        'tsid' : this.player.location.tsid,
        'x' : this.player.x,
        'y' : this.player.y,
        'is_hidden' : this.player.location.is_hidden()
    };

    out.a2 = this.player.avatar.avatar_hash();

    out.houses = this.player.profile.profile_get_houses();
    out.home_street = this.player.profile.profile_get_home_street();

    out.has_done_intro = this.player.has_done_intro ? 1 : 0;
    out.new_player_goodbye_familiar = this.player.has_done_intro ? 1 : 0;

    //
    // Moderation flgs
    //

    out.is_in_timeout = this.player.isInTimeout();
    out.is_in_coneofsilence = this.player.isInConeOfSilence();
    out.is_in_help_coneofsilence = this.player.isInConeOfSilence('help');

    if (!args.skip_upgrades){
        out.upgrades = this.player.imagination.admin_imagination_latest_upgrades(args);
        out.upgrades_total = this.player.imagination.admin_imagination_count_upgrades();
    }

    return out;
}

//
// this feeds the players.fullInfo() API method
//
public function adminGetFullInfo(args){

    this.player.init();

    var out = {};

    //
    // online?
    //

    out.is_online = Server.instance.apiIsPlayerOnline(this.player.tsid);

    if (out.is_online){
        out.last_online = 0;
    } else {
        out.last_online = this.player.date_last_logout;
    }

    //
    // core stats
    //

    out.stats = this.player.stats.stats_get();

    //
    // contact status
    //

    out.is_me = false;
    out.is_contact = false;
    out.is_rev_contact = false;
    out.can_contact = false;

    if (args.viewer_tsid){

        //
        // do we count the viewer as a contact
        //

        var ret = this.player.buddies.getBuddyGroup(args.viewer_tsid);
        if (ret != null){
            out.is_contact = true;
            out.contact_group = ret;
        }

        //
        // does the viewer count us as a contact
        //

        var viewer = Server.instance.apiFindObject(args.viewer_tsid);
        var ret = viewer ? viewer.getBuddyGroup(this.player.tsid) : null;
        if (ret != null){
            out.is_rev_contact = true;
            out.rev_contact_group = ret;
        }

        //
        // can this viewer make this player a contact?
        // (For now, this boils down to "is there an ignore in place?")
        //

        out.can_contact = (viewer && this.player.buddies.buddies_is_ignoring(viewer)) || (viewer && this.player.buddies.buddies_is_ignored_by(viewer)) || (args.viewer_tsid == this.player.tsid) ? false : true;

        //
        // Iiii'm looking at the man inthemirror...
        //
        if (args.viewer_tsid == this.player.tsid){
            out.is_me = true;
        }
    }

    //
    // everything else
    //
    out.num_skills = this.player.skills.skillsGetCount();

    var skill = this.player.skills.skillsGetLatest();

    out.latest_skill = {};

    if (typeof(skill) != 'undefined'){
        out.latest_skill = {
            'id' : skill.id,
            'name' : this.player.skills.skills_get_name(skill.id)
        };
    }
    out.num_achievements = this.player.achievements.achievementsGetCount();

    var latest_achievement = this.player.achievements.achievementsGetLatest();

    out.latest_achievement = {};

    if (latest_achievement){
        out.latest_achievement = {
            'id'   : latest_achievement.id,
            'name' : latest_achievement.name,
            'icon_urls' : {
                'swf' : latest_achievement.url_swf,
                '180' : latest_achievement.url_img_180,
                '60'  : latest_achievement.url_img_60,
                '40'  : latest_achievement.url_img_40
            }
        };
    }

    out.num_upgrades = this.player.imagination.imagination_get_list().length;

    out.metabolics = this.player.profile.profile_get_metabolics();

    out.location = {
        'name' : this.player.location.label,
        'tsid' : this.player.location.tsid,
        'x' : this.player.x,
        'y' : this.player.y,
        'is_hidden' : this.player.location.is_hidden(),
        'is_pol' : this.player.location.pols_is_pol()
    };

    out.houses = this.player.houses.houses_get_with_streets();

    return out;
}

public function adminGetLocationInfo(){
    var is_online = Server.instance.apiIsPlayerOnline(this.player.tsid);
    var out = {
        is_online: is_online,

        last_online: is_online ? 0 : this.player.date_last_logout,

        location: {
            'name' : this.player.location.label,
            'tsid' : this.player.location.tsid,
            'x' : this.player.x,
            'y' : this.player.y,
            'is_hidden' : this.player.location.is_hidden(),
            'is_pol' : this.player.location.pols_is_pol()
        },
        houses: this.player.houses.houses_get_with_streets()
    };

    return out;
}

public function adminIsOnline(){
    return Server.instance.apiIsPlayerOnline(this.player.tsid);
}

public function adminHasUnlearningAbility() {
    return this.player.imagination.imagination_has_upgrade("unlearning_ability");
}

public function adminGetSkills(args){
    var is_admin = !!(args && args.is_admin);
    return {
        skills: this.player.skills.skills_get_all(is_admin),
        skill_queue: this.player.skills.skills_get_queue(),
        unlearn_queue: this.player.skills.skills_get_unlearning()
    };
}

public function adminSkillsTrain(args){
    return this.player.skills.skills_train(args.skill_id);
}

public function adminSkillsUnlearn(args){
    return this.player.skills.skills_unlearn(args.skill_id);
}

public function adminSkillsCancelUnlearn(args){
    return this.player.skills.skills_cancel_unlearning(args.skill_id);
}

public function adminGetCurrants(args){
    return {
        'currants': this.player.stats.currants.value
    };
}

public function adminGetGodProfile(args){

    this.player.init();

    var out = {};

    //
    // online?
    //

    out.is_online = Server.instance.apiIsPlayerOnline(this.player.tsid);
    out.date_last_login = this.player.date_last_login;


    //
    // core stats
    //

    out.stats = this.player.stats.stats_get();

    if (args.wants && args.wants.max_favor){
        out.stats.favor_points_max = {};

        for (var i in out.stats.favor_points){
            out.stats.favor_points_max[i] = this.player.stats.stats_get_max_favor(i);
        }
    }

    //
    // metabolics
    //

    out.metabolics = {};

    out.metabolics.energy = {
        'value' : this.player.metabolics.energy.value,
        'max'   : this.player.metabolics.energy.top
    };

    out.metabolics.mood = {
        'value' : this.player.metabolics.mood.value,
        'max'   : this.player.metabolics.mood.top
    };


    //
    // location
    //

    out.location = {
        'name' : this.player.location.label,
        'tsid' : this.player.location.tsid,
        'x' : this.player.x,
        'y' : this.player.y
    };

    //
    // quests
    //

    if (args.wants && args.wants.quests){
        out.quests = this.player.quests.quests_get_all();
    }


    //
    // skills
    //

    if (args.wants && args.wants.skills){
        out.skills = this.player.skills.skills_get_list();
    }

    //
    // recipes
    //

    if (args.wants && args.wants.recipes){
        var recipes = this.player.making.making_get_known_recipes();

        out.recipes = {};

        // this jiggery-pokery orders recipes by the tools used to create them,
        // because that seems a tad more useful than just spewing out a big jumbled list.
        for (var r in recipes){
            var recipe = get_recipe(r);

            if (!recipe) continue;

            if (out.recipes[recipe.tool] == undefined){
                out.recipes[recipe.tool] = [];
            }

            out.recipes[recipe.tool][r] = {
                'name'    : recipe.name,
                'skill'   : recipe.skill,
                'outputs' : recipe.outputs,
                'learnt'  : recipe.learnt,
                'when'    : recipes[r]
            }
        }
    }

    //
    // achievements
    //

    if (args.wants && args.wants.achievements){
        out.achievements = this.player.achievements.achievements_get_profile();
        out.achievements_queue = this.player.achievements.achievements_get_queue();
    }

    //
    // buffs
    //

    if (args.wants && args.wants.buffs){
        out.buffs = this.player.buffs.buffs_get_active();
    }


    //
    // upgrades
    //

    out.img_migrated = 0;
    if (this.player.imagination && this.player.imagination.converted_at) out.img_migrated = this.player.imagination.converted_at;

    return out;
}

public function adminAddMood(args){
    this.player.metabolics.metabolics_add_mood(args.amount);
}

public function adminAddEnergy(args){
    this.player.metabolics.metabolics_add_energy(args.amount);
}

public function adminRemoveMood(args){
    this.player.metabolics.metabolics_lose_mood(args.amount);
}

public function adminRemoveEnergy(args){
    this.player.metabolics.metabolics_lose_energy(args.amount);
}

public function adminAddXP(args){
    this.player.stats.stats_add_xp(args.amount, true, {type: 'god_page'});
}

public function adminAddCurrants(args){
    this.player.stats.stats_add_currants(args.amount);
}

public function adminRemoveCurrants(args){
    this.player.stats.stats_remove_currants(args.amount, {type: 'admin_call'});
}

public function adminAddFavorPoints(args){
    this.player.stats.stats_add_favor_points(args.giant,args.amount,0);
}

public function adminRemoveFavorPoints(args){
    this.player.stats.stats_remove_favor_points(args.giant,args.amount);
}

public function adminAddImagination(args){
    this.player.stats.stats_add_imagination(args.amount, {type: 'god_page'});
}

public function adminAddBrainCapacity(args){
    this.player.skills.skills_increase_brain_capacity(args.amount);
}

public function adminAddQuoinMultiplier(args){
    this.player.stats.stats_increase_quoin_multiplier(args.amount);
}

public function admin_get_visited_streets(){
    if (this.player.achievements) {
        return this.player.counters.counters.locations_visited;
    } else {
        return {};
    }
}

public function adminStreetHistory() {
    var out = {};

    out.streets = this.player.stats.stats_get_street_history();
    out.pols = this.player.stats.stats_get_pol_history();

    return out;
}

public function admin_get_player_progress() {

    var out = {};

    out.level = this.player.stats.level;
    out.skills = this.player.skills.skills_get_list().length;
    out.time_played = this.player.getTimePlayed();
    out.got_walk_speed1 = this.player.imagination.imagination_has_upgrade("walk_speed_1");
    out.got_walk_speed2 = this.player.imagination.imagination_has_upgrade("walk_speed_2");
    out.got_jump1 = this.player.imagination.imagination_has_upgrade("jump_1");
    out.got_jump2 = this.player.imagination.imagination_has_upgrade("jump_2");
    out.got_mappery = this.player.imagination.imagination_has_upgrade("mappery");
    out.completed_buy_bag = (this.player.quests.getQuestStatus("buy_two_bags") == 'done');
    out.completed_leave_gentle_island = (this.player.quests.getQuestStatus("leave_gentle_island") == 'done');
    out.max_energy = this.player.metabolics.energy.top;
    out.quoin_multiplier = this.player.stats.stats_get_quoin_multiplier();
    out.enter_clouds = (this.player.stats.stats_get_last_street_visit('LIFBFC7TDJ535UL') > 0);
    out.enter_training1 = (this.player.stats.stats_get_last_street_visit('LIFBLMAVDJ53NP1') > 0);
    out.date_last_login = this.player.date_last_loggedin;
    out.num_friends = this.player.buddies.buddies_count();

    return out;
}

public function admin_test_data(){

    var out = {};

    out.level = this.player.stats.level;
    out.max_energy = this.player.metabolics.energy.top;
    out.xp = this.player.stats.xp.value;
    out.currants = this.player.stats.currants.value;
    out.favor_points = this.player.stats.favor_points;
    out.houses = array_keys(this.player.houses);
    out.quests_todo = {};
    out.quests_complete = {};
    if (this.player.quests) {
        for (var i in this.player.quests.done.quests) {
            out.quests_complete[i] = {
                'ts_start' : this.player.quests.done.quests[i].ts_start,
                'ts_done' : this.player.quests.done.quests[i].ts_done
            }
        }
        for (var i in this.player.quests.todo.quests) {
            out.quests_todo[i] = this.player.quests.todo.quests[i].ts_start;
        }
    }
    out.achievements = this.player.achievements.achievements;
    out.inventory = {};
    var inventory = this.player.bag.getAllContents();
    for (var i in inventory){
        var it = inventory[i];
        if (!it) continue;

        if (!out.inventory[it.class_id]) out.inventory[it.class_id] = 0;
        out.inventory[it.class_id] += it.count;
    }
    out.skills = this.player.skills ? this.player.skills.skills : {};
    out.visited_streets = this.player.counters.counters_get_group_count('locations_visited');
    out.buddies = this.player.buddies.buddies_count();
    out.buddies_rev = this.player.buddies.buddies_reverse_count();
    out.recipes = this.player.making.recipes ? array_keys(this.player.making.recipes.recipes) : 0;
    out.completed_tutorial = this.player.has_done_intro ? 1 : 0;
    out.date_last_login = this.player.date_last_login;
    out.time_played = this.player.counters.counters.time_played;
    out.count_ignoring = this.player.buddies.buddies_get_ignoring_count();
    out.count_ignored_by = this.player.buddies.buddies_get_ignored_by_count();

    // get all items in an owned POL and items in cabinets in owned POLs

    /*
    out.house_items = {};
    out.house_cabinet_items = {};
    var houses = this.player.houses.houses_get_all();

    for (var i in houses) {
        var house = houses[i];
        var items = house.getItems();
        for (var j in items) {
            var item = items[j];
            if (item.isBag()) {
                // this is a container
                var cItems = item.getAllContents();
                if (item.class_tsid.indexOf("cabinet") != -1) {
                    // this is a cabinet
                    for (var k in cItems) {
                        var cItem = cItems[k];
                        if (cItem.isBag()) {
                            // this is a container in a cabinet
                            out.house_cabinet_items[k] = {"value" : cItem.class_tsid, "count" : cItem.getCount()};
                            var cbItems = cItem.getAllContents();
                            for (var l in cbItems) {
                                out.house_cabinet_items[l] = {"value" : cbItems[l].class_tsid, "count" : cbItems[l].getCount()};
                            }
                        } else {
                            out.house_cabinet_items[k] = {"value" : cItem.class_tsid, "count" : cItem.getCount()};
                        }
                    }
                } else {
                    // a container in a pol
                    out.house_items[j] = {"value" : item.class_tsid, "count" : item.getCount()};
                    for (var k in cItems) {
                        var bItem = cItems[k];
                        out.house_items[k] = {"value" : bItem.class_tsid, "count" : bItem.getCount()};
                    }
                }
            } else {
                // an item in a pol
                out.house_items[j] = {"value" : item.class_tsid, "count" : item.getCount()};
            }
        }
    }
    */

    if (this.player.houses.home) {
        out.furniture = {};
        out.furniture.bag = this.player.furniture.furniture_count();
        if (this.player.houses.home.interior) {
            var interior_items = this.player.houses.home.interior.admin_get_items().items;
            out.furniture.interior = num_keys(interior_items);
            out.yard_size = this.player.houses.home.interior.home_get_yard_size();
        }
        if (this.player.houses.home.exterior) {
            var exterior_items = this.player.houses.home.exterior.admin_get_items().items;
            out.furniture.exterior = num_keys(exterior_items);
            var yard_size = this.player.houses.home.exterior.home_get_yard_size();
            out.street_size_left = yard_size[0];
            out.street_size_right = yard_size[1];
        }
    }

    return out;
}

public function admin_reset_skills(){

    this.player.skills.skills_remove("croppery");
    this.player.skills.skills_remove("animal_husbandry");
    this.player.skills.skills_remove("botany");
    this.player.skills.skills_remove("cheffery");
    this.player.skills.skills_remove("cocktail_crafting");
    this.player.skills.skills_remove("herdkeeping");
    this.player.skills.skills_remove("remote_herdkeeping");
    this.player.skills.skills_remove("gasmogrification");
    this.player.skills.skills_remove("spice_milling");
    this.player.skills.skills_remove("blending");
    this.player.skills.skills_remove("fruit_changing");
    this.player.skills.skills_remove("master_chef");
    this.player.skills.skills_remove("grilling");
    this.player.skills.skills_remove("saucery");
    this.player.skills.skills_remove("bubble_tuning");
}

public function admin_place_pol(){

    this.player.familiar.familiar_send_alert_now({
        'callback' : 'admin_place_pol_callback'
    });
}

public function admin_place_pol_callback(choice, details){

    //
    // give template choices
    //

    if (choice == 'start'){

        var choices = {};
        var c = 1;

        for (var i in Pols.pol_types){

            choices[c++] = {
                txt : Pols.pol_types[i].label,
                value   : 'pick_template_'+Pols.pol_types[i].uid
            };
        }

        choices[c++] = {
            txt : "Cancel",
            value   : 'dismiss'
        };

        return {
            txt: "Choose a POL template to clone:",
            choices: choices
        };
    }


    //
    // build a street
    //

    if (choice.substr(0, 14) == 'pick_template_'){

        var idx = choice.substr(14);
        var pol = Utils.get_pol_config(idx);

        var ret = this.player.location.pols_write_create(pol.template_tsid, this.player.x, this.player.y, pol.uid, true);

        if (ret.ok){

            return {
                txt: "OK! A POL has been created right where you're standing. Reload the client to show it.",
                done: true
            };
        }else{

            return {
                txt: "Error creating POL: "+ret.error,
                done: true
            };
        }
    }


    //
    // cancel
    //

    return {
        done: true
    };
}

public function admin_test_teleporting(){

    //
    // try and find a remote location...
    //
    var street = this.admin_get_remote_location();

    if (street){
        this.player.sendActivity("found a remote street: "+street.tsid);
    }else{
        this.player.sendActivity("can't find a remote street");
        return;
    }

    this.player.sendActivity('pre-teleport');
    this.player.teleportToLocation(street.tsid, 0, 0);
    this.player.sendActivity('post-teleport');
}

public function admin_get_remote_location(){

    for (var mote_id in MapsProd.data_maps.streets){
        for (var hub_id in MapsProd.data_maps.streets[mote_id]){
            for (var tsid in MapsProd.data_maps.streets[mote_id][hub_id]){

                var street = Server.instance.apiFindObject(tsid);
                if (street.isRemote) return street;
            }
        }
    }

    return null;
}

public function admin_get_leaderboards(){

    if (!config.is_dev && (this.player.is_god || this.player.is_help || this.player.tsid == 'PCRFDQOCKNS1LIS')) return {};

    var out = {
        'players': {
            'xp'        : this.player.stats.stats_get_xp(),
            'currants'  : this.player.stats.stats_get_currants(),
            'locations' : this.player.counters.counters_get_group_count('locations_visited'),
            'achievements'  : this.player.achievements.achievements_get_leaderboard_count(),
            'quests'    : this.player.quests.quests_get_complete_count()
        }
    };

    return out;
}

public function admin_get_inventory(){

    return make_bag(this);
}

public function admin_get_inventory_cabinets(){
    var out = {};

    //
    // If they have one, find their cabinet - it's attached to the house,
    // so walk through houses, then sort through house contents and if we
    // find a cabinet, load it.
    //

    out['cabinets'] = [];
    if (this.player.houses){
        for (var house_tsid in this.player.houses){
            var house = Server.instance.apiFindObject(house_tsid);
            var items = house.admin_get_items();

            for (var item_tsid in items.items){
                var item = Server.instance.apiFindObject(item_tsid);
                if (item.is_cabinet){
                    out['cabinets'].push({
                        class_tsid: item.class_id,
                        label: item.getLabel ? item.getLabel() : item.label,
                        version: item.version,
                        path_tsid: item.path,
                        slots: item.capacity,
                        items: make_bag(item)
                    });
                }
            }
        }
    }

    return out;
}

public function admin_get_inventory_furniture(){

    var bag = this.player.furniture.furniture_get_bag();

    var contents = bag.getContents();

    var out = make_bag(bag);

    for (var i in contents){
        if (contents[i]){
            var tsid = contents[i].tsid;

            if (contents[i].hasTag('trophy')){
                delete out[tsid];
            } else {
                out[tsid].upgrades = contents[i].getUpgrades(this, true);
            }
        }
    }

    return out;
}

//
// return everything needed for the header
//

public function admin_get_stats(){

    var out = {};

    this.player.stats.stats_get_login(out);

    out.energy = {
        value: this.player.metabolics.energy.value,
        max: this.player.metabolics.energy.top
    };

    out.mood = {
        value: this.player.metabolics.mood.value,
        max: this.player.metabolics.mood.top
    };
    out.mail_unread = this.player.mail.mail_count_unread();

    return out;
}

public function adminDebug(args){
    log.info(args);
    return args;
}

public function adminCheckDoneIntro(args){
    if (!this.player.has_done_intro && (config.force_intro || this.player.quickstart_needs_player) && (!this.player.intro_steps || this.player.intro_steps['new_player_part1']) && this.player.stats.stats_get_level() < 2 && !this.player.location.is_newxp && !this.player.location.is_skillquest){
        this.player.no_reset_teleport = true;
        this.player.resetForTesting();
        this.player.goToNewNewStartingLevel();
        log.info(this+' adminCheckDoneIntro reset because not has_done_intro original');
    }
    else if (!this.player.has_done_intro && (config.force_intro || this.player.quickstart_needs_player) && !this.player.location.is_newxp && !this.player.location.is_skillquest && this.player.stats.stats_get_level() < 4){
        this.player.no_reset_teleport = true;
        this.player.resetForTesting();
        this.player.goToNewNewStartingLevel();
        log.info(this+' adminCheckDoneIntro reset because not has_done_intro');
    }
    else if (this.player.location.isInstance('new_starting')){
        this.player.no_reset_teleport = true;
        this.player.resetForTesting();
        this.player.goToNewNewStartingLevel();
        log.info(this+' adminCheckDoneIntro reset because old newxp');
    }

    var leave_gentle_island_status = this.player.quests.getQuestStatus('leave_gentle_island');
    return {
        has_done_intro : this.player.has_done_intro,
        // the following makes the assumption that they cannot have done the leave_gentle_island_status quest if !has_done_intro
        // (but they might not have been given the quest yet, so it might not have a 'todo' status)
        needs_todo_leave_gentle_island: (!this.player.has_done_intro) ? true : (leave_gentle_island_status == 'todo')
    };
}

public function admin_get_location(){
    var info = this.player.location.getInfo();

    return {
        ok      : 1,
        tsid        : info.tsid,
        label       : info.label,
        moteid      : info.moteid,
        hubid       : info.hubid,
        x       : this.player.x,
        y       : this.player.y,
        is_god      : this.player.is_god,
        is_instance : info.is_instance,
        is_pol      : info.is_pol,
        logged_in   : this.player.date_last_login
    };
}

public function admin_is_instanced(){
    if (this.player.location.is_instance){
        var members = this.player.location.instance.get_members();
        var joined = 0;

        for (var member_tsid in members){
            if (member_tsid == this.player.tsid){
                joined = members[member_tsid].joined;
            }
        }

        return {
            'is_instanced': 1,
            'joined': joined
        }
    } else {
        return {
            'is_instanced': 0
        }
    }
}

public function admin_renamed(args){
    // called after player-initiated rename
    if (args.cost) this.player.stats.stats_try_remove_currants(args.cost);

    if (this.player.houses.home){
        var label = Utils.escape(this.player.label)+"'s";
        if (this.player.houses.home.interior) this.player.houses.home.interior.setProp('label', label+' House');
        if (this.player.houses.home.exterior) this.player.houses.home.exterior.setProp('label', label+' Home Street');
        if (this.player.houses.home.tower) this.player.houses.home.tower.tower_set_label(label+' Tower');
    }

    if (Server.instance.apiIsPlayerOnline(this.player.tsid)) {
        this.player.apiSendMsg({
            type: 'pc_rename',
            pc: this.player.make_hash()
        });
    }

}

public function adminGetItemDescExtras(args){
    if (!args || !args.class_id) return {};

    var proto = Server.instance.apiFindItemPrototype(args.class_id);
    if (!proto || !proto.getDescExtras) return {};

    return proto.getDescExtras(this);
}

public function adminGetGodExtras(args){
    return {
        is_in_timeout: this.player.isInTimeout(),
        is_in_coneofsilence: this.player.isInConeOfSilence(),
        is_in_help_coneofsilence: this.player.isInConeOfSilence('help'),
        img_migrated: (this.player.imagination && this.player.imagination.converted_at) ? this.player.imagination.converted_at : 0,
        is_online: Server.instance.apiIsPlayerOnline(this.player.tsid)
    };
}

public function adminBuildPath(args){
    var dst = args.dst;

    var ret = this.player.buildPath(dst);
    if (!ret.ok){
        return ret;
    }

    var rsp = {
        type: 'get_path_to_location',
        path_info: ret.path
    };

    this.player.apiSendMsg(rsp);

    return {ok: 1};
}

public function adminSetTeleportationTokens(args){
    this.player.teleportation.teleportation_init();
    this.player.teleportation.token_balance = intval(args.tokens);
    this.player.teleportation.teleportation_notify_client();
    return {ok: 1};
}

public function adminSetCredits(args){
    this.player.stats.stats_init();
    this.player.stats.stats_set_credits(args.credits);
    return {ok: 1};
}

public function adminSetSubscriptionStatus(args){
    this.player.stats.stats_init();
    this.player.stats.stats_set_sub(args.is_subscriber, args.sub_expires);
    return {ok: 1};
}

public function admin_get_greeting_data(args){
    var out = {};

    out.greeted = this.player.greeted ? this.player.greeted : {};
    out.greeting = this.player.greeting ? this.player.greeting : {};

    return out;
}

public function admin_get_named_animals(){

    var out = {};

    if (this.player.animals_named){
        for (var i in this.player.animals_named){

            var row = Server.instance.apiCopyHash(this.player.animals_named[i]);

            var item = null;
            if (row.tsid) item = Server.instance.apiFindObject(row.tsid);
            if (item) row.current = item.getNameInfo();

            out[i] = row;
        }
    }

    return out;
}

public function admin_fix_quest_containers(){
    var fixed = 0;
    for (var i in this.player.quests.todo.quests){
        //log.info(this+' admin_fix_quest_containers checking '+i);
        var q = this.player.quests.todo.quests[i];
        if (q.isDone(this)){
            //log.info(this+' admin_fix_quest_containers '+i+' is done. Unflagging.');
            // Flag it as incomplete so it can get turned in on next login
            q.setProp('is_complete', false);
            fixed++;
        }
        else{
            //log.info(this+' admin_fix_quest_containers '+i+' is not done.');
        }
    }

    return {
        fixed: fixed
    };
}

public function admin_mail_has_unread(args){
    return { 'ok': 1, 'has_unread_mail': this.player.mail.mail_has_unread() };
}

public function admin_mail_get_count(args){
    return { 'ok': 1, 'message_count': this.player.mail.mail_count_messages() };
}

public function admin_mail_unread_count(args){
    return { 'ok': 1, 'unread_count': this.player.mail.mail_count_unread() };
}

public function admin_mail_get_inbox(args){
    return {
        'ok'        : 1,
        'inbox'     : args.fetch_all ? this.player.mail.build_mail_check_msg(null, null, true) : this.player.mail.build_mail_check_msg(null),
        'unread_count'  : this.player.mail.mail_count_unread(),
        'replied_count' : this.player.mail.mail_count_replied()
    };
}

public function admin_mail_get_message(args){
    var message = this.player.mail.mail_get_player_message_data(args.msg_id);

    if (!args.keep_read_status) this.player.mail.mail_read(args.msg_id, args.mark_as_read);

    if (!message) return {'ok': 1, 'message_not_found' : 1};
    if (message.sender_tsid) {
        var sender_pc = getPlayer(message.sender_tsid);
        message.sender_label = sender_pc.label;
        message.sender_avatar = sender_pc.avatar_get_singles();
    }

    return { 'ok': 1, 'message' : message };
}

public function admin_mail_delete_message(args){
    this.player.mail.mail_remove_player_message(args.msg_id);
    return { 'ok': 1 };
}

public function admin_mail_send(args){

    var delay = config.mail_delivery_time;
    var cost = 2;

    // Remove currents for shipping costs
    var sender_pc = getPlayer(args.sender_tsid);
    sender_pc.stats_remove_currants(cost, {type: 'mail_send', in_reply_to: args.in_reply_to, to: this.player.tsid});

    if (args.in_reply_to) {
        args.in_reply_to = sender_pc.mail_get_player_reply(args.in_reply_to);
    } else if (args.in_reply_to_payload) {
        args.in_reply_to = args.in_reply_to_payload;
    }

    log.info("MAIL: admin_mail_send");
    this.player.mail.mail_add_player_delivery(null, args.sender_tsid, 0, args.message, delay, true, args.in_reply_to);

    return { 'ok': 1 };
}

public function adminGetHomepage(args){

    this.player.init();

    var out = {};

    //
    // structured data
    //

    out.stats = this.player.stats.stats_get();
    out.skills_learning = this.player.skills.skills_get_learning();
    out.friends = this.player.buddies.buddies_get_simple_online();

    // flags
    out.has_done_intro = !!this.player.has_done_intro;
    out.new_player_goodbye_familiar = !!this.player.has_done_intro;
    out.is_in_timeout = this.player.isInTimeout();
    out.is_in_coneofsilence = this.player.isInConeOfSilence();
    out.is_in_help_coneofsilence = this.player.isInConeOfSilence('help');

    return out;
}

public function adminGetProfileFriends(args){

    var out = {};
    out.friends = this.player.buddies.buddies_get_simple_online();

    return out;
}

public function adminCleanLostHiddenItems(){
    var hidden = this.player.hiddenItems;

    var currants = 0;
    var item_count = 0;

    for (var i in hidden){
        var stack = hidden[i];
        if (!stack.is_bag && !this.player.auctions.auctions_get_uid_for_item(stack.tsid)){
            this.player.mail.mail_add_auction_delivery(stack.tsid, config.auction_delivery_time, null, this.player.tsid, 'expired');
        }
    }
}

public function adminCountLostHiddenItems(){
    var hidden = this.player.hiddenItems;

    var currants = 0;
    var item_count = 0;

    for (var i in hidden){
        if (!hidden[i].is_bag && !this.player.auctions.auctions_get_uid_for_item(hidden[i].tsid)){
            currants += intval(Math.round(hidden[i].base_cost * hidden[i].count * 0.9));
            item_count++;
        }
    }

    return item_count+' items worth a calculated '+currants+' currants';
}

public function admin_fix_elixir_of_avarice(){
    if (this.player.achievements.achievements_has('numismatizer_leprechaun_class')) this.player.making.making_try_learn_recipe(241);
}

public function admin_create_new_home(){
    this.player.houses.houses_go_to_new_house(false, true, false);
}

public function admin_craftytasking_robot_category_items(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = {'ok': 1};

    status.data = CraftyTasking.craftytasking_category_items(crafty_bot, args.category);

    return status;
}

public function admin_craftytasking_robot_sequenceSteps(args){

    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = {'ok': 1};

    status.sequence = CraftyTasking.craftytasking_build_sequence(crafty_bot, CraftyTasking.craftytasking_get_static_build_spec(args.class_tsid), args.count);

    return status;
}

public function admin_craftytasking_robot_queueAdd(args){

    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    return crafty_bot.queueAdd(args.class_tsid, args.count);
}

public function admin_craftytasking_robot_queueRemove(args){

    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    return crafty_bot.queueRemove(args.class_tsid, args.count);
}

public function admin_craftytasking_robot_get_status(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = crafty_bot.getStatus();

    status['ok'] = 1;

    return status;
}

public function admin_craftytasking_robot_stop(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = crafty_bot.craftCancel();
    status['ok'] = 1;

    return status;
}

public function admin_craftytasking_robot_canRefuel(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = crafty_bot.canAutoRefuel();

    log.info('CAN REFUEL:'+status);

    return status;
}

public function admin_craftytasking_robot_refuel(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = crafty_bot.autoRefuel();

    return status;
}

public function admin_craftytasking_robot_queue(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var status = {'ok': 1};
    status.active_queue_index = null;
    if (crafty_bot.isCrafting()){
        status.active_queue_index = crafty_bot.getActiveQueueIndex();
    }
    status.queue = [];

    var queue_data = null;
    for (var i=0; i < crafty_bot.queueCount(); i++){
        queue_data = crafty_bot.queueIndexStatus(i);
        if (queue_data){
            status.queue.push({
                'class_tsid': queue_data.class_tsid,
                'complete': queue_data.complete,
                'craftable_count': queue_data.craftable_count,
                'queue_count': queue_data.queue_count,
                'completed_count': queue_data.completed_count,
                'ingredients': queue_data.ingredients,
                'missing_ingredients': queue_data.missing_ingredients,
                'tools': queue_data.tools,
                'missing_tools': queue_data.missing_tools
            });
        }
    }

    return status;
}

public function admin_craftytasking_robot_queueItem(args){
    var crafty_bot = null;
    if (this.player.crafty_bot && this.player.crafty_bot.tsid){
        crafty_bot = Server.instance.apiFindObject(this.player.crafty_bot.tsid);
    }

    if (!crafty_bot) return {'ok':0, 'error':-200, 'error_desc': 'This player does not have a Crafty-bot'};

    var queue = crafty_bot.queueGet();
    var queue_item = null;
    var queue_index = 0;

    //
    // Get the item queue (and set the queue index)
    //
    if (args.class_id){
        for (var i in queue){
            if (queue[i].class_tsid == args.class_id){
                queue_item = queue[i];
                queue_index = i;
                break;
            }
        }
    }else if (args.queue_index){
        queue_item = queue[intval(args.queue_index)];
        if (!queue_item) return {'ok':0, 'error':-201, 'error_desc': 'Invalid queue index'};
        queue_index = args.queue_index;
    }

    if (!queue_item) return {'ok':0, 'error':-201, 'error_desc': 'Queue item not found'};

    var scoped_queue_item = {};
    scoped_queue_item['ok'] = 1;
    scoped_queue_item.queue_index = intval(queue_index);
    scoped_queue_item.active_queue_index = null;
    scoped_queue_item.active_sequence_index = null;

    if (crafty_bot.isCrafting()){
        scoped_queue_item.active_queue_index = crafty_bot.getActiveQueueIndex();
    }
    if (crafty_bot.active_queue_index == queue_index){
        scoped_queue_item.active_sequence_index = crafty_bot.getActiveSequenceIndex();
    }

    scoped_queue_item.queue_is_active = scoped_queue_item.queue_index == scoped_queue_item.active_queue_index;
    scoped_queue_item.class_tsid = queue_item.class_tsid;
    scoped_queue_item.count = queue_item.count;
    for (var i in queue_item.craft_sequence){
        if (scoped_queue_item.queue_is_active && scoped_queue_item.active_sequence_index != undefined){
            if (!queue_item.craft_sequence[i].can_step){
                queue_item.craft_sequence[i].state = 'skipped';
            }else if (i < scoped_queue_item.active_sequence_index){
                queue_item.craft_sequence[i].state = 'complete';
            }else if (i == scoped_queue_item.active_sequence_index){
                queue_item.craft_sequence[i].state = 'active';
            }else{
                queue_item.craft_sequence[i].state = 'pending';
            }
        }else{
            queue_item.craft_sequence[i].state = 'pending';
        }
    }
    scoped_queue_item.craft_sequence = queue_item.craft_sequence;
    var craft_count = 0;
    if (queue_item.craft_sequence[queue_item.craft_sequence.length-1].data){
        craft_count = queue_item.craft_sequence[queue_item.craft_sequence.length-1].data.count;
    }
    scoped_queue_item.craft_count = craft_count;

    return scoped_queue_item;
}

public function admin_furniture_populate(){
    this.player.furniture.furniture_populate(false);
}

public function admin_photos_state(){
    var ret = {};
    ret.has_snapshotting = this.player.imagination.imagination_has_upgrade('snapshotting');
    return ret;
}

public function admin_grant_perftesting_rewards(args){
    this.player.stats.stats_add_currants(1000, {type: 'perftesting_reward'});

    if (args.test_count == 1){
        this.player.stats.stats_add_xp(500, 0, {type: 'perftesting_reward'});
    }
}

public function admin_recover_moving_boxes(){
    for (var i in this.player.houses.home_backup){
        var loc = this.player.houses.home_backup[i];
        if (loc){
            loc.admin_recover_moving_boxes();
        }
    }
}

public function admin_pack_more_moving_boxes(){
    if (this.player.houses.home_backup){
        if (this.player.houses.home_backup.interior){
            this.player.houses.home_backup.interior.pack_moving_boxes('interior');
        }

        if (this.player.houses.home_backup.exterior){
            this.player.houses.home_backup.exterior.pack_moving_boxes('exterior');
        }
    }

    if (this.player.houses_backup){
        for (var i in this.player.houses_backup){
            if (this.player.houses.houses_is_our_home(i)) continue;

            var pol = Server.instance.apiFindObject(i);
            if (pol){
                pol.pack_moving_boxes();
            }
        }
    }
}

public function admin_evacuate_houses(){
    if (this.player.location.pols_is_pol()){
        if (this.player.location.getProp('is_home')){
            this.player.houses.houses_leave();
        }
        else{
            this.player.teleportHome();
        }
    }
}

public function admin_fix_home_door(){
    if (this.player.houses.home && this.player.houses.home.exterior){
        return this.player.houses.home.exterior.admin_fix_home_door();
    }

    return {ok: 1};
}

public function admin_remove_deleted_houses(){
    for (var i in this.player.houses){
        var loc = Server.instance.apiFindObject(i);
        if (!loc) continue;

        if (loc.getProp('is_deleted')){
            if (this.player.houses.houses_is_our_home(i)){
                delete loc.is_deleted;
            }
            else{
                this.player.houses.houses_remove_property(i);
            }
        }
    }
}

public function admin_replace_home_sign_with_rock(){
    if (this.player.houses.home && this.player.houses.home.exterior){
        this.player.houses.home.exterior.homes_replace_sign_with_rock();
    }

    if (this.player.houses.home && this.player.houses.home.interior){
        this.player.houses.home.interior.homes_replace_sign_with_rock();
    }
}

public function adminGetJumpCount(args){
    return this.player.achievements.jump_count;
}

public function adminBackfillNewxpPhysics(args){
    if (this.player.use_img) return;

    this.player.physics.physics_new = {};
    this.player.physics.setDefaultPhysics();
    this.player.use_img = true;

    this.player.imagination.imagination_grant('walk_speed_1', 1, undefined, true, true);
    this.player.imagination.imagination_grant('walk_speed_2', 1, undefined, true, true);
    this.player.imagination.imagination_grant('walk_speed_3', 1, undefined, true, true);
    this.player.imagination.imagination_grant('jump_1', 1, undefined, true, true);
    this.player.imagination.imagination_grant('jump_2', 1, undefined, true, true);
    this.player.imagination.imagination_grant('jump_triple_1', 1, undefined, true, true);
}

public function adminResetPlayer(){
    this.player.resetForTesting(false);
}

public function adminBackfillSnapUpgrades(){

    // Grant new snap_pack upgrades, based on what they snapshot upgrades they already had
    if (this.player.imagination.imagination_has_upgrade('snapshottery_filter_piggy') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_beryl') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_firefly')){
        this.player.imagination.imagination_grant('snapshottery_filter_pack_1');
    }
    if (this.player.imagination.imagination_has_upgrade('snapshottery_filter_holga') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_vintage') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_ancient')){
        this.player.imagination.imagination_grant('snapshottery_filter_pack_2');
    }
    if (this.player.imagination.imagination_has_upgrade('snapshottery_filter_dither') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_shift') || this.player.imagination.imagination_has_upgrade('snapshottery_filter_outline')){
        this.player.imagination.imagination_grant('snapshottery_filter_pack_3');
    }
    if (this.player.imagination.imagination_has_upgrade('snapshottery_filter_memphis')){
        this.player.imagination.imagination_grant('snapshottery_basic_filter_pack');
    }

    // Delete the out of date upgrades
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_piggy');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_beryl');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_firefly');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_holga');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_vintage');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_ancient');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_dither');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_shift');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_outline');
    this.player.imagination.imagination_delete_upgrade('snapshottery_filter_memphis');

    // and remove any from their hand
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_piggy');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_beryl');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_firefly');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_holga');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_vintage');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_ancient');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_dither');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_shift');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_outline');
    this.player.imagination.imagination_remove_from_hand('snapshottery_filter_memphis');

    // Update the hand (if necessary)
    this.player.imagination.imagination_get_next_upgrades();

    // And reload the hand in the client
    this.player.apiSendMsg({
        type: 'imagination_hand',
        hand: this.player.imagination.imagination_get_login(),
        is_redeal: true
    });
}


//
// used by lib_friends/friends_get_list()
//

public function adminGetFriends(args){

    var out = {
        'fwd' : this.player.buddies.buddies_get_tsids(),
        'rev' : this.player.buddies.buddies_get_reverse_tsids()
    };

    if (args.fetch_online){
        out.online = Server.instance.apiCallMethodForOnlinePlayers('buddies_get_simple_online_info', out.fwd);
    }

    return out;
}

//
// used by achievement.php to check if you have the achievements shown on the page
//
public function adminAchievementsCheckHas(args){
    var out = {};

    for (var i in args.class_tsids){
        var class_tsid = args.class_tsids[i];
        out[class_tsid] = this.player.achievements.achievements_has(class_tsid);
    }

    return out;
}

public function adminAchievementsGetAll(args){
    return this.player.achievements.achievements_get_all();
}

public function adminAchievementsGetProfile(args){
    return this.player.achievements.achievements_get_profile();
}

public function adminQuestsGetStatus(args){
    return this.player.quests.getQuestStatus(args.quest_id);
}

public function adminRoleAdd(args){
    var role_name = 'is_'+args.role;
    this[role_name] = 1;
    return 1;
}

public function adminRoleRemove(args){
    var role_name = 'is_'+args.role;
    delete this[role_name];
    return 1;
}

public function adminBuffsApply(args){
    return this.player.buffs.buffs_apply(args.buff_id);
}

public function adminBuffsRemove(args){
    return this.player.buffs.buffs_remove(args.buff_id);
}

public function adminItemsGive(args){
    if (args.item_class == '_currants'){
        this.player.stats.stats_add_currants(args.count);
    } else {
        this.player.items.createItemFromFamiliar(args.item_class, args.count);
    }
}

public function adminItemsDestroy(args){
    return this.player.items.items_destroy(args.item_class, args.count);
}

public function adminQuestsOffer(args){
    return this.player.quests.quests_offer(args.quest_id, true);
}

public function adminQuestsRemove(args){
    return this.player.quests.quests_remove(args.quest_id);
}

public function adminQuestsMadeRecipe(args){
    return this.player.quests.quests_made_recipe(args.recipe_id, args.count);
}

public function adminQuestsIncCounter(args){
    return this.player.quests.quests_inc_counter(args.counter_name, args.count);
}

public function adminQuestsSetFlag(args){
    return this.player.quests.quests_set_flag(args.flag_name);
}

public function adminAchievementsIncrement(args){
    return this.player.achievements.achievements_increment(args.group, args.label, args.count);
}

public function adminAchievementsGrant(args){
    return this.player.achievements.achievements_grant(args.achievement_id);
}

public function adminAchievementsGrantMulti(args){
    for (var i in args.achievements){
        this.player.achievements.achievements_grant(args.achievements[i]);
    }
}

public function adminAchievementsDelete(args){
    return this.player.achievements.achievements_delete(args.achievement_id);
}

public function adminSkillsGive(args){
    return this.player.skills.skills_give(args.skill_id);
}

public function adminSkillsRemove(args){
    return this.player.skills.skills_remove(args.skill_id);
}

public function adminSkillsGetUnlearning(args){
    return this.player.skills.skills_get_unlearning();
}

public function adminSkillsCanUnlearn(args){
    return this.player.skills.skills_can_unlearn(args.skill_id);
}

public function adminMakingLearnRecipe(args){
    return this.player.making.making_learn_recipe(args.recipe_id);
}

public function adminMakingUnlearnRecipe(args){
    return this.player.making.making_unlearn_recipe(args.recipe_id);
}

public function adminImaginationGrantUpgrade(args){
    return this.player.imagination.imagination_grant(args.upgrade_id, args.amount);
}

public function adminImaginationDeleteUpgrade(args){
    return this.player.imagination.imagination_delete_upgrade(args.upgrade_id);
}

public function adminGrantFirstEleven(args){
    if (this.player.skills.skills_get_count() >= 11) this.player.achievements.achievements_grant('first_eleven_skills');
}

public function adminRebuildSocialSignpost(args){
    var exterior = this.player.houses.houses_get_external_street();
    if (exterior){
        exterior.updateNeighborSignpost();
    }
}

public function admin_quickstart_flags(){
    return {
        name    : !!this.player.quickstart_needs_player,
        avatar  : !!this.player.quickstart_needs_avatar,
        account : !!this.player.quickstart_needs_account
    };
}

public function admin_feats_increment(args){
    if (config.is_dev) log.info(this+' admin_feats_increment: '+args);
    return this.player.feats.feats_increment(args.class_tsid, args.amount);
}

public function admin_can_feat(args){
    return {
        quest: this.player.quests.getQuestStatus('last_pilgrimage_of_esquibeth') == 'done',
        conch: !!this.player.quests.has_blown_conch
    };
}

public function admin_set_flag(args){
    this[args.flag_name] = args.value;
}

public function admin_prompts_add_simple(args){
    this.player.prompts.prompts_add_simple(args.txt, intval(args.timeout));
}

    }
}
