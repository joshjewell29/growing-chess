package {
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Utility {
		
		public static function GetRandomIndex( a:Array ):int {
			if( a.length == 0 )
				throw new Error( "There are no elements in the array!" );
				
			var size:int = a.length;
			var index:int = (int)( Math.random() * (size - 1) );
			return index;
		}
		
		public static function LogAction( action:String ):void {
			return;
			var rnd:Number = Math.random() * 200;
			
			var url:URLRequest = new URLRequest(
			"http://www.rivalgames.org/highScore/sendMessage.php?userId=" + GameData.UserId + "&action=" + action + "&fluff=" + rnd );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load( url );
		}
	}
}
