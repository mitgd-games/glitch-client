package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Requests extends Common {
        private static var log : Logger = Log.getLogger("server.player.requests");

        public var config : Config;
        public var player : Player;

        public function Requests(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function sendActionRequest(type, tsid, from, txt, need, got, timeout){
    this.player.sendMsgOnline({
        type: "action_request",
        txt: txt,
        pc: from.make_hash(),
        got: intval(got),
        need: intval(need),
        event_type: type,
        event_tsid: tsid,
        timeout_secs: timeout,
        has_accepted: this.hasActionRequestReply(from),
        uid: from.tsid+'_'+type+'_'+tsid
    });
}

public function broadcastActionRequest(type, tsid, txt, need=false, got=false){

    var timeout = 0;
    if (type == 'trade') timeout = 5*60; // 5 minute timeout for trades

    // Store some flags on the location
    if (!this.player.location.action_requests) this.player.location.action_requests = {};
    if (this.player.location.action_requests[this.player.tsid]){
        this.cancelActionRequestBroadcast(this.player.location.action_requests[this.player.tsid].type, this.player.location.action_requests[this.player.tsid].tsid);
    }

    this.player.location.action_requests[this.player.tsid] = {
        type: type,
        tsid: tsid,
        txt: txt,
        got: got,
        need: need,
        timeout: timeout,
        offered: time()
    };

    this.player.location.apiSendMsgX({
        type: "action_request",
        txt: txt,
        pc: this.player.make_hash(),
        got: intval(got),
        need: intval(need),
        event_type: type,
        event_tsid: tsid,
        timeout_secs: timeout,
        uid: this.player.tsid+'_'+type+'_'+tsid
    }, this);

    this.player.apiSendMsg({
        type: "action_request",
        txt: txt,
        pc: this.player.make_hash(),
        got: intval(got),
        need: intval(need),
        event_type: type,
        event_tsid: tsid,
        timeout_secs: timeout,
        uid: this.player.tsid+'_'+type+'_'+tsid
    });

    return true;
}

public function actionRequestReply(from, msg){
    log.info(this+" Action request reply from "+from+" "+msg);

    var g;
    if (msg.event_type == 'quest_accept'){
        var q = this.player.quests.getQuestInstance(msg.event_tsid);
        if (!q){
            g = config.shared_instances[msg.event_tsid];
            if (!g){
                log.error(this+' actionRequestReply unknown quest id: '+msg.event_tsid);
                return false;
            }
        }

        if (q && (q.isFull() || !q.isStarted())){
            from.prompts_add({
                txt     : 'Sorry, you were not quite fast enough to join '+this.player.linkifyLabel()+' on the '+q.getTitle(this)+' quest.',
                timeout     : 10,
                choices     : [
                    { value : 'ok', label : 'Dagnabit!' }
                ]
            });
        }
        else if (q){
            q.addOpponent(from);
            from.addActionRequestReply(this);
        }

        return true;
    }

    if (g || msg.event_type == 'game_accept'){
        if (this.player.games.games_invite_is_full()){
            from.prompts_add({
                txt     : 'Sorry, you were not quite fast enough to join '+this.player.linkifyLabel()+'.',
                timeout     : 10,
                choices     : [
                    { value : 'ok', label : 'Dagnabit!' }
                ]
            });
        }
        else{
            this.player.games.games_add_opponent(from);
            from.addActionRequestReply(this);
        }

        return true;
    } else if (msg.event_type == 'trade'){
        this.updateActionRequest('was looking for someone to trade with. '+from.linkifyLabel()+' accepted.', 1);
        this.cancelActionRequestBroadcast('trade', this.player.tsid);
        var ret = from.trading_request_start(this.player.tsid);
        if (ret.ok){
            from.apiSendMsgAsIs({
                type: 'trade_start',
                tsid: this.player.tsid
            });
        }

        return true;
    }
    else{
        log.error(this+' actionRequestReply unknown event type: '+msg.event_type);
    }

    return false;
}

public function actionRequestCancel(msg){
    if (msg.event_type == 'quest_accept'){
        var q = this.player.quests.getQuestInstance(msg.event_tsid);

        if (q){
            if (!q.isFull()){
                // Remove prompts
                this.player.prompts.prompts_remove(this['!invite_uid_'+this.player.tsid]);
                for (var i in q.opponents){
                    var opp = getPlayer(i);
                    if (opp){
                        opp.prompts_remove(opp['!invite_uid_'+this.player.tsid]);
                        opp.removeActionRequestReply(this);
                    }
                }

                this.updateActionRequest('was looking for a challenger on the quest <b>'+q.getTitle(this)+'</b>.', 0);
                this.cancelActionRequestBroadcast('quest_accept', q.class_tsid);
                this.player.quests.failQuest(q.class_tsid);
                this.player.events.events_remove(function(details){ return details.callback == 'quests_multiplayer_invite_timeout'; });
            }
        }
        return true;
    } else if (msg.event_type == 'game_accept') {
        if (!this.player.games.games_invite_is_full()){
            var g = config.shared_instances[msg.event_tsid];
            if (!g){
                log.error(this+' actionRequestCancel unknown game id: '+msg.event_tsid);
                return false;
            }

            // Remove prompts
            this.player.prompts.prompts_remove(this['!invite_uid_'+this.player.tsid]);
            for (var i in this.games_invite.opponents){
                var opp = getPlayer(i);
                if (opp){
                    opp.prompts_remove(opp['!invite_uid_'+this.player.tsid]);
                    opp.removeActionRequestReply(this);
                }
            }

            this.updateActionRequest('was looking for a challenger on <b>'+g.name+'</b>.', 0);
            this.cancelActionRequestBroadcast('game_accept', msg.event_tsid);
            this.player.events.events_remove(function(details){ return details.callback == 'games_invite_timeout'; });

            if (this.games_invite && this.games_invite.ticket_on_cancel){
                this.player.items.createItemFromFamiliar(this.games_invite.ticket_on_cancel, 1);
            }

            delete this.games_invite;
        }
        return true;
    } else if (msg.event_type == 'trade'){
        this.updateActionRequest('was looking for someone to trade with.', 0);
        this.cancelActionRequestBroadcast('trade', this.player.tsid);

        return true;
    } else{
        log.error(this+' actionRequestCancel unknown event type: '+msg.event_type);
    }

    return false;
}

public function cancelActionRequestBroadcast(type, tsid){
    if (!this.player.location.action_requests) this.player.location.action_requests = {};
    var details = this.player.location.action_requests[this.player.tsid];
    if (!details) return;
    if (details.type != type) return;

    this.player.location.apiSendMsg({
        type: "action_request_cancel",
        player_tsid: this.player.tsid,
        event_type: details.type,
        event_tsid: details.tsid,
        uid: this.player.tsid+'_'+details.type+'_'+details.tsid
    });

    delete this.player.location.action_requests[this.player.tsid];
}

public function cancelActionRequest(from, type, tsid){
    if (!this.player.location.action_requests) this.player.location.action_requests = {};
    var details = this.player.location.action_requests[from.tsid];
    if (!details) return;
    if (details.type != type) return;

    this.player.apiSendMsg({
        type: "action_request_cancel",
        player_tsid: from.tsid,
        event_type: details.type,
        event_tsid: details.tsid,
        uid: from.tsid+'_'+details.type+'_'+details.tsid
    });
}

public function updateActionRequest(txt, got){
    if (!this.player.location.action_requests) this.player.location.action_requests = {};
    var details = this.player.location.action_requests[this.player.tsid];
    if (!details) return;

    this.player.location.apiSendMsg({
        type: "action_request_update",
        player_tsid: this.player.tsid,
        event_type: details.type,
        event_tsid: details.tsid,
        txt: txt ? txt : '',
        got: intval(got),
        need: intval(details.need),
        uid: this.player.tsid+'_'+details.type+'_'+details.tsid
    });

    this.player.location.action_requests[this.player.tsid].got = got;
    if (txt) this.player.location.action_requests[this.player.tsid].txt = txt;
}

public function addActionRequestReply(from){
    if (!this.action_request_replies) this.action_request_replies = {};

    this.action_request_replies[from.tsid] = this.player.location.action_requests[from.tsid];
    if (this.action_request_replies[from.tsid]){
        this.action_request_replies[from.tsid].location = this.player.location.tsid;
    }
}

public function hasActionRequestReply(from){
    if (!this.action_request_replies) return false;
    return this.action_request_replies[from.tsid] ? true : false;
}

public function cancelActionRequestReplies(){
    // this is complicated!
    for (var i in this.action_request_replies){
        var deets = this.action_request_replies[i];
        if (!deets) continue;

        log.info(this+' is canceling: '+deets);

        var from = getPlayer(i);
        if (deets.type == 'quest_accept'){
            var q = from.getQuestInstance(deets.tsid);

            if (q && !q.isFull()){
                q.removeOpponent(this);
            }
        }
        else if (deets.type == 'game_accept'){
            from.games_remove_opponent(this);
        }

        // Not necessary
        //this.cancelActionRequest(from, deets.type, deets.tsid);
    }

    delete this.action_request_replies;
}

public function removeActionRequestReply(from){
    if (!this.action_request_replies) return;

    delete this.action_request_replies[from.tsid];

    if (!num_keys(this.action_request_replies)) delete this.action_request_replies;
}

    }
}
