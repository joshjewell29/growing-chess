package {

	public class Level {

		public var tilesX:uint = NaN;
		public var tilesY:uint = NaN;
		public var levelInfo:Array = new Array();
		public var centerX:uint = NaN;
		public var centerY:uint = NaN;
		public var playerCenterX:uint = NaN;
		public var playerCenterY:uint = NaN;
		public var midY:uint = NaN;
		public var newPiece:uint = Piece.INVALID;

		public function Level( tilesX:uint, tilesY:uint ):void {
			this.tilesX = tilesX;
			this.tilesY = tilesY;
		}
	}
}
