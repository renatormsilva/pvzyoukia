package loading
{
   import com.display.BitmapDateSourseManager;
   import constants.GlobalConstants;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import manager.UILoaderManager;
   import pvz.battle.battleMode.Battle;
   import pvz.battle.node.BattleOrg;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   import zmyth.load.UILoader;
   
   public class OrgsLoading extends Sprite
   {
      
      private var _loading:MovieClip = null;
      
      private var _uiloadmanager:UILoaderManager = null;
      
      private var _container:DisplayObjectContainer = null;
      
      private var _urlhead:String = "";
      
      public function OrgsLoading(param1:DisplayObjectContainer, param2:String, param3:Array)
      {
         super();
         this._container = param1;
         this._urlhead = param2;
         this._uiloadmanager = new UILoaderManager();
         this._uiloadmanager.startOrg(this._container,this.getOrgLoaderUrl(param3),this.getOrgLoaderName(param3));
      }
      
      private function getOrgLoaderUrl(param1:Array) : Array
      {
         var _loc4_:String = null;
         if(param1 == null || param1.length < 1)
         {
            return new Array();
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this._urlhead + "ORGLibs/org_" + (param1[_loc3_] as Organism).getPicId() + ".swf?" + GlobalConstants.ORG_RES_VERSION;
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getOrgLoaderName(param1:Array) : Array
      {
         var _loc4_:String = null;
         if(param1 == null || param1.length < 1)
         {
            return new Array();
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = (param1[_loc3_] as Organism).getName();
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function initOrgByURL(param1:String) : void
      {
         var _loc2_:int = int(param1.replace(/.+org_/,"").replace(/[.]swf.+/,""));
         this.initOrgBitmap(_loc2_);
      }
      
      private function initOrgBitmap(param1:int) : void
      {
         var _loc2_:MovieClip = this.getOrgMc(BattleOrg.ORG + param1 + BattleOrg.NORMAL);
         var _loc3_:MovieClip = this.getOrgMc(BattleOrg.ORG + param1 + BattleOrg.ATTACK);
         var _loc4_:MovieClip = this.getOrgMc(BattleOrg.ORG + param1 + BattleOrg.ATTACK_OVER);
         BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc2_["org"],BattleOrg.ORG + param1 + BattleOrg.NORMAL);
         BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc3_["org"],BattleOrg.ORG + param1 + BattleOrg.ATTACK);
         if(_loc4_ != null)
         {
            BitmapDateSourseManager.getBitmapDatesByMovieClip(_loc4_["org"],BattleOrg.ORG + param1 + BattleOrg.ATTACK_OVER);
         }
         Battle.getBulletBlastCMovieClip(param1,0);
         Battle.getBulletCMovieClip(param1,0);
      }
      
      private function getOrgMc(param1:String) : MovieClip
      {
         var _loc2_:Class = DomainAccess.getClass(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         return new _loc2_() as MovieClip;
      }
      
      public function remove() : void
      {
         this._container.removeChild(this._loading);
      }
      
      public function show() : void
      {
         var _loc1_:Class = DomainAccess.getClass("loading");
         this._loading = new _loc1_();
         this._container.addChild(this._loading);
         this.addEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
         }
         else
         {
            this.showNextProgress();
         }
      }
      
      public function hidden() : void
      {
         this.visible = false;
      }
      
      private function showNextProgress() : void
      {
         var _loc1_:UILoader = this.getUILoader();
         if(_loc1_ != null)
         {
            _loc1_.addEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
            _loc1_.setListener(this._loading);
         }
      }
      
      private function getUILoader() : UILoader
      {
         if(UILoader.unLoaded.keys.length == 0)
         {
            this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE));
            return null;
         }
         return UILoader.unLoaded[UILoader.unLoaded.keys.getItemAt(0)];
      }
      
      private function onOneComplete(param1:ForeletEvent) : void
      {
         var _loc2_:UILoader = param1.target as UILoader;
         this.initOrgByURL(_loc2_.url);
         _loc2_.removeEventListener(ForeletEvent.COMPLETE,this.onOneComplete);
         _loc2_ = null;
         this.showNextProgress();
      }
      
      private function onComplete(param1:Event) : void
      {
         this.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onComplete);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.ALL_COMPLETE_SELF));
      }
   }
}

