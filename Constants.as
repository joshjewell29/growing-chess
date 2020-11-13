package {
	
	public class Constants {
		public static const RED:uint = 0xFF0000;
		public static const BLACK:uint = 0x000000;
		public static const CANVAS_X:Number = 400;
		public static const CANVAS_Y:Number = 400;
		public static const LEVEL_COUNT:uint = 16;
		
		private static var uniqueCounter:uint = 1;
		static public const AI_PLAYER:uint = uniqueCounter++;
		static public const PLAYER:uint = uniqueCounter++;
	}
	
}
