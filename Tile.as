package {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Tile extends Sprite {
		
		private const _REG_COLOR:uint = 0x000000;
		
		private var _x:uint;
		private var _y:uint;
		private var _visualCenterX:Number = 0;
		private var _visualCenterY:Number = 0;
		private var _circleRad:Number = 0;
		private var _piece:Piece = null;
		private var _ghostPiece:Piece = null;
		private var _canvas:MovieClip = null;
		
		public function Tile( x:uint, y:uint ):void {
			_x = x;
			_y =  y;
		}
		
		public function getCanvas():MovieClip {
			return _canvas;
		}
		
		public function getSize():Number {
			return _circleRad * 2;
		}
		
		public function getX():uint {
			return _x;
		}
		
		public function getY():uint {
			return _y;
		}
		
		public function ghostPiece( p:Piece ):void {
			_ghostPiece = p;
			_ghostPiece.ghostToTile( this );
		}
		
		public function removeGhostPiece():void {
			_ghostPiece.removeGhost( this );
		}
		
		public function addPeice( p:Piece ):void {
			if( _piece != null )
				throw Error( "This GameTile already has a piece." );
				
			_piece = p;
			_piece.addToTile( this );
		}
		
		public function removePiece():void {
			if( _piece == null )
				throw Error( "This GameTile does not have a piece." );
				
			_piece.removeFromTile();
			_piece = null;
		}
		
		public function getPiece():Piece {
			return _piece;
		}
		
		public function getCenterX():Number {
			return _visualCenterX;
		}
		
		public function getCenterY():Number {
			return _visualCenterY;
		}
		
		public function drawSelection():void {
			this.graphics.clear();
			_drawNormalTile();
			this.graphics.beginFill( 0x00FF00, 1.0 );
			this.graphics.drawCircle( _visualCenterX, _visualCenterY, _circleRad );
		}
		
		public function drawAttack():void {
			this.graphics.clear();
			_drawNormalTile();
			this.graphics.beginFill( 0xFF0000, 1.0 );
			this.graphics.drawCircle( _visualCenterX, _visualCenterY, _circleRad );
		}
		
		public function drawDanger():void {
			this.graphics.clear();
			_drawNormalTile();
			this.graphics.beginFill( 0xCCCC00, 1.0 );
			this.graphics.drawCircle( _visualCenterX, _visualCenterY, _circleRad );
		}
		
		public function clearSelection():void {
			_drawNormalTile();
		}
		
		public function getVisualX():Number {
			return _visualCenterX - _circleRad;
		}
		
		public function getVisualY():Number {
			return _visualCenterY - _circleRad;
		}
		
		private function _drawNormalTile():void {			
			var color:uint = _REG_COLOR;
			if( (_x + _y) % 2 == 0 ) {
				color = 0xAAAAAA;
			}
			
			this.graphics.clear();
			this.graphics.beginFill( color, 0.2 );
			this.graphics.drawRect( getVisualX(), getVisualY(), getSize(), getSize());
		}
		
		public function drawTile( x:Number, y:Number, circleRad:Number, canvas:MovieClip ):void {
			_canvas = canvas;
			
			_visualCenterX = x;
			_visualCenterY = y;
			_circleRad = circleRad;
			
			canvas.addChild( this );
			_drawNormalTile();
		}
		
		public function clear( canvas:Sprite ):void {
			_canvas.removeChild( canvas );
		}
		
		public override function toString():String {
			return "tile = {" + _x + "," + _y + "} center = {" + _visualCenterX + "," + _visualCenterY + "}" + " piece = {" + _piece + "}";
		}
	}
}
