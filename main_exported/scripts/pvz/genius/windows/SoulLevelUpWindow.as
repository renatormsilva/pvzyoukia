package pvz.genius.windows
{
   import core.ui.panel.BaseWindow;
   import entity.Organism;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import manager.SoundManager;
   import node.Icon;
   import pvz.genius.vo.SoulData;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import xmlReader.config.XmlGeniusDataConfig;
   
   public class SoulLevelUpWindow extends BaseWindow
   {
      
      private var _window:MovieClip;
      
      private var _level:int;
      
      private var _org:Organism;
      
      public function SoulLevelUpWindow(param1:int, param2:Organism)
      {
         super();
         this._level = param1;
         this._org = param2;
         this._window = GetDomainRes.getMoveClip("GeniusSystem.geniusLevelUpWindow");
         showBG(PlantsVsZombies._node);
         PlantsVsZombies._node.addChild(this._window);
         this.setLoction();
         this.showInfo();
         onShowEffect(this._window);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         var onUp:Function = null;
         onUp = function(param1:MouseEvent):void
         {
            PlantsVsZombies.playSounds(SoundManager.BUTTON2);
            _window.ok.removeEventListener(MouseEvent.MOUSE_UP,onUp);
            _window._cancle.removeEventListener(MouseEvent.MOUSE_UP,onUp);
            onHiddenEffect(_window);
         };
         this._window.ok.addEventListener(MouseEvent.MOUSE_UP,onUp);
         this._window._cancle.addEventListener(MouseEvent.MOUSE_UP,onUp);
      }
      
      private function setLoction() : void
      {
         this._window.x = (PlantsVsZombies.WIDTH - this._window.width) / 2;
         this._window.y = (PlantsVsZombies.HEIGHT - this._window.height) / 2;
      }
      
      private function showInfo() : void
      {
         var _loc2_:SoulData = null;
         var _loc1_:SoulData = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(this._level);
         if(this._level > 1)
         {
            _loc2_ = XmlGeniusDataConfig.getInstance().getSoulDataByLevel(this._level - 1);
         }
         if(_loc2_)
         {
            this._window._txt1.text = _loc2_.addHP + "%";
            this._window._txt2.text = _loc2_.addAttack + "%";
            this._window._txt3.text = _loc2_.addHit + "%";
            this._window._txt4.text = _loc2_.addMiss + "%";
            this._window._txt5.text = _loc2_.addSpeed + "%";
            this._window._txt6.text = _loc2_.addHurt + "%";
            this._window._txt7.text = _loc2_.reduceHurt + "%";
         }
         this._window._txt8.text = _loc1_.addHP + "%";
         this._window._txt9.text = _loc1_.addAttack + "%";
         this._window._txt10.text = _loc1_.addHit + "%";
         this._window._txt11.text = _loc1_.addMiss + "%";
         this._window._txt12.text = _loc1_.addSpeed + "%";
         this._window._txt13.text = _loc1_.addHurt + "%";
         this._window._txt14.text = _loc1_.reduceHurt + "%";
         this._window._name.text = this._org.getName() + LangManager.getInstance().getLanguage("genius035");
         var _loc3_:DisplayObject = FuncKit.getStarDisBySoulLevel(this._level);
         this._window._starnode.addChild(_loc3_);
         _loc3_.y = -_loc3_.height / 2;
         Icon.setUrlIcon(this._window._node,this._org.getPicId(),Icon.ORGANISM_1);
      }
   }
}

