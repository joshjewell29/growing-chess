package {

	public class LevelInfo {
		
		public var x:uint = NaN;
		public var y:uint = NaN;
		public var piece:Piece = null;
		
		public function LevelInfo( x:uint, y:uint, piece:Piece ):void {
			this.x = x;
			this.y = y;
			this.piece = piece;
		}
	}
}
