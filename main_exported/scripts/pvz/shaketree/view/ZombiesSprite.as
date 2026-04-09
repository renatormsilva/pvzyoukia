package pvz.shaketree.view
{
   import com.res.IDestroy;
   import core.managers.GameManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import node.OrgLoader;
   import pvz.shaketree.utils.Rect;
   import pvz.shaketree.utils.ShakeTree_Kit;
   import pvz.shaketree.view.secne.ShakeTreeScene;
   import pvz.shaketree.view.tips.ZombiesInfoTips;
   import pvz.shaketree.vo.ShakeTreeSystermData;
   import pvz.shaketree.vo.ZombiesVo;
   import utils.GetDomainRes;
   import utils.GlowTween;
   
   public class ZombiesSprite extends Sprite implements IDestroy
   {
      
      private var _mc:OrgLoader;
      
      private var _id:int;
      
      private var _bloodBar:MovieClip;
      
      private var _mask:Rect;
      
      private var tips:ZombiesInfoTips;
      
      private var bossMc:DisplayObject;
      
      public function ZombiesSprite()
      {
         super();
      }
      
      public function createZomeies(param1:int) : void
      {
         var zomibeVo:ZombiesVo;
         var watuAni:MovieClip = null;
         var show:Function = null;
         var id:int = param1;
         show = function(param1:Event):void
         {
            _mc.y -= _mc.height / watuAni.totalFrames;
            if(_mc.y <= 0)
            {
               new GlowTween(_mc,16777113);
               _mc.y = 0;
               GameManager.pvzStage.removeEventListener(Event.ENTER_FRAME,show);
               addEvent();
               removeChild(_mask);
               _mc.mask = null;
               watuAni.mask = null;
               removeChild(watuAni);
               _bloodBar.visible = true;
               if(bossMc)
               {
                  bossMc.visible = true;
               }
            }
         };
         this._id = id;
         zomibeVo = ShakeTreeSystermData.I.currentPassData().getZombiesVoByid(id);
         this._mc = ShakeTree_Kit.getZombiesCMovieClip(zomibeVo.getOrgId(),zomibeVo.getDirection());
         this._mc.y = this._mc.height;
         this.addChild(this._mc);
         watuAni = GetDomainRes.getMoveClip("pvz.watu");
         addChild(watuAni);
         this._mask = new Rect(this._mc.width + 50,this._mc.height + 20);
         addChild(this._mask);
         this._mask.x = -this._mask.width / 2;
         this._mask.y = -this._mask.height;
         this._mc.mask = this._mask;
         if(zomibeVo.getIsBoss())
         {
            this._bloodBar = GetDomainRes.getMoveClip("pvz.bloodBar2");
            this.bossMc = GetDomainRes.getDisplayObject("pvz.boss");
            this.addChild(this.bossMc);
            this.bossMc.visible = false;
            this.bossMc.y = -this._mc.height - 20;
         }
         else
         {
            this._bloodBar = GetDomainRes.getMoveClip("pvz.bloodBar1");
         }
         this.addChild(this._bloodBar);
         this._bloodBar.x = -this._bloodBar.width / 2;
         this._bloodBar.y = 0;
         this._bloodBar.visible = false;
         this._bloodBar.bar.scaleX = zomibeVo.getHp() / zomibeVo.getMaxHp();
         GameManager.pvzStage.addEventListener(Event.ENTER_FRAME,show);
      }
      
      private function addEvent() : void
      {
         this._mc.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._mc.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var _loc2_:ZombiesVo = ShakeTreeSystermData.I.currentPassData().getZombiesVoByid(this._id);
         if(this.tips == null)
         {
            this.tips = new ZombiesInfoTips();
         }
         this.tips.showTipss(_loc2_.getIsBoss(),_loc2_.getName(),_loc2_.getMustTools(),_loc2_.getProbelTools());
         PlantsVsZombies._node.addChild(this.tips);
         this.setLocation();
         ShakeTreeScene.miao().visible = true;
         Mouse.hide();
         GameManager.pvzStage.addEventListener(Event.ENTER_FRAME,this.showMiao);
      }
      
      private function showMiao(param1:Event) : void
      {
         ShakeTreeScene.miao().x = GameManager.pvzStage.mouseX;
         ShakeTreeScene.miao().y = GameManager.pvzStage.mouseY;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         if(this.tips)
         {
            this.tips.destroy();
            PlantsVsZombies._node.removeChild(this.tips);
         }
         Mouse.show();
         ShakeTreeScene.miao().visible = false;
         GameManager.pvzStage.removeEventListener(Event.ENTER_FRAME,this.showMiao);
      }
      
      public function updateBloodBar() : void
      {
         var _loc1_:ZombiesVo = ShakeTreeSystermData.I.currentPassData().getZombiesVoByid(this._id);
         _loc1_.setHp(_loc1_.getHp() - 1);
         this._bloodBar.bar.scaleX = _loc1_.getHp() / _loc1_.getMaxHp();
         if(_loc1_.getIsDeath())
         {
            this.visible = false;
         }
      }
      
      private function setLocation() : void
      {
         if(this.tips)
         {
            this.tips.x = this.x + this._mc.width / 2 + 10;
            this.tips.y = this.y;
            if(this.tips.x >= GameManager.pvzStage.stageWidth - this.tips.width)
            {
               this.tips.x = this.tips.x - this._mc.width - this.tips.width - 10;
            }
            if(this.tips.y >= GameManager.pvzStage.stageHeight - this.tips.height)
            {
               this.tips.y -= this.tips.height;
            }
         }
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function destroy() : void
      {
         this._mc.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this._mc.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
   }
}

