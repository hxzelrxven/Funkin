package funkin.data.cutscene;

/**
 * A type definition for the data for a specific cutscene.
 * It includes the data for the events played by the cutscene and the props used in said cutscene.
 * @see https://lib.haxe.org/p/json2object/
 */
typedef CutsceneData =
{
  /**
   * Semantic version for conversation data.
   */
  public var version:String;

  /**
   * Data on the backdrop for the conversation.
   */
  @:jcustomparse(funkin.data.DataParse.backdropData)
  public var backdrop:BackdropData;

  /**
   * Data on the outro for the conversation.
   */
  @:jcustomparse(funkin.data.DataParse.outroData) @:optional
  public var outro:Null<OutroData>;

  /**
   * Data on the music for the conversation.
   */
  @:optional
  public var music:Null<MusicData>;

  /**
   * Data for each line of dialogue in the conversation.
   */
  public var dialogue:Array<DialogueEntryData>;
}

typedef MusicData =
{
  /**
   * The asset to play for the music.
   */
  var asset:String;

  /**
   * The time to fade in the music.
   */
  @:optional @:default(0.0)
  var fadeTime:Float;

  @:optional @:default(false)
  var looped:Bool;
};
