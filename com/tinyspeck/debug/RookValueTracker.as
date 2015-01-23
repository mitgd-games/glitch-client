package com.tinyspeck.debug {
	import com.tinyspeck.core.beacon.StageBeacon;

	public class RookValueTracker extends ValueTracker {
		
		/* singleton boilerplate */
		public static var _instance:RookValueTracker = null;
        public static function get instance() : RookValueTracker {
            if (_instance == null) {
                _instance = new RookValueTracker();
            }
            return _instance;
        }
		
		public function RookValueTracker(){
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			
			CONFIG::debugging {
				trackSelfFunc = Console.trackRookValue;
			}
			
			CONFIG::god {
				StageBeacon.setInterval(updateLogIfDirty, 100);
			}
		} 
	}
}