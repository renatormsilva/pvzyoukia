package effect.flip
{
   import flash.display.Sprite;
   
   public class EffectFlipComponent extends Sprite
   {
      
      private var _Gourp1:EffectFlipGroup;
      
      private var _Gourp2:EffectFlipGroup;
      
      private var _isDoing:Boolean;
      
      public function EffectFlipComponent(param1:Array, param2:Array, param3:Number, param4:int, param5:Number)
      {
         super();
         this._Gourp1 = new EffectFlipGroup(param1,param3,param4,param5,this.setDoingStatus);
         this._Gourp2 = new EffectFlipGroup(param2,param3,param4,param5,this.setDoingStatus);
         this.addChild(this._Gourp1);
         this.addChild(this._Gourp2);
      }
      
      public function show(param1:Array = null, param2:int = 1) : void
      {
         if(this._isDoing)
         {
            return;
         }
         if(!this._Gourp1._status && !this._Gourp2._status)
         {
            this._isDoing = true;
            param2 = EffectFlipGroup.NEXT;
            this._Gourp2.show(param1,param2);
            return;
         }
         if(this._Gourp1._status)
         {
            if(param2 == EffectFlipGroup.UPDATE)
            {
               this._Gourp1.show(param1,param2);
               return;
            }
            this._isDoing = true;
            this._Gourp1.hide(param2);
            this._Gourp2.show(param1,param2);
         }
         if(this._Gourp2._status)
         {
            if(param2 == EffectFlipGroup.UPDATE)
            {
               this._Gourp2.show(param1,param2);
               return;
            }
            this._isDoing = true;
            this._Gourp2.hide(param2);
            this._Gourp1.show(param1,param2);
         }
      }
      
      private function setDoingStatus() : void
      {
         this._isDoing = !this._isDoing;
      }
      
      public function getIsDoing() : Boolean
      {
         return this._isDoing;
      }
      
      public function destory() : void
      {
         this._Gourp1.destory();
         this._Gourp2.destory();
      }
   }
}

