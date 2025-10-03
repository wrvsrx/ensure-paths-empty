import Lean.Data.Json

def appName : String := "ensure-paths-empty"

def getAppConfigDir (appName : String) : IO System.FilePath := do
  let maybeConfigDir ← IO.getEnv "XDG_CONFIG_HOME"
  let configDir ← match maybeConfigDir with
    | some x => pure (System.FilePath.mk x)
    | none => do
        let maybeHomeDir ← IO.getEnv "HOME"
        match maybeHomeDir with
          | some x => pure ((System.FilePath.mk x) / ".config" / appName)
          | _ => throw (IO.Error.userError "Neither $XDG_CONFIG_DIR or $HOME is set.")
  pure configDir

def main : IO Unit := do
  let appConfigDir ← getAppConfigDir appName
  let configFilePath := appConfigDir / "config.json"
  let doesConfigFileExist ← System.FilePath.pathExists configFilePath
  let files ← System.FilePath.readDir "."
  for file in files do
    IO.println file.fileName
