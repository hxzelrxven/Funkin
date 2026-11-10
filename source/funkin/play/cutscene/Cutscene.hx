package funkin.play.cutscene;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import funkin.audio.FunkinSound;
import funkin.group.FunkinGroup;
import funkin.group.FunkinGroup.FunkinSpriteGroup;
import funkin.data.cutscene.CutsceneData;
import funkin.data.cutscene.CutsceneRegistry;
import funkin.graphics.FunkinSprite;
import funkin.modding.events.ScriptEvent;
import funkin.modding.events.ScriptEventDispatcher;
import funkin.modding.IScriptedClass.ICutsceneScriptedClass;
import funkin.modding.IScriptedClass.IEventHandler;
import funkin.util.SortUtil;
import funkin.util.EaseUtil;
import funkin.assets.Paths;
import funkin.assets.Assets;

/**
 * A high-level handler for cutscenes.
 *
 * this one should be used a LOT more than the dialogue one... -hazel
 */
@:nullSafety
class Cutscene extends FunkinSpriteGroup implements IDialogueScriptedClass implements IEventHandler implements IRegistryEntry<CutsceneData>
{
  /**
   * AUDIO
   */
  var music:Null<FunkinSound>;

  /**
   * GRAPHICS
   */
  /**
   * Retrieve a list of all the asset paths required to load the conversation.
   *
   * If you have a scripted class which initializes sprites, or plays sounds or something,
   * make sure you add them here so they get cached in the loading screen.
   *
   * @param type The type of asset to query
   * @param entryId The conversation ID, used to look up the specific assets.
   * @param params The entry parameters, if any.
   * @return An array of asset paths, or empty if no assets of that type are required.
   */
  public static function queryAssets(type:AssetType, entryId:String, ?params:ConversationEntryParams):Array<AssetPath>
  {
    var results:Array<Null<AssetPath>> = [];

    return results.filterNull();
  }

  public function new(id:String, ?params:Dynamic)
  {
    super();

    this.id = id;
    this._data = _fetchData(id);

    if (_data == null)
    {
      throw 'Could not parse cutscene data for id: $id';
    }
  }

  public function onCreate(event:ScriptEvent):Void
  {
  }

  function setupMusic():Void
  {
  }

  public function pauseMusic():Void
  {
  }

  public function resumeMusic():Void
  {
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    var event:UpdateScriptEvent = UpdateScriptEvent.get(elapsed);
    dispatchEvent(event);
  }

  public function startCutscene():Void
  {
    var event:CutsceneScriptEvent = CutsceneScriptEvent.get(CUTSCENE_START, this, true);
    dispatchEvent(event);
  }

  public function endCutscene():Void
  {
    var event:CutsceneScriptEvent = CutsceneScriptEvent.get(CUTSCENE_END, this, true);
    dispatchEvent(event);
  }

  public function dispatchEvent(event:ScriptEvent, finish:Bool = true):Void
  {
    var currentState:IEventHandler = cast FlxG.state;
    currentState.dispatchEvent(event, finish);
  }

  /**
   * Reset the cutscene back to the start.
   */
  public function resetCutscene():Void
  {
    startCutscene();
  }

  /**
   * Dispatch an event to attempt to immediately end the cutscene.
   *
   * The broadcast event may be cancelled by modules or ScriptedCutscenes. This will prevent the cutscene from being cancelled.
   * This is useful if you want to prevent an animation from being skipped or something.
   */
  public function skipCutscene():Void
  {
    var event:CutsceneScriptEvent = CutsceneScriptEvent.get(CUTSCENE_SKIP, this, true);
    dispatchEvent(event);
  }

  /**
   * Performed as the cutscene starts.
   */
  public function onCutsceneStart(event:CutsceneScriptEvent):Void
  {
    propagateEvent(event);
  }

  /**
   * Skip to the end of the cutscene, immediately triggering the DIALOGUE_END event.
   */
  public function onCutsceneSkip(event:CutsceneScriptEvent):Void
  {
    propagateEvent(event);
    if (event.eventCanceled) return;

    endCutscene();
  }

  public function onCutsceneEnd(event:CutsceneScriptEvent):Void
  {
    propagateEvent(event);
  }

  // Only used for events/scripts.

  public function onUpdate(event:UpdateScriptEvent):Void
  {
    propagateEvent(event);

    if (event.eventCanceled) return;
  }

  public function onDestroy(event:ScriptEvent):Void
  {
    propagateEvent(event);
  }

  public function onScriptEvent(event:ScriptEvent):Void
  {
    propagateEvent(event);
  }

  /**
   * As this event is dispatched to the cutscene.
   * @param event
   */
  function propagateEvent(event:ScriptEvent):Void
  {
  }

  /**
   * Calls `kill()` on the group's members and then on the group itself.
   * You can revive this group later via `revive()` after this.
   */
  override public function revive():Void
  {
    super.revive();
    this.alpha = 1;
    this.visible = true;
  }

  /**
   * Calls `kill()` on the group's members and then on the group itself.
   * You can revive this group later via `revive()` after this.
   */
  override public function kill():Void
  {
    alive = false;
    exists = false;

    super.kill();
  }

  override public function toString():String
  {
    return 'Cutscene($id)';
  }
}
