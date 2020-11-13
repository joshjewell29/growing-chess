package {
	
	public class GameData {
		
		public static const EASY:uint = 0;
		public static const MED:uint = 1;
		public static const HARD:uint = 2;
		public static const MOVES_TO_LOG:uint = 10;
		public static const ATTACKS_TO_LOG:uint = 10;
		
		public static var CurrentPlayer:uint = Constants.PLAYER;
		public static var SelectedPiece:Piece = null;
		public static var SelectedTile:Tile = null;
		public static var CurrentLevel:Level = null;
		public static var GlbMoveLogic:MoveLogic = new MoveLogic();
		public static var GlbLevels:Levels = new Levels( GlbMoveLogic );
		public static var LastGhostedTile:Tile = null;
		public static var Document:GrowingChess = null;
		public static var GlbGameOverScreen:GameOverScreen;
		public static var UserId:String;
		public static var AttacksLogged:uint = 0;
		public static var MovesLogged:uint = 0;
		
		private static var _Difficulty:uint = EASY;
		
		//Data To Persist
		public static var MaxLevelUnlocked:uint = 0;
		public static var MaxLevelUnlockedMedium:uint = 0;
		public static var MaxLevelUnlockedHard:uint = 0;
		public static var MediumUnlocked:Boolean = true;
		public static var HardUnlocked:Boolean = true;
		public static var SawMoveHelp:Boolean = false;
		public static var SawSelectHelp:Boolean = false;
		public static var SeenPieces:Array = new Array();
		public static var SeenLevelGrown:Array = new Array();
		public static var SeenTakeFlagHint:Boolean = false;
		
		public static function SetDiff( diff:uint ):void {
			trace( "SetDiff " + diff );
			_Difficulty = diff;
		}
		
		public static function GetDiff():uint {
			return _Difficulty;
		}
	}
}
