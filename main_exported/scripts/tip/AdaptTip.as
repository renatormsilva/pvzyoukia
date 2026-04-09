package tip
{
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import manager.LangManager;
   import zmyth.ui.TextFilter;
   
   public class AdaptTip extends Tips
   {
      
      private var timer:Timer;
      
      private var _text:TextField;
      
      private var _endY:Number;
      
      private var _startY:Number;
      
      public function AdaptTip(param1:Number, param2:Number)
      {
         super();
         this.graphics.beginFill(0,0.7);
         this.graphics.drawRoundRect(0,0,param1,param2,20,20);
         this.graphics.endFill();
         this._text = new TextField();
         TextFilter.MiaoBian(this._text,0);
      }
      
      public function creatInfoText(param1:String, param2:String, param3:String, param4:int, param5:String = "") : void
      {
         var _loc6_:XML = <xml>
									<info1></info1>
									<info2></info2>
									<info3></info3>
									<info4></info4>
									<info5></info5>
									<info6></info6>
							 </xml>;
         var _loc7_:StyleSheet = new StyleSheet();
         if(param4 == 2)
         {
            _loc7_.setStyle("info1",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"3px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info2",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"1px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info3",{
               "fontSize":"12px",
               "color":"#00ccff",
               "leading":"1px",
               "textAlign":"center"
            });
         }
         else if(param4 == 1 || param4 == 4)
         {
            _loc7_.setStyle("info1",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"3px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info2",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"1px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info3",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"1px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info4",{
               "fontSize":"12px",
               "color":"#ff0000",
               "leading":"1px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info5",{
               "fontSize":"12px",
               "color":"#ffffff",
               "leading":"1px",
               "textAlign":"center"
            });
            _loc7_.setStyle("info6",{
               "fontSize":"12px",
               "color":"#00ccff",
               "leading":"1px",
               "textAlign":"center"
            });
         }
         else if(param4 == 3)
         {
            _loc7_.setStyle("info1",{
               "fontSize":"16px",
               "color":"#ffffff",
               "leading":"3px",
               "textAlign":"center"
            });
         }
         this._text.width = 175;
         this._text.height = 45;
         this._text.condenseWhite = true;
         this._text.styleSheet = _loc7_;
         this._text.autoSize = TextFieldAutoSize.CENTER;
         this._text.selectable = false;
         this._text.mouseEnabled = false;
         if(param4 == 2)
         {
            _loc6_.info1 = LangManager.getInstance().getLanguage("window155");
            _loc6_.info2 = LangManager.getInstance().getLanguage("window153",param1);
            _loc6_.info3 = LangManager.getInstance().getLanguage("window156");
            _loc6_.info4 = "";
            _loc6_.info5 = "";
            this.x = 370;
            this.y = 110;
         }
         else if(param4 == 1 || param4 == 4)
         {
            _loc6_.info1 = LangManager.getInstance().getLanguage("window155");
            _loc6_.info2 = LangManager.getInstance().getLanguage("window153",param1);
            _loc6_.info3 = LangManager.getInstance().getLanguage("window152");
            _loc6_.info4 = LangManager.getInstance().getLanguage("window153",param2);
            _loc6_.info5 = LangManager.getInstance().getLanguage("window157",param5);
            _loc6_.info6 = LangManager.getInstance().getLanguage("window154",param3);
            this.x = 370;
            this.y = 110;
         }
         else if(param4 == 3)
         {
            _loc6_.info1 = param1;
         }
         this._text.htmlText = _loc6_;
         if(param4 == 3)
         {
            this._text.x = 12;
         }
         else if(param4 == 4)
         {
            this._text.x = 21;
         }
         else
         {
            this._text.x = 20;
         }
         this._text.y = 4;
         this.addChild(this._text);
      }
      
      public function goAnimate(param1:Point, param2:Point) : void
      {
         if(this.timer != null)
         {
            return;
         }
         this.x = param1.x;
         this.y = param1.y;
         this._startY = param1.y;
         this._endY = param2.y;
         this.parent.mouseChildren = false;
         this.visible = true;
         this.alpha = 0;
         this.timer = new Timer(10);
         this.timer.addEventListener(TimerEvent.TIMER,this.onCountTimer);
         this.timer.start();
      }
      
      private function onCountTimer(param1:TimerEvent) : void
      {
         this.y -= (this.y - this._endY) * 0.1;
         if(this.y < this._startY - (this._startY - this._endY) / 2)
         {
            this.timer.delay = 20;
            this.alpha -= (1 - this.alpha) * 0.5;
            if(this.y <= this._endY + 5)
            {
               this.alpha = 0;
               this.timer.stop();
               this.timer.removeEventListener(TimerEvent.TIMER,this.onCountTimer);
               this.parent.mouseChildren = true;
               this.parent.removeChild(this);
               this.timer = null;
               return;
            }
         }
         this.alpha += (1 - this.alpha) * 0.5;
         if(int(this.y) == this._startY - (this._startY - this._endY) / 2)
         {
            this.alpha = 1;
            this.timer.delay = 500;
         }
      }
      
      public function dispose() : void
      {
         TextFilter.removeFilter(this._text);
         this.graphics.clear();
      }
   }
}

