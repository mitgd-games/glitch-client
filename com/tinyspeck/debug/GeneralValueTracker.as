package com.tinyspeck.debug
{
	import com.tinyspeck.core.beacon.StageBeacon;

	public class GeneralValueTracker extends ValueTracker
	{
		/* singleton boilerplate */
		public static var _instance:GeneralValueTracker = null;
        public static function get instance() : GeneralValueTracker {
            if (_instance == null) {
                _instance = new GeneralValueTracker();
            }
            return _instance;
        }
		
		public function GeneralValueTracker(){
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			
			CONFIG::debugging {
				trackSelfFunc = Console.trackValue;
			}
			
			CONFIG::god {
				StageBeacon.setInterval(updateLogIfDirty, 100);
			}
		}
	}
}