package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class DailyHistory {
        private static var log : Logger = Log.getLogger("server.Player");

        public var config : Config;
        public var player : Player;
		
		public var label : String;
		public var days;
		public var utime : int;

        public function DailyHistory(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function daily_history_init(){
    if (this.days === undefined || this.days === null){
        //this.daily_history = Server.instance.apiNewOwnedDC(this);
        this.label = 'Daily History';
        this.days = {};
    }
}

public function daily_history_reset(){
    if (this.days){
        //delete this.days;
        //this.daily_history.apiDelete();
        //delete this.daily_history;

        this.days = {};
    }

    this.daily_history_init();
}

public function daily_history_get_day(day_key){
    this.daily_history_init();
    if (!this.days[day_key]) return null;

    return this.days[day_key];
}

public function daily_history_get(day_key, label){
    this.daily_history_init();
    if (!this.days[day_key]) return null;
    if (!this.days[day_key][label]) return null;

    return this.days[day_key][label];
}

public function daily_history_increment(label, value){
    this.daily_history_init();
    var today = Common.current_day_key();
    if (!this.days[today]) this.days[today] = {};

    if (!this.days[today][label]) this.days[today][label] = 0;

    this.days[today][label] += value;
}

public function daily_history_push(label, value){
    this.daily_history_init();
    var today = Common.current_day_key();
    if (!this.days[today]) this.days[today] = {};

    if (!this.days[today][label]) this.days[today][label] = [];

    this.days[today][label].push(value);
    this.utime = Common.time();
}

public function daily_history_flag(label){
    this.daily_history_init();
    var today = Common.current_day_key();
    if (!this.days[today]) this.days[today] = {};

    this.days[today][label] = true;
}

public function daily_history_archive(day_key){
    this.daily_history_init();

    if (!this.days[day_key]) return;

    var args = {
        player_tsid: this.player.tsid,
        day_key: day_key,
        data: Utils.JSON_stringify(this.days[day_key])
    };

    Utils.http_post('callbacks/daily_history_archive.php', args, this.player.tsid);
}

public function daily_history_archive_all(){
    this.daily_history_init();

    for (var day_key in this.days){
        this.daily_history_archive(day_key);
    }
}

    }
}
