package pvz.registration.view.panel
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flashx.textLayout.formats.TextAlign;
   import pvz.registration.control.RegistrationMgr;
   import pvz.registration.view.item.RegItem;
   import pvz.registration.view.panel.module.Component;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class Calendar extends Component
   {
      
      private var _signed:Boolean;
      
      private var _day:uint;
      
      private var _month:uint;
      
      private var _year:uint;
      
      private var _btnSign:SimpleButton;
      
      private var _lblMonth:MovieClip;
      
      private var _lblMonPre:String;
      
      private var _btnDays:Vector.<DisplayObject>;
      
      private var _btnTitles:Vector.<DisplayObject>;
      
      private var _title:Sprite;
      
      private var _content:Sprite;
      
      private var _signedDays:Array;
      
      private var _hideTitle:Boolean;
      
      private var _btn_bg_0:BitmapData;
      
      private var _btn_bg_1:BitmapData;
      
      private var _btn_bg_2:BitmapData;
      
      private var _btn_mask:BitmapData;
      
      private var _numPre:String;
      
      private const _dayName:Array = ["日","一","二","三","四","五","六"];
      
      public function Calendar(param1:Object, param2:Number = 365, param3:Number = 220, param4:Boolean = false)
      {
         super(param2,param3);
         this._signed = false;
         this._signedDays = new Array();
         this._hideTitle = param4;
         this.createWithClasses(param1);
         this.createTitle();
         this.createContent();
         this.setDateDate(new Date());
      }
      
      private function createWithClasses(param1:Object) : void
      {
         var prefix:String;
         var classes:Object = param1;
         var checkThemValue:Function = function(param1:String):void
         {
            if(!classes[param1])
            {
               throw "Can not create calendar, theme invalid. [" + param1 + "] undefined or null.";
            }
         };
         checkThemValue("lblMonth");
         checkThemValue("btnSign");
         checkThemValue("btnBg0");
         checkThemValue("btnBg1");
         checkThemValue("btnBg2");
         checkThemValue("btnMask");
         checkThemValue("num");
         prefix = "calendar_";
         this._numPre = prefix + classes.num;
         this._lblMonPre = prefix + classes.lblMonth;
         this._lblMonth = GetDomainRes.getMoveClip("pvz.reg.mon");
         this._lblMonth.gotoAndStop(1);
         this._btnSign = GetDomainRes.getSimpleButton("pvz.reg.btnReg");
         this._btn_bg_0 = GetDomainRes.getBitmapData("pvz.reg.itemBg");
         this._btn_bg_1 = GetDomainRes.getBitmapData("pvz.reg.itemBg");
         this._btn_bg_2 = GetDomainRes.getBitmapData("pvz.reg.itemBg");
         this._btn_mask = GetDomainRes.getBitmapData("pvz.reg.itemBg");
         checkThemValue = null;
         classes = null;
         this._btnSign.x = _width - this._btnSign.width;
         this._btnSign.y = 3;
         this._lblMonth.x = 35;
         this._lblMonth.y = 2;
         if(RegistrationMgr.getInstance().isSignCurrent() == false)
         {
            this._btnSign.addEventListener(MouseEvent.CLICK,this.onBtnSignClick);
            this._btnSign.mouseEnabled = this._btnSign.mouseChildren = true;
            FuncKit.clearNoColorState(this._btnSign);
         }
         else
         {
            FuncKit.setNoColor(this._btnSign);
            this._btnSign.mouseEnabled = this._btnSign.mouseChildren = false;
         }
         addChild(this._btnSign);
         addChild(this._lblMonth);
      }
      
      public function setDate(param1:uint, param2:uint, param3:uint) : void
      {
         this._year = param1;
         this._month = param2;
         this._day = param3;
         if(RegistrationMgr.getInstance().isSignCurrent() == false)
         {
            this._btnSign.addEventListener(MouseEvent.CLICK,this.onBtnSignClick);
            this._btnSign.mouseEnabled = this._btnSign.mouseChildren = true;
            FuncKit.clearNoColorState(this._btnSign);
         }
         else
         {
            this._btnSign.removeEventListener(MouseEvent.CLICK,this.onBtnSignClick);
            FuncKit.setNoColor(this._btnSign);
            this._btnSign.mouseEnabled = this._btnSign.mouseChildren = false;
         }
         validate();
      }
      
      public function setDateDate(param1:Date) : void
      {
         this.setDate(param1.fullYear,param1.month + 1,param1.date);
      }
      
      public function isSigned(param1:uint = 0) : Boolean
      {
         return this._signedDays.indexOf(param1 ? param1 : this._day) != -1;
      }
      
      public function sign(param1:uint = 0) : void
      {
         dispatchEvent(new Event("onSign"));
      }
      
      public function signedDays() : uint
      {
         return this._signedDays.length;
      }
      
      override public function dispose() : void
      {
         this._btnSign.removeEventListener(MouseEvent.CLICK,this.onBtnSignClick);
         this._btn_bg_0.dispose();
         this._btn_bg_1.dispose();
         this._btn_bg_2.dispose();
         this._btn_mask.dispose();
         removeChild(this._btnSign);
         removeChild(this._content);
         removeChild(this._lblMonth);
         if(!this._hideTitle)
         {
            removeChild(this._title);
         }
         this._btn_bg_0 = this._btn_bg_1 = this._btn_bg_2 = this._btn_mask = null;
         this._btnDays = this._btnTitles = null;
         this._btnSign = null;
         this._lblMonth = null;
         this._title = this._content = null;
         this._signedDays = null;
      }
      
      protected function createTitle() : void
      {
         var _loc3_:TextField = null;
         if(this._hideTitle)
         {
            return;
         }
         this._title = new Sprite();
         this._title.x = 0;
         this._title.y = 30;
         this._title.graphics.beginFill(16711680,0);
         this._title.graphics.drawRect(0,0,260,25);
         this._title.graphics.endFill();
         addChild(this._title);
         var _loc1_:TextFormat = new TextFormat("_sans",12,16777215,true,false,false,null,null,TextAlign.CENTER);
         var _loc2_:uint = 0;
         while(_loc2_ < 7)
         {
            _loc3_ = new TextField();
            _loc3_.defaultTextFormat = _loc1_;
            _loc3_.width = 37;
            _loc3_.height = 25;
            _loc3_.x = _loc2_ * 38;
            _loc3_.y = 3;
            _loc3_.selectable = false;
            _loc3_.text = "周" + this._dayName[_loc2_];
            TextFilter.MiaoBian(_loc3_,1118481);
            this._title.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      protected function createContent() : void
      {
         var _loc4_:RegItem = null;
         this._content = new Sprite();
         this._content.x = 0;
         this._content.y = 50;
         addChild(this._content);
         var _loc1_:Number = (_width - 4) / 7;
         var _loc2_:Number = (_height - this._content.y) / 6;
         var _loc3_:uint = 0;
         while(_loc3_ < 42)
         {
            _loc4_ = new RegItem();
            _loc4_.x = _loc3_ % 7 * _loc1_;
            _loc4_.y = int(_loc3_ / 7) * _loc2_;
            this._content.addChild(_loc4_);
            _loc3_++;
         }
      }
      
      protected function getDaysOfMonth(param1:uint, param2:uint) : uint
      {
         if(!param1 || param1 > 12)
         {
            return 0;
         }
         switch(param1)
         {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
               return 31;
            case 2:
               if(param2 % 400 == 0 || param2 % 100 != 0 && param2 % 4 == 0)
               {
                  return 29;
               }
               return 28;
               break;
            default:
               return 30;
         }
      }
      
      protected function onBtnSignClick(param1:*) : void
      {
         this.sign();
      }
      
      override protected function draw() : void
      {
         var _loc7_:RegItem = null;
         var _loc8_:int = 0;
         var _loc9_:Bitmap = null;
         var _loc1_:uint = new Date(this._year,this._month - 1,1).day;
         var _loc2_:uint = this.getDaysOfMonth(this._month,this._year);
         var _loc3_:uint = this.getDaysOfMonth(this._month == 1 ? 12 : uint(this._month - 1),this._month == 1 ? uint(this._year - 1) : this._year);
         var _loc4_:uint = 0;
         while(_loc4_ < 42)
         {
            _loc7_ = this._content.getChildAt(_loc4_) as RegItem;
            _loc8_ = 0;
            _loc9_ = null;
            if(_loc4_ < _loc1_)
            {
               _loc8_ = 0;
            }
            else if(_loc4_ - _loc1_ + 1 > _loc2_)
            {
               _loc8_ = 0;
            }
            else
            {
               _loc8_ = _loc4_ - _loc1_ + 1;
               if(this.isSigned(_loc4_ - _loc1_ + 1))
               {
                  _loc9_ = new Bitmap(this._btn_mask);
               }
            }
            _loc7_.id = _loc8_;
            _loc4_++;
         }
         removeChild(this._lblMonth);
         this._lblMonth.gotoAndStop(this._month);
         this._lblMonth.x = 30;
         this._lblMonth.y = 2;
         addChild(this._lblMonth);
         var _loc5_:Boolean = this.isSigned();
         var _loc6_:Object = this._btnSign as Object;
         if(_loc6_.hasOwnProperty("mouseEnabled"))
         {
            _loc6_.mouseEnabled = !_loc5_;
         }
         if(_loc6_.hasOwnProperty("gotoAndStop"))
         {
            _loc6_.gotoAndStop(_loc5_ ? 1 : 2);
         }
      }
      
      public function get signed() : Array
      {
         return this._signedDays;
      }
      
      public function set signed(param1:Array) : void
      {
         if(this._signedDays == param1)
         {
            return;
         }
         this._signedDays.length = 0;
         this._signedDays = param1.slice();
         validate();
      }
      
      public function get day() : uint
      {
         return this._day;
      }
      
      public function set day(param1:uint) : void
      {
         if(this._day == param1)
         {
            return;
         }
         this._day = param1;
         validate();
      }
      
      public function get month() : uint
      {
         return this._month;
      }
      
      public function set month(param1:uint) : void
      {
         if(this._month == param1)
         {
            return;
         }
         this._month = param1;
         validate();
      }
      
      public function get year() : uint
      {
         return this._year;
      }
      
      public function set year(param1:uint) : void
      {
         if(this._year == param1)
         {
            return;
         }
         this._year = param1;
         validate();
      }
      
      public function set hideTitle(param1:Boolean) : void
      {
         if(this._hideTitle == param1)
         {
            return;
         }
         this._hideTitle = param1;
      }
      
      public function get hideTitle() : Boolean
      {
         return this._hideTitle;
      }
   }
}

