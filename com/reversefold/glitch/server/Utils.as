package com.reversefold.glitch.server {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.data.Pols;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Utils {
        private static var log : Logger = Log.getLogger("server.player.achievements");

// Tiny Speck would like to offer a shoutout to Kevin van Zonneveld
// (http://kevin.vanzonneveld.net). We're using his number_format() function.
// Kevin, there weren't any licensing terms on this, so please let us know
// (feedback@slack.com) if you'd like us to remove it.
//
//#include common.js
//#include utils/craftytasking.js
//#include utils/json.js
//stuff will go here!

public static function http_get(url, args){

    // jdev/jstaging have callbacks disabled by unsetting these config vars
    if (!Config.instance.web_api_url) return;

    var args2 = [];
    for (var i in args){
        args2.push(encodeURIComponent(i)+'='+encodeURIComponent(args[i]));
    }
    var qs = args2.join('&');

    var full = Config.instance.web_api_url + url + '?' + qs;

    if (Config.instance.is_dev) log.info('HTTP: '+full);
    //log.info('HTTP: '+full);
    Server.instance.apiAsyncHttpCall(full, {});
}

public static function http_get_world(url, args){

    // jdev/jstaging have callbacks disabled by unsetting these config vars
    if (!Config.instance.world_api_url) return;

    var args2 = [];
    for (var i in args){
        args2.push(encodeURIComponent(i)+'='+encodeURIComponent(args[i]));
    }
    var qs = args2.join('&');

    Server.instance.apiAsyncHttpCall(Config.instance.world_api_url + url + '?' + qs, {});
}

// obj_tsid is optional, but should be the tsid of the calling object. Used for callback ordering.
public static function http_post(url, args, obj_tsid){

    // jdev/jstaging have callbacks disabled by unsetting these config vars
    if (!Config.instance.web_api_url) return;

    var full = Config.instance.web_api_url + url;

    if (Config.instance.is_dev) log.info('HTTP-POST: '+full);
    Server.instance.apiAsyncHttpCall(full, {}, args, obj_tsid);
}

// Escape all xml characters
public static function escape(txt){
    txt = "" + txt;
    txt = txt.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
    return txt;
}

public static function filter_chat(txt){

    //
    // we currently allow the following pieces of html to appear in chat:
    //
    // <i></i>
    // <b></b>
    //
    // this is *really* annoying, since we need to balance them and filter out everything else.
    //

    // first step is to escape all xml characters
    txt = "" + txt;
    txt = txt.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");

    // now we can un-escape sequences we like
    txt = txt.replace(/&lt;b&gt;/,'<b>').replace(/&lt;\/b&gt;/,'</b>');
    txt = txt.replace(/&lt;i&gt;/,'<i>').replace(/&lt;\/i&gt;/,'</i>');

    // break up the string by tag
    var pieces = [];
    while (txt.length){
        // do we have a tag coming up?
        var i = txt.indexOf('<');
        if (i >= 0){
            // find the end
            var j = txt.indexOf('>');

            pieces.push(txt.substr(0, i));
            pieces.push(txt.substr(i, 1+j-i));
            txt = txt.substr(j+1);
        }else{
            pieces.push(txt);
            txt = '';
        }
    }

    // balance tags
    var states = {};
    var out = '';
    for (var i=0; i<pieces.length; i++){
        if (pieces[i].substr(0,1) == '<'){

            if (pieces[i] == '<b>' && !states.b){
                out += pieces[i];
                states.b = 1;
            }
            if (pieces[i] == '</b>' && states.b){
                out += pieces[i];
                states.b = 0;
            }

            if (pieces[i] == '<i>' && !states.i){
                out += pieces[i];
                states.i = 1;
            }
            if (pieces[i] == '</i>' && states.i){
                out += pieces[i];
                states.i = 0;
            }

        }else{
            out += pieces[i];
        }
    }
    if (states.b) out += '</b>';
    if (states.i) out += '</i>';

    return out;
}

public static function test_filter(){

    var map = [
        ['hello', 'hello'],
        ['hi <b>there</b>', 'hi <b>there</b>'],
        ['hi <<b>>there</b>', 'hi &lt;<b>&gt;there</b>'],
        ['<foo>', '&lt;foo&gt;'],
        ['hi <b>there', 'hi <b>there</b>'],
        ['<i>' ,'<i></i>'],
        ['</i>' ,''],
        ['</i><i>' ,'<i></i>'],
    ];

    for (var i=0; i<map.length; i++){
        var txt_in = map[i][0];
        var txt_out = map[i][1];

        var txt_got = filter_chat(txt_in);

        if (txt_got == txt_out){
            log.info("PASS "+txt_in+" -> "+txt_out);
        }else{
            log.info("FAIL "+txt_in+" -> "+txt_out+" (got "+txt_got+")");
        }
    }
}

public static function trim(str){
    str = ""+str;
    return str.replace(/^\s+|\s+$/g, "");
}
/*
public static function for_all_players(f){

    var out = {};

    for (var i=0; i<Config.instance.all_players.length; i++){
        try {
            var p = Server.instance.apiFindObject(Config.instance.all_players[i]);
            var ret = f(p);
            if (ret) out[k] = ret;
        }catch (e){}
    }

    return out;
}

public static function for_all_locations(f){
    var out = {};
    for (var i in Config.instance.maps.data_maps.streets){
        for (var j in Config.instance.maps.data_maps.streets[i]){
            for (var k in Config.instance.maps.data_maps.streets[i][j]){
                try {
                    var l = Server.instance.apiFindObject(k);
                    var ret = l.run_on_location(f);
                    if (ret) out[k] = ret;
                } catch(e) {}
            }
        }
    }
    return out;
}

public static function for_all_ground_items(f){

    var out = {};
    for (var i in Config.instance.maps.data_maps.streets){
        for (var j in Config.instance.maps.data_maps.streets[i]){
            for (var k in Config.instance.maps.data_maps.streets[i][j]){
                try {
                    var l = Server.instance.apiFindObject(k);
                    var temp = l.run_on_items(f);

                    for (var ii in temp){

                        if (temp[ii]) out[ii] = temp[ii];
                    }
                } catch(e) {}
            }
        }
    }
    return out;
}
*/

public static var roman_map = {
    'M' : 1000,
    'CM'    : 900,
    'D' : 500,
    'CD'    : 400,
    'C' : 100,
    'XC'    : 90,
    'L' : 50,
    'XL'    : 40,
    'X' : 10,
    'IX'    : 9,
    'V' : 5,
    'IV'    : 4,
    'I' : 1
};

public static function to_roman_numerals(num){
    var n = parseInt(num, 10); // intval is not available
    var res = '';

    for (var roman in roman_map){
        var number = roman_map[roman];
		//RVRS: TODO: Why do we parseInt again?
        var matches = parseInt(new Number(n / number).toString(10), 10); // intval is not available
        for (var i=0; i<matches; i++){
            res += roman;
        }
        n = n % number;
    }

    return res;
}

public static function ago(ts){

    if (!ts){
        return 'a long time ago';
    }

    var s = Common.time() - ts;

    if (s > 60 * 60 * 36){
        var d = int(Math.round(s/(60*60*24)));
        return d+" days ago";
    }


    if (s > 60 * 90){
        var h = int(Math.round(s/(60*60)));
        return h+" hr ago";
    }

    if (s > 90){
        var m = int(Math.round(s/60));
        return m+" min ago";
    }

    if (s < 2){
        return "just now";
    }

    return s+" sec ago";
}

public static function copy_hash(hash){
    return Server.instance.apiCopyHash(hash);
}

public static function copy_value(v){
    if (typeof v == 'object'){
        return copy_hash(v);
    }
    return v;
}

public static function copy_gs_object(src){

    var out = {};
    var keys = src.apiGetDynamicKeys();

    for (var i=0; i<keys.length; i++){
        out[keys[i]] = copy_value(src[keys[i]]);
    }

    return out;
}

public static function replace_gs_object(obj, new_dyn){

    var old_keys = obj.apiGetDynamicKeys();
    for (var i=0; i<old_keys.length; i++){
        delete obj[old_keys[i]];
    }

    for (var k in new_dyn){
        obj[k] = copy_value(new_dyn[k]);
    }
}

public static function substitute(str, vars){

    var var_keys = array_keys(vars);

    var out = '';
    var rx = /\$([a-z0-9_]+)/ig;
    var m;

    while (m = rx.exec(str)){
        var var_name = m[1];

        var pre = str.substr(0, rx.lastIndex - (1 + var_name.length));
        str = str.substr(rx.lastIndex);
        out += pre;

        if (in_array(var_name, var_keys)){
            out += vars[var_name];
        }else{
            out += "{$"+var_name+"}";
        }

        rx.lastIndex = 0;
    }

    out += str;
    return out;
}


public static function in_array(needle, haystack){
    for (var i in haystack){
        if (haystack[i] == needle) return 1;
    }
    return 0;
}

public static function array_keys(a){
    var out = [];
    for (var i in a) out.push(i);
    return out;
}

public static function shuffle(o){
	//RVRS: TODO: Why do we parseInt again?
    for(var j, x, i = o.length; i; j = parseInt(new Number(Math.random() * i).toString(10), 10), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}

public static function sortObj(object, sortFunc){
    var rv = [];
    for (var k in object){
        if (object[k]) rv.push({key: k, value:  object[k]});
    }

    rv.sort(function(o1, o2){
        return sortFunc(o1.key, o2.key);
    });

    return rv;
}

public static function pad(number, length) {
    var str = '' + number;
    while (str.length < length) {
        str = '0' + str;
    }

    return str;
}

public static function get_pol_config(door_uid){
    for (var i in Pols.pol_types){
        if (door_uid == Pols.pol_types[i].uid) return Pols.pol_types[i];
    }
    return {};
}

public static function has_key(key, a){
    for (var i in a){
        if (i == key) return true;
    }
    return false;
}

public static function regexp_escape(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
}

public static function irc_inject(channel, msg){
    var args = {
        channel: channel,
        msg: msg
    };
    http_get('callbacks/irc_inject.php', args);
}

public static function strip_html(txt){
    var matchTag = /<(?:.|\s)*?>/g;
    return txt.replace(matchTag, "");
}

public static function number_format(number, decimals, dec_point, thousands_sep){
    // http://kevin.vanzonneveld.net
    // +   original by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +     bugfix by: Michael White (http://getsprink.com)
    // +     bugfix by: Benjamin Lupton
    // +     bugfix by: Allan Jensen (http://www.winternet.no)
    // +    revised by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +     bugfix by: Howard Yeend
    // +    revised by: Luke Smith (http://lucassmith.name)
    // +     bugfix by: Diogo Resende
    // +     bugfix by: Rival
    // +      input by: Kheang Hok Chin (http://www.distantia.ca/)
    // +   improved by: davook
    // +   improved by: Brett Zamir (http://brett-zamir.me)
    // +      input by: Jay Klehr
    // +   improved by: Brett Zamir (http://brett-zamir.me)
    // +      input by: Amir Habibi (http://www.residence-mixte.com/)
    // +     bugfix by: Brett Zamir (http://brett-zamir.me)
    // +   improved by: Theriault
    // +      input by: Amirouche
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // *     example 1: number_format(1234.56);
    // *     returns 1: '1,235'
    // *     example 2: number_format(1234.56, 2, ',', ' ');
    // *     returns 2: '1 234,56'
    // *     example 3: number_format(1234.5678, 2, '.', '');
    // *     returns 3: '1234.57'
    // *     example 4: number_format(67, 2, ',', '.');
    // *     returns 4: '67,00'
    // *     example 5: number_format(1000);
    // *     returns 5: '1,000'
    // *     example 6: number_format(67.311, 2);
    // *     returns 6: '67.31'
    // *     example 7: number_format(1000.55, 1);
    // *     returns 7: '1,000.6'
    // *     example 8: number_format(67000, 5, ',', '.');
    // *     returns 8: '67.000,00000'
    // *     example 9: number_format(0.9, 0);
    // *     returns 9: '1'
    // *    example 10: number_format('1.20', 2);
    // *    returns 10: '1.20'
    // *    example 11: number_format('1.20', 4);
    // *    returns 11: '1.2000'
    // *    example 12: number_format('1.2000', 3);
    // *    returns 12: '1.200'
    // *    example 13: number_format('1 000,50', 2, '.', ' ');
    // *    returns 13: '100 050.00'
    // Strip all characters but numerical ones.
    number = (number + '').replace(/[^0-9+\-Ee.]/g, '');
    var n = !isFinite(+number) ? 0 : +number,
        prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
        sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
        dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
        s = '',
        toFixedFix = function (n, prec) {
            var k = Math.pow(10, prec);
            return '' + Math.round(n * k) / k;
        };
    // Fix for IE parseFloat(0.55).toFixed(0) = 0;
    s = (prec ? toFixedFix(n, prec) : '' + Math.round(n));
	s = s.split('.');
    if (s[0].length > 3){
        s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
    }

	var s1 = s[1] ? s[1] : '';
    if (s1.length < prec){
        s[1] = s[1] || '';
        s[1] += new Array(prec - s[1].length + 1).join('0');
    }

    return s.join(dec);
}

    }
}
