package {
import com.pandaland.manager.SnippetManager;
import com.pandaland.mvc.model.vo.DateVO;
import com.pandaland.mvc.model.vo.PlayerInfoVO;
import com.pandaland.mvc.model.vo.RegisterVO;
import com.pandaland.popup.BodyTextDecorator;
import com.pandaland.popup.ButtonDownloadAGBDecorator;
import com.pandaland.popup.CloseButtonDecorator;
import com.pandaland.popup.DefaultPopup;
import com.pandaland.popup.HorizontalScrollButtonsDecorator;
import com.pandaland.popup.IPopup;
import com.pandaland.popup.OkButtonDecorator;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.filters.GlowFilter;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;

// Background color is RGB(169, 210, 29)
[SWF(width='950', height='500', backgroundColor='0xA9D21D')]
public class PanfuRegister extends Sprite {

    private const VOICE_FADEOUT_TIME:int = 500;

    [Embed(source="./images/background.png")]
    private var pBackGround:Class;
    private var pLoaderInfo:LoaderInfo;
    private var pContent:MovieClip;
    private var pCurrentScreen:int = 0;
    private var pScreenList:Array;
    private var pScreenHandlers:Array;
    private var pCheckInputFunctions:Array;
    private var pNextButtonEnablers:Array;
    private var pRegistrationInfoResetter:Array;
    private var pClickNextErrorMessages:Array;
    private var pClickNextErrorSounds:Array;
    private var pBubbleErrorSounds:Array;
    private var pHeaderSounds:Array;
    private var pRegGender:String = "";
    private var pRegName:String = "";
    private var pRegPass:String = "";
    private var pRegEmail:String = "";
    private var pRegItems:Array;
    private var pRegNewsletter:Boolean = true;
    private var pUserID:int = 0;
    private var pBubbleErrors:Array;
    private var pLanguageAGBPosition:Array;
    private var pCatalog:Array = null;
    private var pCatalogGirl:Array;
    private var pCatalogBoy:Array;
    private var pIsValidating:Boolean = false;
    private var pInputTimer:Timer;
    private var pFakeValidationTimer:Timer;
    private var pBtnBack:MovieClip;
    private var pBtnNext:MovieClip;
    private var glowingButton:DisplayObject;
    private var isGlowUp:Boolean = true;
    private var glowTimer:Timer = null;
    private var pIsOverGender:Boolean = false;
    private var pValidatingElementName:String = "";
    private var pUniqueEmail:Boolean = false;
    private var flashVars:Object;
    private var pRegistrationCompleteTitle:String = "REGISTRATION_SCREEN6_HEADLINE";
    private var pRegistrationCompleteHeader:String = "REGISTRATION_SCREEN6_SUBLINE";
    private var pSuggestedUserName:String = "";
    private var pOriginMailUnique:Boolean = false;

    public function PanfuRegister() {
        this.pScreenList = ["gender", "clothes", "name", "password", "email", "done", "changeemail"];
        this.pScreenHandlers = [this.displayGenderScreen, this.displayClothingScreen, this.displayNameScreen, this.displayPasswordScreen, this.displayEmailScreen, this.displayActivateEmail, this.displayChangeEmail];
        this.pCheckInputFunctions = [null, null, this.checkName, this.checkPass, this.checkEmail, this.checkEmail, null, null];
        this.pNextButtonEnablers = [this.isGenderSelected, null, this.isNameValid, this.isPasswordValid, this.isEmailValid, null, null, null];
        this.pRegistrationInfoResetter = [null, null, this.resetName, this.resetPassword, this.resetEmail, this.resetEmail, null, null];
        this.pClickNextErrorMessages = ["REGISTRATION_SCREEN1_CHOOSE_ERROR", "", "REGISTRATION_SCREEN3_POPUP_ERROR", "REGISTRATION_SCREEN4_PASSWORD_ERROR", "REGISTRATION_SCREEN5_EMAIL_POPUP_ERROR", "", ""];
        this.pClickNextErrorSounds = ["REGISTR_SCR01_ERROR01", "", "REGISTR_SCR03_ERROR01", "REGISTR_SCR04_ERROR01", "REGISTR_SCR05_ERROR03"];
        this.pBubbleErrorSounds = ["REGISTR_SCR04_ERROR03", "REGISTR_SCR04_ERROR02", "REGISTR_SCR05_ERROR02", "REGISTR_SCR05_ERROR01", "", "", "", "", ""];
        this.pHeaderSounds = [{
            "path": "REGISTR_SCR01_HEAD",
            "duration": 5
        }, {
            "path": "REGISTR_SCR02_HEAD",
            "duration": 5
        }, {
            "path": "REGISTR_SCR03_ENTRY",
            "duration": 10
        }, {
            "path": "REGISTR_SCR04_ENTRY",
            "duration": 12
        }, {
            "path": "REGISTR_SCR05_ENTRY",
            "duration": 8
        }];
        this.pRegItems = [];
        this.pBubbleErrors = ["REGISTRATION_SCREEN4_PASSWORD_POPUP_ERROR", "REG_PASSWORD_CHARACTERS_ERROR2", "REGISTRATION_SCREEN5_EMAIL_ERROR_2", "REGISTRATION_SCREEN5_EMAIL_ERROR_1", "REGISTRATION_SCREEN3_CHARACTERS_ERROR", "REGISTRATION_SCREEN3_NAME_ERROR", "REGISTRATION_SCREEN5_ERROR_EMAILALREADYINUSE"];
        this.pLanguageAGBPosition = new Array();
        this.pCatalogGirl = [[102435, 102736, 102747, 102825], [102438, 102374, 102508, 102765], [102607, 102372, 102749, 102766], [102750, 102757, 102737, 102827]];
        this.pCatalogBoy = [[102472, 102783, 102760, 102743], [101617, 102369, 102762, 102784], [102753, 102745, 102763, 102745], [102746, 102809, 102754, 101616]];
        this.pInputTimer = new Timer(3000, 1);
        this.pFakeValidationTimer = new Timer(500, 1);
        this.flashVars = new Object();
        super();
        var _local_1:Bitmap = new this.pBackGround();
        _local_1.name = "background";
        _local_1.x = 0;
        _local_1.y = 0;
        addChild(_local_1);
        this.flashVars = LoaderInfo(this.root.loaderInfo).parameters;
        var _local_2:String = this.flashVars["informationServer"];
        RemotingService.inst.serverURL = _local_2;
        this.registerVOs();
        PanfuRegister.log(("Language " + this.flashVars["language"]));
        if (!this.flashVars["language"]) {
            //this.flashVars["language"] = "DE";
            this.flashVars["language"] = "EN";
        }
        SoundManager.inst.init(this.flashVars["language"]);
        this.setupLanguageAGBPositions();
        var _local_3:Timer = new Timer(10, 1);
        _local_3.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTempTimerComplete);
        _local_3.start();
    }

    private function setupLanguageAGBPositions():void {
        this.pLanguageAGBPosition["ES"] = [-24, 132];
        this.pLanguageAGBPosition["EN"] = [-23, 130];
        this.pLanguageAGBPosition["DE"] = [-11, 300];
        this.pLanguageAGBPosition["DK"] = [-12, 127];
        this.pLanguageAGBPosition["FI"] = [-60, 80];
        this.pLanguageAGBPosition["FR"] = [6, 210];
        this.pLanguageAGBPosition["NL"] = [28, 151];
        this.pLanguageAGBPosition["NO"] = [8, 151];
        this.pLanguageAGBPosition["PL"] = [-48, 97];
        this.pLanguageAGBPosition["SE"] = [-22, 100];
        this.pLanguageAGBPosition["TR"] = [-135, 45];
    }

    private function onTempTimerComplete(_arg_1:TimerEvent):void {
        this.loadMenu();
    }

    private function registerVOs():void {
        RegisterVO.register();
        DateVO.register();
        PlayerInfoVO.register();
    }

    private function loadMenu():void {
        var _local_1:Loader = new Loader();
        var _local_2:URLRequest = new URLRequest("Reg_process_interface_CS3.swf");
        _local_1.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
        _local_1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
        _local_1.load(_local_2);
    }

    private function set isValidating(_arg_1:Boolean):void {
        this.pIsValidating = _arg_1;
    }

    private function get isValidating():Boolean {
        return (this.pIsValidating);
    }

    private function isNameValid():Boolean {
        if (this.pRegName != "") {
            return (true);
        }
        return (false);
    }

    private function isPasswordValid():Boolean {
        if (this.pRegPass != "") {
            return (true);
        }
        return (false);
    }

    private function isEmailValid():Boolean {
        if (this.pRegEmail != "") {
            return (true);
        }
        return (false);
    }

    private function isGenderSelected():Boolean {
        if (this.pRegGender != "") {
            return (true);
        }
        return (false);
    }

    private function switchScreenTo(_arg_1:int):void {
        this.pCurrentScreen = _arg_1;
        var _local_2:String = this.pScreenList[_arg_1];
        PanfuRegister.log(("Go to frame : " + _local_2));
        this.pContent.gotoAndPlay(_local_2);
        this.pContent.addEventListener("switchedFrames", this.onSwitchedFrame);
    }

    private function onSwitchedFrame(_arg_1:Event):void {
        this.pContent.removeEventListener("switchedFrames", this.onSwitchedFrame);
        PanfuRegister.log("onSwitched frame entered...");
        var _local_2:MovieClip = (this.pContent.getChildByName("mcSteps") as MovieClip);
        if (_local_2) {
            _local_2.gotoAndStop((this.pCurrentScreen + 1));
        }

        this.pScreenHandlers[this.pCurrentScreen]();
        this.closeWarningPopup();
        this.checkNavButtonsStatus();
        if (this.pCurrentScreen < this.pHeaderSounds.length) {
            SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pHeaderSounds[this.pCurrentScreen]["path"], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
        }
    }

    private function closeWarningPopup():void {
        var _local_1:MovieClip = this.pContent["popup"];
        if (_local_1) {
            _local_1.visible = false;
        }
    }

    private function resetName():void {
        this.pRegName = "";
    }

    private function resetPassword():void {
        this.pRegPass = "";
    }

    private function resetEmail():void {
        this.pRegEmail = "";
    }

    private function checkNavButtonsStatus():void {
        if (this.pCurrentScreen > 0) {
            this.pBtnBack.gotoAndStop(2);
            this.pBtnBack.visible = true;
        } else {
            this.pBtnBack.gotoAndStop(1);
            this.pBtnBack.visible = false;
        }
        if (((!(this.pNextButtonEnablers[this.pCurrentScreen])) || (this.pNextButtonEnablers[this.pCurrentScreen]()))) {
            this.pBtnNext.gotoAndStop(2);
            this.pBtnNext.buttonMode = true;
        } else {
            this.pBtnNext.gotoAndStop(1);
            this.pBtnNext.buttonMode = false;
        }
        if ((((((((this.pCurrentScreen == 4)) || ((this.pCurrentScreen == 5)))) || ((this.pCurrentScreen == 6)))) || ((this.pCurrentScreen == 7)))) {
            this.pBtnNext.visible = false;
        } else {
            this.pBtnNext.visible = true;
        }
    }

    private function displayGenderScreen():void {
        var _local_8:DisplayObject;
        var _local_9:MovieClip;
        if (this.flashVars["language"] == "DE") {
            _local_9 = (this.pContent["btnMute"] as MovieClip);
            _local_9.visible = true;
        }
        var _local_1:MovieClip = (this.pContent["selectMaleWood"] as MovieClip);
        var _local_2:MovieClip = (this.pContent["selectFemaleWood"] as MovieClip);
        var _local_3:MovieClip = (this.pContent["selectMaleAvatar"] as MovieClip);
        var _local_4:MovieClip = (this.pContent["selectFemaleAvatar"] as MovieClip);
        var _local_5:Array = [_local_1, _local_2, _local_3, _local_4];
        var _local_6:TextField = (this.pContent["title1"] as TextField);
        var _local_7:TextField = (this.pContent["title2"] as TextField);
        SnippetManager.instance.setSnippet(_local_6, "REGISTRATION_SCREEN1_PANDA");
        SnippetManager.instance.setSnippet(_local_7, "REGISTRATION_SCREEN1_PANDA_1");
        SnippetManager.instance.setSnippet((this.pBtnBack["label"] as TextField), "REGISTRATION_SCREEN1_BACK_BUTTON");
        SnippetManager.instance.setSnippet((this.pBtnNext["label"] as TextField), "REGISTRATION_SCREEN1_NEXT_BUTTON");
        SnippetManager.instance.setSnippet(_local_2["woodFemale"]["label"], "REGISTRATION_SCREEN1_GIRL");
        SnippetManager.instance.setSnippet(_local_1["woodMale"]["label"], "REGISTRATION_SCREEN1_BOY");
        for each (_local_8 in _local_5) {
            _local_8.addEventListener(MouseEvent.CLICK, this.onGenderSelected, false, 0, true);
            _local_8.addEventListener(MouseEvent.MOUSE_OVER, this.onAddGlowOnGender, false, 0, true);
            _local_8.addEventListener(MouseEvent.MOUSE_OUT, this.onRemoveGlowOnGender, false, 0, true);
            _local_8.addEventListener(MouseEvent.MOUSE_OVER, this.makeGenderButtonOveredSound, false, 0, true);
            (_local_8 as Sprite).mouseChildren = false;
            (_local_8 as Sprite).buttonMode = true;
        }
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_signs-falling", SoundManager.TYPE_SFX, false);
    }

    private function onAddGlowOnGender(_arg_1:MouseEvent):void {
        var _local_5:DisplayObject;
        var _local_6:DisplayObject;
        var _local_7:DisplayObject;
        var _local_8:DisplayObject;
        var _local_2:MovieClip = (_arg_1.target as MovieClip);
        var _local_3:GlowFilter = new GlowFilter(0xFFFFFF, 1, 10, 10, 4);
        var _local_4:Array = new Array();
        _local_4.push(_local_3);
        if (_local_2.name.search("Female") != -1) {
            _local_5 = (this.pContent["selectFemaleWood"] as MovieClip);
            _local_6 = (this.pContent["selectFemaleAvatar"] as MovieClip);
            _local_6.filters = _local_4;
            _local_5.filters = _local_4;
        } else {
            _local_7 = (this.pContent["selectMaleWood"] as MovieClip);
            _local_8 = (this.pContent["selectMaleAvatar"] as MovieClip);
            _local_7.filters = _local_4;
            _local_8.filters = _local_4;
        }
    }

    private function onRemoveGlowOnGender(_arg_1:MouseEvent):void {
        var _local_3:DisplayObject;
        var _local_4:DisplayObject;
        var _local_5:DisplayObject;
        var _local_6:DisplayObject;
        var _local_2:MovieClip = (_arg_1.target as MovieClip);
        if (_local_2.name.search("Female") != -1) {
            _local_3 = (this.pContent["selectFemaleWood"] as MovieClip);
            _local_4 = (this.pContent["selectFemaleAvatar"] as MovieClip);
            if (_local_4) {
                _local_4.filters = new Array();
            }
            if (_local_3) {
                _local_3.filters = new Array();
            }
        } else {
            _local_5 = (this.pContent["selectMaleWood"] as MovieClip);
            _local_6 = (this.pContent["selectMaleAvatar"] as MovieClip);
            if (_local_5) {
                _local_5.filters = new Array();
            }
            if (_local_6) {
                _local_6.filters = new Array();
            }
        }
    }

    private function markTheSelectedGender(_arg_1:DisplayObject, _arg_2:DisplayObject):void {
        var _local_3:GlowFilter;
        var _local_4:Array;
        if (this.pRegGender != "") {
            _local_3 = new GlowFilter(15601937);
            _local_4 = new Array();
            _local_4.push(_local_3);
            if (this.pRegGender == "MALE") {
                _arg_1.filters = _local_4;
            } else {
                _arg_2.filters = _local_4;
            }
        }
    }

    private function onAddGlow(_arg_1:MouseEvent):void {
        var _local_2:GlowFilter = new GlowFilter(0xFFFFFF, 1, 10, 10, 4);
        var _local_3:Array = new Array();
        _local_3.push(_local_2);
        (_arg_1.target as DisplayObject).filters = _local_3;
    }

    private function onRemoveGlow(_arg_1:MouseEvent):void {
        (_arg_1.target as DisplayObject).filters = new Array();
    }

    private function onGenderSelected(_arg_1:MouseEvent):void {
        var _local_2:DisplayObject = (_arg_1.target as DisplayObject);
        if (_local_2.name.indexOf("Female") != -1) {
            if (this.pRegGender == "MALE") {
                this.pRegItems.splice(0, this.pRegItems.length);
            }
            this.pRegGender = "FEMALE";
            this.pCatalog = this.pCatalogGirl;
        } else {
            if (this.pRegGender == "FEMALE") {
                this.pRegItems.splice(0, this.pRegItems.length);
            }
            this.pRegGender = "MALE";
            this.pCatalog = this.pCatalogBoy;
        }
        this.pCurrentScreen++;
        this.switchScreenTo(this.pCurrentScreen);
    }

    private function displayClothingScreen():void {
        var _local_1:TextField = (this.pContent["title1"] as TextField);
        var _local_2:TextField = (this.pContent["title2"] as TextField);
        SnippetManager.instance.setSnippet(_local_1, "REGISTRATION_SCREEN2_OUTFIT");
        SnippetManager.instance.setSnippet(_local_2, "REGISTRATION_SCREEN2_OUTFIT_2");
        var _local_3:MovieClip = (this.pContent.getChildByName("avatar") as MovieClip);
        _local_3.visible = true;
        if (this.pRegGender == "FEMALE") {
            _local_3.gotoAndStop("girl");
        } else {
            _local_3.gotoAndStop("boy");
        }
        this.initializeCatalog();
        this.pBtnNext.enabled = true;
    }

    private function initializeCatalog():void {
        var _local_4:int;
        var tClothManager:MovieClip;
        var tItemMovie:MovieClip;
        var tItemMiddle:MovieClip;
        var _local_8:int;
        var tItemName:String;
        var tItemNameSplit:Array;
        var tRealItemName:String;
        var tLastFrame:int;
        var tAllClothes:MovieClip;
        var _local_14:MovieClip;
        var _local_1:Array = ["head_", "top_", "bottom_", "shoes_"];
        var tGender:String = "";
        if (this.pRegGender == "FEMALE") {
            tGender = "Girl_";
        } else {
            tGender = "Boy_";
        }
        var tItemType:int;
        while (tItemType < 4) {
            _local_4 = 1;
            while (_local_4 < 5) {
                tClothManager = ClothManager.inst.getCloth((((tGender + _local_1[tItemType]) + _local_4) + "_small"));
                tItemMovie = (this.pContent["catalog"][(("cell_" + tItemType) + (_local_4 - 1))] as MovieClip);
                tClothManager.name = ((tGender + _local_1[tItemType]) + _local_4);
                tItemMovie.addEventListener(MouseEvent.MOUSE_OVER, this.onCatalogOver, false, 0, true);
                tItemMovie.addEventListener(MouseEvent.MOUSE_OUT, this.onCatalogOut, false, 0, true);
                tItemMovie.addEventListener(MouseEvent.CLICK, this.onCatalogClicked, false, 0, true);
                tItemMiddle = (tItemMovie.getChildByName("middle") as MovieClip);
                tItemMiddle.addChild(tClothManager);
                tItemMovie.mouseChildren = false;
                tItemMovie.buttonMode = true;
                tItemMovie.addEventListener(MouseEvent.CLICK, this.onClickedOnCatalogCloth, false, 0, true);
                _local_8 = this.pCatalog[tItemType][(_local_4 - 1)];
                if (this.pRegItems.indexOf(_local_8) != -1) {
                    tItemName = tItemMiddle.getChildAt(1).name;
                    tItemNameSplit = tItemName.split("_");
                    tRealItemName = ((tItemNameSplit[0] + "_") + tItemNameSplit[1]);
                    tLastFrame = (int(tItemNameSplit[2]) + 1);
                    tAllClothes = (this.pContent.getChildByName("allClothes") as MovieClip);
                    _local_14 = (tAllClothes.getChildByName(tRealItemName) as MovieClip);
                    _local_14.gotoAndStop(tLastFrame);
                    _local_14.itemid = _local_8;
                    _local_14.mouseChildren = false;
                    _local_14.buttonMode = true;
                    _local_14.addEventListener(MouseEvent.CLICK, this.onRemoveCloth);
                }
                _local_4++;
            }
            tItemType++;
        }
    }

    private function onCatalogOver(tMouseEvent:MouseEvent):void {
        (tMouseEvent.target as MovieClip).gotoAndStop(2);
    }

    private function onCatalogOut(tMouseEvent:MouseEvent):void {
        (tMouseEvent.target as MovieClip).gotoAndStop(1);
    }

    private function onCatalogClicked(tMouseEvent:MouseEvent):void {
        (tMouseEvent.target as MovieClip).gotoAndStop(2);
    }

    private function onClickedOnCatalogCloth(tMouseEvent:MouseEvent):void {
        var _local_14:int;
        var _local_15:int;
        var tClicked:MovieClip = (tMouseEvent.target as MovieClip);
        var _local_3:MovieClip = (tClicked.getChildByName("middle") as MovieClip);
        var _local_4:String = _local_3.getChildAt(1).name;
        var _local_5:String = (tClicked.name.split("_")[1] as String);
        var _local_6:int = int(_local_5.charAt(1));
        var _local_7:int = int(_local_5.charAt(0));
        var _local_8:int = this.pCatalog[_local_7][_local_6];
        var _local_9:Array = _local_4.split("_");
        var _local_10:String = ((_local_9[0] + "_") + _local_9[1]);
        var _local_11:int = (int(_local_9[2]) + 1);
        var _local_12:MovieClip = (this.pContent.getChildByName("allClothes") as MovieClip);
        var _local_13:MovieClip = (_local_12.getChildByName(_local_10) as MovieClip);
        _local_13.gotoAndStop(_local_11);
        _local_13.itemid = _local_8;
        _local_13.mouseChildren = false;
        _local_13.buttonMode = true;
        _local_13.addEventListener(MouseEvent.CLICK, this.onRemoveCloth);
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_clothes", SoundManager.TYPE_SFX, false);
        for each (_local_14 in this.pCatalog[_local_7]) {
            _local_15 = this.pRegItems.indexOf(_local_14);
            if (_local_15 != -1) {
                this.pRegItems.splice(_local_15, 1);
            }
        }
        this.pRegItems.push(_local_8);
    }

    private function onRemoveCloth(_arg_1:MouseEvent):void {
        var _local_2:MovieClip;
        var _local_3:String;
        var _local_4:int;
        var _local_5:int;
        if (this.pCurrentScreen == 1) {
            (_arg_1.target as MovieClip).gotoAndStop(1);
            _local_2 = (_arg_1.target as MovieClip);
            _local_3 = _local_2.name;
            _local_4 = _local_2.itemid;
            _local_5 = this.pRegItems.indexOf(_local_4);
            if (_local_5 != -1) {
                this.pRegItems.splice(_local_5, 1);
            }
            SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_clothes", SoundManager.TYPE_SFX, false);
        }
    }

    private function onSetTimerForInput(_arg_1:Event):void {
        var _local_2:MovieClip;
        var _local_3:MovieClip;
        var _local_4:MovieClip;
        var _local_5:MovieClip;
        _local_2 = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        _local_3 = (_local_2.getChildByName("validator") as MovieClip);
        _local_4 = (_local_2.getChildByName("validator2") as MovieClip);
        _local_5 = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_6:TextField = (_arg_1.target as TextField);
        if (_local_6.text == "") {
            this.pIsValidating = false;
            _local_3.visible = false;
            return;
        }
        this.pValidatingElementName = _arg_1.target.name;
        if (this.isValidating) {
            _arg_1.preventDefault();
            return;
        }
        var _local_8:Array = this.pRegistrationInfoResetter;
        (_local_8[this.pCurrentScreen]());
        this.checkNavButtonsStatus();
        _local_2 = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        _local_3 = (_local_2.getChildByName("validator") as MovieClip);
        _local_4 = (_local_2.getChildByName("validator2") as MovieClip);
        _local_5 = (_local_2.getChildByName("bubble") as MovieClip);
        if (_local_5) {
            _local_5.visible = false;
        }
        if (!(((stage.focus.name == "txtEmail2")) && ((_local_3.currentFrame == 4)))) {
            this.processValidator(_local_3, 1);
        }
        if (_local_4) {
            this.processValidator(_local_4, 1);
        }
        var _local_7:TextField = (_arg_1.target as TextField);
        if (_local_7.text != "") {
            if (this.pInputTimer.running) {
                this.pInputTimer.reset();
            }
            this.pInputTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onInputTimerComplete);
            this.pInputTimer.start();
            this.pFakeValidationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onFakeValidation);
            this.pFakeValidationTimer.start();
        }
    }

    private function onFakeValidation(_arg_1:TimerEvent):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        _local_3.gotoAndStop(2);
    }

    private function processValidator(_arg_1:MovieClip, _arg_2:int):void {
        _arg_1.gotoAndStop(_arg_2);
        _arg_1.visible = true;
        switch (_arg_2) {
            case 3:
                SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_invalid-icon", SoundManager.TYPE_SFX, false);
                return;
            case 4:
                SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_valid-icon", SoundManager.TYPE_SFX, false);
                return;
        }
    }

    private function onInputTimerComplete(_arg_1:TimerEvent):void {
        var _local_2:Function = this.pCheckInputFunctions[this.pCurrentScreen];
        (_local_2());
    }

    private function checkName(_arg_1:Event = null):void {
        var _local_5:RegExp;
        var _local_6:int;
        var _local_7:Number;
        var _local_8:MovieClip;
        var _local_9:MovieClip;
        var _local_10:MovieClip;
        var _local_11:MovieClip;
        this.isValidating = false;
        if (this.pCurrentScreen != 2) {
            return;
        }
        if (this.pInputTimer) {
            this.pInputTimer.stop();
            this.pFakeValidationTimer.stop();
        }
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:TextField = (this.pContent["ContainerMc"]["txtInput"] as TextField);
        if (this.pRegName == _local_4.text) {
            return;
        }
        if (this.checkNameSyntax(_local_4.text)) {
            _local_5 = /^\w+$/;
            _local_6 = 0;
            _local_7 = 0;
            while (_local_7 < _local_4.text.length) {
                if (Number(_local_4.text.charAt(_local_7))) {
                    _local_6++;
                }
                if (_local_4.text.charAt(_local_7) == " ") {
                    _local_6 = 100;
                    break;
                }
                _local_7++;
            }
            if (!_local_5.test(_local_4.text)) {
                _local_6 = 100;
            }
            // Check for some than 5 numbers in your username
            if(false) {
                if (_local_6 > 5) {
                    this.isValidating = false;
                    this.processValidator(_local_3, 3);
                    _local_8 = (_local_2.getChildByName("bubble") as MovieClip);
                    _local_9 = (_local_8.getChildByName("textmc") as MovieClip);
                    _local_8.visible = true;
                    _local_9.gotoAndStop(5);
                    SnippetManager.instance.setSnippet((_local_9["label"] as TextField), this.pBubbleErrors[4]);
                    SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR03_ERROR02", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
                    _local_10 = (this.pContent.getChildByName("avatar") as MovieClip);
                    _local_11 = (_local_10.getChildByName("avatar") as MovieClip);
                    _local_11.gotoAndPlay("sad");
                    return;
                }
            }
            this.isValidating = true;
            this.processValidator(_local_3, 2);
            _local_4.selectable = false;
            stage.focus = this.pBtnNext;
            RemotingService.inst.checkUserName(this.onNameValidated, this.onServerError, _local_4.text);
        } else {
            this.isValidating = false;
            this.processValidator(_local_3, 2);
        }
    }

    private function checkNameSyntax(_arg_1:String):Boolean {
        if ((((_arg_1.length == 0)) || ((_arg_1.length > 16)))) {
            return (false);
        }
        return (true);
    }

    private function checkPass(_arg_1:Event = null):void {
        var _local_8:MovieClip;
        var _local_9:MovieClip;
        var _local_10:Timer;
        if (this.pCurrentScreen != 3) {
            return;
        }
        if (this.pInputTimer) {
            this.pInputTimer.stop();
            this.pFakeValidationTimer.stop();
        }
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_5:MovieClip = (_local_4.getChildByName("textmc") as MovieClip);
        var _local_6:String = (this.pContent["ContainerMc"]["txtInput"] as TextField).text;
        // Original RegExp
        //var tPasswordRegex:RegExp = /^\w+$/;

        // This Regex allows for special characters in passwords.
        var tPasswordRegex:RegExp = /[-~]*$/;
        if (_local_6 == this.pRegPass) {
            return;
        }
        this.processValidator(_local_3, 2);
        stage.focus = this.pBtnNext;
        if ((((((_local_6.length < 6)) || ((_local_6 == this.pRegName)))) || (!(tPasswordRegex.test(_local_6))))) {
            this.processValidator(_local_3, 3);
            if (_local_6.length < 6) {
                _local_5.gotoAndStop(2);
                SnippetManager.instance.setSnippet((_local_5["label"] as TextField), this.pBubbleErrors[1]);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pBubbleErrorSounds[1], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            }
            if (_local_6 == this.pRegName) {
                _local_5.gotoAndStop(1);
                SnippetManager.instance.setSnippet((_local_5["label"] as TextField), this.pBubbleErrors[0]);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pBubbleErrorSounds[0], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            }
            _local_4.visible = true;
            this.isValidating = false;
            stage.focus = (this.pContent["ContainerMc"]["txtInput"] as TextField);
            _local_8 = (this.pContent.getChildByName("avatar") as MovieClip);
            _local_9 = (_local_8.getChildByName("avatar") as MovieClip);
            _local_9.gotoAndPlay("sad");
        } else {
            this.isValidating = true;
            _local_10 = new Timer(10, 1);
            _local_10.addEventListener(TimerEvent.TIMER_COMPLETE, this.onPasswordValidated, false, 0, true);
            _local_10.start();
        }
    }

    private function onFocusedOutOriginalEmail(_arg_1:FocusEvent):void {
        var _local_8:MovieClip;
        var _local_9:MovieClip;
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:TextField = (_local_2["txtEmail"] as TextField);
        var _local_4:TextField = (_local_2["txtEmail2"] as TextField);
        var _local_5:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_6:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_7:MovieClip = (_local_6.getChildByName("textmc") as MovieClip);
        this.pOriginMailUnique = false;
        if (_local_3.text != "") {
            if (this.validateEmailSyntax(_local_3.text)) {
                this.isValidating = true;
                this.processValidator(_local_5, 2);
                RemotingService.inst.checkEmailAddress(this.onEmailValidated, this.onServerError, _local_3.text);
            } else {
                this.processValidator(_local_5, 3);
                this.isValidating = false;
                _local_6.y = 160;
                _local_7.gotoAndStop(4);
                SnippetManager.instance.setSnippet((_local_7["label"] as TextField), this.pBubbleErrors[3]);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pBubbleErrorSounds[3], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
                _local_6.visible = true;
                _local_8 = (this.pContent.getChildByName("avatar") as MovieClip);
                _local_9 = (_local_8.getChildByName("avatar") as MovieClip);
                _local_9.gotoAndPlay("sad");
            }
        }
    }

    private function onTypedVerifyEmail(_arg_1:Event):void {
        var _local_5:MovieClip;
        var _local_6:MovieClip;
        var _local_7:MovieClip;
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:TextField = (_local_2["txtEmail"] as TextField);
        var _local_4:TextField = (_local_2["txtEmail2"] as TextField);
        if (_local_3.text == _local_4.text) {
            if (this.pOriginMailUnique) {
                _local_5 = (_local_2.getChildByName("bubble") as MovieClip);
                _local_6 = (_local_2.getChildByName("validator2") as MovieClip);
                _local_7 = (_local_5.getChildByName("textmc") as MovieClip);
                this.processValidator(_local_6, 4);
                _local_5.visible = false;
                this.pRegEmail = _local_3.text;
                if (this.isAGBAccepted()) {
                    this.displayPlaynowButton();
                }
            } else {
                this.onEmailOriginNotUnique();
                this.onSecondMailNotMatching(true);
            }
        } else {
            this.onSecondMailNotMatching();
        }
    }

    private function onSecondMailNotMatching(_arg_1:Boolean = false):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:TextField = (_local_2["txtEmail"] as TextField);
        var _local_4:TextField = (_local_2["txtEmail2"] as TextField);
        var _local_5:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_6:MovieClip = (_local_2.getChildByName("validator2") as MovieClip);
        var _local_7:MovieClip = (_local_5.getChildByName("textmc") as MovieClip);
        this.pRegEmail = "";
        this.hidePlayNow(null);
        if (!_arg_1) {
            _local_5.y = 251;
            _local_7.gotoAndStop(3);
            SnippetManager.instance.setSnippet((_local_7["label"] as TextField), this.pBubbleErrors[2]);
            _local_5.visible = true;
        }
        var _local_8:MovieClip = (this.pContent.getChildByName("avatar") as MovieClip);
        var _local_9:MovieClip = (_local_8.getChildByName("avatar") as MovieClip);
        _local_9.gotoAndPlay("sad");
        _local_6.visible = false;
    }

    private function checkEmail():void {
        var _local_9:MovieClip;
        var _local_10:MovieClip;
        if (this.pCurrentScreen != 4) {
            return;
        }
        var _local_1:TextField = (this.pContent["ContainerMc"][this.pValidatingElementName] as TextField);
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:MovieClip = (_local_2.getChildByName("validator2") as MovieClip);
        var _local_5:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_6:MovieClip = (_local_5.getChildByName("textmc") as MovieClip);
        var _local_7:TextField = (_local_2["txtEmail"] as TextField);
        var _local_8:TextField = (_local_2["txtEmail2"] as TextField);
    }

    private function onValidateEmailOnServer(_arg_1:TimerEvent):void {
        var _local_9:MovieClip;
        var _local_10:MovieClip;
        this.isValidating = false;
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:MovieClip = (_local_2.getChildByName("validator2") as MovieClip);
        var _local_5:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_6:MovieClip = (_local_5.getChildByName("textmc") as MovieClip);
        this.processValidator(_local_3, 4);
        var _local_7:TextField = (_local_2["txtEmail"] as TextField);
        var _local_8:TextField = (_local_2["txtEmail2"] as TextField);
        if (_local_8.text != "") {
            if ((((_local_7.text == _local_8.text)) && (!((_local_7.text == ""))))) {
                this.isValidating = false;
                this.processValidator(_local_4, 4);
                this.pRegEmail = _local_7.text;
                this.displayPlaynowButton();
            } else {
                this.pRegEmail = "";
                this.isValidating = false;
                this.processValidator(_local_4, 3);
                _local_5.y = 254;
                _local_5.visible = true;
                _local_6.gotoAndStop(3);
                SnippetManager.instance.setSnippet((_local_6["label"] as TextField), this.pBubbleErrors[2]);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pBubbleErrorSounds[2], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
                _local_9 = (this.pContent.getChildByName("avatar") as MovieClip);
                _local_10 = (_local_9.getChildByName("avatar") as MovieClip);
                _local_10.gotoAndPlay("sad");
            }
        }
    }

    private function validateEmailSyntax(_arg_1:String):Boolean {
        if (_arg_1.indexOf(" ") > 0) {
            return (false);
        }
        var _local_2:Array = _arg_1.split("@");
        if (((((!((_local_2.length == 2))) || ((_local_2[0].length == 0)))) || ((_local_2[1].length == 0)))) {
            return (false);
        }
        var _local_3:Array = _local_2[1].split(".");
        if (_local_3.length < 2) {
            return (false);
        }
        var _local_4:Number = 0;
        while (_local_4 < _local_3.length) {
            if (_local_3[_local_4].length < 1) {
                return (false);
            }
            _local_4++;
        }
        var _local_5:* = _local_3[(_local_3.length - 1)];
        if ((((_local_5.length < 2)) || ((_local_5.length > 4)))) {
            return (false);
        }
        return (true);
    }

    private function onNameValidated(_arg_1:Object):void {
        var _local_5:Boolean;
        var _local_6:String;
        var _local_7:String;
        var _local_8:MovieClip;
        var _local_9:MovieClip;
        var _local_10:TextField;
        var _local_11:MovieClip;
        var _local_12:MovieClip;
        this.isValidating = false;
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:TextField = (_local_2.getChildByName("txtInput") as TextField);
        if ((_arg_1["valueObject"] is Boolean)) {
            _local_5 = (_arg_1["valueObject"] as Boolean);
            if (_local_5) {
                stage.focus = _local_4;
                this.processValidator(_local_3, 4);
                this.pRegName = _local_4.getLineText(0);
                _local_4.selectable = true;
                this.checkNavButtonsStatus();
            } else {
                this.processValidator(_local_3, 3);
                _local_4.selectable = true;
                stage.focus = _local_4;
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR03_ERROR03", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
                RemotingService.inst.loadUsernameSuggestions(this.onUsernameSuggestion, this.onServerError, _local_4.text, this.pRegGender, 1);
            }
        } else {
            if ((_arg_1["valueObject"] is String)) {
                _local_6 = (_arg_1["valueObject"] as String);
                _local_7 = "NA";
                if ((((_local_6 == "BLACKLISTED")) || ((_local_6 == "GRAYLISTED")))) {
                    _local_7 = "REGISTRATION_SCREEN3_NAME_BLACKLISTED";
                } else {
                    if (_local_6 == "RESERVED") {
                        _local_7 = "REGISTRATION_SCREEN3_NAME_ERROR";
                    }
                }
                this.processValidator(_local_3, 3);
                _local_4.selectable = true;
                stage.focus = _local_4;
                _local_8 = (_local_2.getChildByName("bubble") as MovieClip);
                _local_9 = (_local_8.getChildByName("textmc") as MovieClip);
                _local_9.gotoAndStop(6);
                _local_10 = (_local_9["label"] as TextField);
                SnippetManager.instance.setSnippet(_local_10, _local_7);
                _local_8.visible = true;
                _local_11 = (this.pContent.getChildByName("avatar") as MovieClip);
                _local_12 = (_local_11.getChildByName("avatar") as MovieClip);
                _local_12.gotoAndPlay("sad");
            }
        }
    }

    private function onUsernameSuggestion(_arg_1:Object):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_4:MovieClip = (_local_3.getChildByName("textmc") as MovieClip);
        _local_4.names = _arg_1["valueObject"];
        this.pSuggestedUserName = (_local_4.names[0] as String);
        _local_4.gotoAndStop(6);
        var _local_5:TextField = (_local_4["label"] as TextField);
        SnippetManager.instance.setSnippet(_local_5, this.pBubbleErrors[5], null, true);
        if (_local_5.text.indexOf("%3$susername-suggestion%4$s") != -1) {
            _local_4.defaultUsernameError = _local_5.htmlText;
        }
        _local_5.embedFonts = true;
        var _local_6:TextFormat = new TextFormat("Verdana", 10, 0, true);
        _local_5.setTextFormat(_local_6);
        _local_5.htmlText = _local_4.defaultUsernameError.replace("%3$susername-suggestion%4$s", _local_4.names[0]);
        _local_5.htmlText = _local_5.htmlText.replace("%1$susername%2$s", (this.pContent["ContainerMc"]["txtInput"] as TextField).text);
        _local_5.addEventListener(TextEvent.LINK, this.clickedOnSuggestedName);
        _local_3.visible = true;
        var _local_7:MovieClip = (this.pContent.getChildByName("avatar") as MovieClip);
        var _local_8:MovieClip = (_local_7.getChildByName("avatar") as MovieClip);
        _local_8.gotoAndPlay("sad");
        var _local_9:TextField = ((this.pContent.getChildByName("ContainerMc") as MovieClip).getChildByName("txtInput") as TextField);
        _local_9.removeEventListener(FocusEvent.FOCUS_OUT, this.checkName);
    }

    private function clickedOnSuggestedName(_arg_1:TextEvent):void {
        var _local_2:TextField;
        var _local_3:MovieClip;
        var _local_4:MovieClip;
        _arg_1.stopImmediatePropagation();
        if (_arg_1.text == "username") {
            _local_2 = ((this.pContent.getChildByName("ContainerMc") as MovieClip).getChildByName("txtInput") as TextField);
            _local_2.text = this.pSuggestedUserName;
            _local_3 = (this.pContent.getChildByName("ContainerMc") as MovieClip);
            _local_4 = (_local_3.getChildByName("bubble") as MovieClip);
            _local_4.visible = false;
            this.checkName();
        }
    }

    private function onPasswordValidated(_arg_1:TimerEvent):void {
        this.isValidating = false;
        var _local_2:MovieClip = (this.pContent["ContainerMc"]["validator"] as MovieClip);
        this.processValidator(_local_2, 4);
        stage.focus = (this.pContent["ContainerMc"]["txtInput"] as TextField);
        this.pRegPass = (this.pContent["ContainerMc"]["txtInput"] as TextField).text;
        this.checkNavButtonsStatus();
    }

    private function onEmailValidated(_arg_1:Object):void {
        var _local_2:MovieClip;
        var _local_3:TextField;
        var _local_4:TextField;
        var _local_5:MovieClip;
        var _local_6:MovieClip;
        var _local_7:MovieClip;
        var _local_8:MovieClip;
        this.isValidating = false;
        this.pUniqueEmail = (_arg_1["valueObject"] as Boolean);
        if (this.pUniqueEmail) {
            this.pOriginMailUnique = true;
            _local_2 = (this.pContent["ContainerMc"] as MovieClip);
            _local_3 = (_local_2["txtEmail"] as TextField);
            _local_4 = (_local_2["txtEmail2"] as TextField);
            _local_5 = (_local_2.getChildByName("bubble") as MovieClip);
            _local_6 = (_local_5.getChildByName("textmc") as MovieClip);
            _local_7 = (_local_2["validator"] as MovieClip);
            _local_8 = (_local_2["validator2"] as MovieClip);
            this.processValidator(_local_7, 4);
            _local_4.mouseEnabled = true;
            _local_4.selectable = true;
            stage.focus = _local_4;
        } else {
            this.pOriginMailUnique = false;
            this.onEmailOriginNotUnique();
            this.pRegEmail = "";
        }
    }

    private function onEmailOriginNotUnique():void {
        var _local_1:MovieClip = (this.pContent["ContainerMc"] as MovieClip);
        var _local_2:TextField = (_local_1["txtEmail"] as TextField);
        var _local_3:TextField = (_local_1["txtEmail2"] as TextField);
        var _local_4:MovieClip = (_local_1.getChildByName("bubble") as MovieClip);
        var _local_5:MovieClip = (_local_4.getChildByName("textmc") as MovieClip);
        var _local_6:MovieClip = (_local_1["validator"] as MovieClip);
        var _local_7:MovieClip = (_local_1["validator2"] as MovieClip);
        this.processValidator(_local_6, 3);
        this.isValidating = false;
        _local_4.y = 160;
        _local_5.gotoAndStop(7);
        SnippetManager.instance.setSnippet((_local_5["label"] as TextField), this.pBubbleErrors[6]);
        SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR05_ERROR05", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
        _local_4.visible = true;
        var _local_8:MovieClip = (this.pContent.getChildByName("avatar") as MovieClip);
        var _local_9:MovieClip = (_local_8.getChildByName("avatar") as MovieClip);
        _local_9.gotoAndPlay("sad");
    }

    private function onServerError(_arg_1:Object):void {
        if(ExternalInterface.available) {
            ExternalInterface.call("alert", "PanfuRegister.as > There was an error while communicating with the InformationServer, please make sure that it's up to date.");
        }
        PanfuRegister.log("There was an error on server side");
    }

    private function displayNameScreen():void {
        var _local_1:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_2:TextField = (this.pContent["title1"] as TextField);
        var _local_3:TextField = (this.pContent["title2"] as TextField);
        SnippetManager.instance.setSnippet(_local_2, "REGISTRATION_SCREEN3_NAME");
        SnippetManager.instance.setSnippet(_local_3, "REGISTRATION_SCREEN3_NAME_2");
        SnippetManager.instance.setSnippet(_local_1["header"], "REGISTRATION_SCREEN3_PANDA_NAME");
        SnippetManager.instance.setSnippet(_local_1["body"], "REGISTRATION_SCREEN3_CHOOSE_NAME");
        (_local_1["body"] as TextField).mouseEnabled = false;
        var _local_4:TextField = ((this.pContent.getChildByName("ContainerMc") as MovieClip).getChildByName("txtInput") as TextField);
        _local_4.addEventListener(FocusEvent.FOCUS_OUT, this.checkName);
        _local_4.addEventListener(TextEvent.TEXT_INPUT, this.preventPaste);
        _local_4.addEventListener(Event.CHANGE, this.resetPandaAnimation);
        _local_4.embedFonts = true;
        _local_4.addEventListener(TextEvent.TEXT_INPUT, this.onCheckMaxLength);
        if (this.pRegName != "") {
            _local_4.text = this.pRegName;
        }
        _local_4.addEventListener(Event.CHANGE, this.onSetTimerForInput, false, 0, true);
        stage.focus = _local_4;
        this.pBtnNext.enabled = true;
    }

    private function resetPandaAnimation(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("avatar") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("avatar") as MovieClip);
        if ((((_local_3.currentFrame >= 304)) && ((_local_3.currentFrame <= 378)))) {
            _local_3.gotoAndPlay(1);
        }
    }

    private function onCheckMaxLength(_arg_1:TextEvent):void {
        var _local_2:TextField = (_arg_1.target as TextField);
        if (_local_2.text.length > 15) {
            _arg_1.preventDefault();
        }
    }

    private function displayPasswordScreen():void {
        var _local_1:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_2:TextField = (this.pContent["title1"] as TextField);
        var _local_3:TextField = (this.pContent["title2"] as TextField);
        var _local_4:TextField = (_local_1["body"] as TextField);
        _local_4.mouseEnabled = false;
        SnippetManager.instance.setSnippet(_local_2, "REGISTRATION_SCREEN4_PASSWORD");
        SnippetManager.instance.setSnippet(_local_3, "REGISTRATION_SCREEN4_PASSWORD_2");
        SnippetManager.instance.setSnippet(_local_1["header"], "REGISTRATION_SCREEN4_YOUR_PASSWORD");
        SnippetManager.instance.setSnippet(_local_4, "REGISTRATION_SCREEN4_PASSWORD_EXPLAIN");
        var _local_5:TextField = (this.pContent["pandaname"] as TextField);
        _local_5.text = this.pRegName;
        _local_5.selectable = false;
        var _local_6:TextField = (this.pContent["ContainerMc"]["txtInput"] as TextField);
        _local_6.addEventListener(TextEvent.TEXT_INPUT, this.preventPaste);
        _local_6.addEventListener(Event.CHANGE, this.resetPandaAnimation);
        _local_6.embedFonts = true;
        _local_6.displayAsPassword = true;
        if (this.pRegPass != "") {
            _local_6.text = this.pRegPass;
        }
        _local_6.addEventListener(Event.CHANGE, this.onSetTimerForInput, false, 0, true);
        _local_6.addEventListener(FocusEvent.FOCUS_OUT, this.checkPass);
        stage.focus = _local_6;
        this.pBtnNext.enabled = true;
    }

    private function displayEmailScreen():void {
        var _local_1:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_2:TextField = (this.pContent["title1"] as TextField);
        var _local_3:TextField = (this.pContent["title2"] as TextField);
        SnippetManager.instance.setSnippet(_local_2, "REGISTRATION_SCREEN5_EMAIL");
        SnippetManager.instance.setSnippet(_local_3, "REGISTRATION_SCREEN5_EMAIL_2");
        SnippetManager.instance.setSnippet(_local_1["header"], "REGISTRATION_SCREEN5_YOUR_EMAIL");
        SnippetManager.instance.setSnippet(_local_1["body"], "REGISTRATION_SCREEN5_YOUR_EMAIL_TEXT");
        SnippetManager.instance.setSnippet(_local_1["labelAGB"], "REGISTRATION_SCREEN5_TERMS");
        SnippetManager.instance.setSnippet(_local_1["labelNewsletter"], "REGISTRATION_SCREEN5_RECEIVE_NEWS");
        var _local_4:TextField = (_local_1["btnPlayNow"]["label"] as TextField);
        SnippetManager.instance.setSnippet(_local_4, "REGISTRATION_SCREEN5_PLAY_BUTTON");
        var _local_5:TextField = (this.pContent["ContainerMc"]["txtEmail"] as TextField);
        var _local_6:TextField = (this.pContent["ContainerMc"]["txtEmail2"] as TextField);
        var _local_7:MovieClip = (this.pContent["ContainerMc"]["newsletter"] as MovieClip);
        var _local_8:MovieClip = (this.pContent["ContainerMc"]["newsletter_ext"] as MovieClip);
        var _local_9:Sprite = (this.pContent["ContainerMc"]["btnAGBPopup"] as Sprite);
        var _local_10:Sprite = (this.pContent["ContainerMc"]["btnHelp"] as Sprite);
        var _local_11:MovieClip = (this.pContent["ContainerMc"]["acceptagb"] as MovieClip);
        var _local_12:MovieClip = (this.pContent["ContainerMc"]["acceptagb_ext"] as MovieClip);
        SnippetManager.instance.setSnippet((_local_10["label"] as TextField), "REGISTRATION_SCREEN5_HELP");
        _local_5.addEventListener(TextEvent.TEXT_INPUT, this.preventPaste);
        _local_6.addEventListener(TextEvent.TEXT_INPUT, this.preventPaste);
        _local_5.addEventListener(Event.CHANGE, this.resetPandaAnimation);
        _local_6.addEventListener(Event.CHANGE, this.resetPandaAnimation);
        _local_5.selectable = true;
        _local_6.selectable = true;
        _local_5.embedFonts = true;
        _local_6.embedFonts = true;
        _local_6.mouseEnabled = false;
        _local_7.mouseChildren = false;
        _local_7.mouseEnabled = true;
        _local_7.buttonMode = true;
        var _local_13:String = this.flashVars["language"];
        if (_local_13 == "DE") {
            this.toggleNewsletter();
        }
        _local_7.addEventListener(MouseEvent.CLICK, this.toggleNewsletter);
        _local_8.mouseChildren = false;
        _local_8.mouseEnabled = true;
        _local_8.buttonMode = true;
        _local_8.addEventListener(MouseEvent.CLICK, this.toggleNewsletter);
        if (this.pRegEmail != "") {
            _local_5.text = this.pRegEmail;
            _local_6.text = this.pRegEmail;
        }
        var _local_14:Array = this.pLanguageAGBPosition[this.flashVars["language"]];
        _local_9.mouseChildren = false;
        _local_9.buttonMode = true;
        _local_9.addEventListener(MouseEvent.CLICK, this.onAGBTriggered, false, 0, true);
        _local_10.mouseChildren = false;
        _local_10.buttonMode = true;
        _local_10.addEventListener(MouseEvent.CLICK, this.onHelpClicked, false, 0, true);
        _local_11.mouseChildren = false;
        _local_11.buttonMode = true;
        _local_11.addEventListener(MouseEvent.CLICK, this.onToggleAcceptAGB);
        _local_12.addEventListener(MouseEvent.CLICK, this.onToggleAcceptAGB);
        _local_12.mouseChildren = false;
        _local_12.buttonMode = true;
        if ((((((_local_5.text == _local_6.text)) && (!((_local_5.text == ""))))) && (!((this.pRegEmail == ""))))) {
            this.displayPlaynowButton();
        } else {
            this.hidePlayNow(null);
        }
        _local_5.addEventListener(Event.CHANGE, this.hideBubble, false, 0, true);
        _local_6.addEventListener(Event.CHANGE, this.hideBubble, false, 0, true);
        _local_5.addEventListener(Event.CHANGE, this.hideValidator, false, 1, true);
        _local_6.addEventListener(Event.CHANGE, this.onTypedVerifyEmail, false, 10, true);
        _local_6.addEventListener(FocusEvent.FOCUS_OUT, this.onTypedVerifyEmail);
        _local_5.addEventListener(FocusEvent.FOCUS_OUT, this.trackIfEmailsDoNotMatch);
        _local_6.addEventListener(FocusEvent.FOCUS_OUT, this.trackIfEmailsDoNotMatch);
        _local_5.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusedOutOriginalEmail, false, 0, true);
        stage.focus = _local_5;
        this.pBtnNext.enabled = true;
    }

    private function trackIfEmailsDoNotMatch(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:TextField = (_local_2["txtEmail"] as TextField);
        var _local_4:TextField = (_local_2["txtEmail2"] as TextField);
        var _local_5:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_6:MovieClip = (_local_2.getChildByName("validator2") as MovieClip);
        var _local_7:MovieClip = (_local_5.getChildByName("textmc") as MovieClip);
    }

    private function hideValidator(_arg_1:Event):void {
        var _local_2:TextField = (_arg_1.target as TextField);
        var _local_3:MovieClip = (this.pContent["ContainerMc"] as MovieClip);
        if (_local_2.name.indexOf("2") == -1) {
            (_local_3["validator"] as MovieClip).visible = false;
        }
        (_local_3["validator2"] as MovieClip).visible = false;
        this.hidePlayNow(null);
    }

    private function hideBubble(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        _local_3.visible = false;
    }

    private function onToggleAcceptAGB(_arg_1:MouseEvent):void {
        var _local_2:MovieClip = (this.pContent["ContainerMc"]["acceptagb"] as MovieClip);
        var _local_3:MovieClip = (this.pContent["ContainerMc"]["btnPlayNow"] as MovieClip);
        var _local_4:int = _local_2.currentFrame;
        if (_local_4 == 1) {
            _local_2.gotoAndStop(2);
            this.hidePlayNow(null);
        } else {
            _local_2.gotoAndStop(1);
            if (this.checkAllRegistrationData()) {
                this.displayPlaynowButton();
            }
        }
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_checkbox", SoundManager.TYPE_SFX, false);
    }

    private function setAcceptAGB():void {
        var _local_1:MovieClip = (this.pContent["ContainerMc"]["acceptagb"] as MovieClip);
        var _local_2:MovieClip = (this.pContent["ContainerMc"]["btnPlayNow"] as MovieClip);
        var _local_3:int = _local_1.currentFrame;
        _local_1.gotoAndStop(1);
        if (this.checkAllRegistrationData()) {
            this.displayPlaynowButton();
        }
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_checkbox", SoundManager.TYPE_SFX, false);
    }

    private function isAGBAccepted():Boolean {
        var _local_1:MovieClip = (this.pContent["ContainerMc"]["acceptagb"] as MovieClip);
        if (_local_1.currentFrame == 1) {
            return (true);
        }
        return (false);
    }

    private function checkAllRegistrationData():Boolean {
        if (((((((!((this.pRegEmail == ""))) && (!((this.pRegGender == ""))))) && (!((this.pRegName == ""))))) && (!((this.pRegPass == ""))))) {
            return (true);
        }
        return (false);
    }

    private function onAGBTriggered(_arg_1:MouseEvent):void {
        var _local_2:MovieClip = (this.pContent["agbPopup"] as MovieClip);
        var _local_3:IPopup = new ButtonDownloadAGBDecorator(new OkButtonDecorator(new BodyTextDecorator(new CloseButtonDecorator(new HorizontalScrollButtonsDecorator(new DefaultPopup(_local_2))), "AGB_REGISTRATION"), "btnOK", "REGISTRATION_SCREEN5_BUTTON", this.pressedAcceptAGB), "downloadPDF", "OPEN_PDF_VERSION", this.onDownloadAGBPDFClicked);
        _local_2.visible = true;
    }

    private function onDownloadAGBPDFClicked():void {
        var _local_1:String = this.getLangUrl();
        var _local_2:String = (("http://www.panfu." + _local_1) + "/legal-information/terms-and-conditions.html?format=pdf");
        var _local_3:URLRequest = new URLRequest(_local_2);
        navigateToURL(_local_3);
    }

    private function getLangUrl():String {
        var _local_1:String = this.flashVars["language"];
        if (_local_1 == "EN") {
            return ("com");
        }
        if (_local_1 == "AR") {
            return ("ae");
        }
        return (String(this.flashVars["language"]).toLowerCase());
    }

    private function pressedAcceptAGB():void {
        this.setAcceptAGB();
    }

    private function onHelpClicked(_arg_1:MouseEvent):void {
        var _local_2:MovieClip = (this.pContent["popupHelp"] as MovieClip);
        SnippetManager.instance.setSnippet((_local_2["body"] as TextField), "REGISTRATION_SCREEN5_EMAIL_POPUP_HELP");
        var _local_3:IPopup = new CloseButtonDecorator(new DefaultPopup(_local_2));
        _local_2.visible = true;
        SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR05_ERROR04", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
    }

    private function onDisplayErrorFillEmail(_arg_1:MouseEvent):void {
        if (this.pRegEmail == "") {
            if (!this.isAGBAccepted()) {
                SnippetManager.instance.setSnippet(this.pContent["popup"]["body"]["label"], "REGISTRATION_SCREEN5_TERMS_ERROR_1");
                this.pContent["popup"].visible = true;
                SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_popup", SoundManager.TYPE_SFX, false);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR05_ERROR06", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            } else {
                SnippetManager.instance.setSnippet(this.pContent["popup"]["body"]["label"], "REGISTRATION_SCREEN5_EMAIL_POPUP_ERROR");
                this.pContent["popup"].visible = true;
                SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_popup", SoundManager.TYPE_SFX, false);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR05_ERROR03", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            }
        } else {
            if (!this.isAGBAccepted()) {
                SnippetManager.instance.setSnippet(this.pContent["popup"]["body"]["label"], "REGISTRATION_SCREEN5_TERMS_ERROR_2");
                this.pContent["popup"].visible = true;
                SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_popup", SoundManager.TYPE_SFX, false);
                SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, "REGISTR_SCR05_ERROR07", SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            }
        }
    }

    private function registerUser():void {
        PanfuRegister.log("Registring user");
        var _local_1:RegisterVO = new RegisterVO();
        _local_1.name = this.pRegName;
        _local_1.sex = this.pRegGender;
        _local_1.pw = this.pRegPass;
        _local_1.emailParents = this.pRegEmail;
        _local_1.chatId = "0";
        _local_1.itemIds = this.pRegItems;
        _local_1.wantsNewsletter = this.pRegNewsletter;
        _local_1.doubleOptIn = true;
        _local_1.referrer = this.flashVars["referrer"];
        _local_1.refererId = this.flashVars["refID"];
        _local_1.trackingCode = this.flashVars["num"];
        _local_1.partnerId = this.flashVars["partnerId"];
        _local_1.country = this.flashVars["country"];
        if ((((((this.flashVars["referrer"] == "Null")) || ((this.flashVars["referrer"] == "null")))) || ((this.flashVars["referrer"] == "NULL")))) {
            this.flashVars["referrer"] = null;
        }
        if ((((_local_1.country == null)) || (!((_local_1.country.length == 2))))) {
            _local_1.country = "  ";
        }
        RemotingService.inst.registerUser(this.onUserRegistered, this.onServerError, _local_1);
    }

    private function onUserRegistered(_arg_1:Object):void {
        PanfuRegister.log("DONE!", _arg_1);
        this.pUserID = int(_arg_1);
        this.switchScreenTo(5);
        ExternalInterface.call("flash_callback_registration_success", this.pRegName);
    }

    private function displayActivateEmail():void {
        var _local_1:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_2:TextField = (this.pContent["title1"] as TextField);
        var _local_3:Vector.<TextField> = new Vector.<TextField>();
        var _local_4:int = 1;
        while (_local_4 <= 4) {
            _local_3.push((_local_1[("body" + _local_4)] as TextField));
            _local_4++;
        }
        var _local_5:MovieClip = (_local_1["olokoref"] as MovieClip);
        var _local_6:TextField = (_local_5["label"] as TextField);
        SnippetManager.instance.setSnippet(_local_2, this.pRegistrationCompleteTitle);
        SnippetManager.instance.setSnippet(_local_3[0], this.pRegistrationCompleteHeader);
        SnippetManager.instance.setSnippet(_local_3[1], "REGISTRATION_SCREEN6_GO_TO_INBOX_V2");
        SnippetManager.instance.setSnippet(_local_3[2], "REGISTRATION_SCREEN6_YOUR_PANFU_TEAM");
        SnippetManager.instance.setSnippet(_local_3[3], "REGISTRATION_SCREEN6_CHANGE_E_MAIL_TEXT_");
        SnippetManager.instance.setSnippet(_local_6, "REGISTRATION_SCREEN6_OLOKO_REFERENCE");
        if ((((this.flashVars["language"] == "ES")) || ((this.flashVars["language"] == "PL")))) {
            _local_5.visible = false;
        }
        var _local_7:MovieClip = (_local_1.getChildByName("changeOverlay") as MovieClip);
        _local_7.addEventListener(MouseEvent.CLICK, this.onChangeEmailClicked);
        _local_7.buttonMode = true;
        this.pBtnNext.enabled = true;
    }

    private function onChangeEmailClicked(_arg_1:MouseEvent):void {
        this.pCurrentScreen++;
        this.switchScreenTo(this.pCurrentScreen);
        this.pRegistrationCompleteTitle = "REGISTRATION_SCREEN6_HEADLINE";
        this.pRegistrationCompleteHeader = "REGISTRATION_SCREEN6_SUBLINE";
    }

    private function displayChangeEmail():void {
        var _local_1:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_2:TextField = (this.pContent["title1"] as TextField);
        var _local_3:TextField = (this.pContent["title2"] as TextField);
        _local_2.text = "";
        var _local_4:Vector.<TextField> = new Vector.<TextField>();
        var _local_5:int = 1;
        while (_local_5 <= 3) {
            _local_4.push((_local_1[("body" + _local_5)] as TextField));
            _local_5++;
        }
        var _local_6:MovieClip = (_local_1.getChildByName("btnChangeEmail") as MovieClip);
        var _local_7:MovieClip = (_local_1.getChildByName("btnBack") as MovieClip);
        var _local_8:TextField = (_local_1.getChildByName("txtEmail") as TextField);
        var _local_9:TextField = (_local_1.getChildByName("txtEmail2") as TextField);
        var _local_10:TextField = (_local_6.getChildByName("label") as TextField);
        _local_6.buttonMode = true;
        _local_6.mouseChildren = false;
        _local_7.buttonMode = true;
        _local_7.mouseChildren = false;
        _local_6.addEventListener(MouseEvent.CLICK, this.validateEmailAddress);
        _local_7.addEventListener(MouseEvent.CLICK, this.goBackToSuccessScreen);
        SnippetManager.instance.setSnippet(_local_4[0], "REGISTRATION_SCREEN6_POPUP_EMAIL_HEADLINE");
        SnippetManager.instance.setSnippet(_local_4[1], "REGISTRATION_SCREEN6_POPUP_EMAIL_NEW_EMAIL");
        SnippetManager.instance.setSnippet(_local_4[2], "REGISTRATION_SCREEN6_POPUP_EMAIL_NEW_EMAIL_TYPE_AGAIN");
        _local_8.addEventListener(Event.CHANGE, this.onTestEmails);
        _local_9.addEventListener(Event.CHANGE, this.onTestEmails);
        _local_8.addEventListener(Event.CHANGE, this.hideErrorBubbleAndValidator);
        _local_9.addEventListener(Event.CHANGE, this.hideErrorBubbleAndValidator);
    }

    private function hideErrorBubbleAndValidator(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        _local_3.visible = false;
        _local_4.visible = false;
    }

    private function onTestEmails(_arg_1:Event):void {
        var _local_5:MovieClip;
        var _local_2:MovieClip = (_arg_1.target.parent as MovieClip);
        var _local_3:TextField = (_local_2.getChildByName("txtEmail") as TextField);
        var _local_4:TextField = (_local_2.getChildByName("txtEmail2") as TextField);
        if (((((!((_local_3.text.length == 0))) && ((_local_3.text == _local_4.text)))) && (this.validateEmailSyntax(_local_3.text)))) {
            _local_5 = (_local_2.getChildByName("btnChangeEmail") as MovieClip);
            _local_5.gotoAndStop(2);
            _local_5.buttonMode = true;
            _local_5.mouseChildren = false;
            _local_5.addEventListener(MouseEvent.CLICK, this.validateEmailAddress);
        } else {
            _local_5 = (_local_2.getChildByName("btnChangeEmail") as MovieClip);
            _local_5.gotoAndStop(1);
            _local_5.buttonMode = false;
            _local_5.mouseChildren = false;
            _local_5.hasEventListener(MouseEvent.CLICK);
            _local_5.removeEventListener(MouseEvent.CLICK, this.validateEmailAddress);
        }
    }

    private function goBackToSuccessScreen(_arg_1:MouseEvent):void {
        this.pCurrentScreen--;
        this.switchScreenTo(this.pCurrentScreen);
    }

    private function onHideValidators(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("changeEmailPopup") as MovieClip);
        var _local_3:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_4:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        _local_3.visible = false;
        _local_4.visible = false;
    }

    private function onCloseChangeEmailClicked(_arg_1:MouseEvent = null):void {
        this.pRegistrationCompleteTitle = "E_MAIL_CHANGED_TITLE";
        this.pRegistrationCompleteHeader = "E_MAIL_CHANGED_HEADER";
        this.pCurrentScreen--;
        this.switchScreenTo(this.pCurrentScreen);
    }

    private function validateEmailAddress(_arg_1:MouseEvent):void {
        var _local_2:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_3:TextField = (_local_2.getChildByName("txtEmail") as TextField);
        var _local_4:TextField = (_local_2.getChildByName("txtEmail2") as TextField);
        var _local_5:MovieClip = (_local_2.getChildByName("validator") as MovieClip);
        var _local_6:MovieClip = (_local_2.getChildByName("bubble") as MovieClip);
        var _local_7:MovieClip = (_local_6.getChildByName("textmc") as MovieClip);
        var _local_8:TextField = (_local_7.getChildByName("label") as TextField);
        if (((((!((_local_3.text == null))) && (!((_local_3.text.length == 0))))) && (!((_local_3.text == "\r"))))) {
            if (_local_3.text == _local_4.text) {
                if (this.validateEmailSyntax(_local_3.text)) {
                    RemotingService.inst.checkEmailAddress(this.onCheckEmailChangeResponse, this.onServerError, _local_3.text);
                } else {
                    _local_5.gotoAndStop(5);
                    SnippetManager.instance.setSnippet(_local_8, "REGISTRATION_SCREEN5_EMAIL_ERROR_1");
                    _local_5.visible = true;
                    _local_6.visible = true;
                }
            } else {
                _local_5.gotoAndStop(5);
                SnippetManager.instance.setSnippet(_local_8, "REGISTRATION_SCREEN5_EMAIL_ERROR_2");
                _local_5.visible = true;
                _local_6.visible = true;
            }
        } else {
            _local_5.gotoAndStop(5);
            SnippetManager.instance.setSnippet(_local_8, "REGISTRATION_SCREEN5_EMAIL_ERROR_1");
            _local_5.visible = true;
            _local_6.visible = true;
        }
    }

    private function onCheckEmailChangeResponse(_arg_1:Object):void {
        var _local_6:MovieClip;
        var _local_7:MovieClip;
        var _local_8:MovieClip;
        var _local_9:TextField;
        var _local_2:Boolean = (_arg_1["valueObject"] as Boolean);
        var _local_3:MovieClip = (this.pContent.getChildByName("ContainerMc") as MovieClip);
        var _local_4:TextField = (_local_3.getChildByName("txtEmail") as TextField);
        var _local_5:TextField = (_local_3.getChildByName("txtEmail2") as TextField);
        if (_local_2) {
            RemotingService.inst.setEmailAddress(this.onEmailChangedResponse, this.onServerError, this.pUserID, _local_4.text);
        } else {
            _local_6 = (_local_3.getChildByName("validator") as MovieClip);
            _local_7 = (_local_3.getChildByName("bubble") as MovieClip);
            _local_8 = (_local_7.getChildByName("textmc") as MovieClip);
            _local_9 = (_local_8.getChildByName("label") as TextField);
            _local_6.gotoAndStop(5);
            SnippetManager.instance.setSnippet(_local_9, "REGISTRATION_SCREEN5_ERROR_EMAILALREADYINUSE");
            _local_6.visible = true;
            _local_7.visible = true;
            _local_7.x = -87.5;
        }
    }

    private function onEmailChangedResponse(_arg_1:Object):void {
        this.onCloseChangeEmailClicked();
    }

    private function onEmailUpdated(_arg_1:Object):void {
        this.onCloseChangeEmailClicked();
    }

    private function resetStoredEmail(_arg_1:Event):void {
        this.pRegEmail = "";
    }

    private function hidePlayNow(_arg_1:Event):void {
        var _local_2:MovieClip = (this.pContent["ContainerMc"]["btnPlayNow"] as MovieClip);
        _local_2.gotoAndStop(1);
        _local_2.buttonMode = true;
        _local_2.mouseChildren = false;
        if (_local_2.hasEventListener(MouseEvent.MOUSE_OVER)) {
            _local_2.removeEventListener(MouseEvent.MOUSE_OVER, this.onPlayOver);
        }
        if (_local_2.hasEventListener(MouseEvent.MOUSE_OVER)) {
            _local_2.removeEventListener(MouseEvent.MOUSE_OVER, this.makeButtonOveredSound);
        }
        if (_local_2.hasEventListener(MouseEvent.MOUSE_OUT)) {
            _local_2.removeEventListener(MouseEvent.MOUSE_OUT, this.onPlayOut);
        }
        if (_local_2.hasEventListener(MouseEvent.CLICK)) {
            _local_2.removeEventListener(MouseEvent.CLICK, this.onPlayClicked);
        }
        if (_local_2.hasEventListener(MouseEvent.CLICK)) {
            _local_2.removeEventListener(MouseEvent.CLICK, this.makeButtonClickSound);
        }
        _local_2.addEventListener(MouseEvent.CLICK, this.onDisplayErrorFillEmail);
    }

    private function toggleNewsletter(_arg_1:MouseEvent = null):void {
        this.pRegNewsletter = !(this.pRegNewsletter);
        var _local_2:MovieClip = (this.pContent["ContainerMc"]["newsletter"] as MovieClip);
        if (this.pRegNewsletter) {
            _local_2.gotoAndStop(1);
        } else {
            _local_2.gotoAndStop(2);
        }
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_checkbox", SoundManager.TYPE_SFX, false);
    }

    private function preventPaste(_arg_1:TextEvent):void {
        if ((((_arg_1.text.length > 1)) || (this.isValidating))) {
            _arg_1.preventDefault();
        }
    }

    private function displayPlaynowButton():void {
        var _local_1:MovieClip;
        if (this.isAGBAccepted()) {
            _local_1 = (this.pContent["ContainerMc"]["btnPlayNow"] as MovieClip);
            _local_1.mouseChildren = false;
            _local_1.buttonMode = true;
            _local_1.gotoAndStop(2);
            if (_local_1.hasEventListener(MouseEvent.CLICK)) {
                _local_1.removeEventListener(MouseEvent.CLICK, this.onDisplayErrorFillEmail);
            }
            _local_1.addEventListener(MouseEvent.MOUSE_OVER, this.onPlayOver, false, 0, true);
            _local_1.addEventListener(MouseEvent.MOUSE_OVER, this.makeButtonOveredSound, false, 0, true);
            _local_1.addEventListener(MouseEvent.MOUSE_OUT, this.onPlayOut, false, 0, true);
            _local_1.addEventListener(MouseEvent.CLICK, this.onPlayClicked, false, 0, true);
            _local_1.addEventListener(MouseEvent.CLICK, this.makeButtonClickSound, false, 0, true);
            _local_1.focusRect = false;
            stage.focus = _local_1;
            SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_alldone", SoundManager.TYPE_SFX, false);
        }
    }

    private function onPlayOver(_arg_1:MouseEvent):void {
        if (this.pRegEmail != "") {
            (_arg_1.target as MovieClip).gotoAndStop(3);
        }
    }

    private function onPlayOut(_arg_1:MouseEvent):void {
        if (this.pRegEmail != "") {
            (_arg_1.target as MovieClip).gotoAndStop(2);
        }
    }

    private function onPlayClicked(_arg_1:MouseEvent):void {
        if (((((((((!((this.pRegGender == ""))) && (!((this.pRegName == ""))))) && (!((this.pRegEmail == ""))))) && (!((this.pRegPass == ""))))) && (!((this.pRegEmail == ""))))) {
            this.pBtnBack.mouseEnabled = false;
            (_arg_1.target as MovieClip).mouseEnabled = false;
            this.registerUser();
        }
    }

    private function onLoadFailed(_arg_1:IOErrorEvent):void {
        PanfuRegister.log(("Error " + _arg_1.toString()));
    }

    private function onLoadComplete(_arg_1:Event):void {
        var _local_2:LoaderInfo = (_arg_1.target as LoaderInfo);
        this.pLoaderInfo = _local_2;
        addChild(_local_2.content);
        this.pContent = (_local_2.content["main"] as MovieClip);
        ClothManager.inst.initialize(_local_2.applicationDomain);
        this.pBtnBack = this.pContent["btnBack"];
        this.pBtnNext = this.pContent["btnNext"];
        this.pBtnNext.focusRect = false;
        this.pBtnBack.addEventListener(MouseEvent.CLICK, this.onBackClicked);
        this.pBtnNext.addEventListener(MouseEvent.CLICK, this.onNextClicked);
        this.pBtnBack.addEventListener(MouseEvent.CLICK, this.makeButtonClickSound);
        this.pBtnNext.addEventListener(MouseEvent.CLICK, this.makeButtonClickSound);
        this.pBtnBack.addEventListener(MouseEvent.MOUSE_OVER, this.onOveredNavi);
        this.pBtnNext.addEventListener(MouseEvent.MOUSE_OVER, this.onOveredNavi);
        this.pBtnBack.addEventListener(MouseEvent.MOUSE_OVER, this.makeButtonOveredSound);
        this.pBtnNext.addEventListener(MouseEvent.MOUSE_OVER, this.makeButtonOveredSound);
        this.pBtnBack.addEventListener(MouseEvent.MOUSE_OUT, this.onOutNavi);
        this.pBtnNext.addEventListener(MouseEvent.MOUSE_OUT, this.onOutNavi);
        this.pBtnBack.mouseChildren = false;
        this.pBtnBack.buttonMode = true;
        this.pBtnNext.mouseChildren = false;
        this.pBtnNext.buttonMode = true;
        this.pBtnNext.enabled = false;
        (this.pContent["popup"]["ok"] as MovieClip).addEventListener(MouseEvent.CLICK, this.onPopupClose, false, 0, true);
        (this.pContent["popup"]["ok"] as MovieClip).addEventListener(MouseEvent.CLICK, this.makeButtonClickSound, false, 0, true);
        (this.pContent["popup"]["ok"] as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, this.onOkOvered, false, 0, true);
        (this.pContent["popup"]["ok"] as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, this.makeButtonOveredSound, false, 0, true);
        (this.pContent["popup"]["ok"] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, this.onOkOut, false, 0, true);
        var _local_3:MovieClip = (this.pContent["btnMute"] as MovieClip);
        _local_3.buttonMode = true;
        _local_3.mouseChildren = false;
        _local_3.addEventListener(MouseEvent.CLICK, this.onMuteSounds);
        var _local_4:URLLoader = new URLLoader();
        _local_4.addEventListener(Event.COMPLETE, this.onLoaded);
        _local_4.load(new URLRequest((("snippets/website_registration_" + this.flashVars["language"]) + ".xml")));
    }

    private function onLoaded(_arg_1:Event):void {
        SnippetManager.instance.init(_arg_1.target.data);
        this.switchScreenTo(0);
    }

    private function onMuteSounds(_arg_1:MouseEvent):void {
        var _local_2:Boolean = SoundManager.inst.mute;
        SoundManager.inst.mute = !(_local_2);
        if (SoundManager.inst.mute) {
            (_arg_1.target as MovieClip).gotoAndStop(2);
        } else {
            (_arg_1.target as MovieClip).gotoAndStop(1);
        }
    }

    private function makeButtonClickSound(_arg_1:Event):void {
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_all-button-click", SoundManager.TYPE_SFX, false);
    }

    private function makeButtonOveredSound(_arg_1:Event):void {
        if ((_arg_1.target as MovieClip).currentFrame != 1) {
            SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_mouseover", SoundManager.TYPE_SFX, false);
        }
    }

    private function makeGenderButtonOveredSound(_arg_1:Event):void {
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_mouseover", SoundManager.TYPE_SFX, false);
    }

    private function makeCheckBoxClickSound(_arg_1:Event):void {
        SoundManager.inst.playTrack(SoundManager.TYPE_SFX, "Player-Reg_checkbox", SoundManager.TYPE_SFX, false);
    }

    private function onPopupClose(_arg_1:MouseEvent):void {
        var _local_2:MovieClip = (_arg_1.target as MovieClip);
        _local_2.gotoAndStop(1);
        _local_2.parent.visible = false;
    }

    private function onOkOvered(_arg_1:MouseEvent):void {
        (_arg_1.target as MovieClip).gotoAndStop(2);
    }

    private function onOkOut(_arg_1:MouseEvent):void {
        (_arg_1.target as MovieClip).gotoAndStop(1);
    }

    private function onOveredNavi(_arg_1:MouseEvent):void {
        if ((_arg_1.target as MovieClip).currentFrame != 1) {
            (_arg_1.target as MovieClip).gotoAndStop(3);
        }
    }

    private function onOutNavi(_arg_1:MouseEvent):void {
        if ((_arg_1.target as MovieClip).currentFrame == 3) {
            (_arg_1.target as MovieClip).gotoAndStop(2);
        }
    }

    private function onAddGlowToNavBtnNext(_arg_1:MouseEvent):void {
        if (this.pNextButtonEnablers[this.pCurrentScreen] != null) {
            if (this.pNextButtonEnablers[this.pCurrentScreen]()) {
                this.onAddGlow(_arg_1);
            }
        } else {
            this.onAddGlow(_arg_1);
        }
    }

    private function onBackClicked(_arg_1:MouseEvent):void {
        if ((((((this.pCurrentScreen > 0)) && (!(this.pIsValidating)))) && (!(this.pInputTimer.running)))) {
            this.trackNaviClick("back");
            this.pCurrentScreen--;
            this.switchScreenTo(this.pCurrentScreen);
        }
    }

    private function onNextClicked(_arg_1:MouseEvent):void {
        if (((this.pInputTimer.running) || (this.pFakeValidationTimer.running))) {
            return;
        }
        if ((((this.pBtnNext.currentFrame == 1)) || (this.pIsValidating))) {
            SnippetManager.instance.setSnippet((this.pContent["popup"]["body"]["label"] as TextField), this.pClickNextErrorMessages[this.pCurrentScreen]);
            this.pContent["popup"].visible = true;
            SoundManager.inst.playTrack(SoundManager.TYPE_FEMALE_VOICE, this.pClickNextErrorSounds[this.pCurrentScreen], SoundManager.TYPE_FEMALE_VOICE, true, this.VOICE_FADEOUT_TIME);
            return;
        }
        this.pInputTimer.stop();
        this.pFakeValidationTimer.stop();
        if (this.pCurrentScreen < this.pScreenList.length) {
            this.pBtnNext.enabled = false;
            this.trackNaviClick("next");
            this.pCurrentScreen++;
            this.switchScreenTo(this.pCurrentScreen);
        }
    }

    private function trackNaviClick(_arg_1:String):void {
        var _local_2:String;
        switch (this.pCurrentScreen) {
            case 0:
                _local_2 = "RS_gender";
                break;
            case 1:
                _local_2 = "RS_outfit";
                break;
            case 2:
                _local_2 = "RS_name";
                break;
            case 3:
                _local_2 = "RS_password";
                break;
            case 4:
                _local_2 = "RS_e-mail";
                break;
        }
        switch (_arg_1) {
            case "back":
                _local_2 = (_local_2 + "_back");
                break;
            case "next":
                _local_2 = (_local_2 + "_forward");
                break;
        }
        PanfuRegister.log("### tracking:", _local_2);
    }

    public static function log(...tArgs):void {
        if(ExternalInterface.available) {
            ExternalInterface.call("console.log", "Register > " + String(tArgs.join(" ")));
        }
    }


}
}

