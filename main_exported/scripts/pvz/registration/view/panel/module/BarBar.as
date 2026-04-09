package pvz.registration.view.panel.module
{
   import flash.geom.Rectangle;
   import utils.GetDomainRes;
   
   public class BarBar extends Component
   {
      
      private var _bg:Scale9Image = null;
      
      public function BarBar(param1:String = "scrollBar_bar")
      {
         var _loc2_:Rectangle = null;
         if(param1 == "scrollBar_bar")
         {
            _loc2_ = new Rectangle(5,7,3,7);
         }
         else
         {
            _loc2_ = new Rectangle(3,6,8,78.8);
         }
         this._bg = new Scale9Image(GetDomainRes.getBitmapData(param1),_loc2_);
         this._bg.repeatFillLeft = this._bg.repeatFillRight = this._bg.repeatFillCenter = false;
         this._bg.x = 1;
         addChild(this._bg);
         buttonMode = true;
         super(this._bg.width,this._bg.height);
      }
      
      public function get minHeight() : Number
      {
         if(this._bg.height > super.height)
         {
            return this._bg.height;
         }
         return 0;
      }
      
      override public function set width(param1:Number) : void
      {
         this._bg.width = param1;
         super.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         this._bg.height = param1;
         super.height = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._bg.dispose();
      }
   }
}

