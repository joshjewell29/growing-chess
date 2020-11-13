package {
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.MovieClip;

	public class NormInv {
		
		public static const NegativeInfinity:Number = -1.47328473298473294872349837238;
		public static const PositiveInfinity:Number = 48329048324098340938240932843284;
		
		public static var rangeLow:Number = 0;
		public static var rangeHigh:Number = 31;
		
		public static var outputOut:TextField = new TextField();
		public static var outputOut2:TextField = new TextField();
		public static var iterationsVal:TextField = new TextField();
		public static var itsVal:TextField = new TextField();
		public static var rangeMinVal:TextField = new TextField();
		public static var rangeMaxVal:TextField = new TextField();
		public static var eqInput:TextField = new TextField();
		
		private static var _value:Number = 0;
		
		public function NormInv():void {
		}
		
		public static function SetupGui( document:GrowingChess ):void {
			var mc:MovieClip = new MovieClip();
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill( 0xFF0000 );
			spr.graphics.drawRect(0, 0, 600, 400);
			mc.addChild( spr );
			
			const HEIGHT:Number = 20;
			
			var equation:TextField = new TextField();
			equation.text = "Equation: ";
			equation.height = HEIGHT;
			equation.mouseEnabled = false;
			equation.scaleY = 2;
			mc.addChild( equation );
			
			eqInput.type = TextFieldType.INPUT;
			eqInput.x = 100;
			eqInput.y = 10;
			eqInput.width = 400;
			eqInput.height = HEIGHT;
			eqInput.text = "+12 * x^5 - 975 * x^4+28000 * x ^ 3 - 345000 * x ^ 2 + 1800000 * x^1";
			eqInput.background = true;
			eqInput.backgroundColor = 0xFFFFFF;
			//eqInput.scaleY = 2;
			mc.addChild( eqInput );
			
			const row2:Number = 50;
			const row3:Number = 100;
			const row4:Number = 150;
			const row5:Number = 150;
			const row6:Number = 200;
			const row7:Number = 250;
			const row8:Number = 300;
			const row9:Number = 350;
			
			var rangeMin:TextField = new TextField();
			rangeMin.y = row2;
			rangeMin.height = HEIGHT;
			rangeMin.text = "Range Min:";
			mc.addChild( rangeMin );
			
			rangeMinVal.y = row2;
			rangeMinVal.x = 100;
			rangeMinVal.height = HEIGHT;
			rangeMinVal.type = TextFieldType.INPUT;
			rangeMinVal.background = true;
			rangeMinVal.backgroundColor = 0xFFFFFF;
			rangeMinVal.text = "0";
			mc.addChild( rangeMinVal );
			
			var rangeMax:TextField = new TextField();
			rangeMax.y = row2;
			rangeMax.x = 250;
			rangeMax.height = HEIGHT;
			rangeMax.text = "Range Max:";
			mc.addChild( rangeMax );
			
			rangeMaxVal.y = row2;
			rangeMaxVal.x = 100 + rangeMax.x;
			rangeMaxVal.height = HEIGHT;
			rangeMaxVal.type = TextFieldType.INPUT;
			rangeMaxVal.background = true;
			rangeMaxVal.backgroundColor = 0xFFFFFF;
			rangeMaxVal.text = "31";
			mc.addChild( rangeMaxVal );
			
			var iterations:TextField = new TextField();
			iterations.y = row3;
			iterations.text = "Iterations:";
			mc.addChild( iterations );
			
			iterationsVal.y = row3;
			iterationsVal.x = 100 + iterations.x;
			iterationsVal.height = HEIGHT;
			iterationsVal.type = TextFieldType.INPUT;
			iterationsVal.background = true;
			iterationsVal.backgroundColor = 0xFFFFFF;
			iterationsVal.text = "10";
			mc.addChild( iterationsVal );
			
			var its:TextField = new TextField();
			its.y = row4;
			its.text = "Initial Trial Solution";
			mc.addChild( its );
			
			itsVal.y = row4;
			itsVal.x = 100 + its.x;
			itsVal.height = HEIGHT;
			itsVal.type = TextFieldType.INPUT;
			itsVal.background = true;
			itsVal.backgroundColor = 0xFFFFFF;
			itsVal.text = "15.5";
			mc.addChild( itsVal );
			
			var btnRun:Sprite = new GameResources.BtnRun();
			btnRun.y = row6;
			btnRun.addEventListener( MouseEvent.CLICK, _OnRun );
			mc.addChild( btnRun );
			
			var output:TextField = new TextField();
			output.y = row8;
			output.text = "Output";
			mc.addChild( output );
			
			outputOut.y = row8;
			outputOut.x = 100 + output.x;
			outputOut.height = HEIGHT;
			outputOut.background = true;
			outputOut.backgroundColor = 0xFFFFFF;
			outputOut.text = "";
			outputOut.width = 400;
			mc.addChild( outputOut );
			
			outputOut2.y = row9;
			outputOut2.x = 100 + output.x;
			outputOut2.height = HEIGHT;
			outputOut2.background = true;
			outputOut2.backgroundColor = 0xFFFFFF;
			outputOut2.text = "";
			outputOut2.width = 400;
			mc.addChild( outputOut2 );
			
			document.addChild( mc );
		}
		
		private static function _OnRun( me:MouseEvent ):void {
			_value = 0;
			RunCode();
		}
		
		//12 * x^5 - 975 * x^4+28000 * x ^ 3 - 345000 * x ^ 2 + 1800000 * x
		private static function _SolveEq( x:Number, eq:String ):Number {
			trace( "_SolveEq " + eq );
			var lastPlus:int = eq.lastIndexOf( "+" );
			var lastMinus:int = eq.lastIndexOf( "-" );
			
			if( lastPlus == -1 && lastMinus == -1 ) {
				trace( "no signs " + eq );
				return 0;
			}
			
			var greaterSign:int = Math.max( lastPlus, lastMinus );
			var body:String = eq.substr( 0, greaterSign );
			var tail:String = eq.substr( greaterSign );
			
			return _SolveTail( x, tail ) + _SolveEq( x, body );
			
//			trace( "body " + body );
//			trace( "tail " + tail );
//			
//			
//			trace( "eqInput " + eqInput );
//			var splitPlus:Array = eqInput.text.split( "+" );
//			for each( var s:String in splitPlus ) {
//				trace( "s " + s );
//			}
			return _RunEquation( x );
		}
		
		private static function _SolveTail( x:Number, eq:String ):Number {
			trace( "_SolveTail " + eq );
			
			var sign:String = eq.substr( 0, 1 );
			trace( "sign " + sign );
			
			var multiplier:Number = 1;
			if( sign == "-" )
				multiplier = -1;
				
			var afterSignRemoval:String = eq.substr( 1 );
			trace( "afterSignRemoval " + afterSignRemoval );
			
			var multIndex:int = afterSignRemoval.indexOf( "*" );
			var number:String = afterSignRemoval.substr( 0, multIndex );
			trace( "number " + number );
			var numberVal:Number = new Number( number );
			
			var carrotIndex:int = afterSignRemoval.indexOf( "^" );
			var power:String = afterSignRemoval.substr( carrotIndex+1 );
			trace( "power " + power );
			var powerVal:int = new Number( power );
			trace( "powerVal " + powerVal );
				
			return multiplier * numberVal * Math.pow(x, powerVal );
		}
		
		private static function _SolveBody( eq:String ):Number {
			return 0;			
		}
		
		public static function RunCode():void {
			var x:Number = 0;
			//eq 5x^2 - 50x
			
			rangeLow = new Number( rangeMinVal.text );
			trace( "rangeLow " + rangeLow );
			rangeHigh = new Number( rangeMaxVal.text );
			trace( "rangeHigh " + rangeHigh );
			
			if( rangeLow >= rangeHigh ) {
				rangeLow = rangeHigh - 30;
				rangeMinVal.text = rangeLow.toString();
				trace( "rangeLow " + rangeLow );
			}
			
			var initTrialSln:Number = new Number( itsVal.text );
			trace( "initTrialSln " + initTrialSln );
			
			var iterCount:int = new Number( iterationsVal.text );
			if( iterCount > 10000 ) {
				iterCount = 10000;
				iterationsVal.text = "10000";
			}
			trace( "iterCount " + iterCount );
			
			var selOfNeighbor:Number = ( rangeHigh - rangeLow ) / 6;
			
			x = initTrialSln;
			var t1:Number = 0.2 * _SolveEq( x, eqInput.text );
			var t2:Number = t1 / 2;
			var t3:Number = t2 / 2;
			var t4:Number = t3 / 2;
			var t5:Number = t4 / 2;
			
			var acceptedT1:Array = _FillAcceptedList( iterCount, initTrialSln, acceptedT1, t1, selOfNeighbor );
			var acceptedT2:Array = _FillAcceptedList( iterCount, initTrialSln, acceptedT2, t2, selOfNeighbor);
			var acceptedT3:Array = _FillAcceptedList( iterCount, initTrialSln, acceptedT3, t3, selOfNeighbor);
			var acceptedT4:Array = _FillAcceptedList( iterCount, initTrialSln, acceptedT4, t4, selOfNeighbor);
			var acceptedT5:Array = _FillAcceptedList( iterCount, initTrialSln, acceptedT5, t5, selOfNeighbor);

			var maxValue:NormInvValue = new NormInvValue();
			maxValue = _SetMax( maxValue, acceptedT1 );
			maxValue = _SetMax( maxValue, acceptedT2 );
			maxValue = _SetMax( maxValue, acceptedT3 );
			maxValue = _SetMax( maxValue, acceptedT4 );
			maxValue = _SetMax( maxValue, acceptedT5 );

//			trace( "x " + maxValue.x );
//			trace( "eqValue " + maxValue.eqValue );
			
			outputOut.text = "Max Value x = " + maxValue.x;
			outputOut2.text = "Eq Value With x = " + maxValue.eqValue;
		}
		
		private static function _SetMax( val:NormInvValue, a:Array ):NormInvValue {
			for each ( var normInvValue:NormInvValue in a ) {
				if ( normInvValue.eqValue > val.eqValue ) {
					
					val.x = normInvValue.x;
					val.eqValue = normInvValue.eqValue;
				}
			}
			
			return val;
		}
		
		private static function _FillAcceptedList( 
			iterCount:int, initTrialSln:Number, acceptedListToUse:Array, t:Number, selOfNeighbor:Number ):Array {
				
			acceptedListToUse = new Array();
			
			while( acceptedListToUse.length < iterCount ) {
				
				var val:NormInvValue = new NormInvValue();
				
				var a:Number = initTrialSln;
				var b:Number = initTrialSln + DoNormInv( Math.random(), 0, selOfNeighbor );
				var outOfRange:Boolean = ( b < rangeLow || b > rangeHigh );
				if( outOfRange ) {
					continue;
				}
				
				var eqWithA:Number = _SolveEq( a, eqInput.text );
				var eqWithB:Number = _SolveEq( b, eqInput.text );
			
				if( eqWithB < eqWithA ) {
										
					var probOfAcceptance:Number = Math.exp( eqWithB - eqWithA / t );
					if( probOfAcceptance < Math.random() ) {
						
						val.x = b;
						val.eqValue = eqWithB;
						
						acceptedListToUse.push( val );
					}
				}
				else {
					val.x = b;
					val.eqValue = eqWithB;

					acceptedListToUse.push( val );
				}
			}
			
			return acceptedListToUse;
		}
		
		private static function _RunEquation( x:Number ):Number {			
			return ( 12 * Math.pow(x, 5) - 975 * Math.pow(x, 4) + 28000 * Math.pow(x, 3) - 345000 * Math.pow(x, 2) + 1800000 * x );
		}
		
		public static function DoNormInv( p:Number, mu:Number, sigma:Number ):Number
        {
            if (p < 0 || p > 1)
            {
                throw new Error("The probality p must be bigger than 0 and smaller than 1");
            }
            if (sigma < 0)
            {
                throw new Error("The standard deviation sigma must be positive");
            }

            if (p == 0)
            {
                return NegativeInfinity;
            }
            if (p == 1)
            {
                return PositiveInfinity;
            }
            if (sigma == 0)
            {
                return mu;
            }

			var q:Number;
			var r:Number;
			var val:Number;

            q = p - 0.5;

            /*-- use AS 241 --- */
            /* double ppnd16_(double *p, long *ifault)*/
            /*      ALGORITHM AS241  APPL. STATIST. (1988) VOL. 37, NO. 3

                    Produces the normal deviate Z corresponding to a given lower
                    tail area of P; Z is accurate to about 1 part in 10**16.
            */
            if (Math.abs(q) <= .425)
            {/* 0.075 <= p <= 0.925 */
                r = .180625 - q * q;
                val =
                       q * (((((((r * 2509.0809287301226727 +
                                  33430.575583588128105) * r + 67265.770927008700853) * r +
                                45921.953931549871457) * r + 13731.693765509461125) * r +
                              1971.5909503065514427) * r + 133.14166789178437745) * r +
                            3.387132872796366608)
                       / (((((((r * 5226.495278852854561 +
                                28729.085735721942674) * r + 39307.89580009271061) * r +
                              21213.794301586595867) * r + 5394.1960214247511077) * r +
                            687.1870074920579083) * r + 42.313330701600911252) * r + 1);
            }
            else
            { /* closer than 0.075 from {0,1} boundary */

                /* r = min(p, 1-p) < 0.075 */
                if (q > 0)
                    r = 1 - p;
                else
                    r = p;

                r = Math.sqrt(-Math.log(r));
                /* r = sqrt(-log(r))  <==>  min(p, 1-p) = exp( - r^2 ) */

                if (r <= 5)
                { /* <==> min(p,1-p) >= exp(-25) ~= 1.3888e-11 */
                    r += -1.6;
                    val = (((((((r * 7.7454501427834140764e-4 +
                               .0227238449892691845833) * r + .24178072517745061177) *
                             r + 1.27045825245236838258) * r +
                            3.64784832476320460504) * r + 5.7694972214606914055) *
                          r + 4.6303378461565452959) * r +
                         1.42343711074968357734)
                        / (((((((r *
                                 1.05075007164441684324e-9 + 5.475938084995344946e-4) *
                                r + .0151986665636164571966) * r +
                               .14810397642748007459) * r + .68976733498510000455) *
                             r + 1.6763848301838038494) * r +
                            2.05319162663775882187) * r + 1);
                }
                else
                { /* very close to  0 or 1 */
                    r += -5;
                    val = (((((((r * 2.01033439929228813265e-7 +
                               2.71155556874348757815e-5) * r +
                              .0012426609473880784386) * r + .026532189526576123093) *
                            r + .29656057182850489123) * r +
                           1.7848265399172913358) * r + 5.4637849111641143699) *
                         r + 6.6579046435011037772)
                        / (((((((r *
                                 2.04426310338993978564e-15 + 1.4215117583164458887e-7) *
                                r + 1.8463183175100546818e-5) * r +
                               7.868691311456132591e-4) * r + .0148753612908506148525)
                             * r + .13692988092273580531) * r +
                            .59983220655588793769) * r + 1);
                }

                if (q < 0.0)
                {
                    val = -val;
                }
            }

            return mu + sigma * val;
        }
    }
}
