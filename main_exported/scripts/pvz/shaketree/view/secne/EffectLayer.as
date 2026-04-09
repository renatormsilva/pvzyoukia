package pvz.shaketree.view.secne
{
   import com.display.CMovieClip;
   import core.managers.GameManager;
   import effect.flap.FlapManager;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import manager.SoundManager;
   import pvz.shaketree.utils.ShakeTree_Kit;
   import pvz.shaketree.view.JewelPrizeLabel;
   import utils.FuncKit;
   
   public class EffectLayer
   {
      
      private const RECTAGE:Number = -200;
      
      private var _mcNode:MovieClip;
      
      public function EffectLayer(param1:MovieClip)
      {
         super();
         this._mcNode = param1;
         this._mcNode.visible = false;
      }
      
      public function showExplosionEffect(param1:Point, param2:int = 0, param3:Function = null) : void
      {
         var cmc:CMovieClip = null;
         var beishuMc:MovieClip = null;
         var onEnterRrame:Function = null;
         var point:Point = param1;
         var baoji:int = param2;
         var end:Function = param3;
         onEnterRrame = function(param1:Event):void
         {
            if(cmc.currentFrameIndex == cmc.totalFrames - 1)
            {
               _mcNode.visible = false;
               _mcNode.removeChild(cmc);
               GameManager.pvzStage.removeEventListener(Event.ENTER_FRAME,onEnterRrame);
               if(end != null)
               {
                  end.call();
               }
            }
         };
         this._mcNode.visible = true;
         cmc = ShakeTree_Kit.getBigExplosionEffect(baoji);
         this._mcNode.addChild(cmc);
         if(baoji == 1)
         {
            cmc.x = point.x - 90;
            cmc.y = point.y - 80;
         }
         else if(baoji == 2)
         {
            cmc.x = point.x - 170;
            cmc.y = point.y - 220;
            beishuMc = ShakeTree_Kit.getBaojiBeiShuMoiveClip(baoji);
            this._mcNode.addChild(beishuMc);
            FuncKit.PlayFlashAnimation(beishuMc,this._mcNode,null,new Point(point.x,point.y - 100));
         }
         else if(baoji == 4)
         {
            cmc.x = point.x - 150;
            cmc.y = point.y - 280;
            beishuMc = ShakeTree_Kit.getBaojiBeiShuMoiveClip(baoji);
            this._mcNode.addChild(beishuMc);
            FuncKit.PlayFlashAnimation(beishuMc,this._mcNode,null,new Point(point.x,point.y - 100));
         }
         else if(baoji == 8)
         {
            cmc.x = point.x - 170;
            cmc.y = point.y - 500;
            beishuMc = ShakeTree_Kit.getBaojiBeiShuMoiveClip(baoji);
            this._mcNode.addChild(beishuMc);
            FuncKit.PlayFlashAnimation(beishuMc,this._mcNode,null,new Point(point.x,point.y - 100));
         }
         PlantsVsZombies.playSounds(SoundManager.EXPLOSION1);
         GameManager.pvzStage.addEventListener(Event.ENTER_FRAME,onEnterRrame);
      }
      
      public function showJewelPrizeLabels(param1:Array, param2:Point) : void
      {
         var _loc3_:JewelPrizeLabel = null;
         var _loc4_:Tool = null;
         var _loc5_:* = 0;
         this._mcNode.visible = true;
         for each(_loc4_ in param1)
         {
            _loc5_ = int(_loc4_.getNum());
            while(_loc5_ > 0)
            {
               _loc3_ = new JewelPrizeLabel(_loc4_);
               this._mcNode.addChild(_loc3_);
               _loc3_.x = param2.x + Math.random() * this.RECTAGE;
               _loc3_.y = param2.y + Math.random() * this.RECTAGE;
               FlapManager.flapInfos3(_loc3_.x,_loc3_.y,_loc3_);
               _loc5_--;
            }
         }
      }
      
      public function clearLayer() : void
      {
         FuncKit.clearAllChildrens(this._mcNode);
         this._mcNode.visible = false;
      }
   }
}

