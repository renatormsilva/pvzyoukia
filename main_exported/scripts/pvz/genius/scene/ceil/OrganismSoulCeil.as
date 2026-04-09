package pvz.genius.scene.ceil
{
   import com.display.CMovieClip;
   import entity.Organism;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import manager.EffectManager;
   import manager.OrganismManager;
   import node.OrgLoader;
   import pvz.genius.tips.SoulTips;
   import utils.GlowTween;
   import utils.TextFilter;
   import xmlReader.config.XmlQualityConfig;
   import zmyth.res.IDestroy;
   
   public class OrganismSoulCeil extends Sprite implements IDestroy
   {
      
      internal var _o:Organism = null;
      
      public var _sp:OrgLoader;
      
      private var type:int = 0;
      
      private var _loc:int = 0;
      
      private var tips:SoulTips;
      
      private var lightC:CMovieClip = null;
      
      private var lightS:CMovieClip;
      
      private var __tipsNode:Sprite;
      
      private var _nameText:TextField;
      
      public function OrganismSoulCeil(param1:Organism, param2:int, param3:Sprite, param4:Boolean = true)
      {
         super();
         this._sp = new OrgLoader(param1.getPicId(),param2,this.setOrgLoction,1,param4);
         this._sp.buttonMode = true;
         this._o = param1;
         this._loc = param2;
         this.__tipsNode = param3;
         this.addEvent();
         if(param1.getBlood() != OrganismManager.ZOMBIE)
         {
            new GlowTween(this._sp,16777113);
         }
         else
         {
            this.setGlowTween();
         }
         this.type = this.type;
         this.addChild(this._sp);
         this.visionPlantsName();
         this.setLightEffect();
      }
      
      public function upOrgSoulLightEffect() : void
      {
         var _loc1_:int = this._o.getSoulLevel();
         this.clearSoulEffect();
         if(_loc1_ <= 0)
         {
            return;
         }
         this.lightS = EffectManager.getSoulEffect(_loc1_);
         if(this.lightS == null)
         {
            return;
         }
         this.lightS.y = -160;
         this.addChild(this.lightS);
      }
      
      public function clearSoulEffect() : void
      {
         if(this.lightS != null)
         {
            this.lightS.stop();
            if(this.contains(this.lightS))
            {
               this.removeChild(this.lightS);
            }
            this.lightS = null;
         }
      }
      
      private function setLightEffect() : void
      {
         this.lightC = EffectManager.getQualityEffect(this._o);
         if(this.lightC != null)
         {
            this.lightC.mouseChildren = false;
            this.lightC.mouseEnabled = false;
            addChild(this.lightC);
         }
      }
      
      public function destroy() : void
      {
         if(this.tips != null)
         {
            this.tips.clear();
         }
         this.clearSoulEffect();
         this.removeEvent();
         this.setGlowTween(true);
         this._sp.destroy();
      }
      
      private function setOrgLoction() : void
      {
         this._sp.x = 0;
         this._sp.y = 0;
      }
      
      private function setGlowTween(param1:Boolean = false) : void
      {
         var _toggle:Boolean;
         var t:Timer = null;
         var _blur:Number = NaN;
         var onTimer:Function = null;
         var stop:Boolean = param1;
         onTimer = function(param1:TimerEvent):void
         {
            var _loc3_:uint = 0;
            if(_o.getDifficulty() == 1)
            {
               _loc3_ = 13434777;
            }
            else if(_o.getDifficulty() == 2)
            {
               _loc3_ = 13158600;
            }
            else
            {
               _loc3_ = 16728642;
            }
            var _loc2_:GlowFilter = new GlowFilter(_loc3_,1,_blur,_blur,5,2);
            _sp.filters = [_loc2_];
         };
         if(t != null)
         {
            t.stop();
            t.removeEventListener(TimerEvent.TIMER,onTimer);
         }
         if(stop)
         {
            return;
         }
         t = new Timer(800);
         t.addEventListener(TimerEvent.TIMER,onTimer);
         t.start();
         _blur = 2;
         _toggle = true;
      }
      
      private function addEvent() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this.tips.parent)
         {
            this.tips.visible = false;
            this.tips.parent.removeChild(this.tips);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new SoulTips();
         }
         if(param1.target == this._nameText || param1.target == this.lightC)
         {
            return;
         }
         this.tips.show(this._o);
         this.__tipsNode.addChild(this.tips);
         this.tips.visible = true;
         this.tips.x = this.tips.width / 2;
         this.tips.y = this.tips.height / 2;
      }
      
      private function visionPlantsName() : void
      {
         var _loc1_:TextFormat = null;
         if(this._nameText == null)
         {
            this._nameText = new TextField();
            TextFilter.MiaoBian(this._nameText,1118481);
         }
         var _loc2_:String = "Lv." + this._o.getGrade() + "  " + this._o.getName();
         var _loc3_:int = XmlQualityConfig.getInstance().getID(this._o.getQuality_name());
         var _loc4_:uint = TextFilter.getCoulorByQuality(_loc3_);
         this._nameText.text = _loc2_;
         this._nameText.textColor = _loc4_;
         _loc1_ = this._nameText.defaultTextFormat;
         _loc1_.align = TextFieldAutoSize.CENTER;
         _loc1_.size = 15;
         _loc1_.bold = true;
         this._nameText.setTextFormat(_loc1_);
         this._nameText.selectable = false;
         this._nameText.width = this._nameText.textWidth + 10;
         this._nameText.x = -70;
         this._nameText.y = 20;
         this.addChild(this._nameText);
      }
   }
}

