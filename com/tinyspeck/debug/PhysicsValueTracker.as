package com.tinyspeck.debug {
	import com.tinyspeck.core.beacon.StageBeacon;

	public class PhysicsValueTracker extends ValueTracker {
		
		/* singleton boilerplate */
		public static var _instance:PhysicsValueTracker = null;
        public static function get instance() : PhysicsValueTracker {
            if (_instance == null) {
                _instance = new PhysicsValueTracker();
            }
            return _instance;
        }
		
		public function PhysicsValueTracker(){
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			
			CONFIG::debugging {
				trackSelfFunc = Console.trackPhysicsValue;
			}
			
			CONFIG::god {
				StageBeacon.setInterval(updateLogIfDirty, 100);
			}
		}
	}
}