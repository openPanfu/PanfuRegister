package {
import flash.display.MovieClip;
import flash.system.ApplicationDomain;

public class ClothManager {

    private static var pInst:ClothManager;

    private var pApplicationDomain:ApplicationDomain;

    public function ClothManager() {
    }

    public static function get inst():ClothManager {
        if (pInst == null) {
            pInst = new ClothManager();
        }
        return (pInst);
    }


    public function initialize(_arg_1:ApplicationDomain):void {
        this.pApplicationDomain = _arg_1;
    }

    public function getCloth(_arg_1:String):MovieClip {
        var _local_2:Class = (this.pApplicationDomain.getDefinition(_arg_1) as Class);
        return (new (_local_2)());
    }


}
}