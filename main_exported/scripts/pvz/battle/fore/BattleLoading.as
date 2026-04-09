package pvz.battle.fore
{
   import constants.GlobalConstants;
   import entity.Organism;
   import flash.display.DisplayObjectContainer;
   import loading.OrgsLoading;
   import zlib.event.ForeletEvent;
   import zlib.utils.DomainAccess;
   
   public class BattleLoading
   {
      
      private var _callback:Function = null;
      
      private var _orgsLoader:OrgsLoading = null;
      
      public function BattleLoading(param1:DisplayObjectContainer, param2:Array, param3:Array, param4:Function)
      {
         super();
         this._callback = param4;
         var _loc5_:Array = this.getLoadingOrgs(param2,param3);
         if(_loc5_ == null || _loc5_.length < 1)
         {
            this._callback();
            return;
         }
         this._orgsLoader = new OrgsLoading(param1,GlobalConstants.PVZ_RES_BASE_URL,_loc5_);
         this._orgsLoader.addEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
         this._orgsLoader.show();
      }
      
      private function checkLoadOrgsArray(param1:Array) : Array
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ > -1)
         {
            if(DomainAccess.getClass("org_" + (param1[_loc2_] as Organism).getPicId() + "_0") != null)
            {
               param1.splice(_loc2_,1);
            }
            _loc2_--;
         }
         return param1;
      }
      
      private function getLoadingOrgs(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(!this.isHave(param1[_loc4_],_loc3_))
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            if(!this.isHave(param2[_loc5_],_loc3_))
            {
               _loc3_.push(param2[_loc5_]);
            }
            _loc5_++;
         }
         return this.checkLoadOrgsArray(_loc3_);
      }
      
      private function isHave(param1:Organism, param2:Array) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == null || param2.length < 1)
         {
            return _loc3_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param1.getPicId() == (param2[_loc4_] as Organism).getPicId())
            {
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function onAllComp(param1:ForeletEvent) : void
      {
         if(this._orgsLoader != null)
         {
            this._orgsLoader.remove();
            this._orgsLoader.removeEventListener(ForeletEvent.ALL_COMPLETE,this.onAllComp);
            this._orgsLoader = null;
         }
         this._callback();
      }
   }
}

