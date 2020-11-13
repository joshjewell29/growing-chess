package {
	public class MoveInfo {
		
		public var tileFrom:Tile;
		public var pieceFrom:Piece;
		public var tileTo:Tile;
		public var value:Number = 0;
		public var reasons:Array = new Array();
		
		public function MoveInfo( tileFrom:Tile, pieceFrom:Piece, tileTo:Tile ):void {
			this.tileFrom = tileFrom;
			this.pieceFrom = pieceFrom;
			this.tileTo = tileTo;
		}
		
		public function toString():String {
			var retString:String = "";
			retString =  "move: from{" + tileFrom.getX() + "," + tileFrom.getY() + "}" + 
				" to{" + tileTo.getX() + "," + tileTo.getY() + "} value{" + value + "} reasons{";

			for each( var reason:String in reasons ) {
				retString += reason + ",";
			}
			
			retString += "}";
			return retString; 
		}
	}
}
