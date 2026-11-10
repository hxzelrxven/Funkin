package funkin.data.dialogue;

import funkin.play.cutscene.dialogue.Conversation;
import funkin.util.tools.ISingleton;
import funkin.data.DefaultRegistryImpl;

@:nullSafety
class CutsceneRegistry extends BaseRegistry<Conversation, CutsceneData, CutsceneEntryParams> implements ISingleton implements DefaultRegistryImpl
{
  /**
   * The current version string for the cutscene data format.
   * Handle breaking changes by incrementing this value
   * and adding migration to the `migrateCutsceneData()` function.
   */
  public static final CUTSCENE_DATA_VERSION:thx.semver.Version = '1.0.0';

  public static final CUTSCENE_DATA_VERSION_RULE:thx.semver.VersionRule = '>=1.0.0';

  public function new()
  {
    super({
      registryId: 'CUTSCENE',
      dataFilePath: 'gameplay/cutscenes/',
      nestedEntries: true,
      versionRule: CUTSCENE_DATA_VERSION_RULE
    });
  }
}

typedef CutsceneEntryParams =
{
  var placeholder:String;
}
