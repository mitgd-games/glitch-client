package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Prompts {
        private static var log : Logger = Log.getLogger("server.player.achievements");

        public var config : Config;
        public var player : Player;

        public function Prompts(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


// http://svn.tinyspeck.com/wiki/Sticky_Prompts
public function prompts_init(){
    if (!this.prompts) this.prompts = {};
}

public function prompts_delete(){
    delete this.prompts;
}

public function prompts_reset(){
    this.prompts_delete();
    this.prompts_init();
}

public function prompts_get_login(){
    this.prompts_expire();

    var out = [];
    for (var i in this.prompts){
        // REMOVEME: processing for people harrassed by the mail system
        if(this.prompts[i].callback == "answer_mail_prompt") {
            delete this.prompts[i];
        } else {
            out.push(this.prompts_get_msg(this.prompts[i]));
        }
    }
    return out;
}

//////////////////////////////////////////////////////////////////////////


//
// For the times when all you want are some text and an OK button
//

public function prompts_add_simple(txt, timeout){
    var details = {
        txt             : txt,
        icon_buttons    : false,
        choices         : [
            { value : 'ok', label : 'OK' }
        ]
    };

    if (timeout){
        details.timeout = timeout;
    }

    return this.prompts_add(details);
}


//
// The workhorse function
//

public function prompts_add(details){
    if (!details.txt) return false;
    if (this.prompts_over_limit()) return false;

    // If we were called from events.js, cleanup first
    if (details.prompt_callback){
        details.callback = details.prompt_callback;
        delete details.prompt_callback;
    }

    details.uid = this.prompts_get_uid();
    if (details.timeout && !details.timeout_value){
        details.expires = time() + details.timeout;
    }

    this.prompts[details.uid] = details;

    var msg = this.prompts_get_msg(details);
    msg.type = 'prompt';

    this.player.sendMsgOnline(msg);

    return details.uid;
}

public function prompts_over_limit(){
    if (num_keys(this.prompts) >= 100) return true;
    return false;
}

public function prompts_add_delayed(details, seconds){
    // Copy the prompt callback, if any
    if (details.callback) details.prompt_callback = details.callback;
    details.callback = 'prompts_add';

    this.player.events.events_add(details, seconds);
}

public function prompts_has(uid){
    return this.prompts[uid] ? true : false;
}

public function prompts_remove(uid){
    if (!this.prompts_has(uid)) return false;

    delete this.prompts[uid];

    this.player.sendMsgOnline({
        type: 'prompt_remove',
        uid: uid
    });

    return true;
}

//////////////////////////////////////////////////////////////////////////

public function prompts_get_uid(){

    var uid = time();
    while (this.prompts && this.prompts[str(uid)]){
        uid++;
    }
    return str(uid);
}

public function prompts_get_msg(details){

    var out = {
        uid     : details.uid,
        txt     : details.txt,
        icon_buttons    : details.icon_buttons ? true : false,
        choices     : details.choices,
        timeout     : intval(details.timeout),
        is_modal    : details.is_modal ? true : false,
        escape_value    : details.escape_value
    };

    if (details.dialog_item_class) out.item_class = details.dialog_item_class;
    if (details.title) out.title = details.title;
    if (details.timeout_value) out.timeout_value = details.timeout_value;
    if (details.sound) out.sound = details.sound;
    if (details.max_w) out.max_w = details.max_w;

    return out;
}

public function prompts_choice(uid, value){

    if (this.tsid == 'PLI12CTGL42H9') log.info(this+' prompts_choice: '+uid+' - '+value);

    // Greeter alerts are broadcast out and don't have records on the player objects
    if (uid.substring(0,13) == 'greeter_alert'){
        if (value != 'no'){

            var dst = Server.instance.apiFindObject(value);
            if (!dst){
                log.error(this+' could not find greeting location for '+value);
                return true;
            }

            if (!dst.getProp('greeting_summons_canceled')){
                log.info(this+' taking to greeting location '+dst+' on choice '+value);
                dst.cancelGreeterSummons();

                var pc = dst.getNonGreeters()[0];
                if (!pc){
                    log.info(this+' greeter target player gone missing');
                    return this.player.sendActivity("Wait, where'd they go?");
                }

                this.player.groups.groups_chat(config.greeter_group, "I got "+pc.label+"!");
                utils.irc_inject('#greeters', this.label+': I got '+pc.label+'!');

                this.greeting_previous_location = {tsid: this.location.tsid, x: this.x, y: this.y};

                var instance_id = dst.getProp('instance_id');
                if (instance_id){
                    this.player.instances.instances_add(instance_id, dst.getProp('instance'));
                    return this.player.instances.instances_enter(instance_id, pc.x-150, pc.y);
                }
                else{
                    return this.player.teleportToLocationDelayed(value, pc.x-150, pc.y);
                }
            }
            else{
                return this.player.sendActivity("Oops, someone else beat you to it.");
            }
        }

        return true;
    }

    // Look up the deets for this prompt
    var details = this.prompts[uid];

    if (details){

        if (details.callback && this[details.callback]){
            this[details.callback].call(this, value, details);
        }
        delete this.prompts[uid];
    }else{
        log.error("prompt_choice for unknown choice uid", uid);
    }
}

public function prompts_expire(){

    for (var i in this.prompts){
        var p = this.prompts[i];

        if (!p.txt || (p.expires && p.expires < time())){

            delete this.prompts[i];
        }
    }
}



public function prompts_test(){
    var uid = this.prompts_add({
        txt     : 'This is a test prompt',
        icon_buttons    : false,
        timeout_value   : 'timeout',
        timeout     : 10,
        choices     : [
            { value : 'a', label : 'Choice A' },
            { value : 'b', label : 'Choice B' }
        ],
        callback    : 'prompts_test_callback'
    });

    this.player.sendActivity('The prompt uid is: '+uid);
}

public function prompts_test_callback(value, details){

    this.player.sendActivity('You chose option '+value);
}

public function prompts_itemstack_location_callback(value, details){
    if (details.itemstack_tsid){
        var items = this.location.getItems();
        if (items[details.itemstack_tsid]){
            var it = items[details.itemstack_tsid];
            if (it.modal_callback){
                it.modal_callback(this, value, details);
            }
            else{
                log.error(this+' prompts_itemstack_location_callback for an item without a handler: '+details);
            }
        }
        else{
            log.error(this+' prompts_itemstack_location_callback did not get a VALID itemstack tsid: '+details);
        }
    }
    else{
        log.error(this+' prompts_itemstack_location_callback did not get an itemstack tsid: '+details);
    }
}

public function prompts_itemstack_modal_callback(value, details){
    if (details.itemstack_tsid){
        var items = this.getAllContents();
        if (items[details.itemstack_tsid]){
            var it = items[details.itemstack_tsid];
            if (it.modal_callback){
                it.modal_callback(this, value, details);
            }
            else{
                log.error(this+' prompts_itemstack_modal_callback for an item without a handler: '+details);
            }
        }
        else{
            log.error(this+' prompts_itemstack_modal_callback did not get a VALID itemstack tsid: '+details);
        }
    }
    else{
        log.error(this+' prompts_itemstack_modal_callback did not get an itemstack tsid: '+details);
    }
}

public function prompts_buff_callback(value, details){
    //log.info(this+' prompts_buff_callback: '+details);
    if (details.buff_class_tsid){
        this.player.buffs.buffs_apply(details.buff_class_tsid, details.buff_args);
    }
}

    }
}
