package com.reversefold.glitch.server {
	public class Prop {
		private var _value : int;
		private var _lo : int;
		private var _hi : int;
		
		public function Prop(value, lo, hi) : void {
			_value = value;
			_lo = lo;
			_hi = hi;
		}
		
		public function get value() : int {
			return _value;
		}
		
		public function get lo() : int {
			return _lo;
		}
		
		public function get hi() : int {
			return _hi;
		}
		
		public function apiSet(value : int) : void {
			_value = value;
		}
		
		public function apiInc(value : int) : int {
			_value += value;
			return _value;
		}
	}
}
