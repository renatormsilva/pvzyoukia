package pvz.copy.ui.tips
{
   import com.res.IDestroy;
   import core.ui.tips.TipsItem1;
   import core.ui.tips.TipsItem2;
   import entity.Tool;
   import flash.display.DisplayObject;
   import manager.LangManager;
   import pvz.genius.tips.BaseSectionsTips;
   
   public class LimitCheckPonitTips extends BaseSectionsTips
   {
      
      public function LimitCheckPonitTips()
      {
         super("pvz.activtyCopy.tips1",false);
      }
      
      public function initTips(param1:Object, param2:String = "") : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         var _loc5_:TipsItem1 = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:String = null;
         var _loc8_:TipsItem1 = null;
         var _loc9_:Array = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:Tool = null;
         var _loc12_:TipsItem2 = null;
         var _loc13_:Array = null;
         var _loc14_:Vector.<String> = null;
         var _loc15_:Tool = null;
         var _loc16_:TipsItem2 = null;
         this.destroy();
         createTips();
         _ui["_label"].text = param2;
         if(param1.money)
         {
            _loc3_ = new Vector.<String>();
            _loc4_ = LangManager.getInstance().getLanguage("activtyCopy007") + param1.money;
            _loc3_.push(_loc4_);
            _loc5_ = new TipsItem1(LangManager.getInstance().getLanguage("activtyCopy008"),_loc3_,176);
            _bg.addChild(_loc5_);
            _layout.addDisToGroup(_loc5_);
            reLayout();
         }
         if(param1.exp)
         {
            _loc6_ = new Vector.<String>();
            _loc7_ = LangManager.getInstance().getLanguage("activtyCopy009") + param1.exp;
            _loc6_.push(_loc7_);
            _loc8_ = new TipsItem1(LangManager.getInstance().getLanguage("activtyCopy008"),_loc6_,176);
            _bg.addChild(_loc8_);
            _layout.addDisToGroup(_loc8_);
            reLayout();
         }
         if(param1.sureTools)
         {
            _loc9_ = param1.sureTools;
            _loc10_ = new Vector.<String>();
            for each(_loc11_ in _loc9_)
            {
               _loc10_.push(_loc11_.getName());
            }
            _loc12_ = new TipsItem2(LangManager.getInstance().getLanguage("activtyCopy010"),_loc10_,176);
            _bg.addChild(_loc12_);
            _layout.addDisToGroup(_loc12_);
            reLayout();
         }
         if(param1.maybeTools)
         {
            _loc13_ = param1.maybeTools;
            _loc14_ = new Vector.<String>();
            for each(_loc15_ in _loc13_)
            {
               _loc14_.push(_loc15_.getName());
            }
            _loc16_ = new TipsItem2(LangManager.getInstance().getLanguage("activtyCopy011"),_loc14_,176);
            _bg.addChild(_loc16_);
            _layout.addDisToGroup(_loc16_);
            reLayout();
         }
      }
      
      override public function destroy() : void
      {
         while(_bg.numChildren > 0)
         {
            if(_bg.getChildAt(0) is IDestroy)
            {
               (_bg.getChildAt(0) as IDestroy).destroy();
            }
            _bg.getChildAt(0).filters = null;
            _bg.removeChild(_bg.getChildAt(0) as DisplayObject);
         }
      }
   }
}

