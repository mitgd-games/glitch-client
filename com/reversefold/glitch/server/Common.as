package com.reversefold.glitch.server {
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Utils;
    
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Common {
        private static var log : Logger = Log.getLogger("server.Common");
		
		
		private var timers : Dictionary = new Dictionary();
		
		public function apiTimerExists(callback_name : String) : Boolean {
			return timers.hasOwnProperty(callback_name);
		}
		
		private function _apiSetTimer(name : String, ms : int, callback : Function) : void {
			var timer : Timer = new Timer(ms, 0);
			timers[name] = timer;
			timer.addEventListener(TimerEvent.TIMER, function(e : Event) : void {
				callback();
			});
			timer.start();
		}

		public function apiSetTimer(callback_name : String, ms : int, ... args) : void {
			var callback : Function;
			if (args.length == 0) {
				callback = this[callback_name];
			} else {
				callback = function() : void {
					this[callback_name].apply(this, args);
				};
			}
			_apiSetTimer(callback_name, ms, callback);
		}
		
		public function apiSetTimerX(callback_name : String, ms : int, ... args) {
			//RVRS: TODO: it looks like this can take the same args as apiSetTimer so how should apiSetTimerX differ?
			apiSetTimer.apply(this, [callback_name, ms] + args);
			/*
			_apiSetTimer(callback_name, ms, function() : void {
				this[callback_name](x);
			});
			*/
		}

		public function apiCancelTimer(callback_name : String) : Boolean {
			if (!timers.hasOwnProperty(callback_name)) {
				return false;
			}
			timers[callback_name].stop();
			delete timers[callback_name];
			return true;
		}
		
		public function apiDeleteTimers() : void {
			for (var callback_name : String in timers) {
				timers[callback_name].stop();
			}
			//delete timers?
			timers = new Dictionary();
		}

		//RVRS: TODO: How should these differ?
		public function apiSendMsgAsIs(msg) {
			Server.instance.sendMessage(msg);
		}
		public function apiSendMsg(msg) {
			Server.instance.sendMessage(msg);
		}
		
		public function apiAddHiddenStack(it) {
			//RVRS: TODO
			throw new Error('apiAddHiddenStack ' + it);
		}
		
		
		public function randInt(min : int, max : int) : int {
			return Math.floor(min + Math.random() * (1 + max - min));
		}
		

public static function getPlayer(tsid){
    if (!tsid) return null;

    var pc = Server.instance.apiFindObject(tsid);
    if (pc === null || pc === undefined) return null;

    if (pc.is_player) return pc;

    return null;
}

public static function time(){
    return intval(Math.round(new Date().getTime() / 1000));
}

public static function current_gametime(){
    var ts = time();
    return timestamp_to_gametime(ts);
}

public static function current_day_key(){
    return gametime_to_key(current_gametime());
}

public static function real_day_key(){
    var dt = new Date();
    var y = dt.getUTCFullYear();
    var m = dt.getUTCMonth();
    var d = dt.getUTCDate();

    y = Utils.pad(y, 4);
    m = Utils.pad(m, 2);
    d = Utils.pad(d, 2);

    return y+'-'+m+'-'+d;
}

public static function gametime_to_key(gt){
    return Utils.pad(gt[0], 2)+'-'+Utils.pad(gt[1], 2)+'-'+Utils.pad(gt[2], 2);
}

public static function current_game_month(){
    var gt = current_gametime();

    return Config.instance.base.game_month_names[gt[1]-1];
}

public static function timestamp_to_gametime(ts){

    //
    // how many real seconds have elapsed since game epoch?
    //

    var sec = ts - 1238562000;


    //
    // there are 4435200 real seconds in a game year
    // there are 14400 real seconds in a game day
    // there are 600 real seconds in a game hour
    // there are 10 real seconds in a game minute
    //

    var y = Math.floor(sec / 4435200);
    sec -= y * 4435200;

    var d = Math.floor(sec / 14400);
    sec -= d * 14400;

    var h = Math.floor(sec / 600);
    sec -= h * 600;

    var i = Math.floor(sec / 10);
    sec -= i * 10;


    //
    // turn the 0-based day number into a day & month
    //

    var md = calendar__day_to_md(d);

    d = md[1];
    var m = md[0];

    return [y,m,d,h,i];
}

public static function gametime_to_timestamp(gt){

    var d = calendar__md_to_day(intval(gt[1]), intval(gt[2]));

    var ts = 1238562000;

    ts += intval(gt[0]) * 4435200;
    ts += d * 14400;
    if (gt[3]) ts += gt[3] * 600;
    if (gt[4]) ts += gt[4] * 10;

    return ts;
}

public static function calendar__day_to_md(id){

    var cd = 0;

    for (var i=0; i<Config.instance.base.game_month_lengths.length; i++){
        cd += Config.instance.base.game_month_lengths[i];
        if (cd > id){
            var m = i+1;
            var d = id+1 - (cd - Config.instance.base.game_month_lengths[i]);
            return [m,d];
        }
    }

    return [0,0];
}

public static function calendar__md_to_day(m, d){

    var out = d-1;

    for (var i=0; i<m-1; i++){
        out += Config.instance.base.game_month_lengths[i];
    }

    return out;
}

public static function format_gametime(gt){
    var d = numberth(gt[2]);

    var dm = d+' of '+Config.instance.base.game_month_names[gt[1]-1];
    if (gt[1]==12) dm = Config.instance.base.game_month_names[gt[1]-1];

    var i = ""+gt[4];
    if (i.length == 1) i = "0"+i;

    var t = gt[3]+':'+i+' am';


    if (gt[3] == 0) t = '12:'+i+' am';
    if (gt[3] == 12) t = '12:'+i+' pm';
    if (gt[3] > 12) t = (gt[3]-12)+':'+i+' pm';
    if (gt[3] == 0 && gt[4] == 0) t = 'midnight';
    if (gt[3] == 12 && gt[4] == 0) t = 'noon';

    return t+', '+dm+', year '+gt[0];
}

public static function game_days_to_ms(days){
    return days * 14400 * 1000;
}

public static function game_mins_to_ms(mins){
    return mins * 10 * 1000;
}

public static function seconds_until_next_game_day() {
    var gt = current_gametime();
    return ((23-gt[3]) * 600) + ((59-gt[4])*10);
}

public static function is_same_day(gametime1, gametime2){
    if (gametime1[0] === gametime2[0] && gametime1[1] === gametime2[1] && gametime1[2] === gametime2[2]){
        return true;
    }

    return false;
}

// This returns a whole number of game days.
public static function game_days_since(gametime){
    var current_time = time();
    var ts = intval(Math.round(gametime_to_timestamp(gametime)));

    var diff = current_time - ts; // this is the number of seconds since the given time

    if (diff < 0) { return 0; } // time is in the future?

    // From above:
    // there are 14400 real seconds in a game day
    var gdays = intval(Math.round(diff / 14400));
    return gdays;
}

// This returns a whole number of game days.
public static function game_days_since_ts(timestamp) {
    var current_time = new Date().getTime();

    var diff = current_time - timestamp;

    if (diff < 0) { return 0; } // time is in the future?

    // From above:
    // there are 14400 real seconds in a game day
    var gdays = intval(Math.round(diff / game_days_to_ms(1)));
    return gdays;
}

// Converts a number of seconds to a string for display.
// Handles minutes but not hours
public static function secondsToString(secs) {
    if (secs >= 60) {
        var wholeMins = Math.floor(secs/60);
        var wholeSeconds = secs-(wholeMins*60);

        if (wholeMins == 1) {
            var minWord = "minute";
        }
        else {
            var minWord = "minutes";
        }

        if (wholeSeconds == 1) {
            var secWord = "second";
        }
        else {
            var secWord = "seconds";
        }

        if (wholeSeconds) {
            return (""+wholeMins+" "+minWord+" and "+wholeSeconds+" "+secWord);
        }
        else {
            return (""+wholeMins+" "+minWord);
        }
    }
    else {
        if (secs == 1) {
            var secWord = "second";
        }
        else {
            var secWord = "seconds";
        }

        return ""+secs+" "+secWord;
    }
}

// If it is the player's birthday, return their age. Otherwise, return false.
// Note: there are 308 glitch days in a glitch year
public static function isBirthday(pc) {
    var gt = timestamp_to_gametime(pc.ts/1000);
    var today = current_gametime();

    log.info("BIRTHDAY "+gt);
    log.info("BIRTHDAY "+today);

    if (gt[1] == today[1] // month
    &&  gt[2] == today[2] // day
       )
    {
        var years = today[0] - gt[0];
        return years;
    }

    return false;
}

//
// Zilloween items become functional on the 25th of Remember, and stay functional until the end of
// Zilloween day.
//
public static function isZilloween() {

    // Special for end of the world:
    return true;

    // Special for Halloween 2012 - start 6pm PST on the 30th, runs for 48 hours
    var now = time();
    var start = 1351645200;
    var end = 1351645200 + 60*60*48; // 48 hours
    if (now > start && now < end) {
        return true;
    }

    var month = current_game_month();
    if (month == 'Remember') {
        var gt = current_gametime();
        var day = gt[2];    // game day

        if (day >= 25){
            return true;
        }
    }

    return false;
}

public static function isGlitchmas() {

    // Special for end of the world:
    return true;

    // Currently enabled up until the 2012-01-03 10AM PST
    if (new Date().getTime()/1000 < 1325613600){
        return true;
    }

    // Special for testing:
    if (Config.is_dev){
        return false;
    }

    return false;
}

public static function isPiDay(){
    var date = new Date();

    // Months are zero indexed but days aren't for some reason.
    if ((date.getUTCMonth() +1) == 3){
        if  (date.getUTCDate() == 14){
            return true;
        }
        // Should be true as long as it is Pi day somewhere in the world. Date line is at +/- 12 from UTC
        // So we will check the dates on both sides:
        else if (date.getUTCDate() == 15 && date.getUTCHours() < 12){
            // Still Pi day in timezones 12 hours behind UTC
            return true;
        }
        else if (date.getUTCDate() == 13 && date.getUTCHours() >= 12){
            // Is Pi day already in timezones 12 hours ahead of UTC
            return true;
        }
    }

    //log.info("month is "+(date.getMonth()+1)+" and day is "+date.getDate());
    return false;
}

public static function numberth(number){
    var number_ten = number % 10;
    var numberth = number+'th';
    if (number < 10 || number > 20) {
        if (number_ten == 1) numberth = number+'st';
        if (number_ten == 2) numberth = number+'nd';
        if (number_ten == 3) numberth = number+'rd';
    }

    return numberth;
}

public static function numberth_word(number){

    return Config.instance.base.numbers_to_words[number];
}

public static function is_chance(prob){
    if (prob <= 0) return 0;
    if (prob == 1) return 1;
    if (prob > 1){
        log.error('is_chance called with probability greater than 1. Fix this!');
        //log.printStackTrace();
        prob /= 100;
    }
    if (Math.random() <= prob) return 1;
    return 0;
}

public static function choose_one(choices){
    return choices[randInt(0, choices.length-1)];
}

public static function choose_one_hash(choices){
    var keys = [];
    for (var i in choices){
        keys.push(i);
    }

    var choice = choose_one(keys);
    return choices[choice];
}

public static function first_property(obj) {
    for (var i in obj) {
        return obj[i];
    }
}

public static function choose_property(obj) {
    var k = 0;
    var n = randInt(0, num_keys(obj)-1);

    for(var i in obj) {
        if(k == n) {
            return obj[i];
        } else {
            k++;
        }
    }
}

public static function choose_key(obj) {
    var k = 0;
    var n = randInt(0, num_keys(obj)-1);

    for(var i in obj) {
        if(k == n) {
            return i;
        } else {
            k++;
        }
    }
}

public static function num_keys(a){
    var c = 0;
    for (var i in a) c++;
    return c;
}

public static function numValidKeys(a) {
    var c = 0;
    for (var i in a) {
        if (a[i]) {
            c ++;
        }
    }

    return c;
}

public static function is_array(a) : Boolean {
	return a is Array;
	/*
    if (/Array/.exec(toString.call(a))) {
        return true;
    }

    return false;
	*/
}

public static function array_keys(a){
    var out = [];
    for (var i in a) out.push(i);
    return out;
}

public static function array_values(a){
    var out = [];
    for (var i in a) out.push(a[i]);
    return out;
}

public static function array_remove(array, from, to){
    var rest = array.slice((to || from) + 1 || array.length);
    array.length = from < 0 ? array.length + from : from;
    return array.push.apply(array, rest);
}

public static function array_remove_value(array : Array, value){
	//RVRS: TODO: is this supposed to modify the passed in array?
	return array.filter(function(val) : Boolean { return val != value; });
	/*
    var idx = null;
    for (var i=0; i<array.length; i++){
        if (array[i] == value){
            idx = i;
            break;
        }
    }

    if (idx != null){
        return array_remove(array, idx);
    }
    else{
        return array;
    }
	*/
}

public static function make_rsp(req){
    return {
        msg_id: req.msg_id,
        type: req.type
    };
}

public static function make_ok_rsp(req){
    return {
        msg_id  : req.msg_id,
        type    : req.type,
        success : true
    };
}

public static function make_fail_rsp(req, code, msg){
    return {
        msg_id  : req.msg_id,
        type    : req.type,
        success : false,
        error   : {
            code    : code,
            msg     : msg
        }
    };
}

public static function make_item(item, pc){
    var ret = make_item_simple(item);
    if (Config.is_dev){
        ret.ctor_func = 'make_item';
    }
    ret.version = item.version;
    ret.path_tsid = item.path;
    if (item.state) ret.s = item.buildState(pc);
    if (typeof item.onStatus == 'function' && pc) ret.status = item.onStatus(pc); // Action indicators, replace with config?
    if (item.is_tool) ret.tool_state = item.get_tool_state(); // Replace with config
    if (item.is_consumable) ret.consumable_state = item.get_consumable_state(); // Used on firefly jars for recipes, replace with config
    if (item.getTooltipLabel) ret.tooltip_label = item.getTooltipLabel(); // Used in tools, not sure why this isn't just in getLabel()
    if (!item.isSelectable(pc)) ret.not_selectable = true; // Probably just a new message type to turn it on/off
    ret.soulbound_to = (item.isSoulbound() && item.soulbound_to) ? item.soulbound_to : null;
    if (item.getSubClass) ret.subclass_tsid = item.getSubClass();

    // Is this a bag?
    if (item.is_bag && !item.hasTag('not_openable')){
        ret.slots = item.capacity;

        if (item.is_trophycase){
            ret.itemstacks = make_bag(item);
        }

    }

    // Config?
    if (item.make_config){
        ret.config = item.make_config();
    }

    // Rooked status
    if (item.isRookable()){
        if (item.isRooked()){
            ret.rs = true;
        }
        else{
            ret.rs = false;
        }
    }

    return ret;
}

public static function make_item_simple(item){
    var ret = {
        class_tsid  : item.class_tsid,
        x       : item.x,
        y       : item.y,
        label   : item.getLabel ? item.getLabel() : item.label,
        count   : item.count
    };
    if (item.z !== undefined && item.z !== null) ret.z = item.z;
    if (Config.is_dev){
        ret.ctor_func = 'make_item_simple';
    }

    return ret;
}

public static function make_bag(bag, pc = null){
    var contents = bag.getContents();

    var itemstacks = {};
    for (var n in contents){
        var it = contents[n];
        if (it){
            itemstacks[it.tsid] = {
                class_tsid: it.class_id,
                label: it.getLabel ? it.getLabel() : it.label,
                count: it.count,
                slot: it.slot,
                version: it.version,
                path_tsid: it.path
            };

            if (it.z) itemstacks[it.tsid].z = it.z;
            if (it.state) itemstacks[it.tsid].s = it.buildState();
            if (it.is_tool) itemstacks[it.tsid].tool_state = it.get_tool_state();
            if (it.is_consumable) itemstacks[it.tsid].consumable_state = it.get_consumable_state();
            if (it.is_powder && parseInt(it.getClassProp('maxCharges')) > 0) itemstacks[it.tsid].powder_state = it.get_powder_state();
            if (it.getTooltipLabel) itemstacks[it.tsid].tooltip_label = it.getTooltipLabel();
            if (pc && !it.isSelectable(pc)) itemstacks[it.tsid].not_selectable = true; // Probably just a new message type to turn it on/off
            itemstacks[it.tsid].soulbound_to = (it.isSoulbound() && it.soulbound_to) ? it.soulbound_to : null;

            // Config?
            if (it.make_config) itemstacks[it.tsid].config = it.make_config();

            // Is this a bag?
            if (it.is_bag && !it.hasTag('not_openable')){
                itemstacks[it.tsid].slots = it.capacity;

                var sub = make_bag(it);
                for (var i in sub){
                    itemstacks[i] = sub[i];
                }
            }
        }
    }

    return itemstacks;
}

public static function make_location(location, pc){
    var out = {
        tsid        : location.tsid,
        pcs     : {},
        itemstacks  : {}
    };

    for (var i in location.activePlayers){
        var p = location.activePlayers[i];
        if (!p) continue;
        out.pcs[p.tsid] = p.make_hash_with_location();
    }

    for (var i in location.items){
        var item = location.items[i];
        if (!item || !item.isVisibleTo(pc)) continue;
        out.itemstacks[item.tsid] = make_item(item, pc);

    }

    return out;
}

public static function get_recipe(id){

    var prot = Server.instance.apiFindItemPrototype('catalog_recipes');
    if (prot.recipes[id] && prot.recipes[id].tool){
        var tool = Server.instance.apiFindItemPrototype(prot.recipes[id].tool);
        // Find the verb on this tool that makes recipe id 'id'
        for (var v in tool.verbs){
            // Is this a making verb?
            if (tool.verbs[v].making){
                for (var r2=0; r2<tool.verbs[v].making.recipes.length; r2++){
                    // Verb 'v' makes recipe id 'id'
                    if (tool.verbs[v].making.recipes[r2] == id){
                        prot.recipes[id].tool_verb = v;
                        break;
                    }
                }
            }

            if (prot.recipes[id].tool_verb) break;
        }
    }

    if (prot.recipes[id] && prot.recipes[id].inputs){
        // Find consumables
        for (var i=0; i<prot.recipes[id].inputs.length; i++){
            var input = Server.instance.apiFindItemPrototype(prot.recipes[id].inputs[i][0]);
            if (input && input.is_consumable){
                prot.recipes[id].inputs[i][2] = true;
            }
            else{
                prot.recipes[id].inputs[i][2] = false;
            }
        }
    }

    return prot.recipes[id];
}

public static function get_recipe_ids_for_skill(skill_id){

    var prot = Server.instance.apiFindItemPrototype('catalog_recipes');
    var recipe_ids = [];

    for (var i in prot.recipes){
        if (prot.recipes[i].skill == skill_id){
            recipe_ids.push(i);
        }
    }

    return recipe_ids;
}

public static function in_array(needle, haystack){
    for (var i in haystack){
        if (haystack[i] == needle) return 1;
    }
    return 0;
}

public static function in_array_real(needle, haystack){
    if (!haystack) return 0;

    for (var i=0; i<haystack.length; i++){
        if (haystack[i] == needle) return 1;
    }
    return 0;
}

public static function randInt(lo, hi){

    return lo + Math.floor(Math.random()*(1+hi-lo));
}

public static function make_fail_msg(type, code, msg){
    return {
        type    : type,
        success : false,
        error   : {
            code    : code,
            msg     : msg
        }
    };
}

public static function get_store(id){

    var prot = Server.instance.apiFindItemPrototype('catalog_stores');
    return Utils.copy_hash(prot.stores[id]);
}

public static function get_achievement(id){
    try{
        var prot = Server.instance.apiGetJSFileObject('achievements/'+id+'.js');
        return Utils.copy_hash(prot);
    }
    catch(e){
        log.error('Could not load non-existent achievement: '+id);
        return null;
    }
}

public static function intval(x){
    var y = parseInt(x, 10);
    if (isNaN(y)) return 0;
    if (!isFinite(y)) return 0;
    return y;
}

public static function floatval(x){
    var y = parseFloat(x);
    if (isNaN(y)) return 0;
    if (!isFinite(y)) return 0;
    return y;
}

public static function str(x, undef=null){
    if (x===null) return '';
    if (x===undef) return '';
    return ""+x;
}

public static function hasIntVal(x){
    if (x === undefined) return 0;
    if (x === null) return 0;
    if (x === '') return 0;
    return 1;
}

// based on a StackOverflow answer
public static function addCommas(num) {
    var strNum = ""+num;
    strNum = strNum.split("").reverse();

    var output = "";
    var length = strNum.length;
    for ( var i = 0; i < length; i++ ){
        output = strNum[i] + output;
        if ((i+1) % 3 == 0 && (length-1) !== i)output = ',' + output;
    }
    return output;
}

public static function pretty_list(list, joiner){

    if (list.length == 0) return '';
    if (list.length == 1) return list[0];

    var last = list.pop();
    return list.join(', ')+joiner+last;
}

public static function capitalize(str){
    return str.replace(/\w+/g, function(a){
        return a.charAt(0).toUpperCase() + a.substr(1).toLowerCase();
    });
}
/*
public static function getProp(p){
    return this[p];
}

public static function setProp(p, v){
    this[p] = v;
}

public static function setProps(props){
    for (var i in props){
        this[i] = props[i];
    }
}

public static function runCustom(code){
    return eval(code);
}
*/

public static function pluralize(count, singular, plural){
    if (count == 1){
        return '1 '+singular;
    }
    else{
        return count+' '+plural;
    }
}

public static function get_skill_package(id){

    var prot = Server.instance.apiFindItemPrototype('catalog_skill_packages');
    return Utils.copy_hash(prot.skill_packages[id]);
}

public static function api_error(msg){
    return {
        ok: 0,
        error: msg
    };
}

public static function api_ok(){
    return {
        ok: 1
    };
}

public static function overlay_key_to_url(key){
    return Config.instance.overlays.overlays_map[key];
}

public static function text_list_from_array(data_array){
    var text_list = '';
    for (var i = 0; i < data_array.length; i++){
        if (i > 0){
            if (i == data_array.length-1 ){
                text_list += ' and ';
            }else if (text_list != ''){
                text_list += ', ';
            }
        }
        text_list += data_array[i];
    }
    return text_list;
}

public static function get_item_names_from_classes(class_tsids, plural, include_article){
    var name_list = [];
    for (var i in class_tsids){
        name_list.push(get_item_name_from_class(class_tsids[i], plural, include_article));
    }
    return name_list;
}

public static function get_item_name_from_class(class_tsid, plural, include_article){
    try {
        var prot = Server.instance.apiFindItemPrototype(class_tsid);
        if (prot){
            var article = '';
            if (include_article){
                if (plural){
                    article = 'some ';
                }else{
                    article = prot.article+' ';
                }
            }

            if (plural){
                return article+prot.name_plural;
            }else{
                return article+prot.name_single;
            }
        }
    } catch(e) {
    }
    return '';
}

public static function round_to_5(value){
    return (value % 5) >= 2.5 ? int(value / 5) * 5 + 5 : int(value / 5) * 5;
}

public static function rootPlayer(pc){
    pc.announce_vp_overlay({
        type: "vp_overlay",
        dismissible: false,
        locking: true,
        click_to_advance: false,
        text: ['HI'],
        x: 200,
        y: -4000, // hide it!
        uid: 'newxp_locking_annc'
    });
}

public static function unrootPlayer(pc){
    pc.apiSendMsg({type: 'overlay_cancel', uid: 'newxp_locking_annc'});
}

// Get a new value for the sequence
public static function getSequence(key){
    var sequences = Server.instance.apiFindObject(Config.instance.sequence_object);
    if (!sequences) return null;

    return sequences.getSequence(key);
}

// Get the current value for the sequence without incrementing it
public static function getCurrentSequence(key){
    var sequences = Server.instance.apiFindObject(Config.instance.sequence_object);
    if (!sequences) return 0;

    return sequences.getCurrentSequence(key);
}


public static function linkifyPlayer(pc, possessive){
    if (!possessive) {
        var txt = "<a href=\"event:player_info|"+pc.tsid+"\">"+Utils.escape(pc.label)+"</a>";
    }
    else {
        var txt = "<a href=\"event:player_info|"+pc.tsid+"\">"+Utils.escape(pc.label+"'s")+"</a>";
    }

return txt;
}

	}
}
