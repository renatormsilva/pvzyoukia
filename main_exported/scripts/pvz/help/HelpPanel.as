package pvz.help
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import utils.GetDomainRes;
   import utils.LightUp;
   import utils.TextFilter;
   
   public class HelpPanel extends Sprite
   {
      
      private var bg:HelpBgSprite;
      
      private var _light:LightUp;
      
      public function HelpPanel()
      {
         super();
      }
      
      public function createPanel(param1:String = "", param2:int = 0, param3:Number = 0, param4:Function = null, param5:String = "", param6:uint = 10) : void
      {
         var arrow:MovieClip;
         var submit:MovieClip = null;
         var onMouseUp:Function = null;
         var str:String = param1;
         var arrowDiection:int = param2;
         var txtWidth:Number = param3;
         var callback:Function = param4;
         var buttonLabel:String = param5;
         var gap:uint = param6;
         var tf:HelpTextfield = new HelpTextfield(str,txtWidth);
         if(buttonLabel != "")
         {
            onMouseUp = function(param1:MouseEvent):void
            {
               submit.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
               if(callback != null)
               {
                  callback();
               }
            };
            submit = GetDomainRes.getMoveClip("pvz.button2");
            if(submit._label)
            {
               submit._label.text = buttonLabel;
               submit._label.mouseEnabled = false;
            }
            this.bg = new HelpBgSprite(tf.width + gap,tf.height + gap + submit.height - 5);
            addChild(this.bg);
            this.bg.addChild(submit);
            submit.x = this.bg.width - submit.width - 5;
            submit.y = this.bg.height - submit.height;
            submit.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         }
         else
         {
            this.bg = new HelpBgSprite(tf.width + gap,tf.height + gap);
            addChild(this.bg);
         }
         this.bg.x = -this.bg.width / 2;
         this.bg.y = -this.bg.height / 2;
         this.bg.addChild(tf);
         tf.x = gap / 2;
         tf.y = gap / 2;
         arrow = GetDomainRes.getMoveClip("pvz.teachArrow");
         addChild(arrow);
         this.location(arrow,arrowDiection);
         TextFilter.MiaoBian(this.bg,1838080);
         this._light = new LightUp(this.bg,15722382);
      }
      
      private function location(param1:DisplayObject, param2:int) : void
      {
         if(param2 == NewHelper.ARROW_UP)
         {
            param1.rotation = 180;
            param1.y = -this.height / 2 - NewHelper.ARROW_GAP;
         }
         else if(param2 == NewHelper.ARROW_DOWN)
         {
            param1.y = this.height / 2 + NewHelper.ARROW_GAP;
         }
         else if(param2 == NewHelper.ARROW_LEFT)
         {
            param1.rotation = 90;
            param1.x = -this.width / 2 - NewHelper.ARROW_GAP;
         }
         else if(param2 == NewHelper.ARROW_RIGHT)
         {
            param1.rotation = -90;
            param1.x = this.width / 2 + NewHelper.ARROW_GAP;
         }
      }
      
      public function destory() : void
      {
         TextFilter.removeFilter(this.bg);
         if(this._light)
         {
            this._light.closeLightUp();
            this._light = null;
         }
      }
   }
}

import flash.display.Sprite;
import utils.GetDomainRes;

class HelpBgSprite extends Sprite
{
   
   public function HelpBgSprite(param1:Number, param2:Number)
   {
      super();
      this.graphics.clear();
      this.graphics.beginBitmapFill(GetDomainRes.getBitmapData("pvz.helpbg"));
      this.graphics.drawRect(0,0,param1,param2);
      this.graphics.endFill();
   }
}
