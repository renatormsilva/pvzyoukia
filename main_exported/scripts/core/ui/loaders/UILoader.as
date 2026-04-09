package core.ui.loaders
{
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class UILoader extends Loader
   {
      
      public var url:String = "";
      
      public function UILoader()
      {
         super();
      }
      
      public function starLoad() : void
      {
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.load(new URLRequest(this.url),_loc1_);
      }
   }
}

